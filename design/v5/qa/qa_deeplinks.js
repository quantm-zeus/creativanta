const puppeteer=require('/home/whaleorcale/.local/share/evergreen-remote/node_modules/puppeteer');
const f='/home/whaleorcale/evergreen/services/creativanta/design/v5/dist/creativanta-v5-start-here.html';
const p='/home/whaleorcale/evergreen/services/creativanta/design/v5/dist';
const chrome='/home/whaleorcale/.cache/puppeteer/chrome-headless-shell/linux-156.0.8078.80/chrome-headless-shell-linux64/chrome-headless-shell';
(async()=>{
const b=await puppeteer.launch({headless:true,executablePath:chrome,args:['--no-sandbox','--allow-file-access-from-files']});
let fail=0;
for(const [plat,id] of [['web','W052'],['mobile','M043'],['admin','A015']]){
 const page=await b.newPage();await page.setViewport({width:800,height:860});
 await page.goto('file://'+p+'/creativanta-v5-start-here.html',{waitUntil:'domcontentloaded'});
 await page.type('#search',id);
 const destination=await page.$eval('.screen',el=>el.href);
 if(!destination.includes('creativanta-v5-'+plat+'-all.html#'+id)){fail++;console.log('BAD_DEST',plat,destination);}
 await page.goto(destination,{waitUntil:'domcontentloaded'});
 const actual=await page.evaluate(()=>({hash:location.hash,screen:document.querySelector('[data-full-screen],[data-v5-mobile]')?.getAttribute('data-full-screen')||document.querySelector('[data-v5-mobile]')?.getAttribute('data-v5-mobile'),heading:document.querySelector('#content h1,main h1')?.textContent?.trim(),text:document.querySelector('#content,main')?.textContent.slice(0,150)}));
 if(!actual.heading||actual.screen!==id)fail++;
 console.log('DEEPLINK',plat,id,JSON.stringify(actual));
 await page.close();
}
await b.close();console.log('DEEPLINK_FAIL',fail);process.exitCode=fail?1:0;
})().catch(e=>{console.error(e.stack);process.exitCode=2});