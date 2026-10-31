#!/usr/bin/env node
/* Executable Chromium evidence for Creativanta V5 — every canonical route. */
const fs=require('fs');
const path=require('path');
const puppeteer=require('/home/whaleorcale/.local/share/evergreen-remote/node_modules/puppeteer');
const ROOT='/home/whaleorcale/evergreen/services/creativanta/design/v5';
const DATA=JSON.parse(fs.readFileSync(path.join(ROOT,'screen_specs.json'),'utf8'));
const CHROME='/home/whaleorcale/.cache/puppeteer/chrome-headless-shell/linux-156.0.8078.80/chrome-headless-shell-linux64/chrome-headless-shell';
const IMG=path.join(ROOT,'qa','screenshots');fs.mkdirSync(IMG,{recursive:true});
const FILES={web:'creativanta-v5-web-all.html',admin:'creativanta-v5-admin-all.html',mobile:'creativanta-v5-mobile-all.html',shared:'creativanta-v5-shared-system.html'};
const rootViews=new Set(['W001','W012','W038','W046','W055','W062','W075','W100','W114','A001']);
const selected=new Set(['W052','W076','W062','W084','W010','W038','W016','W012','W100','W055','A015','A021','A026','A002','A001','M043','M011','M027','M058','M025','M017','M001','M051','M040']);
async function tick(ms=20){return new Promise(r=>setTimeout(r,ms))}
(async()=>{
const browser=await puppeteer.launch({executablePath:CHROME,headless:true,args:['--no-sandbox','--disable-gpu','--disable-dev-shm-usage','--allow-file-access-from-files']});
let failures=[],checks=0,captures=0;
for(const [plat,width,height] of [['web',1440,900],['web',820,950],['web',390,844],['web',360,780],
 ['admin',1440,900],['admin',390,844],['mobile',1440,900],['mobile',820,950],['mobile',390,844],['mobile',360,780]]){
 const page=await browser.newPage();await page.setViewport({width,height,deviceScaleFactor:1});
 let errs=[];page.on('pageerror',e=>errs.push(e.message));
 await page.goto('file://'+path.join(ROOT,'dist',FILES[plat]),{waitUntil:'domcontentloaded',timeout:30000});
 await tick(80);
 const records=DATA.filter(x=>x.platform===plat);
 for(const s of records){
  await page.evaluate(id=>window.__cv5QA(id),s.id);
  if(selected.has(s.id) && (width===1440||width===390)){
    await tick(50);await page.screenshot({path:path.join(IMG,plat+'-'+width+'-'+s.id+'.png'),captureBeyondViewport:false});captures++;
  }
  const m=await page.evaluate(()=>{
    const main=document.querySelector('.m-scroller,#content,main');
    const detail=document.querySelector('[data-v5-mobile],[data-full-screen]');
    const content=document.querySelector('#content,main');
    return {hash:location.hash,fullId:detail?.getAttribute('data-v5-mobile')||detail?.getAttribute('data-full-screen'),
      heading:content?.querySelector('h1')?.textContent?.trim().slice(0,75),
      textLen:content?.innerText?.trim().length,
      docWidth:document.documentElement.scrollWidth,viewport:innerWidth,
      mainWidth:main?.clientWidth,mainScrollWidth:main?.scrollWidth,
      actionCount:content?.querySelectorAll('[data-v5],[data-v5m],[data-go],[data-act]').length||0};
  });
  checks++;
  if(m.docWidth>width+3||!m.heading||m.textLen<110||m.actionCount<1||m.mainScrollWidth>m.mainWidth+4||(m.fullId!==s.id&&!rootViews.has(s.id))){
   failures.push({plat,width,id:s.id,reason:'layout_or_missing_screen',metrics:m});
  }
 }
 console.log('ALL_ROUTES',plat,width,'checked',records.length,'runtimeErrors',errs.length);
 if(errs.length)failures.push({plat,width,runtimeErrors:errs.slice(0,8)});
 // Search/keyboard: validate through visible UI (not just programmatic navigation).
 if(plat==='web'||plat==='admin'){
   await page.evaluate(()=>document.querySelector('[data-act="search"]')?.click());
   await tick(30);
   const search=await page.$('#palette-input');
   if(!search)failures.push({plat,width,action:'command palette missing'});
   else{
     await search.type(plat==='web'?'W052':'A015');
     const count=await page.$$eval('.palette-result',x=>x.length);
     if(!count)failures.push({plat,width,action:'command palette no results'});
     await page.keyboard.press('Escape');
     if(await page.$('.palette'))failures.push({plat,width,action:'escape failed'});
   }
   await page.evaluate(id=>window.__cv5QA(id),plat==='web'?'W060':'A002');
   await page.evaluate(()=>document.querySelector('[data-v5="create"]')?.click());
   if(!(await page.$('#v5-modal-title')))failures.push({plat,width,action:'create-modal-missing'});
   else{
    await page.type('#v5-modal-title','QA V5 test record');
    await page.evaluate(()=>document.querySelector('[data-v5="add-record"]')?.click());
    const saved=await page.evaluate(()=>document.querySelector('#content')?.innerText.includes('QA V5 test record'));
    if(!saved)failures.push({plat,width,action:'record-create-not-rendered'});
   }
 }else{
   await page.evaluate(()=>window.__cv5QA('M043'));
   await page.evaluate(()=>document.querySelector('[data-v5m="save"]')?.click());
   await page.evaluate(()=>window.__cv5QA('M027'));
   await page.evaluate(()=>document.querySelector('[data-v5m="create"]')?.click());
   if(!(await page.$('#m-v5-new')))failures.push({plat,width,action:'create modal missing'});
   else{
    await page.type('#m-v5-new','QA mobile expense');
    await page.evaluate(()=>document.querySelector('[data-v5m="add"]')?.click());
    const saved=await page.evaluate(()=>document.querySelector('main')?.innerText.includes('QA mobile expense'));
    if(!saved)failures.push({plat,width,action:'create not saved'});
   }
   await page.evaluate(()=>document.querySelector('[data-action="search"]')?.click());
   if(!(await page.$('#mobile-search')))failures.push({plat,width,action:'mobile search missing'});
   else{
    await page.type('#mobile-search','M043');
    const count=await page.$$eval('.m-search-result',e=>e.length);
    if(count!==1)failures.push({plat,width,action:'mobile search expected one',count});
    await page.keyboard.press('Escape');
    if(await page.$('#mobile-search'))failures.push({plat,width,action:'mobile escape failed'});
   }
   await page.evaluate(()=>window.__cv5QA('home'));
   await page.screenshot({path:path.join(IMG,'mobile-'+width+'-HOME.png'),captureBeyondViewport:false});captures++;
 }
 await page.close();
}
for(const width of [1440,390]){
 const page=await browser.newPage();await page.setViewport({width,height:900});
 const errs=[];page.on('pageerror',e=>errs.push(e.message));
 await page.goto('file://'+path.join(ROOT,'dist',FILES.shared),{waitUntil:'domcontentloaded'});
 let m=await page.evaluate(()=>({patterns:document.querySelectorAll('.pattern').length,bodyWidth:document.documentElement.scrollWidth,btn:document.querySelectorAll('button').length}));
 if(m.patterns!==12||m.bodyWidth>width+2||errs.length)failures.push({plat:'shared',width,metrics:m,errs});
 await page.evaluate(()=>document.querySelector('[data-action="modal"]')?.click());
 if(!(await page.$('.dialog')))failures.push({plat:'shared',width,action:'dialog missing'});
 await page.keyboard.press('Escape');
 if(await page.$('.dialog'))failures.push({plat:'shared',width,action:'dialog not closed'});
 await page.screenshot({path:path.join(IMG,'shared-'+width+'.png'),captureBeyondViewport:false});captures++;
 await page.close();
}
await browser.close();
const summary={checks,distinctScreens:DATA.length,captures,failures:failures.length,examples:failures.slice(0,25)};
fs.writeFileSync(path.join(ROOT,'qa','results.json'),JSON.stringify(summary,null,2));
console.log('FINAL_QA',JSON.stringify(summary));
process.exitCode=failures.length?1:0;
})().catch(e=>{console.error(e.stack);process.exitCode=2});
