"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const puppeteer_1 = require("puppeteer");
(async () => {
    const browser = await puppeteer_1.launch({ headless: true, args: ['--no-sandbox', '--disable-setuid-sandbox']});
    const [page] = await browser.pages();

    function handleClose(){
	console.log('crashed');
	page.close();
        browser.close();
        process.exit(1);
    }

    process.on("uncaughtException", () => {
       handleClose();
    });

    process.on("unhandledRejection", () => {
      handleClose();
    });
 
    await page.goto("http://localhost:8315");
    await page.emulate({
        viewport: {
            width: 1600,
            height: 800
        },
        userAgent: ""
    });
    await page.waitFor('[title="index.html"]');
    await page.click('[title="index.html"]');

    await page.waitFor(500);
 
    (await page.evaluateHandle('document.querySelector("#-blink-dev-tools > div.widget.vbox.root-view > div > div.widget.vbox.insertion-point-sidebar > div > div").shadowRoot.querySelector("#tab-console")')).click();

    await page.waitFor(1000);

    await page.keyboard.type(`document.getElementsByClassName("big-button")[0].firstChild.click()`);
    await page.keyboard.press("Enter");
   
    // Wait 5min to update the game
    await page.waitFor(300000);

    await page.close();
    browser.close();
    process.exit();
})();
