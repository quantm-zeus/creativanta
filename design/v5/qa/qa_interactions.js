const puppeteer=require('/home/whaleorcale/.local/share/evergreen-remote/node_modules/puppeteer');
const root='/home/whaleorcale/evergreen/services/creativanta/design/v5/dist/';
const files={web:'creativanta-v5-web-all.html',admin:'creativanta-v5-admin-all.html',mobile:'creativanta-v5-mobile-all.html'};
const chrome='/home/whaleorcale/.cache/puppeteer/chrome-headless-shell/linux-156.0.8078.80/chrome-headless-shell-linux64/chrome-headless-shell';
(async()=>{
let bad=[];const browser=await puppeteer.launch({executablePath:chrome,headless:true,args:['--no-sandbox','--allow-file-access-from-files','--disable-dev-shm-usage']});
for(const plat of ['web','admin','mobile']){
 const page=await browser.newPage();await page.setViewport({width:plat==='mobile'?390:1440,height:900});
 page.on('pageerror',e=>bad.push({plat,error:e.message}));
 await page.goto('file://'+root+files[plat],{waitUntil:'domcontentloaded'});
 if(plat==='admin'){
  await page.evaluate(()=>window.__cv5QA('A015'));
  const decision=await page.$$('[data-v5="decision"]');
  if(decision.length<2)bad.push({plat,action:'approval rows missing'});
  else{
   await decision[1].click();
   const confirm=await page.$('[data-v5="confirm-decision"]');
   if(!confirm)bad.push({plat,action:'approval confirm missing'});
   else await confirm.click();
   const second=await page.evaluate(()=>document.querySelectorAll('.v5-item')[1]?.textContent.includes('Đã xác nhận DEMO'));
   if(!second)bad.push({plat,action:'wrong row status'});
  }
 }else if(plat==='web'){
  await page.evaluate(()=>window.__cv5QA('W052'));
  await page.type('#v5-field-0','Kịch bản thử nghiệm V5');
  await page.evaluate(()=>document.querySelector('[data-v5="save"]')?.click());
  if(!(await page.evaluate(()=>document.getElementById('toast-root')?.textContent.includes('Đã lưu'))))bad.push({plat,action:'draft save'});
  await page.evaluate(()=>document.querySelector('[data-v5="actions"]')?.click());
  const all=await page.$$eval('[data-v5="source-action"]',xs=>xs.length);
  if(all<8)bad.push({plat,action:'source actions modal count',all});
  await page.keyboard.press('Escape');
  await page.evaluate(()=>window.__cv5QA('W076'));
  await page.evaluate(()=>document.querySelector('[data-v5="period"][data-v5-key="90 ngày"]')?.click());
  const ninety=await page.evaluate(()=>document.querySelector('[data-v5="period"][data-v5-key="90 ngày"]')?.classList.contains('active'));
  if(!ninety)bad.push({plat,action:'period switch'});
 }else{
  await page.evaluate(()=>window.__cv5QA('M043'));
  const input=await page.$('[data-v5m-field="M043-1"]');
  if(!input)bad.push({plat,action:'cost amount missing'});
  else{
   await input.type('250000');
   await page.evaluate(()=>document.querySelector('[data-v5m="save"]')?.click());
   if(!(await page.evaluate(()=>document.getElementById('mobile-toast')?.textContent.includes('Đã lưu'))))bad.push({plat,action:'cost draft save'});
  }
  const more=await page.$('[data-v5m="more-actions"]');
  if(!more)bad.push({plat,action:'more actions button missing'});
  else{
   await more.click();
   const count=await page.$$eval('.m-sheet [data-v5m="source"]',els=>els.length);
   if(count<9)bad.push({plat,action:'more source actions',count});
   await page.keyboard.press('Escape');
   if(await page.$('.m-sheet'))bad.push({plat,action:'escape sheet failed'});
  }
 }
 console.log('INTERACTION_QA',plat,'complete');await page.close();
}
await browser.close();console.log('INTERACTION_FAILURES',bad.length,JSON.stringify(bad));process.exitCode=bad.length?1:0;
})().catch(e=>{console.error(e.stack);process.exitCode=2});