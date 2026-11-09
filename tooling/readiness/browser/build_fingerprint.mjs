#!/usr/bin/env node
import crypto from 'node:crypto';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const FINGERPRINT_FILENAME = '.creativanta_source_fingerprint';
const IGNORED_APP_DIRS = new Set(['build', '.svelte-kit', 'node_modules', '.git']);

function sha256Buffer(buf) {
  return crypto.createHash('sha256').update(buf).digest('hex');
}

function collectFilesRecursive(baseDir, currentRelDir, ignoreSet, out) {
  const absDir = currentRelDir ? path.join(baseDir, currentRelDir) : baseDir;
  if (!fs.existsSync(absDir)) {
    return;
  }
  const entries = fs.readdirSync(absDir, { withFileTypes: true });
  entries.sort((a, b) => a.name.localeCompare(b.name));
  for (const entry of entries) {
    if (ignoreSet.has(entry.name)) {
      continue;
    }
    const relPath = currentRelDir ? `${currentRelDir}/${entry.name}` : entry.name;
    const fullPath = path.join(baseDir, relPath);
    if (entry.isDirectory()) {
      collectFilesRecursive(baseDir, relPath, ignoreSet, out);
    } else if (entry.isFile()) {
      out.push({ relPath, fullPath });
    }
  }
}

export function computeSourceFingerprint(repoRoot, appName) {
  if (appName !== 'web' && appName !== 'admin') {
    throw new Error(`Unsupported app name: ${appName}`);
  }
  const hash = crypto.createHash('sha256');
  const rootInputs = ['package.json', 'pnpm-lock.yaml', 'tsconfig.base.json'];
  for (const rel of rootInputs) {
    const full = path.join(repoRoot, rel);
    if (fs.existsSync(full) && fs.statSync(full).isFile()) {
      const content = fs.readFileSync(full);
      hash.update(`root:${rel}\0${content.length}\0${sha256Buffer(content)}\n`);
    }
  }

  const appDir = path.join(repoRoot, 'apps', appName);
  if (!fs.existsSync(appDir)) {
    throw new Error(`App directory does not exist: ${appDir}`);
  }
  const files = [];
  collectFilesRecursive(appDir, '', IGNORED_APP_DIRS, files);
  for (const file of files) {
    const content = fs.readFileSync(file.fullPath);
    hash.update(`app:${appName}/${file.relPath}\0${content.length}\0${sha256Buffer(content)}\n`);
  }
  return hash.digest('hex');
}

export function computeArtifactDigest(repoRoot, appName) {
  const buildDir = path.join(repoRoot, 'apps', appName, 'build');
  const entryFile = path.join(buildDir, 'index.js');
  if (!fs.existsSync(entryFile) || !fs.statSync(entryFile).isFile()) {
    return null;
  }
  const files = [];
  collectFilesRecursive(buildDir, '', new Set([FINGERPRINT_FILENAME]), files);
  if (files.length === 0) {
    return null;
  }
  const hash = crypto.createHash('sha256');
  for (const file of files) {
    const content = fs.readFileSync(file.fullPath);
    hash.update(`build:${appName}/${file.relPath}\0${content.length}\0${sha256Buffer(content)}\n`);
  }
  return hash.digest('hex');
}

export function stampBuildFingerprint(repoRoot, appName) {
  const sourceFingerprint = computeSourceFingerprint(repoRoot, appName);
  const artifactSha256 = computeArtifactDigest(repoRoot, appName);
  if (!artifactSha256) {
    throw new Error(`Cannot stamp fingerprint: apps/${appName}/build/index.js does not exist`);
  }
  const fpPath = path.join(repoRoot, 'apps', appName, 'build', FINGERPRINT_FILENAME);
  const payload = {
    app: appName,
    source_fingerprint: sourceFingerprint,
    artifact_sha256: artifactSha256,
  };
  fs.writeFileSync(fpPath, `${JSON.stringify(payload, null, 2)}\n`, 'utf8');
  return payload;
}

export function verifyBuildFingerprint(repoRoot, appName) {
  const expectedSource = computeSourceFingerprint(repoRoot, appName);
  const expectedArtifact = computeArtifactDigest(repoRoot, appName);
  if (!expectedArtifact) {
    return {
      valid: false,
      reason: `apps/${appName}/build/index.js is missing`,
      expectedSourceFingerprint: expectedSource,
      recordedSourceFingerprint: '',
      expectedArtifactSha256: '',
      recordedArtifactSha256: '',
    };
  }
  const fpPath = path.join(repoRoot, 'apps', appName, 'build', FINGERPRINT_FILENAME);
  if (!fs.existsSync(fpPath) || !fs.statSync(fpPath).isFile()) {
    return {
      valid: false,
      reason: `apps/${appName}/build/${FINGERPRINT_FILENAME} is missing (unverified build artifact)`,
      expectedSourceFingerprint: expectedSource,
      recordedSourceFingerprint: '',
      expectedArtifactSha256: expectedArtifact,
      recordedArtifactSha256: '',
    };
  }
  let parsed;
  try {
    parsed = JSON.parse(fs.readFileSync(fpPath, 'utf8'));
  } catch (err) {
    return {
      valid: false,
      reason: `apps/${appName}/build/${FINGERPRINT_FILENAME} is malformed: ${err.message}`,
      expectedSourceFingerprint: expectedSource,
      recordedSourceFingerprint: '',
      expectedArtifactSha256: expectedArtifact,
      recordedArtifactSha256: '',
    };
  }
  const recordedSource = typeof parsed?.source_fingerprint === 'string' ? parsed.source_fingerprint : '';
  const recordedArtifact = typeof parsed?.artifact_sha256 === 'string' ? parsed.artifact_sha256 : '';
  if (recordedSource !== expectedSource) {
    return {
      valid: false,
      reason: `apps/${appName}/build source fingerprint mismatch (expected ${expectedSource}, recorded ${recordedSource || '<empty>'})`,
      expectedSourceFingerprint: expectedSource,
      recordedSourceFingerprint: recordedSource,
      expectedArtifactSha256: expectedArtifact,
      recordedArtifactSha256: recordedArtifact,
    };
  }
  if (recordedArtifact !== expectedArtifact) {
    return {
      valid: false,
      reason: `apps/${appName}/build artifact digest mismatch (expected ${expectedArtifact}, recorded ${recordedArtifact || '<empty>'})`,
      expectedSourceFingerprint: expectedSource,
      recordedSourceFingerprint: recordedSource,
      expectedArtifactSha256: expectedArtifact,
      recordedArtifactSha256: recordedArtifact,
    };
  }
  return {
    valid: true,
    reason: 'OK',
    expectedSourceFingerprint: expectedSource,
    recordedSourceFingerprint: recordedSource,
    expectedArtifactSha256: expectedArtifact,
    recordedArtifactSha256: recordedArtifact,
  };
}

const isMain = process.argv[1] && path.resolve(process.argv[1]) === path.resolve(fileURLToPath(import.meta.url));
if (isMain) {
  const [cmd, appName, customRoot] = process.argv.slice(2);
  const repoRoot = customRoot
    ? path.resolve(customRoot)
    : path.resolve(path.dirname(fileURLToPath(import.meta.url)), '../../..');
  try {
    if (cmd === 'compute') {
      process.stdout.write(`${computeSourceFingerprint(repoRoot, appName)}\n`);
    } else if (cmd === 'stamp') {
      const stamped = stampBuildFingerprint(repoRoot, appName);
      process.stdout.write(`Stamped apps/${appName}/build (${stamped.source_fingerprint.slice(0, 12)})\n`);
    } else if (cmd === 'verify') {
      const res = verifyBuildFingerprint(repoRoot, appName);
      if (!res.valid) {
        process.stderr.write(`INVALID_BUILD_FINGERPRINT [${appName}]: ${res.reason}\n`);
        process.exit(1);
      }
      process.stdout.write(`Verified apps/${appName}/build fingerprint (${res.expectedSourceFingerprint.slice(0, 12)})\n`);
    } else {
      process.stderr.write('Usage: build_fingerprint.mjs <compute|stamp|verify> <web|admin> [repoRoot]\n');
      process.exit(2);
    }
  } catch (err) {
    process.stderr.write(`ERROR: ${err.message}\n`);
    process.exit(1);
  }
}
