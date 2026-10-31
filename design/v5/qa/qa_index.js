const puppeteer=require('/home/whaleorcale/.local/share/evergreen-remote/node_modules/puppeteer');
const f='/home/whaleorcale/evergreen/services/creativanta/design/v5/dist/creativanta-v5-start-here.html';
(async()=>{let fail=0;const b=await puppeteer.launch({executablePath:'/home/whaleorcale/.cache/puppeteer/chrome-headless-shell/linux-156.0.8078.80/chrome-headless-shell-linux64/chrome-headless-shell',args:['--no-sandbox','--allow-file-access-from-files']});
for(const width of [1440,820,390,360]){
 const p=await b.newPage();await p.setViewport({width,height:900});
 let errs=[];p.on('pageerror',e=>errs.push(e.message));
 await p.goto('file://'+f,{waitUntil:'load'});
 const first=await p.evaluate(()=>({cards:document.querySelectorAll('.card').length,links:document.querySelectorAll('.screen').length,docWidth:document.documentElement.scrollWidth,viewport:innerWidth,pics:document.images.length,loaded:[...document.images].filter(x=>x.complete&&x.naturalWidth).length}));
 await p.type('#search','M043');
 const result=await p.$eval('#count',e=>e.textContent);
 if(first.cards!==4||first.links!==233||first.docWidth>width+2||first.loaded!==3||!result.includes('1 / 233')||errs.length)fail++;
 await p.screenshot({path:'/home/whaleorcale/evergreen/services/creativanta/design/v5/qa/screenshots/start-here-'+width+'.png'});
 console.log(JSON.stringify({width,first,result,errs}));await p.close();
}
await b.close();console.log('INDEX_FAILURES',fail);process.exitCode=fail?1:0;})().catch(e=>{console.error(e.stack);process.exitCode=2});