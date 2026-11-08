package migrate

import (
	"context"
	"errors"
	"os"
	"path/filepath"
	"strings"
	"testing"
	"time"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgconn"
	"github.com/jackc/pgx/v5/pgxpool"
)

func TestLoadAndValidateCanonicalP004Migration(t *testing.T) {
	dir := filepath.Join("..", "..", "..", "..", "infra", "migrations")
	migrations, err := LoadDir(dir)
	if err != nil {
		t.Fatalf("LoadDir(%q) failed: %v", dir, err)
	}
	if len(migrations) < 5 {
		t.Fatalf("expected at least 5 migrations in %q, got %d", dir, len(migrations))
	}

	m := migrations[0]
	if m.Version != 1 {
		t.Fatalf("expected version 1, got %d", m.Version)
	}
	if len(m.Checksum) != 64 {
		t.Fatalf("expected 64-char sha256 checksum, got %q", m.Checksum)
	}
	const wantChecksumV1 = "b2f4c41ab41c013d19f260a450982229bc4ef7f159d4f334cf56c6706a28a1e6"
	if m.Checksum != wantChecksumV1 {
		t.Fatalf("expected immutable v1 checksum %s, got %s", wantChecksumV1, m.Checksum)
	}
	if len(m.UpStatements) < 200 {
		t.Fatalf("expected >= 200 UpStatements, got %d", len(m.UpStatements))
	}
	if len(m.DownStatements) < 35 {
		t.Fatalf("expected >= 35 DownStatements, got %d", len(m.DownStatements))
	}

	if err := ValidateCanonicalMigrationContract(m); err != nil {
		t.Fatalf("ValidateCanonicalMigrationContract failed on canonical migration v1: %v", err)
	}

	m2 := migrations[1]
	if m2.Version != 2 {
		t.Fatalf("expected version 2, got %d", m2.Version)
	}
	if len(m2.Checksum) != 64 {
		t.Fatalf("expected 64-char sha256 checksum for v2, got %q", m2.Checksum)
	}
	if err := ValidateCanonicalMigrationContract(m2); err != nil {
		t.Fatalf("ValidateCanonicalMigrationContract failed on canonical migration v2: %v", err)
	}

	m3 := migrations[2]
	if m3.Version != 3 {
		t.Fatalf("expected version 3, got %d", m3.Version)
	}
	if len(m3.Checksum) != 64 {
		t.Fatalf("expected 64-char sha256 checksum for v3, got %q", m3.Checksum)
	}
	if err := ValidateCanonicalMigrationContract(m3); err != nil {
		t.Fatalf("ValidateCanonicalMigrationContract failed on canonical migration v3: %v", err)
	}

	m4 := migrations[3]
	if m4.Version != 4 {
		t.Fatalf("expected version 4, got %d", m4.Version)
	}
	if len(m4.Checksum) != 64 {
		t.Fatalf("expected 64-char sha256 checksum for v4, got %q", m4.Checksum)
	}
	if err := ValidateCanonicalMigrationContract(m4); err != nil {
		t.Fatalf("ValidateCanonicalMigrationContract failed on canonical migration v4: %v", err)
	}

	m5 := migrations[4]
	if m5.Version != 5 {
		t.Fatalf("expected version 5, got %d", m5.Version)
	}
	if len(m5.Checksum) != 64 {
		t.Fatalf("expected 64-char sha256 checksum for v5, got %q", m5.Checksum)
	}
	if err := ValidateCanonicalMigrationContract(m5); err != nil {
		t.Fatalf("ValidateCanonicalMigrationContract failed on canonical migration v5: %v", err)
	}

	m6 := migrations[5]
	if m6.Version != 6 {
		t.Fatalf("expected version 6, got %d", m6.Version)
	}
	if len(m6.Checksum) != 64 {
		t.Fatalf("expected 64-char sha256 checksum for v6, got %q", m6.Checksum)
	}
	const wantChecksumV6 = "d463a8f01946972a3f9c4243943a91452e0722b850478d7a998f842e0a1655f3"
	if m6.Checksum != wantChecksumV6 {
		t.Fatalf("expected immutable v6 checksum %s, got %s", wantChecksumV6, m6.Checksum)
	}
	if err := ValidateCanonicalMigrationContract(m6); err != nil {
		t.Fatalf("ValidateCanonicalMigrationContract failed on canonical migration v6: %v", err)
	}

	m7 := migrations[6]
	if m7.Version != 7 {
		t.Fatalf("expected version 7, got %d", m7.Version)
	}
	if len(m7.Checksum) != 64 {
		t.Fatalf("expected 64-char sha256 checksum for v7, got %q", m7.Checksum)
	}
	if err := ValidateCanonicalMigrationContract(m7); err != nil {
		t.Fatalf("ValidateCanonicalMigrationContract failed on canonical migration v7: %v", err)
	}

	m8 := migrations[7]
	if m8.Version != 8 {
		t.Fatalf("expected version 8, got %d", m8.Version)
	}
	if len(m8.Checksum) != 64 {
		t.Fatalf("expected 64-char sha256 checksum for v8, got %q", m8.Checksum)
	}
	if err := ValidateCanonicalMigrationContract(m8); err != nil {
		t.Fatalf("ValidateCanonicalMigrationContract failed on canonical migration v8: %v", err)
	}

	m9 := migrations[8]
	if m9.Version != 9 {
		t.Fatalf("expected version 9, got %d", m9.Version)
	}
	if len(m9.Checksum) != 64 {
		t.Fatalf("expected 64-char sha256 checksum for v9, got %q", m9.Checksum)
	}
	if err := ValidateCanonicalMigrationContract(m9); err != nil {
		t.Fatalf("ValidateCanonicalMigrationContract failed on canonical migration v9: %v", err)
	}

	m10 := migrations[9]
	if m10.Version != 10 {
		t.Fatalf("expected version 10, got %d", m10.Version)
	}
	if len(m10.Checksum) != 64 {
		t.Fatalf("expected 64-char sha256 checksum for v10, got %q", m10.Checksum)
	}
	if err := ValidateCanonicalMigrationContract(m10); err != nil {
		t.Fatalf("ValidateCanonicalMigrationContract failed on canonical migration v10: %v", err)
	}

	m11 := migrations[10]
	if m11.Version != 11 {
		t.Fatalf("expected version 11, got %d", m11.Version)
	}
	if len(m11.Checksum) != 64 {
		t.Fatalf("expected 64-char sha256 checksum for v11, got %q", m11.Checksum)
	}
	if err := ValidateCanonicalMigrationContract(m11); err != nil {
		t.Fatalf("ValidateCanonicalMigrationContract failed on canonical migration v11: %v", err)
	}

	m12 := migrations[11]
	if m12.Version != 12 {
		t.Fatalf("expected version 12, got %d", m12.Version)
	}
	if len(m12.Checksum) != 64 {
		t.Fatalf("expected 64-char sha256 checksum for v12, got %q", m12.Checksum)
	}
	if err := ValidateCanonicalMigrationContract(m12); err != nil {
		t.Fatalf("ValidateCanonicalMigrationContract failed on canonical migration v12: %v", err)
	}

	m13 := migrations[12]
	if m13.Version != 13 {
		t.Fatalf("expected version 13, got %d", m13.Version)
	}
	if len(m13.Checksum) != 64 {
		t.Fatalf("expected 64-char sha256 checksum for v13, got %q", m13.Checksum)
	}
	if err := ValidateCanonicalMigrationContract(m13); err != nil {
		t.Fatalf("ValidateCanonicalMigrationContract failed on canonical migration v13: %v", err)
	}

	m14 := migrations[13]
	if m14.Version != 14 {
		t.Fatalf("expected version 14, got %d", m14.Version)
	}
	if len(m14.Checksum) != 64 {
		t.Fatalf("expected 64-char sha256 checksum for v14, got %q", m14.Checksum)
	}
	if err := ValidateCanonicalMigrationContract(m14); err != nil {
		t.Fatalf("ValidateCanonicalMigrationContract failed on canonical migration v14: %v", err)
	}

	m15 := migrations[14]
	if m15.Version != 15 {
		t.Fatalf("expected version 15, got %d", m15.Version)
	}
	if len(m15.Checksum) != 64 {
		t.Fatalf("expected 64-char sha256 checksum for v15, got %q", m15.Checksum)
	}
	if err := ValidateCanonicalMigrationContract(m15); err != nil {
		t.Fatalf("ValidateCanonicalMigrationContract failed on canonical migration v15: %v", err)
	}

	m16 := migrations[15]
	if m16.Version != 16 {
		t.Fatalf("expected version 16, got %d", m16.Version)
	}
	if len(m16.Checksum) != 64 {
		t.Fatalf("expected 64-char sha256 checksum for v16, got %q", m16.Checksum)
	}
	if err := ValidateCanonicalMigrationContract(m16); err != nil {
		t.Fatalf("ValidateCanonicalMigrationContract failed on canonical migration v16: %v", err)
	}

	m17 := migrations[16]
	if m17.Version != 17 {
		t.Fatalf("expected version 17, got %d", m17.Version)
	}
	if len(m17.Checksum) != 64 {
		t.Fatalf("expected 64-char sha256 checksum for v17, got %q", m17.Checksum)
	}
	if err := ValidateCanonicalMigrationContract(m17); err != nil {
		t.Fatalf("ValidateCanonicalMigrationContract failed on canonical migration v17: %v", err)
	}

	m18 := migrations[17]
	if m18.Version != 18 {
		t.Fatalf("expected version 18, got %d", m18.Version)
	}
	if len(m18.Checksum) != 64 {
		t.Fatalf("expected 64-char sha256 checksum for v18, got %q", m18.Checksum)
	}
	if err := ValidateCanonicalMigrationContract(m18); err != nil {
		t.Fatalf("ValidateCanonicalMigrationContract failed on canonical migration v18: %v", err)
	}

	m19 := migrations[18]
	if m19.Version != 19 {
		t.Fatalf("expected version 19, got %d", m19.Version)
	}
	if len(m19.Checksum) != 64 {
		t.Fatalf("expected 64-char sha256 checksum for v19, got %q", m19.Checksum)
	}
	if err := ValidateCanonicalMigrationContract(m19); err != nil {
		t.Fatalf("ValidateCanonicalMigrationContract failed on canonical migration v19: %v", err)
	}

	m20 := migrations[19]
	if m20.Version != 20 {
		t.Fatalf("expected version 20, got %d", m20.Version)
	}
	if len(m20.Checksum) != 64 {
		t.Fatalf("expected 64-char sha256 checksum for v20, got %q", m20.Checksum)
	}
	if err := ValidateCanonicalMigrationContract(m20); err != nil {
		t.Fatalf("ValidateCanonicalMigrationContract failed on canonical migration v20: %v", err)
	}

	m21 := migrations[20]
	if m21.Version != 21 {
		t.Fatalf("expected version 21, got %d", m21.Version)
	}
	if len(m21.Checksum) != 64 {
		t.Fatalf("expected 64-char sha256 checksum for v21, got %q", m21.Checksum)
	}
	if err := ValidateCanonicalMigrationContract(m21); err != nil {
		t.Fatalf("ValidateCanonicalMigrationContract failed on canonical migration v21: %v", err)
	}

	m22 := migrations[21]
	if m22.Version != 22 {
		t.Fatalf("expected version 22, got %d", m22.Version)
	}
	if len(m22.Checksum) != 64 {
		t.Fatalf("expected 64-char sha256 checksum for v22, got %q", m22.Checksum)
	}
	if err := ValidateCanonicalMigrationContract(m22); err != nil {
		t.Fatalf("ValidateCanonicalMigrationContract failed on canonical migration v22: %v", err)
	}

	m23 := migrations[22]
	if m23.Version != 23 {
		t.Fatalf("expected version 23, got %d", m23.Version)
	}
	if len(m23.Checksum) != 64 {
		t.Fatalf("expected 64-char sha256 checksum for v23, got %q", m23.Checksum)
	}
	if err := ValidateCanonicalMigrationContract(m23); err != nil {
		t.Fatalf("ValidateCanonicalMigrationContract failed on canonical migration v23: %v", err)
	}

	m24 := migrations[23]
	if m24.Version != 24 {
		t.Fatalf("expected version 24, got %d", m24.Version)
	}
	if len(m24.Checksum) != 64 {
		t.Fatalf("expected 64-char sha256 checksum for v24, got %q", m24.Checksum)
	}
	if err := ValidateCanonicalMigrationContract(m24); err != nil {
		t.Fatalf("ValidateCanonicalMigrationContract failed on canonical migration v24: %v", err)
	}

	m25 := migrations[24]
	if m25.Version != 25 {
		t.Fatalf("expected version 25, got %d", m25.Version)
	}
	if len(m25.Checksum) != 64 {
		t.Fatalf("expected 64-char sha256 checksum for v25, got %q", m25.Checksum)
	}
	if err := ValidateCanonicalMigrationContract(m25); err != nil {
		t.Fatalf("ValidateCanonicalMigrationContract failed on canonical migration v25: %v", err)
	}

	m26 := migrations[25]
	if m26.Version != 26 {
		t.Fatalf("expected version 26, got %d", m26.Version)
	}
	if len(m26.Checksum) != 64 {
		t.Fatalf("expected 64-char sha256 checksum for v26, got %q", m26.Checksum)
	}
	if err := ValidateCanonicalMigrationContract(m26); err != nil {
		t.Fatalf("ValidateCanonicalMigrationContract failed on canonical migration v26: %v", err)
	}

	m27 := migrations[26]
	if m27.Version != 27 {
		t.Fatalf("expected version 27, got %d", m27.Version)
	}
	if len(m27.Checksum) != 64 {
		t.Fatalf("expected 64-char sha256 checksum for v27, got %q", m27.Checksum)
	}
	if err := ValidateCanonicalMigrationContract(m27); err != nil {
		t.Fatalf("ValidateCanonicalMigrationContract failed on canonical migration v27: %v", err)
	}

	m28 := migrations[27]
	if m28.Version != 28 {
		t.Fatalf("expected version 28, got %d", m28.Version)
	}
	if len(m28.Checksum) != 64 {
		t.Fatalf("expected 64-char sha256 checksum for v28, got %q", m28.Checksum)
	}
	if err := ValidateCanonicalMigrationContract(m28); err != nil {
		t.Fatalf("ValidateCanonicalMigrationContract failed on canonical migration v28: %v", err)
	}

	m29 := migrations[28]
	if m29.Version != 29 {
		t.Fatalf("expected version 29, got %d", m29.Version)
	}
	if len(m29.Checksum) != 64 {
		t.Fatalf("expected 64-char sha256 checksum for v29, got %q", m29.Checksum)
	}
	if err := ValidateCanonicalMigrationContract(m29); err != nil {
		t.Fatalf("ValidateCanonicalMigrationContract failed on canonical migration v29: %v", err)
	}

	m30 := migrations[29]
	if m30.Version != 30 {
		t.Fatalf("expected version 30, got %d", m30.Version)
	}
	if len(m30.Checksum) != 64 {
		t.Fatalf("expected 64-char sha256 checksum for v30, got %q", m30.Checksum)
	}
	if err := ValidateCanonicalMigrationContract(m30); err != nil {
		t.Fatalf("ValidateCanonicalMigrationContract failed on canonical migration v30: %v", err)
	}
	m31 := migrations[30]
	if m31.Version != 31 {
		t.Fatalf("expected version 31, got %d", m31.Version)
	}
	if len(m31.Checksum) != 64 {
		t.Fatalf("expected 64-char sha256 checksum for v31, got %q", m31.Checksum)
	}
	if err := ValidateCanonicalMigrationContract(m31); err != nil {
		t.Fatalf("ValidateCanonicalMigrationContract failed on canonical migration v31: %v", err)
	}

	m32 := migrations[31]
	if m32.Version != 32 {
		t.Fatalf("expected version 32, got %d", m32.Version)
	}
	if len(m32.Checksum) != 64 {
		t.Fatalf("expected 64-char sha256 checksum for v32, got %q", m32.Checksum)
	}
	if err := ValidateCanonicalMigrationContract(m32); err != nil {
		t.Fatalf("ValidateCanonicalMigrationContract failed on canonical migration v32: %v", err)
	}

	m33 := migrations[32]
	if m33.Version != 33 {
		t.Fatalf("expected version 33, got %d", m33.Version)
	}
	if len(m33.Checksum) != 64 {
		t.Fatalf("expected 64-char sha256 checksum for v33, got %q", m33.Checksum)
	}
	if err := ValidateCanonicalMigrationContract(m33); err != nil {
		t.Fatalf("ValidateCanonicalMigrationContract failed on canonical migration v33: %v", err)
	}

	m34 := migrations[33]
	if m34.Version != 34 {
		t.Fatalf("expected version 34, got %d", m34.Version)
	}
	if len(m34.Checksum) != 64 {
		t.Fatalf("expected 64-char sha256 checksum for v34, got %q", m34.Checksum)
	}
	if err := ValidateCanonicalMigrationContract(m34); err != nil {
		t.Fatalf("ValidateCanonicalMigrationContract failed on canonical migration v34: %v", err)
	}

	m35 := migrations[34]
	if m35.Version != 35 {
		t.Fatalf("expected version 35, got %d", m35.Version)
	}
	if len(m35.Checksum) != 64 {
		t.Fatalf("expected 64-char sha256 checksum for v35, got %q", m35.Checksum)
	}
	if err := ValidateCanonicalMigrationContract(m35); err != nil {
		t.Fatalf("ValidateCanonicalMigrationContract failed on canonical migration v35: %v", err)
	}

	m36 := migrations[35]
	if m36.Version != 36 {
		t.Fatalf("expected version 36, got %d", m36.Version)
	}
	if len(m36.Checksum) != 64 {
		t.Fatalf("expected 64-char sha256 checksum for v36, got %q", m36.Checksum)
	}
	if err := ValidateCanonicalMigrationContract(m36); err != nil {
		t.Fatalf("ValidateCanonicalMigrationContract failed on canonical migration v36: %v", err)
	}

	m37 := migrations[36]
	if m37.Version != 37 {
		t.Fatalf("expected version 37, got %d", m37.Version)
	}
	if len(m37.Checksum) != 64 {
		t.Fatalf("expected 64-char sha256 checksum for v37, got %q", m37.Checksum)
	}
	if err := ValidateCanonicalMigrationContract(m37); err != nil {
		t.Fatalf("ValidateCanonicalMigrationContract failed on canonical migration v37: %v", err)
	}

	m38 := migrations[37]
	if m38.Version != 38 {
		t.Fatalf("expected version 38, got %d", m38.Version)
	}
	if len(m38.Checksum) != 64 {
		t.Fatalf("expected 64-char sha256 checksum for v38, got %q", m38.Checksum)
	}
	if err := ValidateCanonicalMigrationContract(m38); err != nil {
		t.Fatalf("ValidateCanonicalMigrationContract failed on canonical migration v38: %v", err)
	}

	m39 := migrations[38]
	if m39.Version != 39 {
		t.Fatalf("expected version 39, got %d", m39.Version)
	}
	if len(m39.Checksum) != 64 {
		t.Fatalf("expected 64-char sha256 checksum for v39, got %q", m39.Checksum)
	}
	if err := ValidateCanonicalMigrationContract(m39); err != nil {
		t.Fatalf("ValidateCanonicalMigrationContract failed on canonical migration v39: %v", err)
	}

	m40 := migrations[39]
	if m40.Version != 40 {
		t.Fatalf("expected version 40, got %d", m40.Version)
	}
	if len(m40.Checksum) != 64 {
		t.Fatalf("expected 64-char sha256 checksum for v40, got %q", m40.Checksum)
	}
	if err := ValidateCanonicalMigrationContract(m40); err != nil {
		t.Fatalf("ValidateCanonicalMigrationContract failed on canonical migration v40: %v", err)
	}

	m41 := migrations[40]
	if m41.Version != 41 {
		t.Fatalf("expected version 41, got %d", m41.Version)
	}
	if len(m41.Checksum) != 64 {
		t.Fatalf("expected 64-char sha256 checksum for v41, got %q", m41.Checksum)
	}
	if err := ValidateCanonicalMigrationContract(m41); err != nil {
		t.Fatalf("ValidateCanonicalMigrationContract failed on canonical migration v41: %v", err)
	}

	m42 := migrations[41]
	if m42.Version != 42 {
		t.Fatalf("expected version 42, got %d", m42.Version)
	}
	if len(m42.Checksum) != 64 {
		t.Fatalf("expected 64-char sha256 checksum for v42, got %q", m42.Checksum)
	}
	if err := ValidateCanonicalMigrationContract(m42); err != nil {
		t.Fatalf("ValidateCanonicalMigrationContract failed on canonical migration v42: %v", err)
	}

	m43 := migrations[42]
	if m43.Version != 43 {
		t.Fatalf("expected version 43, got %d", m43.Version)
	}
	if len(m43.Checksum) != 64 {
		t.Fatalf("expected 64-char sha256 checksum for v43, got %q", m43.Checksum)
	}
	if err := ValidateCanonicalMigrationContract(m43); err != nil {
		t.Fatalf("ValidateCanonicalMigrationContract failed on canonical migration v43: %v", err)
	}

	m44 := migrations[43]
	if m44.Version != 44 {
		t.Fatalf("expected version 44, got %d", m44.Version)
	}
	if len(m44.Checksum) != 64 {
		t.Fatalf("expected 64-char sha256 checksum for v44, got %q", m44.Checksum)
	}
	if err := ValidateCanonicalMigrationContract(m44); err != nil {
		t.Fatalf("ValidateCanonicalMigrationContract failed on canonical migration v44: %v", err)
	}

	m45 := migrations[44]
	if m45.Version != 45 {
		t.Fatalf("expected version 45, got %d", m45.Version)
	}
	if len(m45.Checksum) != 64 {
		t.Fatalf("expected 64-char sha256 checksum for v45, got %q", m45.Checksum)
	}
	if err := ValidateCanonicalMigrationContract(m45); err != nil {
		t.Fatalf("ValidateCanonicalMigrationContract failed on canonical migration v45: %v", err)
	}

	m46 := migrations[45]
	if m46.Version != 46 {
		t.Fatalf("expected version 46, got %d", m46.Version)
	}
	if len(m46.Checksum) != 64 {
		t.Fatalf("expected 64-char sha256 checksum for v46, got %q", m46.Checksum)
	}
	if err := ValidateCanonicalMigrationContract(m46); err != nil {
		t.Fatalf("ValidateCanonicalMigrationContract failed on canonical migration v46: %v", err)
	}

	m47 := migrations[46]
	if m47.Version != 47 {
		t.Fatalf("expected version 47, got %d", m47.Version)
	}
	if len(m47.Checksum) != 64 {
		t.Fatalf("expected 64-char sha256 checksum for v47, got %q", m47.Checksum)
	}
	if err := ValidateCanonicalMigrationContract(m47); err != nil {
		t.Fatalf("ValidateCanonicalMigrationContract failed on canonical migration v47: %v", err)
	}

	m48 := migrations[47]
	if m48.Version != 48 {
		t.Fatalf("expected version 48, got %d", m48.Version)
	}
	if len(m48.Checksum) != 64 {
		t.Fatalf("expected 64-char sha256 checksum for v48, got %q", m48.Checksum)
	}
	const wantChecksumV48 = "b220691e9d89b6e0270f35c7edf522b8080610ea7d145b653fbe8fa5dc19cd5a"
	if m48.Checksum != wantChecksumV48 {
		t.Fatalf("expected immutable v48 checksum %s, got %s", wantChecksumV48, m48.Checksum)
	}
	if err := ValidateCanonicalMigrationContract(m48); err != nil {
		t.Fatalf("ValidateCanonicalMigrationContract failed on canonical migration v48: %v", err)
	}

	m49 := migrations[48]
	if m49.Version != 49 {
		t.Fatalf("expected version 49, got %d", m49.Version)
	}
	if len(m49.Checksum) != 64 {
		t.Fatalf("expected 64-char sha256 checksum for v49, got %q", m49.Checksum)
	}
	if err := ValidateCanonicalMigrationContract(m49); err != nil {
		t.Fatalf("ValidateCanonicalMigrationContract failed on canonical migration v49: %v", err)
	}
}

func TestValidateCanonicalMigrationContractRejectsViolations(t *testing.T) {
	dir := filepath.Join("..", "..", "..", "..", "infra", "migrations")
	migrations, err := LoadDir(dir)
	if err != nil {
		t.Fatalf("LoadDir failed: %v", err)
	}
	base := migrations[0]

	t.Run("rejects GRANT ALL", func(t *testing.T) {
		bad := base
		bad.UpStatements = append([]string{}, base.UpStatements...)
		bad.UpStatements = append(bad.UpStatements, "GRANT ALL ON workspaces TO app_user")
		if err := ValidateCanonicalMigrationContract(bad); !errors.Is(err, ErrContractViolation) {
			t.Fatalf("expected ErrContractViolation for GRANT ALL, got %v", err)
		}
	})

	t.Run("rejects FLOAT or REAL on money or credit column (DB-H-001)", func(t *testing.T) {
		bad := base
		bad.UpStatements = append([]string{}, base.UpStatements...)
		bad.UpStatements = append(bad.UpStatements, "CREATE TABLE bad_ledger (amount FLOAT NOT NULL, credits_balance REAL)")
		if err := ValidateCanonicalMigrationContract(bad); !errors.Is(err, ErrContractViolation) {
			t.Fatalf("expected ErrContractViolation for float money column, got %v", err)
		}
	})

	t.Run("rejects missing FORCE ROW LEVEL SECURITY on junction table", func(t *testing.T) {
		bad := base
		var filtered []string
		for _, s := range base.UpStatements {
			if strings.Contains(s, "ALTER TABLE trend_signals FORCE ROW LEVEL SECURITY") {
				continue
			}
			filtered = append(filtered, s)
		}
		bad.UpStatements = filtered
		if err := ValidateCanonicalMigrationContract(bad); !errors.Is(err, ErrContractViolation) {
			t.Fatalf("expected ErrContractViolation when FORCE RLS is missing on trend_signals, got %v", err)
		}
	})

	t.Run("rejects missing composite tenant FK", func(t *testing.T) {
		bad := base
		var filtered []string
		for _, s := range base.UpStatements {
			filtered = append(filtered, strings.ReplaceAll(s, "fk_trend_signals_trend_id_tenant", "removed_fk"))
		}
		bad.UpStatements = filtered
		if err := ValidateCanonicalMigrationContract(bad); !errors.Is(err, ErrContractViolation) {
			t.Fatalf("expected ErrContractViolation when composite tenant FK is missing, got %v", err)
		}
	})
}

type fakeRows struct {
	pgx.Rows
	records []AppliedRecord
	idx     int
}

func (r *fakeRows) Close()                        {}
func (r *fakeRows) Err() error                    { return nil }
func (r *fakeRows) CommandTag() pgconn.CommandTag { return pgconn.NewCommandTag("SELECT") }
func (r *fakeRows) Next() bool {
	if r.idx < len(r.records) {
		r.idx++
		return true
	}
	return false
}
func (r *fakeRows) Scan(dest ...any) error {
	rec := r.records[r.idx-1]
	*(dest[0].(*int64)) = rec.ID
	*(dest[1].(*int64)) = rec.VersionID
	*(dest[2].(*bool)) = rec.IsApplied
	*(dest[3].(*string)) = rec.Checksum
	*(dest[4].(*time.Time)) = rec.AppliedAt
	return nil
}

type fakeTx struct {
	runner     *fakeRunner
	committed  bool
	rolledBack bool
	failOnStmt string
}

func (tx *fakeTx) Begin(ctx context.Context) (pgx.Tx, error) { return tx, nil }
func (tx *fakeTx) Commit(ctx context.Context) error {
	tx.committed = true
	return nil
}
func (tx *fakeTx) Rollback(ctx context.Context) error {
	tx.rolledBack = true
	return nil
}
func (tx *fakeTx) CopyFrom(ctx context.Context, tableName pgx.Identifier, columnNames []string, rowSrc pgx.CopyFromSource) (int64, error) {
	return 0, nil
}
func (tx *fakeTx) SendBatch(ctx context.Context, b *pgx.Batch) pgx.BatchResults { return nil }
func (tx *fakeTx) LargeObjects() pgx.LargeObjects                               { return pgx.LargeObjects{} }
func (tx *fakeTx) Prepare(ctx context.Context, name, sql string) (*pgconn.StatementDescription, error) {
	return nil, nil
}
func (tx *fakeTx) Exec(ctx context.Context, sql string, args ...any) (pgconn.CommandTag, error) {
	if tx.failOnStmt != "" && strings.Contains(sql, tx.failOnStmt) {
		return pgconn.CommandTag{}, errors.New("simulated SQL failure")
	}
	if strings.Contains(sql, "INSERT INTO goose_db_version") {
		ver := args[0].(int64)
		cs := args[1].(string)
		applied := strings.Contains(sql, "true")
		tx.runner.records = append(tx.runner.records, AppliedRecord{
			ID:        int64(len(tx.runner.records) + 1),
			VersionID: ver,
			IsApplied: applied,
			Checksum:  cs,
			AppliedAt: time.Now().UTC(),
		})
	}
	return pgconn.NewCommandTag("EXEC 1"), nil
}
func (tx *fakeTx) Query(ctx context.Context, sql string, args ...any) (pgx.Rows, error) {
	return &fakeRows{}, nil
}
func (tx *fakeTx) QueryRow(ctx context.Context, sql string, args ...any) pgx.Row { return nil }
func (tx *fakeTx) Conn() *pgx.Conn                                               { return nil }

type fakeRunner struct {
	records    []AppliedRecord
	lastTx     *fakeTx
	failOnStmt string
}

func (f *fakeRunner) Begin(ctx context.Context) (pgx.Tx, error) {
	tx := &fakeTx{runner: f, failOnStmt: f.failOnStmt}
	f.lastTx = tx
	return tx, nil
}
func (f *fakeRunner) Exec(ctx context.Context, sql string, arguments ...any) (pgconn.CommandTag, error) {
	return pgconn.NewCommandTag("EXEC 1"), nil
}
func (f *fakeRunner) Query(ctx context.Context, sql string, args ...any) (pgx.Rows, error) {
	cp := make([]AppliedRecord, len(f.records))
	copy(cp, f.records)
	return &fakeRows{records: cp}, nil
}

func TestUpStatusDownTransactionalBehavior(t *testing.T) {
	dir := filepath.Join("..", "..", "..", "..", "infra", "migrations")
	ctx := context.Background()
	runner := &fakeRunner{}

	applied, err := Up(ctx, runner, dir)
	if err != nil {
		t.Fatalf("Up failed: %v", err)
	}
	if len(applied) != 49 {
		t.Fatalf("expected 49 applied migrations, got %d", len(applied))
	}
	for i, v := range applied {
		if v != int64(i+1) {
			t.Fatalf("expected version %d at index %d, got %d", i+1, i, v)
		}
	}
	if !runner.lastTx.committed || runner.lastTx.rolledBack {
		t.Fatalf("expected transaction committed")
	}

	// Idempotent second Up run does nothing.
	applied2, err := Up(ctx, runner, dir)
	if err != nil {
		t.Fatalf("second Up failed: %v", err)
	}
	if len(applied2) != 0 {
		t.Fatalf("expected 0 newly applied on second Up, got %v", applied2)
	}

	// Status reports Applied = true for all 49 migrations.
	statuses, err := Status(ctx, runner, dir)
	if err != nil {
		t.Fatalf("Status failed: %v", err)
	}
	if len(statuses) != 49 {
		t.Fatalf("expected status for 49 migrations, got %d", len(statuses))
	}
	for i, s := range statuses {
		if !s.Applied {
			t.Fatalf("expected status Applied=true for migration %d, got %+v", i+1, s)
		}
	}

	// Down without allowLocalRollback fails closed.
	if _, err := Down(ctx, runner, dir, false); !errors.Is(err, ErrRollbackForbidden) {
		t.Fatalf("expected ErrRollbackForbidden when allowLocalRollback=false, got %v", err)
	}

	// Down with allowLocalRollback=true rolls back version 49, then 48, then 47, then 46...
	rolled49, err := Down(ctx, runner, dir, true)
	if err != nil {
		t.Fatalf("Down(allowLocalRollback=true) for v49 failed: %v", err)
	}
	if rolled49 != 49 {
		t.Fatalf("expected rolled back version 49, got %d", rolled49)
	}
	rolled48, err := Down(ctx, runner, dir, true)
	if err != nil {
		t.Fatalf("Down(allowLocalRollback=true) for v48 failed: %v", err)
	}
	if rolled48 != 48 {
		t.Fatalf("expected rolled back version 48, got %d", rolled48)
	}
	rolled47, err := Down(ctx, runner, dir, true)
	if err != nil {
		t.Fatalf("Down(allowLocalRollback=true) for v47 failed: %v", err)
	}
	if rolled47 != 47 {
		t.Fatalf("expected rolled back version 47, got %d", rolled47)
	}
	rolled46, err := Down(ctx, runner, dir, true)
	if err != nil {
		t.Fatalf("Down(allowLocalRollback=true) for v46 failed: %v", err)
	}
	if rolled46 != 46 {
		t.Fatalf("expected rolled back version 46, got %d", rolled46)
	}
	rolled45, err := Down(ctx, runner, dir, true)
	if err != nil {
		t.Fatalf("Down(allowLocalRollback=true) for v45 failed: %v", err)
	}
	if rolled45 != 45 {
		t.Fatalf("expected rolled back version 45, got %d", rolled45)
	}
	rolled44, err := Down(ctx, runner, dir, true)
	if err != nil {
		t.Fatalf("Down(allowLocalRollback=true) for v44 failed: %v", err)
	}
	if rolled44 != 44 {
		t.Fatalf("expected rolled back version 44, got %d", rolled44)
	}
	rolled43, err := Down(ctx, runner, dir, true)
	if err != nil {
		t.Fatalf("Down(allowLocalRollback=true) for v43 failed: %v", err)
	}
	if rolled43 != 43 {
		t.Fatalf("expected rolled back version 43, got %d", rolled43)
	}
	rolled42, err := Down(ctx, runner, dir, true)
	if err != nil {
		t.Fatalf("Down(allowLocalRollback=true) for v42 failed: %v", err)
	}
	if rolled42 != 42 {
		t.Fatalf("expected rolled back version 42, got %d", rolled42)
	}
	rolled41, err := Down(ctx, runner, dir, true)
	if err != nil {
		t.Fatalf("Down(allowLocalRollback=true) for v41 failed: %v", err)
	}
	if rolled41 != 41 {
		t.Fatalf("expected rolled back version 41, got %d", rolled41)
	}
	rolled40, err := Down(ctx, runner, dir, true)
	if err != nil {
		t.Fatalf("Down(allowLocalRollback=true) for v40 failed: %v", err)
	}
	if rolled40 != 40 {
		t.Fatalf("expected rolled back version 40, got %d", rolled40)
	}
	rolled39, err := Down(ctx, runner, dir, true)
	if err != nil {
		t.Fatalf("Down(allowLocalRollback=true) for v39 failed: %v", err)
	}
	if rolled39 != 39 {
		t.Fatalf("expected rolled back version 39, got %d", rolled39)
	}
	rolled38, err := Down(ctx, runner, dir, true)
	if err != nil {
		t.Fatalf("Down(allowLocalRollback=true) for v38 failed: %v", err)
	}
	if rolled38 != 38 {
		t.Fatalf("expected rolled back version 38, got %d", rolled38)
	}
	rolled37, err := Down(ctx, runner, dir, true)
	if err != nil {
		t.Fatalf("Down(allowLocalRollback=true) for v37 failed: %v", err)
	}
	if rolled37 != 37 {
		t.Fatalf("expected rolled back version 37, got %d", rolled37)
	}
	rolled36, err := Down(ctx, runner, dir, true)
	if err != nil {
		t.Fatalf("Down(allowLocalRollback=true) for v36 failed: %v", err)
	}
	if rolled36 != 36 {
		t.Fatalf("expected rolled back version 36, got %d", rolled36)
	}
	rolled35, err := Down(ctx, runner, dir, true)
	if err != nil {
		t.Fatalf("Down(allowLocalRollback=true) for v35 failed: %v", err)
	}
	if rolled35 != 35 {
		t.Fatalf("expected rolled back version 35, got %d", rolled35)
	}
	rolled34, err := Down(ctx, runner, dir, true)
	if err != nil {
		t.Fatalf("Down(allowLocalRollback=true) for v34 failed: %v", err)
	}
	if rolled34 != 34 {
		t.Fatalf("expected rolled back version 34, got %d", rolled34)
	}
	rolled33, err := Down(ctx, runner, dir, true)
	if err != nil {
		t.Fatalf("Down(allowLocalRollback=true) for v33 failed: %v", err)
	}
	if rolled33 != 33 {
		t.Fatalf("expected rolled back version 33, got %d", rolled33)
	}
	rolled32, err := Down(ctx, runner, dir, true)
	if err != nil {
		t.Fatalf("Down(allowLocalRollback=true) for v32 failed: %v", err)
	}
	if rolled32 != 32 {
		t.Fatalf("expected rolled back version 32, got %d", rolled32)
	}
	rolled31, err := Down(ctx, runner, dir, true)
	if err != nil {
		t.Fatalf("Down(allowLocalRollback=true) for v31 failed: %v", err)
	}
	if rolled31 != 31 {
		t.Fatalf("expected rolled back version 31, got %d", rolled31)
	}
	rolled30, err := Down(ctx, runner, dir, true)
	if err != nil {
		t.Fatalf("Down(allowLocalRollback=true) for v30 failed: %v", err)
	}
	if rolled30 != 30 {
		t.Fatalf("expected rolled back version 30, got %d", rolled30)
	}
	rolled29, err := Down(ctx, runner, dir, true)
	if err != nil {
		t.Fatalf("Down(allowLocalRollback=true) for v29 failed: %v", err)
	}
	if rolled29 != 29 {
		t.Fatalf("expected rolled back version 29, got %d", rolled29)
	}
	rolled28, err := Down(ctx, runner, dir, true)
	if err != nil {
		t.Fatalf("Down(allowLocalRollback=true) for v28 failed: %v", err)
	}
	if rolled28 != 28 {
		t.Fatalf("expected rolled back version 28, got %d", rolled28)
	}
	rolled27, err := Down(ctx, runner, dir, true)
	if err != nil {
		t.Fatalf("Down(allowLocalRollback=true) for v27 failed: %v", err)
	}
	if rolled27 != 27 {
		t.Fatalf("expected rolled back version 27, got %d", rolled27)
	}
	rolled26, err := Down(ctx, runner, dir, true)
	if err != nil {
		t.Fatalf("Down(allowLocalRollback=true) for v26 failed: %v", err)
	}
	if rolled26 != 26 {
		t.Fatalf("expected rolled back version 26, got %d", rolled26)
	}
	rolled25, err := Down(ctx, runner, dir, true)
	if err != nil {
		t.Fatalf("Down(allowLocalRollback=true) for v25 failed: %v", err)
	}
	if rolled25 != 25 {
		t.Fatalf("expected rolled back version 25, got %d", rolled25)
	}
	rolled24, err := Down(ctx, runner, dir, true)
	if err != nil {
		t.Fatalf("Down(allowLocalRollback=true) for v24 failed: %v", err)
	}
	if rolled24 != 24 {
		t.Fatalf("expected rolled back version 24, got %d", rolled24)
	}
	rolled23, err := Down(ctx, runner, dir, true)
	if err != nil {
		t.Fatalf("Down(allowLocalRollback=true) for v23 failed: %v", err)
	}
	if rolled23 != 23 {
		t.Fatalf("expected rolled back version 23, got %d", rolled23)
	}
	rolled22, err := Down(ctx, runner, dir, true)
	if err != nil {
		t.Fatalf("Down(allowLocalRollback=true) for v22 failed: %v", err)
	}
	if rolled22 != 22 {
		t.Fatalf("expected rolled back version 22, got %d", rolled22)
	}
	rolled21, err := Down(ctx, runner, dir, true)
	if err != nil {
		t.Fatalf("Down(allowLocalRollback=true) for v21 failed: %v", err)
	}
	if rolled21 != 21 {
		t.Fatalf("expected rolled back version 21, got %d", rolled21)
	}
	rolled20, err := Down(ctx, runner, dir, true)
	if err != nil {
		t.Fatalf("Down(allowLocalRollback=true) for v20 failed: %v", err)
	}
	if rolled20 != 20 {
		t.Fatalf("expected rolled back version 20, got %d", rolled20)
	}
	rolled19, err := Down(ctx, runner, dir, true)
	if err != nil {
		t.Fatalf("Down(allowLocalRollback=true) for v19 failed: %v", err)
	}
	if rolled19 != 19 {
		t.Fatalf("expected rolled back version 19, got %d", rolled19)
	}
	rolled18, err := Down(ctx, runner, dir, true)
	if err != nil {
		t.Fatalf("Down(allowLocalRollback=true) for v18 failed: %v", err)
	}
	if rolled18 != 18 {
		t.Fatalf("expected rolled back version 18, got %d", rolled18)
	}
	rolled17, err := Down(ctx, runner, dir, true)
	if err != nil {
		t.Fatalf("Down(allowLocalRollback=true) for v17 failed: %v", err)
	}
	if rolled17 != 17 {
		t.Fatalf("expected rolled back version 17, got %d", rolled17)
	}
	rolled16, err := Down(ctx, runner, dir, true)
	if err != nil {
		t.Fatalf("Down(allowLocalRollback=true) for v16 failed: %v", err)
	}
	if rolled16 != 16 {
		t.Fatalf("expected rolled back version 16, got %d", rolled16)
	}
	rolled15, err := Down(ctx, runner, dir, true)
	if err != nil {
		t.Fatalf("Down(allowLocalRollback=true) for v15 failed: %v", err)
	}
	if rolled15 != 15 {
		t.Fatalf("expected rolled back version 15, got %d", rolled15)
	}
	rolled14, err := Down(ctx, runner, dir, true)
	if err != nil {
		t.Fatalf("Down(allowLocalRollback=true) for v14 failed: %v", err)
	}
	if rolled14 != 14 {
		t.Fatalf("expected rolled back version 14, got %d", rolled14)
	}
	rolled13, err := Down(ctx, runner, dir, true)
	if err != nil {
		t.Fatalf("Down(allowLocalRollback=true) for v13 failed: %v", err)
	}
	if rolled13 != 13 {
		t.Fatalf("expected rolled back version 13, got %d", rolled13)
	}
	rolled12, err := Down(ctx, runner, dir, true)
	if err != nil {
		t.Fatalf("Down(allowLocalRollback=true) for v12 failed: %v", err)
	}
	if rolled12 != 12 {
		t.Fatalf("expected rolled back version 12, got %d", rolled12)
	}
	rolled11, err := Down(ctx, runner, dir, true)
	if err != nil {
		t.Fatalf("Down(allowLocalRollback=true) for v11 failed: %v", err)
	}
	if rolled11 != 11 {
		t.Fatalf("expected rolled back version 11, got %d", rolled11)
	}
	rolled10, err := Down(ctx, runner, dir, true)
	if err != nil {
		t.Fatalf("Down(allowLocalRollback=true) for v10 failed: %v", err)
	}
	if rolled10 != 10 {
		t.Fatalf("expected rolled back version 10, got %d", rolled10)
	}
	rolled9, err := Down(ctx, runner, dir, true)
	if err != nil {
		t.Fatalf("Down(allowLocalRollback=true) for v9 failed: %v", err)
	}
	if rolled9 != 9 {
		t.Fatalf("expected rolled back version 9, got %d", rolled9)
	}
	rolled8, err := Down(ctx, runner, dir, true)
	if err != nil {
		t.Fatalf("Down(allowLocalRollback=true) for v8 failed: %v", err)
	}
	if rolled8 != 8 {
		t.Fatalf("expected rolled back version 8, got %d", rolled8)
	}
	rolled7, err := Down(ctx, runner, dir, true)
	if err != nil {
		t.Fatalf("Down(allowLocalRollback=true) for v7 failed: %v", err)
	}
	if rolled7 != 7 {
		t.Fatalf("expected rolled back version 7, got %d", rolled7)
	}
	rolled6, err := Down(ctx, runner, dir, true)
	if err != nil {
		t.Fatalf("Down(allowLocalRollback=true) for v6 failed: %v", err)
	}
	if rolled6 != 6 {
		t.Fatalf("expected rolled back version 6, got %d", rolled6)
	}
	rolled5, err := Down(ctx, runner, dir, true)
	if err != nil {
		t.Fatalf("Down(allowLocalRollback=true) for v5 failed: %v", err)
	}
	if rolled5 != 5 {
		t.Fatalf("expected rolled back version 5, got %d", rolled5)
	}
	rolled4, err := Down(ctx, runner, dir, true)
	if err != nil {
		t.Fatalf("Down(allowLocalRollback=true) for v4 failed: %v", err)
	}
	if rolled4 != 4 {
		t.Fatalf("expected rolled back version 4, got %d", rolled4)
	}
	rolled3, err := Down(ctx, runner, dir, true)
	if err != nil {
		t.Fatalf("Down(allowLocalRollback=true) for v3 failed: %v", err)
	}
	if rolled3 != 3 {
		t.Fatalf("expected rolled back version 3, got %d", rolled3)
	}
	rolled2, err := Down(ctx, runner, dir, true)
	if err != nil {
		t.Fatalf("Down(allowLocalRollback=true) for v2 failed: %v", err)
	}
	if rolled2 != 2 {
		t.Fatalf("expected rolled back version 2, got %d", rolled2)
	}
	rolled, err := Down(ctx, runner, dir, true)
	if err != nil {
		t.Fatalf("Down(allowLocalRollback=true) for v1 failed: %v", err)
	}
	if rolled != 1 {
		t.Fatalf("expected rolled back version 1, got %d", rolled)
	}

	// Simulate statement failure during Up -> must roll back transaction.
	runner.failOnStmt = "CREATE TABLE IF NOT EXISTS bundles"
	if _, err := Up(ctx, runner, dir); err == nil {
		t.Fatalf("expected error on simulated statement failure")
	}
	if !runner.lastTx.rolledBack || runner.lastTx.committed {
		t.Fatalf("expected rollback on failed migration statement")
	}

	// Checksum drift detection fails closed.
	runner.failOnStmt = ""
	runner.records = []AppliedRecord{{
		ID:        1,
		VersionID: 1,
		IsApplied: true,
		Checksum:  "0000000000000000000000000000000000000000000000000000000000000000",
		AppliedAt: time.Now().UTC(),
	}}
	if _, err := Up(ctx, runner, dir); !errors.Is(err, ErrChecksumMismatch) {
		t.Fatalf("expected ErrChecksumMismatch, got %v", err)
	}
}

func TestPostgresLiveMigrationAndAppUserRLS(t *testing.T) {
	dsn := os.Getenv("CREATIVANTA_TEST_DATABASE_URL")
	if dsn == "" {
		t.Skip("CREATIVANTA_TEST_DATABASE_URL not set; live PostgreSQL 17.10 migration & RLS suite executes in CI")
	}

	ctx, cancel := context.WithTimeout(context.Background(), 45*time.Second)
	defer cancel()

	adminPool, err := pgxpool.New(ctx, dsn)
	if err != nil {
		t.Fatalf("connect adminPool: %v", err)
	}
	defer adminPool.Close()

	// Ensure clean public schema before running Goose migration test.
	_, _ = adminPool.Exec(ctx, `DROP SCHEMA IF EXISTS public CASCADE; CREATE SCHEMA public; GRANT ALL ON SCHEMA public TO CURRENT_USER; GRANT USAGE ON SCHEMA public TO PUBLIC;`)
	dir := filepath.Join("..", "..", "..", "..", "infra", "migrations")

	// Apply migration Up, then Down twenty-five times, then Up again to prove full Goose SQL repeatability.
	applied, err := Up(ctx, adminPool, dir)
	if err != nil {
		t.Fatalf("initial Up failed: %v", err)
	}
	if len(applied) != 49 {
		t.Fatalf("expected 49 applied migrations, got %v", applied)
	}
	if _, err := Down(ctx, adminPool, dir, true); err != nil {
		t.Fatalf("Down rollback v49 failed: %v", err)
	}
	if _, err := Down(ctx, adminPool, dir, true); err != nil {
		t.Fatalf("Down rollback v48 failed: %v", err)
	}
	if _, err := Down(ctx, adminPool, dir, true); err != nil {
		t.Fatalf("Down rollback v47 failed: %v", err)
	}
	if _, err := Down(ctx, adminPool, dir, true); err != nil {
		t.Fatalf("Down rollback v46 failed: %v", err)
	}
	if _, err := Down(ctx, adminPool, dir, true); err != nil {
		t.Fatalf("Down rollback v45 failed: %v", err)
	}
	if _, err := Down(ctx, adminPool, dir, true); err != nil {
		t.Fatalf("Down rollback v44 failed: %v", err)
	}
	if _, err := Down(ctx, adminPool, dir, true); err != nil {
		t.Fatalf("Down rollback v43 failed: %v", err)
	}
	if _, err := Down(ctx, adminPool, dir, true); err != nil {
		t.Fatalf("Down rollback v42 failed: %v", err)
	}
	if _, err := Down(ctx, adminPool, dir, true); err != nil {
		t.Fatalf("Down rollback v41 failed: %v", err)
	}
	if _, err := Down(ctx, adminPool, dir, true); err != nil {
		t.Fatalf("Down rollback v40 failed: %v", err)
	}
	if _, err := Down(ctx, adminPool, dir, true); err != nil {
		t.Fatalf("Down rollback v39 failed: %v", err)
	}
	if _, err := Down(ctx, adminPool, dir, true); err != nil {
		t.Fatalf("Down rollback v38 failed: %v", err)
	}
	if _, err := Down(ctx, adminPool, dir, true); err != nil {
		t.Fatalf("Down rollback v37 failed: %v", err)
	}
	if _, err := Down(ctx, adminPool, dir, true); err != nil {
		t.Fatalf("Down rollback v36 failed: %v", err)
	}
	if _, err := Down(ctx, adminPool, dir, true); err != nil {
		t.Fatalf("Down rollback v35 failed: %v", err)
	}
	if _, err := Down(ctx, adminPool, dir, true); err != nil {
		t.Fatalf("Down rollback v34 failed: %v", err)
	}
	if _, err := Down(ctx, adminPool, dir, true); err != nil {
		t.Fatalf("Down rollback v33 failed: %v", err)
	}
	if _, err := Down(ctx, adminPool, dir, true); err != nil {
		t.Fatalf("Down rollback v32 failed: %v", err)
	}
	if _, err := Down(ctx, adminPool, dir, true); err != nil {
		t.Fatalf("Down rollback v31 failed: %v", err)
	}
	if _, err := Down(ctx, adminPool, dir, true); err != nil {
		t.Fatalf("Down rollback v30 failed: %v", err)
	}
	if _, err := Down(ctx, adminPool, dir, true); err != nil {
		t.Fatalf("Down rollback v29 failed: %v", err)
	}
	if _, err := Down(ctx, adminPool, dir, true); err != nil {
		t.Fatalf("Down rollback v28 failed: %v", err)
	}
	if _, err := Down(ctx, adminPool, dir, true); err != nil {
		t.Fatalf("Down rollback v27 failed: %v", err)
	}
	if _, err := Down(ctx, adminPool, dir, true); err != nil {
		t.Fatalf("Down rollback v26 failed: %v", err)
	}
	if _, err := Down(ctx, adminPool, dir, true); err != nil {
		t.Fatalf("Down rollback v25 failed: %v", err)
	}
	if _, err := Down(ctx, adminPool, dir, true); err != nil {
		t.Fatalf("Down rollback v24 failed: %v", err)
	}
	if _, err := Down(ctx, adminPool, dir, true); err != nil {
		t.Fatalf("Down rollback v23 failed: %v", err)
	}
	if _, err := Down(ctx, adminPool, dir, true); err != nil {
		t.Fatalf("Down rollback v22 failed: %v", err)
	}
	if _, err := Down(ctx, adminPool, dir, true); err != nil {
		t.Fatalf("Down rollback v21 failed: %v", err)
	}
	if _, err := Down(ctx, adminPool, dir, true); err != nil {
		t.Fatalf("Down rollback v20 failed: %v", err)
	}
	if _, err := Down(ctx, adminPool, dir, true); err != nil {
		t.Fatalf("Down rollback v19 failed: %v", err)
	}
	if _, err := Down(ctx, adminPool, dir, true); err != nil {
		t.Fatalf("Down rollback v18 failed: %v", err)
	}
	if _, err := Down(ctx, adminPool, dir, true); err != nil {
		t.Fatalf("Down rollback v17 failed: %v", err)
	}
	if _, err := Down(ctx, adminPool, dir, true); err != nil {
		t.Fatalf("Down rollback v16 failed: %v", err)
	}
	if _, err := Down(ctx, adminPool, dir, true); err != nil {
		t.Fatalf("Down rollback v15 failed: %v", err)
	}
	if _, err := Down(ctx, adminPool, dir, true); err != nil {
		t.Fatalf("Down rollback v14 failed: %v", err)
	}
	if _, err := Down(ctx, adminPool, dir, true); err != nil {
		t.Fatalf("Down rollback v13 failed: %v", err)
	}
	if _, err := Down(ctx, adminPool, dir, true); err != nil {
		t.Fatalf("Down rollback v12 failed: %v", err)
	}
	if _, err := Down(ctx, adminPool, dir, true); err != nil {
		t.Fatalf("Down rollback v11 failed: %v", err)
	}
	if _, err := Down(ctx, adminPool, dir, true); err != nil {
		t.Fatalf("Down rollback v10 failed: %v", err)
	}
	if _, err := Down(ctx, adminPool, dir, true); err != nil {
		t.Fatalf("Down rollback v9 failed: %v", err)
	}
	if _, err := Down(ctx, adminPool, dir, true); err != nil {
		t.Fatalf("Down rollback v8 failed: %v", err)
	}
	if _, err := Down(ctx, adminPool, dir, true); err != nil {
		t.Fatalf("Down rollback v7 failed: %v", err)
	}
	if _, err := Down(ctx, adminPool, dir, true); err != nil {
		t.Fatalf("Down rollback v6 failed: %v", err)
	}
	if _, err := Down(ctx, adminPool, dir, true); err != nil {
		t.Fatalf("Down rollback v5 failed: %v", err)
	}
	if _, err := Down(ctx, adminPool, dir, true); err != nil {
		t.Fatalf("Down rollback v4 failed: %v", err)
	}
	if _, err := Down(ctx, adminPool, dir, true); err != nil {
		t.Fatalf("Down rollback v3 failed: %v", err)
	}
	if _, err := Down(ctx, adminPool, dir, true); err != nil {
		t.Fatalf("Down rollback v2 failed: %v", err)
	}
	if _, err := Down(ctx, adminPool, dir, true); err != nil {
		t.Fatalf("Down rollback v1 failed: %v", err)
	}
	reApplied, err := Up(ctx, adminPool, dir)
	if err != nil {
		t.Fatalf("re-apply Up after Down failed: %v", err)
	}
	if len(reApplied) != len(applied) {
		t.Fatalf("expected all %d migrations to re-apply after full Down rollback, got %d (%v)", len(applied), len(reApplied), reApplied)
	}

	const (
		userA    = "11111111-1111-4111-8111-111111111111"
		userB    = "22222222-2222-4222-8222-222222222222"
		tenantA  = "aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa"
		tenantB  = "bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb"
		trendA   = "33333333-3333-4333-8333-333333333333"
		signalA  = "44444444-4444-4444-8444-444444444444"
		trendB   = "55555555-5555-4555-8555-555555555555"
		signalB  = "66666666-6666-4666-8666-666666666666"
		ticketA  = "77777777-7777-4777-8777-777777777777"
		evidA    = "88888888-8888-4888-8888-888888888888"
		kitPubA  = "99999999-9999-4999-8999-999999999991"
		kitHidA  = "99999999-9999-4999-8999-999999999992"
		connAccA = "cccccccc-cccc-4ccc-8ccc-cccccccccccc"
		auditA   = "dddddddd-dddd-4ddd-8ddd-dddddddddddd"
	)

	// Seed users, two tenants, trends, signals, support tickets, media kits, connected accounts, and audit events.
	seedSQL := `
		INSERT INTO users (user_id, external_auth_id, email, display_name, status) VALUES
		  ('11111111-1111-4111-8111-111111111111', 'user_ext_a', 'a@example.com', 'User A', 'active'),
		  ('22222222-2222-4222-8222-222222222222', 'user_ext_b', 'b@example.com', 'User B', 'active');

		INSERT INTO workspaces (workspace_id, name, slug, owner_user_id, status) VALUES
		  ('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa', 'Tenant A', 'tenant-a', '11111111-1111-4111-8111-111111111111', 'active'),
		  ('bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb', 'Tenant B', 'tenant-b', '22222222-2222-4222-8222-222222222222', 'active');

		INSERT INTO workspace_members (workspace_id, user_id, role, status) VALUES
		  ('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa', '11111111-1111-4111-8111-111111111111', 'owner', 'active'),
		  ('bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb', '22222222-2222-4222-8222-222222222222', 'owner', 'active');

		INSERT INTO connected_accounts (connected_account_id, workspace_id, platform, account_type, external_account_id, connection_state) VALUES
		  ('cccccccc-cccc-4ccc-8ccc-cccccccccccc', 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa', 'tiktok', 'creator', 'tt_acc_a', 'connected');

		INSERT INTO trends (trend_id, workspace_id, title) VALUES
		  ('33333333-3333-4333-8333-333333333333', 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa', 'Trend A'),
		  ('55555555-5555-4555-8555-555555555555', 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb', 'Trend B');

		INSERT INTO signals (signal_id, workspace_id, source_platform, signal_type, raw_payload) VALUES
		  ('44444444-4444-4444-8444-444444444444', 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa', 'tiktok', 'video', '{"v":1}'::jsonb),
		  ('66666666-6666-4666-8666-666666666666', 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb', 'tiktok', 'video', '{"v":2}'::jsonb);

		INSERT INTO trend_signals (workspace_id, trend_id, signal_id) VALUES
		  ('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa', '33333333-3333-4333-8333-333333333333', '44444444-4444-4444-8444-444444444444'),
		  ('bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb', '55555555-5555-4555-8555-555555555555', '66666666-6666-4666-8666-666666666666');

		INSERT INTO support_tickets (ticket_id, workspace_id, user_id, ticket_number, subject) VALUES
		  ('77777777-7777-4777-8777-777777777777', 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa', '11111111-1111-4111-8111-111111111111', 'TK-0001', 'Help A');

		INSERT INTO support_ticket_messages (workspace_id, ticket_id, author_type, author_id, body, is_internal_note) VALUES
		  ('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa', '77777777-7777-4777-8777-777777777777', 'user', '11111111-1111-4111-8111-111111111111', 'Public reply', false),
		  ('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa', '77777777-7777-4777-8777-777777777777', 'admin', NULL, 'Secret internal admin triage note', true);

		INSERT INTO media_kits (media_kit_id, workspace_id, sections, directory_opt_in, directory_status, directory_profile) VALUES
		  ('99999999-9999-4999-8999-999999999991', 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa', '[{"private":"draft"}]'::jsonb, true, 'published', '{"display_name":"Creator A","handle":"creator_a","categories":["beauty"],"platforms":["tiktok"],"accepts_inquiries":true}'::jsonb),
		  ('99999999-9999-4999-8999-999999999992', 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa', '[{"private":"secret"}]'::jsonb, false, 'hidden', '{"display_name":"Hidden Creator","handle":"hidden_a"}'::jsonb);

		INSERT INTO watchlists (watchlist_id, workspace_id, name, type) VALUES
		  ('aaaaaaaa-1111-4aaa-8aaa-aaaaaaaaaaaa', 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa', 'Watchlist A', 'trend');

		INSERT INTO watchlist_alert_logs (alert_log_id, workspace_id, watchlist_id, trend_id, alert_fingerprint, cooldown_until) VALUES
		  ('aaaaaaaa-2222-4aaa-8aaa-aaaaaaaaaaaa', 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa', 'aaaaaaaa-1111-4aaa-8aaa-aaaaaaaaaaaa', '33333333-3333-4333-8333-333333333333', 'fp_a', NOW() + INTERVAL '1 hour');

		INSERT INTO competitor_entities (competitor_id, workspace_id, name, entity_type, platform, external_handle) VALUES
		  ('aaaaaaaa-3333-4aaa-8aaa-aaaaaaaaaaaa', 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa', 'Competitor A', 'creator', 'tiktok', '@competitor_a');

		INSERT INTO benchmark_snapshots (snapshot_id, workspace_id, competitor_id, snapshot_type, source_class, confidence) VALUES
		  ('aaaaaaaa-4444-4aaa-8aaa-aaaaaaaaaaaa', 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa', 'aaaaaaaa-3333-4aaa-8aaa-aaaaaaaaaaaa', 'benchmark', 'inferred', 'high');
	`
	if _, err := adminPool.Exec(ctx, seedSQL); err != nil {
		t.Fatalf("seedSQL failed: %v", err)
	}

	// Test 1: As app_user scoped to Tenant B, cannot read Tenant A's trends or trend_signals (direct-junction isolation).
	tx, err := adminPool.Begin(ctx)
	if err != nil {
		t.Fatal(err)
	}
	defer tx.Rollback(ctx)

	if _, err := tx.Exec(ctx, `SET LOCAL ROLE app_user`); err != nil {
		t.Fatalf("SET LOCAL ROLE app_user: %v", err)
	}
	if _, err := tx.Exec(ctx, `SELECT set_config('app.current_tenant_id', $1, true), set_config('app.current_user_id', $2, true)`, tenantB, userB); err != nil {
		t.Fatal(err)
	}

	var visibleTrends int
	if err := tx.QueryRow(ctx, `SELECT COUNT(*) FROM trends WHERE trend_id = $1::uuid`, trendA).Scan(&visibleTrends); err != nil {
		t.Fatal(err)
	}
	if visibleTrends != 0 {
		t.Fatalf("two-tenant attack succeeded: Tenant B saw %d rows from Tenant A trends", visibleTrends)
	}

	var visibleJunction int
	if err := tx.QueryRow(ctx, `SELECT COUNT(*) FROM trend_signals WHERE trend_id = $1::uuid`, trendA).Scan(&visibleJunction); err != nil {
		t.Fatal(err)
	}
	if visibleJunction != 0 {
		t.Fatalf("direct-junction read attack succeeded: Tenant B saw %d rows from Tenant A trend_signals", visibleJunction)
	}

	var visibleWatchlists int
	if err := tx.QueryRow(ctx, `SELECT COUNT(*) FROM watchlists WHERE workspace_id = $1::uuid`, tenantA).Scan(&visibleWatchlists); err != nil {
		t.Fatal(err)
	}
	if visibleWatchlists != 0 {
		t.Fatalf("watchlists RLS breach: Tenant B saw %d watchlists from Tenant A", visibleWatchlists)
	}

	var visibleAlertLogs int
	if err := tx.QueryRow(ctx, `SELECT COUNT(*) FROM watchlist_alert_logs WHERE workspace_id = $1::uuid`, tenantA).Scan(&visibleAlertLogs); err != nil {
		t.Fatal(err)
	}
	if visibleAlertLogs != 0 {
		t.Fatalf("watchlist_alert_logs RLS breach: Tenant B saw %d alert logs from Tenant A", visibleAlertLogs)
	}

	var visibleCompetitors int
	if err := tx.QueryRow(ctx, `SELECT COUNT(*) FROM competitor_entities WHERE workspace_id = $1::uuid`, tenantA).Scan(&visibleCompetitors); err != nil {
		t.Fatal(err)
	}
	if visibleCompetitors != 0 {
		t.Fatalf("competitor_entities RLS breach: Tenant B saw %d competitors from Tenant A", visibleCompetitors)
	}

	var visibleBenchmarks int
	if err := tx.QueryRow(ctx, `SELECT COUNT(*) FROM benchmark_snapshots WHERE workspace_id = $1::uuid`, tenantA).Scan(&visibleBenchmarks); err != nil {
		t.Fatal(err)
	}
	if visibleBenchmarks != 0 {
		t.Fatalf("benchmark_snapshots RLS breach: Tenant B saw %d benchmarks from Tenant A", visibleBenchmarks)
	}

	// Test 2: Cross-tenant composite FK write attack on trend_signals and external_effects denied!
	if _, err := tx.Exec(ctx, `SAVEPOINT sp_cross_junction`); err != nil {
		t.Fatal(err)
	}
	if _, err := tx.Exec(ctx, `
		INSERT INTO trend_signals (workspace_id, trend_id, signal_id)
		VALUES ($1::uuid, $2::uuid, $3::uuid)
	`, tenantB, trendA, signalB); err == nil {
		t.Fatalf("expected composite tenant FK to reject cross-tenant trend_signals link")
	}
	_, _ = tx.Exec(ctx, `ROLLBACK TO SAVEPOINT sp_cross_junction`)

	if _, err := tx.Exec(ctx, `SAVEPOINT sp_cross_watchlist`); err != nil {
		t.Fatal(err)
	}
	if _, err := tx.Exec(ctx, `
		INSERT INTO watchlists (watchlist_id, workspace_id, name, type)
		VALUES (gen_random_uuid(), $1::uuid, 'Cross Tenant Watchlist', 'trend')
	`, tenantA); err == nil {
		t.Fatalf("expected RLS WITH CHECK to reject Tenant B inserting watchlist with workspace_id=Tenant A")
	}
	_, _ = tx.Exec(ctx, `ROLLBACK TO SAVEPOINT sp_cross_watchlist`)

	if _, err := tx.Exec(ctx, `SAVEPOINT sp_cross_effect_fk`); err != nil {
		t.Fatal(err)
	}
	if _, err := tx.Exec(ctx, `
		INSERT INTO external_effects (workspace_id, operation_key, provider, connected_account_id, aggregate_type, aggregate_id, status)
		VALUES ($1::uuid, 'op_cross_1', 'tiktok', $2::uuid, 'publish_job', $3::uuid, 'prepared')
	`, tenantB, connAccA, trendB); err == nil {
		t.Fatalf("expected fk_external_effects_connected_account_id_tenant to reject cross-tenant connected_account_id")
	}
	_, _ = tx.Exec(ctx, `ROLLBACK TO SAVEPOINT sp_cross_effect_fk`)

	if _, err := tx.Exec(ctx, `SAVEPOINT sp_cross_benchmark_fk`); err != nil {
		t.Fatal(err)
	}
	if _, err := tx.Exec(ctx, `
		INSERT INTO benchmark_snapshots (snapshot_id, workspace_id, competitor_id, snapshot_type, source_class, confidence)
		VALUES (gen_random_uuid(), $1::uuid, 'aaaaaaaa-3333-4aaa-8aaa-aaaaaaaaaaaa'::uuid, 'benchmark', 'inferred', 'medium')
	`, tenantB); err == nil {
		t.Fatalf("expected fk_benchmark_snapshots_competitor_id_tenant to reject cross-tenant competitor_id link")
	}
	_, _ = tx.Exec(ctx, `ROLLBACK TO SAVEPOINT sp_cross_benchmark_fk`)

	if _, err := tx.Exec(ctx, `SAVEPOINT sp_cross_benchmark_rls`); err != nil {
		t.Fatal(err)
	}
	if _, err := tx.Exec(ctx, `
		INSERT INTO benchmark_snapshots (snapshot_id, workspace_id, snapshot_type, source_class, confidence)
		VALUES (gen_random_uuid(), $1::uuid, 'benchmark', 'inferred', 'low')
	`, tenantA); err == nil {
		t.Fatalf("expected RLS WITH CHECK to reject Tenant B inserting benchmark_snapshots with workspace_id=Tenant A")
	}
	_, _ = tx.Exec(ctx, `ROLLBACK TO SAVEPOINT sp_cross_benchmark_rls`)

	// Test 3: Switch to Tenant A as app_user -> verify support_ticket_messages hides is_internal_note = true!
	if _, err := tx.Exec(ctx, `SELECT set_config('app.current_tenant_id', $1, true), set_config('app.current_user_id', $2, true)`, tenantA, userA); err != nil {
		t.Fatal(err)
	}
	var msgCount int
	if err := tx.QueryRow(ctx, `SELECT COUNT(*) FROM support_ticket_messages WHERE ticket_id = $1::uuid`, ticketA).Scan(&msgCount); err != nil {
		t.Fatal(err)
	}
	if msgCount != 1 {
		t.Fatalf("expected exactly 1 non-internal ticket message visible to app_user, got %d", msgCount)
	}

	// Attempting to insert an internal note as app_user must fail WITH CHECK!
	if _, err := tx.Exec(ctx, `SAVEPOINT sp_internal_note`); err != nil {
		t.Fatal(err)
	}
	if _, err := tx.Exec(ctx, `
		INSERT INTO support_ticket_messages (workspace_id, ticket_id, author_type, author_id, body, is_internal_note)
		VALUES ($1::uuid, $2::uuid, 'user', $3::uuid, 'Forged internal note', true)
	`, tenantA, ticketA, userA); err == nil {
		t.Fatalf("expected RLS WITH CHECK to reject app_user inserting is_internal_note=true")
	}
	_, _ = tx.Exec(ctx, `ROLLBACK TO SAVEPOINT sp_internal_note`)

	// Test 4: Immutable evidence_objects trigger protect_evidence_content() and audit_events trigger protect_audit_log_immutability().
	if _, err := tx.Exec(ctx, `
		INSERT INTO evidence_objects (evidence_id, workspace_id, evidence_type, content_hash)
		VALUES ($1::uuid, $2::uuid, 'receipt', 'sha512_original_hash')
	`, evidA, tenantA); err != nil {
		t.Fatalf("insert evidence_objects failed: %v", err)
	}
	if _, err := tx.Exec(ctx, `
		INSERT INTO audit_events (audit_event_id, workspace_id, actor_user_id, actor_type, action, resource_type, resource_id)
		VALUES ($1::uuid, $2::uuid, $3::uuid, 'user', 'diagnostics.check', 'workspace', $2::uuid)
	`, auditA, tenantA, userA); err != nil {
		t.Fatalf("insert audit_events failed: %v", err)
	}
	if _, err := tx.Exec(ctx, `SAVEPOINT sp_audit_update`); err != nil {
		t.Fatal(err)
	}
	if _, err := tx.Exec(ctx, `UPDATE audit_events SET action = 'tampered' WHERE audit_event_id = $1::uuid`, auditA); err == nil {
		t.Fatalf("expected audit_events UPDATE to be denied by privileges/trigger")
	}
	_, _ = tx.Exec(ctx, `ROLLBACK TO SAVEPOINT sp_audit_update`)

	// Updating verification_status is permitted:
	if _, err := tx.Exec(ctx, `
		UPDATE evidence_objects SET verification_status = 'verified' WHERE evidence_id = $1::uuid
	`, evidA); err != nil {
		t.Fatalf("updating verification_status should succeed: %v", err)
	}
	// Updating content_hash must be blocked by protect_evidence_content():
	if _, err := tx.Exec(ctx, `SAVEPOINT sp_evid_mutate`); err != nil {
		t.Fatal(err)
	}
	if _, err := tx.Exec(ctx, `
		UPDATE evidence_objects SET content_hash = 'sha512_tampered' WHERE evidence_id = $1::uuid
	`, evidA); err == nil {
		t.Fatalf("expected protect_evidence_content() to block content_hash mutation")
	}
	_, _ = tx.Exec(ctx, `ROLLBACK TO SAVEPOINT sp_evid_mutate`)

	// Hard-deleting evidence_objects must be blocked:
	if _, err := tx.Exec(ctx, `SAVEPOINT sp_evid_del`); err != nil {
		t.Fatal(err)
	}
	if _, err := tx.Exec(ctx, `DELETE FROM evidence_objects WHERE evidence_id = $1::uuid`, evidA); err == nil {
		t.Fatalf("expected protect_evidence_content() to block hard DELETE")
	}
	_, _ = tx.Exec(ctx, `ROLLBACK TO SAVEPOINT sp_evid_del`)

	// Test 5: app_user cannot TRUNCATE or read internal_admins.
	if _, err := tx.Exec(ctx, `SAVEPOINT sp_truncate`); err != nil {
		t.Fatal(err)
	}
	if _, err := tx.Exec(ctx, `TRUNCATE TABLE trends`); err == nil {
		t.Fatalf("expected app_user TRUNCATE to be denied")
	}
	_, _ = tx.Exec(ctx, `ROLLBACK TO SAVEPOINT sp_truncate`)

	if _, err := tx.Exec(ctx, `SAVEPOINT sp_admin_tbl`); err != nil {
		t.Fatal(err)
	}
	if _, err := tx.Exec(ctx, `SELECT COUNT(*) FROM internal_admins`); err == nil {
		t.Fatalf("expected app_user SELECT on internal_admins to be denied")
	}
	_, _ = tx.Exec(ctx, `ROLLBACK TO SAVEPOINT sp_admin_tbl`)

	// Test 6: directory_reader role can read ONLY (media_kit_id, directory_profile) on published opt-in rows.
	if _, err := tx.Exec(ctx, `RESET ROLE`); err != nil {
		t.Fatal(err)
	}
	// Verify even table owner cannot UPDATE or DELETE audit_events thanks to protect_audit_log_immutability():
	if _, err := tx.Exec(ctx, `SAVEPOINT sp_owner_audit_update`); err != nil {
		t.Fatal(err)
	}
	if _, err := tx.Exec(ctx, `UPDATE audit_events SET action = 'tampered' WHERE audit_event_id = $1::uuid`, auditA); err == nil {
		t.Fatalf("expected protect_audit_log_immutability() to block owner UPDATE on audit_events")
	}
	_, _ = tx.Exec(ctx, `ROLLBACK TO SAVEPOINT sp_owner_audit_update`)

	if _, err := tx.Exec(ctx, `SAVEPOINT sp_owner_audit_delete`); err != nil {
		t.Fatal(err)
	}
	if _, err := tx.Exec(ctx, `DELETE FROM audit_events WHERE audit_event_id = $1::uuid`, auditA); err == nil {
		t.Fatalf("expected protect_audit_log_immutability() to block owner DELETE on audit_events")
	}
	_, _ = tx.Exec(ctx, `ROLLBACK TO SAVEPOINT sp_owner_audit_delete`)

	// Test 7: outbox_poller can SELECT/UPDATE event_outbox but is denied access to consumer_inbox and external_effects.
	if _, err := tx.Exec(ctx, `SET LOCAL ROLE outbox_poller`); err != nil {
		t.Fatalf("SET LOCAL ROLE outbox_poller: %v", err)
	}
	var outboxCount int
	if err := tx.QueryRow(ctx, `SELECT COUNT(*) FROM event_outbox`).Scan(&outboxCount); err != nil {
		t.Fatalf("outbox_poller SELECT event_outbox failed: %v", err)
	}
	if _, err := tx.Exec(ctx, `SAVEPOINT sp_poller_inbox`); err != nil {
		t.Fatal(err)
	}
	if _, err := tx.Exec(ctx, `SELECT COUNT(*) FROM consumer_inbox`); err == nil {
		t.Fatalf("expected outbox_poller SELECT on consumer_inbox to be denied")
	}
	_, _ = tx.Exec(ctx, `ROLLBACK TO SAVEPOINT sp_poller_inbox`)

	if _, err := tx.Exec(ctx, `RESET ROLE`); err != nil {
		t.Fatal(err)
	}
	if _, err := tx.Exec(ctx, `SET LOCAL ROLE directory_reader`); err != nil {
		t.Fatalf("SET LOCAL ROLE directory_reader: %v", err)
	}
	var dirCount int
	if err := tx.QueryRow(ctx, `SELECT COUNT(media_kit_id) FROM media_kits`).Scan(&dirCount); err != nil {
		t.Fatalf("directory_reader SELECT allowed columns failed: %v", err)
	}
	if dirCount != 1 {
		t.Fatalf("expected directory_reader to see exactly 1 published opt-in media_kit, got %d", dirCount)
	}
	if _, err := tx.Exec(ctx, `SAVEPOINT sp_dir_col`); err != nil {
		t.Fatal(err)
	}
	if _, err := tx.Exec(ctx, `SELECT sections FROM media_kits`); err == nil {
		t.Fatalf("expected directory_reader SELECT on private sections column to be denied")
	}
	_, _ = tx.Exec(ctx, `ROLLBACK TO SAVEPOINT sp_dir_col`)

	// Test 8 (P0-07): Composite tenant FKs on fallback_paths -> policy_notes and platform_health_scores -> connected_accounts,
	// plus app_user vs admin_user isolation on moderation_cases, fraud_cases, and impersonation_sessions (mode='read_only').
	if _, err := tx.Exec(ctx, `RESET ROLE`); err != nil {
		t.Fatal(err)
	}
	const (
		policyNoteA = "eeeeeeee-eeee-4eee-8eee-eeeeeeeeeee1"
		adminID1    = "ffffffff-ffff-4fff-8fff-fffffffffff1"
	)
	if _, err := tx.Exec(ctx, `
		INSERT INTO policy_notes (policy_note_id, workspace_id, platform, capability_key, summary)
		VALUES ($1::uuid, $2::uuid, 'tiktok', 'publish_post', 'TikTok Direct Post requires approved scopes')
	`, policyNoteA, tenantA); err != nil {
		t.Fatalf("seed policy_notes failed: %v", err)
	}
	if _, err := tx.Exec(ctx, `
		INSERT INTO internal_admins (admin_id, email, display_name, password_hash, role, mfa_enabled)
		VALUES ($1::uuid, 'ops@creativanta.internal', 'Ops Admin', '$argon2id$v=19$m=65536,t=3,p=4$test', 'ops_admin', true)
	`, adminID1); err != nil {
		t.Fatalf("seed internal_admins failed: %v", err)
	}
	if _, err := tx.Exec(ctx, `
		INSERT INTO moderation_cases (workspace_id, content_type, content_id, flag_reason, sla_deadline)
		VALUES ($1::uuid, 'publish_item', $2::uuid, 'spam', NOW() + INTERVAL '4 hours')
	`, tenantA, trendA); err != nil {
		t.Fatalf("seed moderation_cases failed: %v", err)
	}

	if _, err := tx.Exec(ctx, `SET LOCAL ROLE app_user`); err != nil {
		t.Fatal(err)
	}
	if _, err := tx.Exec(ctx, `SELECT set_config('app.current_tenant_id', $1, true), set_config('app.current_user_id', $2, true)`, tenantB, userB); err != nil {
		t.Fatal(err)
	}

	// Cross-tenant fk_fallback_paths_related_policy_note_id_tenant must fail:
	if _, err := tx.Exec(ctx, `SAVEPOINT sp_cross_fp_fk`); err != nil {
		t.Fatal(err)
	}
	if _, err := tx.Exec(ctx, `
		INSERT INTO fallback_paths (workspace_id, platform, capability_key, fallback_type, instructions, related_policy_note_id)
		VALUES ($1::uuid, 'tiktok', 'publish_post', 'manual_upload', 'Upload manually', $2::uuid)
	`, tenantB, policyNoteA); err == nil {
		t.Fatalf("expected fk_fallback_paths_related_policy_note_id_tenant to reject cross-tenant policy_note_id")
	}
	_, _ = tx.Exec(ctx, `ROLLBACK TO SAVEPOINT sp_cross_fp_fk`)

	// Cross-tenant fk_platform_health_scores_connected_account_id_tenant must fail:
	if _, err := tx.Exec(ctx, `SAVEPOINT sp_cross_phs_fk`); err != nil {
		t.Fatal(err)
	}
	if _, err := tx.Exec(ctx, `
		INSERT INTO platform_health_scores (workspace_id, connected_account_id, platform, overall_score, snapshot_date)
		VALUES ($1::uuid, $2::uuid, 'tiktok', 85, CURRENT_DATE)
	`, tenantB, connAccA); err == nil {
		t.Fatalf("expected fk_platform_health_scores_connected_account_id_tenant to reject cross-tenant connected_account_id")
	}
	_, _ = tx.Exec(ctx, `ROLLBACK TO SAVEPOINT sp_cross_phs_fk`)

	// app_user cannot access fraud_cases or mutate moderation_cases:
	if _, err := tx.Exec(ctx, `SAVEPOINT sp_app_fraud`); err != nil {
		t.Fatal(err)
	}
	if _, err := tx.Exec(ctx, `SELECT COUNT(*) FROM fraud_cases`); err == nil {
		t.Fatalf("expected app_user SELECT on fraud_cases to be denied")
	}
	_, _ = tx.Exec(ctx, `ROLLBACK TO SAVEPOINT sp_app_fraud`)

	if _, err := tx.Exec(ctx, `SAVEPOINT sp_app_mod_write`); err != nil {
		t.Fatal(err)
	}
	if _, err := tx.Exec(ctx, `UPDATE moderation_cases SET status = 'approved'`); err == nil {
		t.Fatalf("expected app_user UPDATE on moderation_cases to be denied")
	}
	_, _ = tx.Exec(ctx, `ROLLBACK TO SAVEPOINT sp_app_mod_write`)

	// Switch to admin_user: can manage moderation_cases and create read_only impersonation_sessions,
	// but non-read_only impersonation mode is rejected by DB CHECK constraint!
	if _, err := tx.Exec(ctx, `RESET ROLE`); err != nil {
		t.Fatal(err)
	}
	if _, err := tx.Exec(ctx, `SELECT set_config('app.current_tenant_id', $1, true), set_config('app.current_user_id', $2, true)`, tenantA, userA); err != nil {
		t.Fatal(err)
	}
	if _, err := tx.Exec(ctx, `SET LOCAL ROLE admin_user`); err != nil {
		t.Fatal(err)
	}
	if _, err := tx.Exec(ctx, `
		INSERT INTO impersonation_sessions (admin_id, target_user_id, target_workspace_id, mode, expires_at)
		VALUES ($1::uuid, $2::uuid, $3::uuid, 'read_only', NOW() + INTERVAL '30 minutes')
	`, adminID1, userA, tenantA); err != nil {
		t.Fatalf("admin_user insert read_only impersonation_sessions failed: %v", err)
	}
	if _, err := tx.Exec(ctx, `SAVEPOINT sp_imp_write_mode`); err != nil {
		t.Fatal(err)
	}
	if _, err := tx.Exec(ctx, `
		INSERT INTO impersonation_sessions (admin_id, target_user_id, target_workspace_id, mode, expires_at)
		VALUES ($1::uuid, $2::uuid, $3::uuid, 'read_write', NOW() + INTERVAL '30 minutes')
	`, adminID1, userA, tenantA); err == nil {
		t.Fatalf("expected impersonation_sessions CHECK (mode IN ('read_only')) to reject 'read_write'")
	}
	_, _ = tx.Exec(ctx, `ROLLBACK TO SAVEPOINT sp_imp_write_mode`)

	// Test 9 (P3-01): Hooks table tenant isolation and composite foreign key to ideas
	const (
		ideaA = "aaaaaaaa-5555-4aaa-8aaa-aaaaaaaaaaaa"
		hookA = "aaaaaaaa-6666-4aaa-8aaa-aaaaaaaaaaaa"
	)
	if _, err := tx.Exec(ctx, `RESET ROLE`); err != nil {
		t.Fatal(err)
	}
	if _, err := tx.Exec(ctx, `
		INSERT INTO ideas (idea_id, workspace_id, title, status)
		VALUES ($1::uuid, $2::uuid, 'Test Idea A', 'draft')
	`, ideaA, tenantA); err != nil {
		t.Fatalf("seed idea failed: %v", err)
	}
	if _, err := tx.Exec(ctx, `
		INSERT INTO hooks (hook_id, workspace_id, idea_id, hook_text, hook_type, source)
		VALUES ($1::uuid, $2::uuid, $3::uuid, 'Why do 90 percent fail?', 'question', 'manual')
	`, hookA, tenantA, ideaA); err != nil {
		t.Fatalf("seed hook failed: %v", err)
	}

	if _, err := tx.Exec(ctx, `SET LOCAL ROLE app_user`); err != nil {
		t.Fatal(err)
	}
	if _, err := tx.Exec(ctx, `SELECT set_config('app.current_tenant_id', $1, true), set_config('app.current_user_id', $2, true)`, tenantB, userB); err != nil {
		t.Fatal(err)
	}
	var hookCount int
	if err := tx.QueryRow(ctx, `SELECT COUNT(*) FROM hooks WHERE hook_id = $1::uuid`, hookA).Scan(&hookCount); err != nil {
		t.Fatal(err)
	}
	if hookCount != 0 {
		t.Fatalf("hooks RLS breach: Tenant B saw %d hooks from Tenant A", hookCount)
	}

	// Cross-tenant composite FK write attack on hooks denied:
	if _, err := tx.Exec(ctx, `SAVEPOINT sp_cross_hook_fk`); err != nil {
		t.Fatal(err)
	}
	if _, err := tx.Exec(ctx, `
		INSERT INTO hooks (workspace_id, idea_id, hook_text, hook_type, source)
		VALUES ($1::uuid, $2::uuid, 'Cross hook', 'shock', 'manual')
	`, tenantB, ideaA); err == nil {
		t.Fatalf("expected composite tenant FK to reject cross-tenant idea_id on hooks")
	}
	_, _ = tx.Exec(ctx, `ROLLBACK TO SAVEPOINT sp_cross_hook_fk`)

	// P3-02: Scripts & Asset Briefs RLS and Composite FK checks
	scriptA := "33333333-3333-3333-3333-333333333301"
	briefA := "33333333-3333-3333-3333-333333333302"
	if _, err := tx.Exec(ctx, `RESET ROLE`); err != nil {
		t.Fatal(err)
	}
	if _, err := tx.Exec(ctx, `
		INSERT INTO scripts (script_id, workspace_id, idea_id, title, format_type, body)
		VALUES ($1::uuid, $2::uuid, $3::uuid, 'Test Script A', 'short_form', '[{"scene_id":"s1","content":"Intro"}]')
	`, scriptA, tenantA, ideaA); err != nil {
		t.Fatalf("seed script failed: %v", err)
	}
	if _, err := tx.Exec(ctx, `
		INSERT INTO asset_briefs (asset_brief_id, workspace_id, script_id, output_type, target_format, continuity_requirements)
		VALUES ($1::uuid, $2::uuid, $3::uuid, 'video', '9:16', '{"character_id":"char-1"}')
	`, briefA, tenantA, scriptA); err != nil {
		t.Fatalf("seed asset_brief failed: %v", err)
	}

	if _, err := tx.Exec(ctx, `SET LOCAL ROLE app_user`); err != nil {
		t.Fatal(err)
	}
	if _, err := tx.Exec(ctx, `SELECT set_config('app.current_tenant_id', $1, true), set_config('app.current_user_id', $2, true)`, tenantB, userB); err != nil {
		t.Fatal(err)
	}
	var scriptCount int
	if err := tx.QueryRow(ctx, `SELECT COUNT(*) FROM scripts WHERE script_id = $1::uuid`, scriptA).Scan(&scriptCount); err != nil {
		t.Fatal(err)
	}
	if scriptCount != 0 {
		t.Fatalf("scripts RLS breach: Tenant B saw %d scripts from Tenant A", scriptCount)
	}
	var briefCount int
	if err := tx.QueryRow(ctx, `SELECT COUNT(*) FROM asset_briefs WHERE asset_brief_id = $1::uuid`, briefA).Scan(&briefCount); err != nil {
		t.Fatal(err)
	}
	if briefCount != 0 {
		t.Fatalf("asset_briefs RLS breach: Tenant B saw %d asset briefs from Tenant A", briefCount)
	}

	// Cross-tenant composite FK write attack on scripts denied:
	if _, err := tx.Exec(ctx, `SAVEPOINT sp_cross_script_fk`); err != nil {
		t.Fatal(err)
	}
	if _, err := tx.Exec(ctx, `
		INSERT INTO scripts (workspace_id, idea_id, title, format_type, body)
		VALUES ($1::uuid, $2::uuid, 'Cross Script', 'short_form', '[]')
	`, tenantB, ideaA); err == nil {
		t.Fatalf("expected composite tenant FK to reject cross-tenant idea_id on scripts")
	}
	_, _ = tx.Exec(ctx, `ROLLBACK TO SAVEPOINT sp_cross_script_fk`)

	// Cross-tenant composite FK write attack on asset_briefs denied:
	if _, err := tx.Exec(ctx, `SAVEPOINT sp_cross_brief_fk`); err != nil {
		t.Fatal(err)
	}
	if _, err := tx.Exec(ctx, `
		INSERT INTO asset_briefs (workspace_id, script_id, output_type, target_format)
		VALUES ($1::uuid, $2::uuid, 'video', '9:16')
	`, tenantB, scriptA); err == nil {
		t.Fatalf("expected composite tenant FK to reject cross-tenant script_id on asset_briefs")
	}
	_, _ = tx.Exec(ctx, `ROLLBACK TO SAVEPOINT sp_cross_brief_fk`)

	// P3-03: Continuity Packs, Characters & Consent RLS, FK, and Single Default checks
	consentA := "33333333-3333-3333-3333-333333333303"
	charA := "33333333-3333-3333-3333-333333333304"
	charA2 := "33333333-3333-3333-3333-333333333305"
	packA := "33333333-3333-3333-3333-333333333306"
	if _, err := tx.Exec(ctx, `RESET ROLE`); err != nil {
		t.Fatal(err)
	}
	if _, err := tx.Exec(ctx, `
		INSERT INTO consent_records (consent_id, user_id, workspace_id, consent_type, version, granted)
		VALUES ($1::uuid, $2::uuid, $3::uuid, 'digital_twin', '1.0', true)
	`, consentA, userA, tenantA); err != nil {
		t.Fatalf("seed consent_record failed: %v", err)
	}
	if _, err := tx.Exec(ctx, `
		INSERT INTO characters (character_id, workspace_id, name, character_type, consent_verified, consent_record_id, is_default, status)
		VALUES ($1::uuid, $2::uuid, 'Default Persona A', 'digital_twin', true, $3::uuid, true, 'ready')
	`, charA, tenantA, consentA); err != nil {
		t.Fatalf("seed character failed: %v", err)
	}
	if _, err := tx.Exec(ctx, `
		INSERT INTO continuity_packs (pack_id, workspace_id, pack_type, name, character_id, status)
		VALUES ($1::uuid, $2::uuid, 'character', 'Persona A Pack', $3::uuid, 'active')
	`, packA, tenantA, charA); err != nil {
		t.Fatalf("seed continuity_pack failed: %v", err)
	}

	if _, err := tx.Exec(ctx, `SET LOCAL ROLE app_user`); err != nil {
		t.Fatal(err)
	}
	if _, err := tx.Exec(ctx, `SELECT set_config('app.current_tenant_id', $1, true), set_config('app.current_user_id', $2, true)`, tenantB, userB); err != nil {
		t.Fatal(err)
	}
	var charCount int
	if err := tx.QueryRow(ctx, `SELECT COUNT(*) FROM characters WHERE character_id = $1::uuid`, charA).Scan(&charCount); err != nil {
		t.Fatal(err)
	}
	if charCount != 0 {
		t.Fatalf("characters RLS breach: Tenant B saw %d characters from Tenant A", charCount)
	}
	var packCount int
	if err := tx.QueryRow(ctx, `SELECT COUNT(*) FROM continuity_packs WHERE pack_id = $1::uuid`, packA).Scan(&packCount); err != nil {
		t.Fatal(err)
	}
	if packCount != 0 {
		t.Fatalf("continuity_packs RLS breach: Tenant B saw %d packs from Tenant A", packCount)
	}

	// Cross-tenant composite FK write attack on continuity_packs denied:
	if _, err := tx.Exec(ctx, `SAVEPOINT sp_cross_pack_fk`); err != nil {
		t.Fatal(err)
	}
	if _, err := tx.Exec(ctx, `
		INSERT INTO continuity_packs (workspace_id, pack_type, name, character_id)
		VALUES ($1::uuid, 'character', 'Cross Pack', $2::uuid)
	`, tenantB, charA); err == nil {
		t.Fatalf("expected composite tenant FK to reject cross-tenant character_id on continuity_packs")
	}
	_, _ = tx.Exec(ctx, `ROLLBACK TO SAVEPOINT sp_cross_pack_fk`)

	// Acceptance Target 3 constraint test: Second default character in same workspace is strictly rejected by DB
	if _, err := tx.Exec(ctx, `SELECT set_config('app.current_tenant_id', $1, true), set_config('app.current_user_id', $2, true)`, tenantA, userA); err != nil {
		t.Fatal(err)
	}
	if _, err := tx.Exec(ctx, `SAVEPOINT sp_second_default`); err != nil {
		t.Fatal(err)
	}
	if _, err := tx.Exec(ctx, `
		INSERT INTO characters (character_id, workspace_id, name, character_type, is_default, status)
		VALUES ($1::uuid, $2::uuid, 'Second Default Persona', 'ai_generated', true, 'ready')
	`, charA2, tenantA); err == nil {
		t.Fatalf("expected unique constraint uq_characters_single_default to reject multiple default characters in workspace")
	}
	_, _ = tx.Exec(ctx, `ROLLBACK TO SAVEPOINT sp_second_default`)

	// P4-01: Assets & Generation Jobs RLS and Composite FK checks
	assetA := "44444444-4444-4444-4444-444444444401"
	jobA := "44444444-4444-4444-4444-444444444402"
	if _, err := tx.Exec(ctx, `RESET ROLE`); err != nil {
		t.Fatal(err)
	}
	if _, err := tx.Exec(ctx, `
		INSERT INTO assets (asset_id, workspace_id, asset_type, title, source_generation_mode, generation_state, quality_state)
		VALUES ($1::uuid, $2::uuid, 'video', 'Video Asset A', 'ai_generated', 'queued', 'draft')
	`, assetA, tenantA); err != nil {
		t.Fatalf("seed asset failed: %v", err)
	}
	if _, err := tx.Exec(ctx, `
		INSERT INTO generation_jobs (job_id, workspace_id, asset_id, job_type, provider, status, estimated_credits)
		VALUES ($1::uuid, $2::uuid, $3::uuid, 'video_gen', 'veo', 'queued', 15.000000)
	`, jobA, tenantA, assetA); err != nil {
		t.Fatalf("seed generation_job failed: %v", err)
	}

	if _, err := tx.Exec(ctx, `SET LOCAL ROLE app_user`); err != nil {
		t.Fatal(err)
	}
	if _, err := tx.Exec(ctx, `SELECT set_config('app.current_tenant_id', $1, true), set_config('app.current_user_id', $2, true)`, tenantB, userB); err != nil {
		t.Fatal(err)
	}
	var assetCount int
	if err := tx.QueryRow(ctx, `SELECT COUNT(*) FROM assets WHERE asset_id = $1::uuid`, assetA).Scan(&assetCount); err != nil {
		t.Fatal(err)
	}
	if assetCount != 0 {
		t.Fatalf("assets RLS breach: Tenant B saw %d assets from Tenant A", assetCount)
	}
	var jobCount int
	if err := tx.QueryRow(ctx, `SELECT COUNT(*) FROM generation_jobs WHERE job_id = $1::uuid`, jobA).Scan(&jobCount); err != nil {
		t.Fatal(err)
	}
	if jobCount != 0 {
		t.Fatalf("generation_jobs RLS breach: Tenant B saw %d generation jobs from Tenant A", jobCount)
	}

	// Cross-tenant composite FK write attack on generation_jobs denied:
	if _, err := tx.Exec(ctx, `SAVEPOINT sp_cross_job_fk`); err != nil {
		t.Fatal(err)
	}
	if _, err := tx.Exec(ctx, `
		INSERT INTO generation_jobs (workspace_id, asset_id, job_type, provider, status)
		VALUES ($1::uuid, $2::uuid, 'video_gen', 'veo', 'queued')
	`, tenantB, assetA); err == nil {
		t.Fatalf("expected composite tenant FK to reject cross-tenant asset_id on generation_jobs")
	}
	_, _ = tx.Exec(ctx, `ROLLBACK TO SAVEPOINT sp_cross_job_fk`)

	// P4-02: Transcripts, Quick Edit Drafts & Sound Library RLS and Composite FK checks
	transcriptA := "55555555-5555-4555-8555-555555555501"
	draftA := "55555555-5555-4555-8555-555555555502"
	soundCustomA := "55555555-5555-4555-8555-555555555503"

	if _, err := tx.Exec(ctx, `RESET ROLE`); err != nil {
		t.Fatal(err)
	}
	if _, err := tx.Exec(ctx, `
		INSERT INTO transcripts (transcript_id, workspace_id, asset_id, language, raw_text, alignment_status)
		VALUES ($1::uuid, $2::uuid, $3::uuid, 'vi', 'Hello world video A', 'auto_aligned')
	`, transcriptA, tenantA, assetA); err != nil {
		t.Fatalf("seed transcript failed: %v", err)
	}
	if _, err := tx.Exec(ctx, `
		INSERT INTO quick_edit_drafts (draft_id, workspace_id, asset_id, transcript_id, name, estimated_credits)
		VALUES ($1::uuid, $2::uuid, $3::uuid, $4::uuid, 'Draft A', 15.000000)
	`, draftA, tenantA, assetA, transcriptA); err != nil {
		t.Fatalf("seed quick_edit_draft failed: %v", err)
	}
	if _, err := tx.Exec(ctx, `
		INSERT INTO sound_library (sound_id, workspace_id, title, artist, genre, duration_seconds, audio_url)
		VALUES ($1::uuid, $2::uuid, 'Tenant A Exclusive Track', 'Artist A', 'chill', 120.0, 'https://cdn.example.com/a.mp3')
	`, soundCustomA, tenantA); err != nil {
		t.Fatalf("seed tenant-specific sound failed: %v", err)
	}

	if _, err := tx.Exec(ctx, `SET LOCAL ROLE app_user`); err != nil {
		t.Fatal(err)
	}
	if _, err := tx.Exec(ctx, `SELECT set_config('app.current_tenant_id', $1, true), set_config('app.current_user_id', $2, true)`, tenantB, userB); err != nil {
		t.Fatal(err)
	}

	var transcriptCount int
	if err := tx.QueryRow(ctx, `SELECT COUNT(*) FROM transcripts WHERE transcript_id = $1::uuid`, transcriptA).Scan(&transcriptCount); err != nil {
		t.Fatal(err)
	}
	if transcriptCount != 0 {
		t.Fatalf("transcripts RLS breach: Tenant B saw %d transcripts from Tenant A", transcriptCount)
	}

	var draftCount int
	if err := tx.QueryRow(ctx, `SELECT COUNT(*) FROM quick_edit_drafts WHERE draft_id = $1::uuid`, draftA).Scan(&draftCount); err != nil {
		t.Fatal(err)
	}
	if draftCount != 0 {
		t.Fatalf("quick_edit_drafts RLS breach: Tenant B saw %d drafts from Tenant A", draftCount)
	}

	var customSoundCount int
	if err := tx.QueryRow(ctx, `SELECT COUNT(*) FROM sound_library WHERE sound_id = $1::uuid`, soundCustomA).Scan(&customSoundCount); err != nil {
		t.Fatal(err)
	}
	if customSoundCount != 0 {
		t.Fatalf("sound_library RLS breach: Tenant B saw %d workspace-specific sounds from Tenant A", customSoundCount)
	}

	// Global sounds (workspace_id IS NULL) must still be visible to Tenant B
	var globalSoundCount int
	if err := tx.QueryRow(ctx, `SELECT COUNT(*) FROM sound_library WHERE workspace_id IS NULL`).Scan(&globalSoundCount); err != nil {
		t.Fatal(err)
	}
	if globalSoundCount < 6 {
		t.Fatalf("expected at least 6 seeded global sounds visible to Tenant B, got %d", globalSoundCount)
	}

	// Cross-tenant composite FK write attack on transcripts denied (tenantB cannot bind to tenantA's assetA):
	if _, err := tx.Exec(ctx, `SAVEPOINT sp_cross_transcript_fk`); err != nil {
		t.Fatal(err)
	}
	if _, err := tx.Exec(ctx, `
		INSERT INTO transcripts (workspace_id, asset_id, language, raw_text)
		VALUES ($1::uuid, $2::uuid, 'vi', 'Cross tenant attack')
	`, tenantB, assetA); err == nil {
		t.Fatalf("expected composite tenant FK to reject cross-tenant asset_id on transcripts")
	}
	_, _ = tx.Exec(ctx, `ROLLBACK TO SAVEPOINT sp_cross_transcript_fk`)

	// Cross-tenant composite FK write attack on quick_edit_drafts denied:
	if _, err := tx.Exec(ctx, `SAVEPOINT sp_cross_draft_fk`); err != nil {
		t.Fatal(err)
	}
	if _, err := tx.Exec(ctx, `
		INSERT INTO quick_edit_drafts (workspace_id, asset_id, transcript_id, name)
		VALUES ($1::uuid, $2::uuid, $3::uuid, 'Cross draft attack')
	`, tenantB, assetA, transcriptA); err == nil {
		t.Fatalf("expected composite tenant FK to reject cross-tenant asset/transcript on quick_edit_drafts")
	}
	_, _ = tx.Exec(ctx, `ROLLBACK TO SAVEPOINT sp_cross_draft_fk`)

	// P5-01: publish_items, publish_jobs, publish_logs RLS and composite FK isolation:
	const (
		pubItemA = "eeeeeeee-eeee-4eee-8eee-eeeeeeeeeee1"
		pubJobA  = "eeeeeeee-eeee-4eee-8eee-eeeeeeeeeee2"
		pubLogA  = "eeeeeeee-eeee-4eee-8eee-eeeeeeeeeee3"
	)
	if _, err := tx.Exec(ctx, `
		SET LOCAL app.current_tenant_id = 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa';
		SET LOCAL app.current_user_id = '11111111-1111-4111-8111-111111111111';
		INSERT INTO publish_items (publish_item_id, workspace_id, target_platform, title, lifecycle_state)
		VALUES ('eeeeeeee-eeee-4eee-8eee-eeeeeeeeeee1'::uuid, 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa'::uuid, 'tiktok', 'TikTok Video 1', 'scheduled');
		INSERT INTO publish_jobs (publish_job_id, workspace_id, publish_item_id, lifecycle_state)
		VALUES ('eeeeeeee-eeee-4eee-8eee-eeeeeeeeeee2'::uuid, 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa'::uuid, 'eeeeeeee-eeee-4eee-8eee-eeeeeeeeeee1'::uuid, 'queued');
		INSERT INTO publish_logs (publish_log_id, workspace_id, publish_job_id, publish_item_id, result_status, execution_path)
		VALUES ('eeeeeeee-eeee-4eee-8eee-eeeeeeeeeee3'::uuid, 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa'::uuid, 'eeeeeeee-eeee-4eee-8eee-eeeeeeeeeee2'::uuid, 'eeeeeeee-eeee-4eee-8eee-eeeeeeeeeee1'::uuid, 'success', 'native_api');
	`); err != nil {
		t.Fatalf("failed to insert Tenant A publish fixtures: %v", err)
	}

	// Switch to Tenant B and assert RLS isolation across publish tables:
	if _, err := tx.Exec(ctx, `
		SET LOCAL app.current_tenant_id = 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb';
		SET LOCAL app.current_user_id = '22222222-2222-4222-8222-222222222222';
	`); err != nil {
		t.Fatal(err)
	}
	var pubItemCount int
	if err := tx.QueryRow(ctx, `SELECT COUNT(*) FROM publish_items WHERE publish_item_id = $1::uuid`, pubItemA).Scan(&pubItemCount); err != nil {
		t.Fatal(err)
	}
	if pubItemCount != 0 {
		t.Fatalf("publish_items RLS breach: Tenant B saw %d items from Tenant A", pubItemCount)
	}

	var pubJobCount int
	if err := tx.QueryRow(ctx, `SELECT COUNT(*) FROM publish_jobs WHERE publish_job_id = $1::uuid`, pubJobA).Scan(&pubJobCount); err != nil {
		t.Fatal(err)
	}
	if pubJobCount != 0 {
		t.Fatalf("publish_jobs RLS breach: Tenant B saw %d jobs from Tenant A", pubJobCount)
	}

	var pubLogCount int
	if err := tx.QueryRow(ctx, `SELECT COUNT(*) FROM publish_logs WHERE publish_log_id = $1::uuid`, pubLogA).Scan(&pubLogCount); err != nil {
		t.Fatal(err)
	}
	if pubLogCount != 0 {
		t.Fatalf("publish_logs RLS breach: Tenant B saw %d logs from Tenant A", pubLogCount)
	}

	// Cross-tenant composite FK attack: Tenant B cannot create publish_job for Tenant A's publish_item:
	if _, err := tx.Exec(ctx, `SAVEPOINT sp_cross_pub_job_fk`); err != nil {
		t.Fatal(err)
	}
	if _, err := tx.Exec(ctx, `
		INSERT INTO publish_jobs (workspace_id, publish_item_id, lifecycle_state)
		VALUES ($1::uuid, $2::uuid, 'queued')
	`, tenantB, pubItemA); err == nil {
		t.Fatalf("expected composite tenant FK to reject cross-tenant publish_item_id on publish_jobs")
	}
	_, _ = tx.Exec(ctx, `ROLLBACK TO SAVEPOINT sp_cross_pub_job_fk`)

	// TENANT-01: User B in Tenant B context must not self-insert as owner into Tenant A's workspace_members:
	if _, err := tx.Exec(ctx, `SAVEPOINT sp_cross_member_self_insert`); err != nil {
		t.Fatal(err)
	}
	if _, err := tx.Exec(ctx, `
		INSERT INTO workspace_members (workspace_id, user_id, role, status)
		VALUES ($1::uuid, $2::uuid, 'owner', 'active')
	`, tenantA, userB); err == nil {
		t.Fatalf("TENANT-01 RLS breach: User B self-inserted into foreign workspace A")
	}
	_, _ = tx.Exec(ctx, `ROLLBACK TO SAVEPOINT sp_cross_member_self_insert`)

	// TENANT-02: affiliate_statement_items must enforce tenant isolation for app_user:
	const (
		affStmtA = "ffffffff-ffff-4fff-8fff-fffffffffff1"
		affItemA = "ffffffff-ffff-4fff-8fff-fffffffffff2"
	)
	if _, err := tx.Exec(ctx, `
		SET LOCAL app.current_tenant_id = 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa';
		SET LOCAL app.current_user_id = '11111111-1111-4111-8111-111111111111';
		INSERT INTO affiliate_statements (statement_id, workspace_id, platform, external_statement_ref, period_start, period_end, total_commission, currency, reconciliation_state)
		VALUES ('ffffffff-ffff-4fff-8fff-fffffffffff1'::uuid, 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa'::uuid, 'tiktok_shop', 'stmt-2026-10', '2026-10-01', '2026-10-31', 100000, 'VND', 'fully_reconciled');
		INSERT INTO affiliate_statement_items (item_id, statement_id, external_order_id, order_amount, commission_amount, status)
		VALUES ('ffffffff-ffff-4fff-8fff-fffffffffff2'::uuid, 'ffffffff-ffff-4fff-8fff-fffffffffff1'::uuid, 'ext_ord_1', 100000, 100000, 'matched');
	`); err != nil {
		t.Fatalf("failed to insert Tenant A affiliate_statement_items fixture: %v", err)
	}
	if _, err := tx.Exec(ctx, `
		SET LOCAL app.current_tenant_id = 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb';
		SET LOCAL app.current_user_id = '22222222-2222-4222-8222-222222222222';
	`); err != nil {
		t.Fatal(err)
	}
	var affItemCount int
	if err := tx.QueryRow(ctx, `SELECT COUNT(*) FROM affiliate_statement_items WHERE item_id = $1::uuid`, affItemA).Scan(&affItemCount); err != nil {
		t.Fatal(err)
	}
	if affItemCount != 0 {
		t.Fatalf("TENANT-02 RLS breach: Tenant B saw %d affiliate_statement_items from Tenant A", affItemCount)
	}
	if _, err := tx.Exec(ctx, `SAVEPOINT sp_cross_aff_stmt_item_fk`); err != nil {
		t.Fatal(err)
	}
	if _, err := tx.Exec(ctx, `
		INSERT INTO affiliate_statement_items (workspace_id, statement_id, external_order_id, commission_minor, status)
		VALUES ($1::uuid, $2::uuid, 'ext_ord_cross', 50000, 'matched')
	`, tenantB, affStmtA); err == nil {
		t.Fatalf("TENANT-02 FK/RLS breach: Tenant B linked affiliate_statement_items to Tenant A statement")
	}
	_, _ = tx.Exec(ctx, `ROLLBACK TO SAVEPOINT sp_cross_aff_stmt_item_fk`)
}

// TestPostgresSeedTwiceIdempotency satisfies Acceptance Target 1:
// Executes docs/06_quality_ops/seed_data.sql against live PostgreSQL 17,
// verifies row counts, then executes seed_data.sql a SECOND time,
// asserting 100% idempotent execution with zero conflict errors or data corruption.
func TestPostgresSeedTwiceIdempotency(t *testing.T) {
	dsn := os.Getenv("CREATIVANTA_TEST_DATABASE_URL")
	if dsn == "" {
		t.Skip("CREATIVANTA_TEST_DATABASE_URL not set; live PostgreSQL seed twice idempotency suite executes in CI")
	}

	ctx, cancel := context.WithTimeout(context.Background(), 45*time.Second)
	defer cancel()

	adminPool, err := pgxpool.New(ctx, dsn)
	if err != nil {
		t.Fatalf("connect adminPool: %v", err)
	}
	defer adminPool.Close()

	// 1. Ensure migrations are applied
	migrationsDir := filepath.Join("..", "..", "..", "..", "infra", "migrations")
	if _, err := Up(ctx, adminPool, migrationsDir); err != nil {
		t.Fatalf("migrate.Up failed: %v", err)
	}

	// 2. Read canonical seed SQL
	seedPath := filepath.Join("..", "..", "..", "..", "docs", "06_quality_ops", "seed_data.sql")
	seedBytes, err := os.ReadFile(seedPath)
	if err != nil {
		t.Fatalf("read seed_data.sql: %v", err)
	}
	seedSQL := string(seedBytes)

	// Clean up any previous seed data to ensure fresh verification
	cleanupSQL := `
		DELETE FROM cost_items WHERE cost_item_id IN ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2');
		DELETE FROM profit_snapshots WHERE snapshot_id = '99999999-9999-9999-9999-999999999901';
		ALTER TABLE ai_credit_transactions DISABLE TRIGGER trg_ai_credit_transactions_immutable;
		DELETE FROM ai_credit_transactions WHERE workspace_id IN ('22222222-2222-2222-2222-222222222201','22222222-2222-2222-2222-222222222202','22222222-2222-2222-2222-222222222203');
		ALTER TABLE ai_credit_transactions ENABLE TRIGGER trg_ai_credit_transactions_immutable;
		DELETE FROM ai_credit_lots WHERE workspace_id IN ('22222222-2222-2222-2222-222222222201','22222222-2222-2222-2222-222222222202','22222222-2222-2222-2222-222222222203');
		DELETE FROM products WHERE workspace_id = '22222222-2222-2222-2222-222222222201';
		DELETE FROM ideas WHERE workspace_id = '22222222-2222-2222-2222-222222222201';
		DELETE FROM workspace_members WHERE workspace_id IN ('22222222-2222-2222-2222-222222222201','22222222-2222-2222-2222-222222222202','22222222-2222-2222-2222-222222222203');
		DELETE FROM workspaces WHERE workspace_id IN ('22222222-2222-2222-2222-222222222201','22222222-2222-2222-2222-222222222202','22222222-2222-2222-2222-222222222203');
		DELETE FROM users WHERE clerk_id IN ('user_seed_owner','user_seed_manager','user_seed_editor','user_seed_viewer','user_seed_admin');
	`
	_, _ = adminPool.Exec(ctx, cleanupSQL)

	// --- SEED EXECUTION 1 ---
	t.Log("Executing seed_data.sql (pass 1)...")
	if _, err := adminPool.Exec(ctx, seedSQL); err != nil {
		t.Fatalf("seed_data.sql pass 1 failed: %v", err)
	}

	// Helper to collect row counts
	type tableCounts struct {
		currencies   int
		regions      int
		users        int
		workspaces   int
		members      int
		ideas        int
		products     int
		creditLots   int
		transactions int
		snapshots    int
		costItems    int
	}

	getCounts := func() tableCounts {
		var c tableCounts
		_ = adminPool.QueryRow(ctx, `SELECT COUNT(*) FROM currencies WHERE code IN ('VND', 'USD')`).Scan(&c.currencies)
		_ = adminPool.QueryRow(ctx, `SELECT COUNT(*) FROM regions WHERE code IN ('VN', 'US', 'SEA')`).Scan(&c.regions)
		_ = adminPool.QueryRow(ctx, `SELECT COUNT(*) FROM users WHERE clerk_id LIKE 'user_seed_%'`).Scan(&c.users)
		_ = adminPool.QueryRow(ctx, `SELECT COUNT(*) FROM workspaces WHERE workspace_id IN ('22222222-2222-2222-2222-222222222201','22222222-2222-2222-2222-222222222202','22222222-2222-2222-2222-222222222203')`).Scan(&c.workspaces)
		_ = adminPool.QueryRow(ctx, `SELECT COUNT(*) FROM workspace_members WHERE workspace_id IN ('22222222-2222-2222-2222-222222222201','22222222-2222-2222-2222-222222222202','22222222-2222-2222-2222-222222222203')`).Scan(&c.members)
		_ = adminPool.QueryRow(ctx, `SELECT COUNT(*) FROM ideas WHERE workspace_id = '22222222-2222-2222-2222-222222222201'`).Scan(&c.ideas)
		_ = adminPool.QueryRow(ctx, `SELECT COUNT(*) FROM products WHERE workspace_id = '22222222-2222-2222-2222-222222222201'`).Scan(&c.products)
		_ = adminPool.QueryRow(ctx, `SELECT COUNT(*) FROM ai_credit_lots WHERE workspace_id IN ('22222222-2222-2222-2222-222222222201','22222222-2222-2222-2222-222222222202','22222222-2222-2222-2222-222222222203')`).Scan(&c.creditLots)
		_ = adminPool.QueryRow(ctx, `SELECT COUNT(*) FROM ai_credit_transactions WHERE workspace_id IN ('22222222-2222-2222-2222-222222222201','22222222-2222-2222-2222-222222222202','22222222-2222-2222-2222-222222222203')`).Scan(&c.transactions)
		_ = adminPool.QueryRow(ctx, `SELECT COUNT(*) FROM profit_snapshots WHERE snapshot_id = '99999999-9999-9999-9999-999999999901'`).Scan(&c.snapshots)
		_ = adminPool.QueryRow(ctx, `SELECT COUNT(*) FROM cost_items WHERE cost_item_id IN ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2')`).Scan(&c.costItems)
		return c
	}

	counts1 := getCounts()
	if counts1.currencies != 2 || counts1.regions != 3 || counts1.users != 5 || counts1.workspaces != 3 ||
		counts1.members != 5 || counts1.ideas != 3 || counts1.products != 3 || counts1.creditLots != 4 ||
		counts1.transactions != 6 || counts1.snapshots != 1 || counts1.costItems != 2 {
		t.Fatalf("unexpected counts after pass 1: %+v", counts1)
	}

	// --- SEED EXECUTION 2 (IDEMPOTENCY PROOF) ---
	t.Log("Executing seed_data.sql (pass 2 - idempotency verification)...")
	if _, err := adminPool.Exec(ctx, seedSQL); err != nil {
		t.Fatalf("seed_data.sql pass 2 failed (idempotency violation): %v", err)
	}

	counts2 := getCounts()
	if counts1 != counts2 {
		t.Fatalf("idempotency violation: counts changed between pass 1 and pass 2: pass1=%+v pass2=%+v", counts1, counts2)
	}

	// Check balance verification on workspace 1
	var creditsRemaining int
	err = adminPool.QueryRow(ctx, `SELECT ai_credits_remaining FROM workspaces WHERE workspace_id = '22222222-2222-2222-2222-222222222201'`).Scan(&creditsRemaining)
	if err != nil {
		t.Fatalf("query credits_remaining: %v", err)
	}
	if creditsRemaining != 2420 {
		t.Fatalf("expected credits remaining 2420, got %d", creditsRemaining)
	}

	t.Log("Seed twice idempotency check PASSED successfully.")
}

func TestPostgresUpgradeFromBaselinePreservesChecksumsAndAppliesRemediation(t *testing.T) {
	dsn := os.Getenv("CREATIVANTA_TEST_DATABASE_URL")
	if dsn == "" {
		t.Skip("CREATIVANTA_TEST_DATABASE_URL not set; live PostgreSQL baseline upgrade suite executes in CI")
	}

	ctx, cancel := context.WithTimeout(context.Background(), 60*time.Second)
	defer cancel()

	adminPool, err := pgxpool.New(ctx, dsn)
	if err != nil {
		t.Fatalf("connect adminPool: %v", err)
	}
	defer adminPool.Close()

	_, _ = adminPool.Exec(ctx, `DROP SCHEMA IF EXISTS public CASCADE; CREATE SCHEMA public; GRANT ALL ON SCHEMA public TO CURRENT_USER; GRANT USAGE ON SCHEMA public TO PUBLIC;`)

	migrationsDir := filepath.Join("..", "..", "..", "..", "infra", "migrations")
	entries, err := os.ReadDir(migrationsDir)
	if err != nil {
		t.Fatalf("ReadDir(%q): %v", migrationsDir, err)
	}

	// Copy only baseline migrations 00001..00048 into a temporary directory.
	baselineDir := t.TempDir()
	for _, entry := range entries {
		if entry.IsDir() || !strings.HasSuffix(entry.Name(), ".sql") {
			continue
		}
		if strings.HasPrefix(entry.Name(), "00049_") {
			continue
		}
		raw, err := os.ReadFile(filepath.Join(migrationsDir, entry.Name()))
		if err != nil {
			t.Fatalf("read baseline migration %s: %v", entry.Name(), err)
		}
		if err := os.WriteFile(filepath.Join(baselineDir, entry.Name()), raw, 0o600); err != nil {
			t.Fatalf("write baseline migration %s: %v", entry.Name(), err)
		}
	}

	// 1. Migrate clean database to baseline v1..v48.
	baseApplied, err := Up(ctx, adminPool, baselineDir)
	if err != nil {
		t.Fatalf("baseline Up(v1..v48) failed: %v", err)
	}
	if len(baseApplied) != 48 {
		t.Fatalf("expected 48 baseline migrations applied, got %d (%v)", len(baseApplied), baseApplied)
	}

	// Verify recorded checksums in goose_db_version match immutable baseline artifacts.
	for ver, wantCS := range map[int64]string{
		1:  "b2f4c41ab41c013d19f260a450982229bc4ef7f159d4f334cf56c6706a28a1e6",
		6:  "d463a8f01946972a3f9c4243943a91452e0722b850478d7a998f842e0a1655f3",
		48: "b220691e9d89b6e0270f35c7edf522b8080610ea7d145b653fbe8fa5dc19cd5a",
	} {
		var gotCS string
		if err := adminPool.QueryRow(ctx, `SELECT checksum FROM goose_db_version WHERE version_id = $1 AND is_applied = true ORDER BY id DESC LIMIT 1`, ver).Scan(&gotCS); err != nil {
			t.Fatalf("query checksum for v%d: %v", ver, err)
		}
		if gotCS != wantCS {
			t.Fatalf("v%d checksum mismatch: want %s, got %s", ver, wantCS, gotCS)
		}
	}

	const (
		userA   = "11111111-1111-4111-8111-111111111101"
		userB   = "22222222-2222-4222-8222-222222222202"
		wsA     = "aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaa01"
		wsB     = "bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbb02"
		prodA   = "cccccccc-cccc-4ccc-8ccc-cccccccccc01"
		orderB  = "dddddddd-dddd-4ddd-8ddd-dddddddddd01"
		adminID = "eeeeeeee-eeee-4eee-8eee-eeeeeeeeee01"
		sessID  = "ffffffff-ffff-4fff-8fff-ffffffffff01"
	)

	seedBaselineSQL := `
		INSERT INTO users (user_id, clerk_id, email, display_name, status)
		VALUES
			('11111111-1111-4111-8111-111111111101'::uuid, 'clerk_upgrade_user_a', 'upgrade_a@creativanta.test', 'Upgrade A', 'active'),
			('22222222-2222-4222-8222-222222222202'::uuid, 'clerk_upgrade_user_b', 'upgrade_b@creativanta.test', 'Upgrade B', 'active');

		INSERT INTO workspaces (workspace_id, name, slug, owner_user_id, subscription_tier, default_mode, enabled_modes, status)
		VALUES
			('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaa01'::uuid, 'Upgrade WS A', 'upgrade-ws-a', '11111111-1111-4111-8111-111111111101'::uuid, 'pro', 'seller'::operator_mode, ARRAY['seller']::operator_mode[], 'active'),
			('bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbb02'::uuid, 'Upgrade WS B', 'upgrade-ws-b', '22222222-2222-4222-8222-222222222202'::uuid, 'free', 'creator'::operator_mode, ARRAY['creator']::operator_mode[], 'active');

		INSERT INTO workspace_members (workspace_id, user_id, role, status)
		VALUES
			('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaa01'::uuid, '11111111-1111-4111-8111-111111111101'::uuid, 'owner', 'active'),
			('bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbb02'::uuid, '22222222-2222-4222-8222-222222222202'::uuid, 'owner', 'active');

		INSERT INTO products (product_id, workspace_id, product_type, title, currency, catalog_status)
		VALUES
			('cccccccc-cccc-4ccc-8ccc-cccccccccc01'::uuid, 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaa01'::uuid, 'physical', 'WS A Product', 'VND', 'active');

		INSERT INTO internal_admins (admin_id, email, display_name, password_hash, role, status, mfa_enabled)
		VALUES
			('eeeeeeee-eeee-4eee-8eee-eeeeeeeeee01'::uuid, 'admin_upgrade@creativanta.test', 'Upgrade Admin', '$2a$12$upgrade_hash', 'super_admin', 'active', true);

		INSERT INTO admin_sessions (session_id, admin_id, ip_address, user_agent, vpn_verified, mfa_verified, started_at, expired_at, session_token_hash)
		VALUES
			('ffffffff-ffff-4fff-8fff-ffffffffff01'::uuid, 'eeeeeeee-eeee-4eee-8eee-eeeeeeeeee01'::uuid, '127.0.0.1'::inet, 'UpgradeTest', true, true, NOW() - INTERVAL '1 hour', NULL, 'hash_legacy_null_expiry_0001');
	`
	if _, err := adminPool.Exec(ctx, seedBaselineSQL); err != nil {
		t.Fatalf("seed baseline data failed: %v", err)
	}

	// 2. Verify that BEFORE v49, Clerk bootstrap under app_user (with only app.current_clerk_id set) sees 0 rows in users.
	txPre, err := adminPool.Begin(ctx)
	if err != nil {
		t.Fatalf("begin txPre: %v", err)
	}
	if _, err := txPre.Exec(ctx, `SET LOCAL ROLE app_user; SELECT set_config('app.current_clerk_id', 'clerk_upgrade_user_a', true);`); err != nil {
		_ = txPre.Rollback(ctx)
		t.Fatalf("set role/config in txPre: %v", err)
	}
	var preBootstrapCount int
	if err := txPre.QueryRow(ctx, `SELECT COUNT(*) FROM users WHERE clerk_id = 'clerk_upgrade_user_a'`).Scan(&preBootstrapCount); err != nil {
		_ = txPre.Rollback(ctx)
		t.Fatalf("query users in txPre: %v", err)
	}
	_ = txPre.Rollback(ctx)
	if preBootstrapCount != 0 {
		t.Fatalf("expected 0 users visible to app_user via app.current_clerk_id before v49, got %d", preBootstrapCount)
	}

	// 3. Negative preflight test: insert a cross-tenant order in WS B referencing WS A's product (allowed by baseline v6 single-column FK).
	// Upgrading to v49 must fail closed in preflight and roll back cleanly.
	if _, err := adminPool.Exec(ctx, `
		INSERT INTO orders (order_id, workspace_id, product_id, source_platform, external_order_id, currency, amount, lifecycle_state)
		VALUES ($1::uuid, $2::uuid, $3::uuid, 'shopify', 'ext_cross_tenant_1', 'VND', 100000, 'confirmed')
	`, orderB, wsB, prodA); err != nil {
		t.Fatalf("insert baseline cross-tenant order failed: %v", err)
	}
	if _, err := Up(ctx, adminPool, migrationsDir); err == nil || !strings.Contains(err.Error(), "migration 00049 preflight failed") {
		t.Fatalf("expected Up(v49) to fail preflight on cross-tenant orders.product_id, got %v", err)
	}

	// Remove the invalid cross-tenant order row so the upgrade can proceed.
	if _, err := adminPool.Exec(ctx, `DELETE FROM orders WHERE order_id = $1::uuid`, orderB); err != nil {
		t.Fatalf("delete cross-tenant order failed: %v", err)
	}

	// 4. Run forward-only upgrade to v49!
	upgraded, err := Up(ctx, adminPool, migrationsDir)
	if err != nil {
		t.Fatalf("upgrade Up(v1..v48 -> v49) failed: %v", err)
	}
	if len(upgraded) != 1 || upgraded[0] != 49 {
		t.Fatalf("expected only migration 49 to be newly applied during upgrade, got %v", upgraded)
	}

	// 5. Verify post-upgrade invariants:
	// 5a. Clerk bootstrap under app_user RLS now resolves the caller's own user_id and isolates other users.
	txPost, err := adminPool.Begin(ctx)
	if err != nil {
		t.Fatalf("begin txPost: %v", err)
	}
	if _, err := txPost.Exec(ctx, `SET LOCAL ROLE app_user; SELECT set_config('app.current_clerk_id', 'clerk_upgrade_user_a', true);`); err != nil {
		_ = txPost.Rollback(ctx)
		t.Fatalf("set role/config in txPost: %v", err)
	}
	var resolvedUserID string
	if err := txPost.QueryRow(ctx, `SELECT user_id::text FROM users WHERE clerk_id = 'clerk_upgrade_user_a'`).Scan(&resolvedUserID); err != nil || resolvedUserID != userA {
		_ = txPost.Rollback(ctx)
		t.Fatalf("expected Clerk bootstrap under app_user after v49 to resolve %s, got %q (err=%v)", userA, resolvedUserID, err)
	}
	var foreignUserCount int
	if err := txPost.QueryRow(ctx, `SELECT COUNT(*) FROM users WHERE clerk_id = 'clerk_upgrade_user_b'`).Scan(&foreignUserCount); err != nil || foreignUserCount != 0 {
		_ = txPost.Rollback(ctx)
		t.Fatalf("expected Clerk bootstrap under app_user to isolate foreign user B, got count=%d err=%v", foreignUserCount, err)
	}
	_ = txPost.Rollback(ctx)

	// 5b. Cross-tenant orders.product_id insert is now rejected by composite FK fk_orders_product_id_tenant.
	if _, err := adminPool.Exec(ctx, `
		INSERT INTO orders (order_id, workspace_id, product_id, source_platform, external_order_id, currency, amount, lifecycle_state)
		VALUES ($1::uuid, $2::uuid, $3::uuid, 'shopify', 'ext_cross_tenant_2', 'VND', 100000, 'confirmed')
	`, orderB, wsB, prodA); err == nil {
		t.Fatalf("expected composite FK fk_orders_product_id_tenant to reject cross-tenant product_id after v49 upgrade")
	}

	// 5c. Legacy admin_sessions row with expired_at = NULL was backfilled to started_at + 8 hours.
	var hasBackfilledExpiry bool
	if err := adminPool.QueryRow(ctx, `
		SELECT expired_at IS NOT NULL AND expired_at = started_at + INTERVAL '8 hours'
		FROM admin_sessions
		WHERE session_id = $1::uuid
	`, sessID).Scan(&hasBackfilledExpiry); err != nil || !hasBackfilledExpiry {
		t.Fatalf("expected legacy admin_sessions row %s to have expired_at backfilled to started_at + 8 hours, got %v (err=%v)", sessID, hasBackfilledExpiry, err)
	}
}

func buildHistorical4837954BundleDir(t *testing.T, migrationsDir string) string {
	t.Helper()
	entries, err := os.ReadDir(migrationsDir)
	if err != nil {
		t.Fatalf("ReadDir(%q): %v", migrationsDir, err)
	}

	bundleDir := t.TempDir()
	for _, entry := range entries {
		if entry.IsDir() || !strings.HasSuffix(entry.Name(), ".sql") {
			continue
		}
		if strings.HasPrefix(entry.Name(), "00049_") {
			continue
		}
		rawBytes, err := os.ReadFile(filepath.Join(migrationsDir, entry.Name()))
		if err != nil {
			t.Fatalf("read migration %s: %v", entry.Name(), err)
		}
		raw := string(rawBytes)

		switch {
		case strings.HasPrefix(entry.Name(), "00001_"):
			target := "CREATE POLICY user_self ON users\n" +
				"  USING (user_id = NULLIF(current_setting('app.current_user_id', true), '')::uuid)\n" +
				"  WITH CHECK (user_id = NULLIF(current_setting('app.current_user_id', true), '')::uuid);\n"
			replacement := target + "\n" +
				"CREATE POLICY user_self_clerk_bootstrap ON users FOR SELECT TO app_user\n" +
				"  USING (\n" +
				"    NULLIF(current_setting('app.current_clerk_id', true), '') IS NOT NULL\n" +
				"    AND (\n" +
				"      clerk_id = NULLIF(current_setting('app.current_clerk_id', true), '')\n" +
				"      OR external_auth_id = NULLIF(current_setting('app.current_clerk_id', true), '')\n" +
				"    )\n" +
				"  );\n"
			raw = strings.Replace(raw, target, replacement, 1)
		case strings.HasPrefix(entry.Name(), "00006_"):
			raw = strings.Replace(raw, "  connected_account_id    UUID REFERENCES connected_accounts(connected_account_id),\n", "  connected_account_id    UUID,\n", 1)
			raw = strings.Replace(raw, "  product_id              UUID REFERENCES products(product_id),\n  offer_id                UUID REFERENCES offers(offer_id),\n", "  product_id              UUID,\n  offer_id                UUID,\n", 1)
			raw = strings.Replace(raw, "  customer_entity_id      UUID REFERENCES entities(entity_id),\n", "  customer_entity_id      UUID,\n", 1)
			raw = strings.Replace(
				raw,
				"  CONSTRAINT uq_orders_tenant_pk UNIQUE (workspace_id, order_id),\n",
				"  CONSTRAINT uq_orders_tenant_pk UNIQUE (workspace_id, order_id),\n"+
					"  CONSTRAINT fk_orders_connected_account_id_tenant FOREIGN KEY (workspace_id, connected_account_id) REFERENCES connected_accounts(workspace_id, connected_account_id),\n"+
					"  CONSTRAINT fk_orders_product_id_tenant FOREIGN KEY (workspace_id, product_id) REFERENCES products(workspace_id, product_id),\n"+
					"  CONSTRAINT fk_orders_offer_id_tenant FOREIGN KEY (workspace_id, offer_id) REFERENCES offers(workspace_id, offer_id),\n"+
					"  CONSTRAINT fk_orders_customer_entity_id_tenant FOREIGN KEY (workspace_id, customer_entity_id) REFERENCES entities(workspace_id, entity_id),\n",
				1,
			)
			raw = strings.Replace(
				raw,
				"CREATE INDEX IF NOT EXISTS idx_refunds_order ON refunds(workspace_id, order_id);\n",
				"CREATE INDEX IF NOT EXISTS idx_refunds_order ON refunds(workspace_id, order_id);\n"+
					"CREATE UNIQUE INDEX IF NOT EXISTS idx_refunds_external_identity\n"+
					"  ON refunds(workspace_id, order_id, source_platform, external_refund_id)\n"+
					"  WHERE external_refund_id IS NOT NULL AND deleted_at IS NULL;\n",
				1,
			)
			raw = strings.Replace(raw, "  refund_id           UUID REFERENCES refunds(refund_id),\n", "  refund_id           UUID,\n", 1)
			raw = strings.Replace(
				raw,
				"  lifecycle_state     VARCHAR(20) NOT NULL DEFAULT 'initiated',\n",
				"  lifecycle_state     VARCHAR(20) NOT NULL DEFAULT 'initiated',\n"+
					"  source_platform     VARCHAR(50),\n"+
					"  external_return_id  VARCHAR(255),\n",
				1,
			)
			raw = strings.Replace(
				raw,
				"  CONSTRAINT fk_returns_order_id_tenant FOREIGN KEY (workspace_id, order_id) REFERENCES orders(workspace_id, order_id) ON DELETE CASCADE,\n",
				"  CONSTRAINT fk_returns_order_id_tenant FOREIGN KEY (workspace_id, order_id) REFERENCES orders(workspace_id, order_id) ON DELETE CASCADE,\n"+
					"  CONSTRAINT fk_returns_refund_id_tenant FOREIGN KEY (workspace_id, refund_id) REFERENCES refunds(workspace_id, refund_id),\n",
				1,
			)
			raw = strings.Replace(
				raw,
				"CREATE INDEX IF NOT EXISTS idx_returns_order ON returns(workspace_id, order_id);\n",
				"CREATE INDEX IF NOT EXISTS idx_returns_order ON returns(workspace_id, order_id);\n"+
					"CREATE UNIQUE INDEX IF NOT EXISTS idx_returns_external_identity\n"+
					"  ON returns(workspace_id, order_id, source_platform, external_return_id)\n"+
					"  WHERE external_return_id IS NOT NULL AND deleted_at IS NULL;\n",
				1,
			)
		}

		if err := os.WriteFile(filepath.Join(bundleDir, entry.Name()), []byte(raw), 0o600); err != nil {
			t.Fatalf("write historical 4837954 migration %s: %v", entry.Name(), err)
		}
	}

	migs, err := LoadDir(bundleDir)
	if err != nil {
		t.Fatalf("LoadDir(4837954 bundle) failed: %v", err)
	}
	if len(migs) != 48 {
		t.Fatalf("expected 48 migrations in 4837954 bundle, got %d", len(migs))
	}
	if migs[0].Checksum != "87595883069286733567722b6f16de46da25216f8e6be429e23c3c8e12f28bc7" {
		t.Fatalf("expected 4837954 v1 checksum 87595883..., got %s", migs[0].Checksum)
	}
	if migs[5].Checksum != "8696ef9664e392fcd78544242e14b7e6f78e0953414679801c923e73aa36929e" {
		t.Fatalf("expected 4837954 v6 checksum 8696ef96..., got %s", migs[5].Checksum)
	}
	return bundleDir
}

func TestEmptyMigrationBundleFailsClosed(t *testing.T) {
	emptyDir := t.TempDir()
	if err := os.Mkdir(filepath.Join(emptyDir, "subdir"), 0o755); err != nil {
		t.Fatalf("mkdir subdir: %v", err)
	}
	if err := os.WriteFile(filepath.Join(emptyDir, "README.md"), []byte("not sql"), 0o600); err != nil {
		t.Fatalf("write non-sql file: %v", err)
	}

	if _, err := LoadDir(emptyDir); err == nil {
		t.Fatalf("expected LoadDir on empty migration bundle to fail closed, got nil")
	}
	runner := &fakeRunner{}
	if _, err := Up(context.Background(), runner, emptyDir); err == nil {
		t.Fatalf("expected Up on empty migration bundle to fail closed, got nil")
	}
	if _, err := Status(context.Background(), runner, emptyDir); err == nil {
		t.Fatalf("expected Status on empty migration bundle to fail closed, got nil")
	}
}

func TestPostgresUpgradeFromHistorical4837954LineageAndTamperDenial(t *testing.T) {
	dsn := os.Getenv("CREATIVANTA_TEST_DATABASE_URL")
	if dsn == "" {
		t.Skip("CREATIVANTA_TEST_DATABASE_URL not set; live PostgreSQL 4837954 lineage upgrade suite executes in CI")
	}

	ctx, cancel := context.WithTimeout(context.Background(), 60*time.Second)
	defer cancel()

	adminPool, err := pgxpool.New(ctx, dsn)
	if err != nil {
		t.Fatalf("connect adminPool: %v", err)
	}
	defer adminPool.Close()

	_, _ = adminPool.Exec(ctx, `DROP SCHEMA IF EXISTS public CASCADE; CREATE SCHEMA public; GRANT ALL ON SCHEMA public TO CURRENT_USER; GRANT USAGE ON SCHEMA public TO PUBLIC;`)

	migrationsDir := filepath.Join("..", "..", "..", "..", "infra", "migrations")
	bundle4837954Dir := buildHistorical4837954BundleDir(t, migrationsDir)

	// 1. Apply the historical 4837954 bundle (v1..v48) to a clean database.
	applied48, err := Up(ctx, adminPool, bundle4837954Dir)
	if err != nil {
		t.Fatalf("Up(4837954 bundle v1..v48) failed: %v", err)
	}
	if len(applied48) != 48 {
		t.Fatalf("expected 48 migrations applied from 4837954 bundle, got %d", len(applied48))
	}

	// Seed tenant, product, order, and legacy unbounded admin session data on the 4837954 database.
	const (
		userA   = "11111111-1111-4111-8111-111111111201"
		userB   = "22222222-2222-4222-8222-222222222203"
		wsA     = "aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaa11"
		wsB     = "bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbb12"
		prodA   = "cccccccc-cccc-4ccc-8ccc-cccccccccc11"
		orderA  = "dddddddd-dddd-4ddd-8ddd-dddddddddd11"
		orderB  = "dddddddd-dddd-4ddd-8ddd-dddddddddd12"
		adminID = "eeeeeeee-eeee-4eee-8eee-eeeeeeeeee11"
		sessID  = "ffffffff-ffff-4fff-8fff-ffffffffff11"
	)
	seedSQL := `
		INSERT INTO users (user_id, clerk_id, email, display_name, status)
		VALUES
			('11111111-1111-4111-8111-111111111201'::uuid, 'clerk_4837954_user_a', 'u4837954_a@creativanta.test', 'User 4837954 A', 'active'),
			('22222222-2222-4222-8222-222222222203'::uuid, 'clerk_4837954_user_b', 'u4837954_b@creativanta.test', 'User 4837954 B', 'active');

		INSERT INTO workspaces (workspace_id, name, slug, owner_user_id, subscription_tier, default_mode, enabled_modes, status)
		VALUES
			('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaa11'::uuid, 'WS 4837954 A', 'ws-4837954-a', '11111111-1111-4111-8111-111111111201'::uuid, 'pro', 'seller'::operator_mode, ARRAY['seller']::operator_mode[], 'active'),
			('bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbb12'::uuid, 'WS 4837954 B', 'ws-4837954-b', '22222222-2222-4222-8222-222222222203'::uuid, 'free', 'creator'::operator_mode, ARRAY['creator']::operator_mode[], 'active');

		INSERT INTO workspace_members (workspace_id, user_id, role, status)
		VALUES
			('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaa11'::uuid, '11111111-1111-4111-8111-111111111201'::uuid, 'owner', 'active'),
			('bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbb12'::uuid, '22222222-2222-4222-8222-222222222203'::uuid, 'owner', 'active');

		INSERT INTO products (product_id, workspace_id, product_type, title, currency, catalog_status)
		VALUES
			('cccccccc-cccc-4ccc-8ccc-cccccccccc11'::uuid, 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaa11'::uuid, 'physical', '4837954 Product A', 'VND', 'active');

		INSERT INTO orders (order_id, workspace_id, product_id, source_platform, external_order_id, currency, amount, lifecycle_state)
		VALUES
			('dddddddd-dddd-4ddd-8ddd-dddddddddd11'::uuid, 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaa11'::uuid, 'cccccccc-cccc-4ccc-8ccc-cccccccccc11'::uuid, 'shopify', 'ext_4837954_valid_1', 'VND', 250000, 'confirmed');

		INSERT INTO internal_admins (admin_id, email, display_name, password_hash, role, status, mfa_enabled)
		VALUES
			('eeeeeeee-eeee-4eee-8eee-eeeeeeeeee11'::uuid, 'admin_4837954@creativanta.test', 'Admin 4837954', '$2a$12$hash4837954', 'super_admin', 'active', true);

		INSERT INTO admin_sessions (session_id, admin_id, ip_address, user_agent, vpn_verified, mfa_verified, started_at, expired_at, session_token_hash)
		VALUES
			('ffffffff-ffff-4fff-8fff-ffffffffff11'::uuid, 'eeeeeeee-eeee-4eee-8eee-eeeeeeeeee11'::uuid, '127.0.0.1'::inet, 'Upgrade4837954Test', true, true, NOW() - INTERVAL '30 minutes', NULL, 'hash_4837954_null_expiry_0001');
	`
	if _, err := adminPool.Exec(ctx, seedSQL); err != nil {
		t.Fatalf("seed 4837954 data failed: %v", err)
	}

	// 2. Negative check: attempting to run a 70c2b71-only bundle (without migration 00049) against a 4837954 database MUST fail closed with ErrChecksumMismatch.
	baselineNo49Dir := t.TempDir()
	entries, err := os.ReadDir(migrationsDir)
	if err != nil {
		t.Fatalf("ReadDir(%q): %v", migrationsDir, err)
	}
	for _, entry := range entries {
		if entry.IsDir() || !strings.HasSuffix(entry.Name(), ".sql") || strings.HasPrefix(entry.Name(), "00049_") {
			continue
		}
		b, err := os.ReadFile(filepath.Join(migrationsDir, entry.Name()))
		if err != nil {
			t.Fatalf("read %s: %v", entry.Name(), err)
		}
		if err := os.WriteFile(filepath.Join(baselineNo49Dir, entry.Name()), b, 0o600); err != nil {
			t.Fatalf("write %s: %v", entry.Name(), err)
		}
	}
	if _, err := Up(ctx, adminPool, baselineNo49Dir); !errors.Is(err, ErrChecksumMismatch) {
		t.Fatalf("expected Up without migration 00049 on 4837954 DB to fail closed with ErrChecksumMismatch, got %v", err)
	}

	// 3. Negative check: if the 4837954 schema object (user_self_clerk_bootstrap policy) is missing while checksum claims 4837954, Up MUST fail closed with ErrChecksumMismatch.
	if _, err := adminPool.Exec(ctx, `DROP POLICY user_self_clerk_bootstrap ON users`); err != nil {
		t.Fatalf("drop policy user_self_clerk_bootstrap: %v", err)
	}
	if _, err := Up(ctx, adminPool, migrationsDir); !errors.Is(err, ErrChecksumMismatch) {
		t.Fatalf("expected Up to fail with ErrChecksumMismatch when 4837954 schema policy is missing, got %v", err)
	}
	// Restore the 4837954 policy so the DB genuinely matches 4837954 schema state.
	if _, err := adminPool.Exec(ctx, `
		CREATE POLICY user_self_clerk_bootstrap ON users FOR SELECT TO app_user
		  USING (
		    NULLIF(current_setting('app.current_clerk_id', true), '') IS NOT NULL
		    AND (
		      clerk_id = NULLIF(current_setting('app.current_clerk_id', true), '')
		      OR external_auth_id = NULLIF(current_setting('app.current_clerk_id', true), '')
		    )
		  )
	`); err != nil {
		t.Fatalf("restore policy user_self_clerk_bootstrap: %v", err)
	}

	// 3b. Negative check: if a 4837954 v6 composite tenant FK (fk_orders_product_id_tenant) is missing while checksum claims 4837954, Up and Status MUST fail closed with ErrChecksumMismatch.
	if _, err := adminPool.Exec(ctx, `ALTER TABLE orders DROP CONSTRAINT fk_orders_product_id_tenant`); err != nil {
		t.Fatalf("drop constraint fk_orders_product_id_tenant: %v", err)
	}
	if _, err := Status(ctx, adminPool, migrationsDir); !errors.Is(err, ErrChecksumMismatch) {
		t.Fatalf("expected Status to fail with ErrChecksumMismatch when 4837954 v6 composite FK is missing, got %v", err)
	}
	if _, err := Up(ctx, adminPool, migrationsDir); !errors.Is(err, ErrChecksumMismatch) {
		t.Fatalf("expected Up to fail with ErrChecksumMismatch when 4837954 v6 composite FK is missing, got %v", err)
	}
	if _, err := adminPool.Exec(ctx, `
		ALTER TABLE orders
		ADD CONSTRAINT fk_orders_product_id_tenant
		FOREIGN KEY (workspace_id, product_id) REFERENCES products(workspace_id, product_id)
	`); err != nil {
		t.Fatalf("restore constraint fk_orders_product_id_tenant: %v", err)
	}

	// 4. Status and Up from 4837954 -> HEAD (with 00049) must succeed, preserve data, and append reconciled checksums without deleting 4837954 audit history.
	statusesBefore, err := Status(ctx, adminPool, migrationsDir)
	if err != nil {
		t.Fatalf("Status(4837954 DB against HEAD) failed: %v", err)
	}
	if len(statusesBefore) != 49 || !statusesBefore[0].Applied || !statusesBefore[5].Applied || statusesBefore[48].Applied {
		t.Fatalf("unexpected pre-upgrade status on 4837954 DB: v1=%+v v6=%+v v49=%+v", statusesBefore[0], statusesBefore[5], statusesBefore[48])
	}

	upgraded, err := Up(ctx, adminPool, migrationsDir)
	if err != nil {
		t.Fatalf("upgrade Up(4837954 -> HEAD v49) failed: %v", err)
	}
	if len(upgraded) != 1 || upgraded[0] != 49 {
		t.Fatalf("expected only migration 49 newly applied when upgrading from 4837954, got %v", upgraded)
	}

	// 5. Verify both historical 4837954 checksums and reconciled canonical checksums are recorded in goose_db_version (append-only audit history preserved).
	for _, tc := range []struct {
		ver         int64
		histCS      string
		canonicalCS string
	}{
		{1, "87595883069286733567722b6f16de46da25216f8e6be429e23c3c8e12f28bc7", "b2f4c41ab41c013d19f260a450982229bc4ef7f159d4f334cf56c6706a28a1e6"},
		{6, "8696ef9664e392fcd78544242e14b7e6f78e0953414679801c923e73aa36929e", "d463a8f01946972a3f9c4243943a91452e0722b850478d7a998f842e0a1655f3"},
	} {
		var latestCS string
		if err := adminPool.QueryRow(ctx, `SELECT checksum FROM goose_db_version WHERE version_id = $1 AND is_applied = true ORDER BY id DESC LIMIT 1`, tc.ver).Scan(&latestCS); err != nil {
			t.Fatalf("query latest checksum for v%d: %v", tc.ver, err)
		}
		if latestCS != tc.canonicalCS {
			t.Fatalf("expected latest reconciled v%d checksum %s, got %s", tc.ver, tc.canonicalCS, latestCS)
		}
		var histCount int
		if err := adminPool.QueryRow(ctx, `SELECT COUNT(*) FROM goose_db_version WHERE version_id = $1 AND is_applied = true AND checksum = $2`, tc.ver, tc.histCS).Scan(&histCount); err != nil || histCount != 1 {
			t.Fatalf("expected historical 4837954 checksum row for v%d to be preserved in goose_db_version, got count=%d err=%v", tc.ver, histCount, err)
		}
	}

	// 6. Verify seeded order data survived, cross-tenant FK is enforced, Clerk bootstrap works under app_user, and legacy NULL admin_sessions.expired_at was backfilled.
	var orderCount int
	if err := adminPool.QueryRow(ctx, `SELECT COUNT(*) FROM orders WHERE order_id = $1::uuid AND workspace_id = $2::uuid`, orderA, wsA).Scan(&orderCount); err != nil || orderCount != 1 {
		t.Fatalf("expected seeded order %s to survive 4837954 -> HEAD upgrade, got count=%d err=%v", orderA, orderCount, err)
	}
	if _, err := adminPool.Exec(ctx, `
		INSERT INTO orders (order_id, workspace_id, product_id, source_platform, external_order_id, currency, amount, lifecycle_state)
		VALUES ($1::uuid, $2::uuid, $3::uuid, 'shopify', 'ext_4837954_cross_tenant', 'VND', 100000, 'confirmed')
	`, orderB, wsB, prodA); err == nil {
		t.Fatalf("expected composite FK fk_orders_product_id_tenant to reject cross-tenant order after 4837954 -> HEAD upgrade")
	}
	var backfilled bool
	if err := adminPool.QueryRow(ctx, `
		SELECT expired_at IS NOT NULL AND expired_at = started_at + INTERVAL '8 hours'
		FROM admin_sessions WHERE session_id = $1::uuid
	`, sessID).Scan(&backfilled); err != nil || !backfilled {
		t.Fatalf("expected admin_sessions row %s to have expired_at backfilled after 4837954 -> HEAD upgrade, got %v (err=%v)", sessID, backfilled, err)
	}

	txPost, err := adminPool.Begin(ctx)
	if err != nil {
		t.Fatalf("begin txPost: %v", err)
	}
	if _, err := txPost.Exec(ctx, `SET LOCAL ROLE app_user; SELECT set_config('app.current_clerk_id', 'clerk_4837954_user_a', true);`); err != nil {
		_ = txPost.Rollback(ctx)
		t.Fatalf("set role/config in txPost: %v", err)
	}
	var resolvedUserID string
	if err := txPost.QueryRow(ctx, `SELECT user_id::text FROM users WHERE clerk_id = 'clerk_4837954_user_a'`).Scan(&resolvedUserID); err != nil || resolvedUserID != userA {
		_ = txPost.Rollback(ctx)
		t.Fatalf("expected Clerk bootstrap under app_user after 4837954 -> HEAD upgrade to resolve %s, got %q (err=%v)", userA, resolvedUserID, err)
	}
	var foreignCount int
	if err := txPost.QueryRow(ctx, `SELECT COUNT(*) FROM users WHERE clerk_id = 'clerk_4837954_user_b'`).Scan(&foreignCount); err != nil || foreignCount != 0 {
		_ = txPost.Rollback(ctx)
		t.Fatalf("expected Clerk bootstrap under app_user to isolate user B after 4837954 -> HEAD upgrade, got %d (err=%v)", foreignCount, err)
	}
	_ = txPost.Rollback(ctx)
}
