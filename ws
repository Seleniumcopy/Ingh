Yes, it's possible to save each 


---


import org.apache.poi.xwpf.usermodel.*;
import org.openqa.selenium.*;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.io.FileHandler;

import java.io.*;
import java.util.List;

public class WsdlScreenshotToWord {

    public static void main(String[] args) {
        // List of URLs to visit
        List<String> wsdlUrls = List.of(
            "https://example.com/wsdl1",
            "https://example.com/wsdl2",
            "https://example.com/wsdl3"
        );

        // Set up WebDriver (ensure you have ChromeDriver in PATH)
        System.setProperty("webdriver.chrome.driver", "/path/to/chromedriver");
        WebDriver driver = new ChromeDriver();

        // Create a Word document
        XWPFDocument document = new XWPFDocument();

        try {
            for (String url : wsdlUrls) {
                driver.get(url);

                // Wait for the page to load
                Thread.sleep(2000);

   cs             // Scroll to the  section (adjust the locator as needed)
                WebElement cs = driver.findElement(By.xpath("//*[contains(text(), 'CompanyStatus')]"));
                ((JavascriptExecutor) driver).executeScript("arguments[0].scrollIntoView(true);", companyStatusElement);

                // Wait for scroll to complete
                Thread.sleep(1000);

                // Take a screenshot
                File screenshotFile = takeScreenshot(driver, url);

                // Add screenshot to the Word document
                addScreenshotToWord(document, screenshotFile, url);

                System.out.println("Screenshot added for URL: " + url);
            }

            // Save the Word document
            try (FileOutputStream out = new FileOutputStream("WSDL_Screenshots.docx")) {
                document.write(out);
            }

            System.out.println("Screenshots saved to Word document.");

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // Close the browser
            driver.quit();

            // Close the Word document
            try {
                document.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    public static File takeScreenshot(WebDriver driver, String url) {
        try {
            // Take a screenshot
            File srcFile = ((TakesScreenshot) driver).getScreenshotAs(OutputType.FILE);

            // Create a clean filename based on the URL
            String fileName = url.replaceAll("[^a-zA-Z0-9]", "_") + ".png";

            // Save the screenshot
            File screenshotFile = new File("./" + fileName);
            FileHandler.copy(srcFile, screenshotFile);
            return screenshotFile;
        } catch (Exception e) {
            System.out.println("Error taking screenshot for URL: " + url);
            e.printStackTrace();
            return null;
        }
    }

    public static void addScreenshotToWord(XWPFDocument document, File screenshotFile, String url) {
        try {
            // Add a title for the URL
            XWPFParagraph paragraph = document.createParagraph();
            XWPFRun run = paragraph.createRun();
            run.setText("Screenshot for URL: " + url);
            run.setBold(true);

            // Add the screenshot as an image
            if (screenshotFile != null && screenshotFile.exists()) {
                InputStream is = new FileInputStream(screenshotFile);
                document.addPictureData(is, XWPFDocument.PICTURE_TYPE_PNG);
                is.close();

                XWPFParagraph imageParagraph = document.createParagraph();
                XWPFRun imageRun = imageParagraph.createRun();
                imageRun.addPicture(
                    new FileInputStream(screenshotFile),
                    XWPFDocument.PICTURE_TYPE_PNG,
                    screenshotFile.getName(),
                    Units.toEMU(500), // Width in EMUs
                    Units.toEMU(300)  // Height in EMUs
                );
            }
        } catch (Exception e) {
            System.out.println("Error adding screenshot to Word document for URL: " + url);
            e.printStackTrace();
        }
    }
}


---

Explanation:

1. Take Screenshots:

The takeScreenshot method captures a screenshot using Selenium and saves it as a PNG file.



2. Create a Word Document:

The program creates an instance of XWPFDocument to represent the Word document.



3. Add Screenshots to Word:

The addScreenshotToWord method adds a heading with the URL and embeds the screenshot below it.



4. Save the Document:

At the end of the process, the document is saved as WSDL_Screenshots.docx.





---

Steps to Run:

1. Set Up WebDriver:

Ensure you have the correct WebDriver for your browser.



2. Compile and Run:

Compile:

javac -cp .:selenium-java-4.x.x.jar:poi-ooxml-5.x.x.jar WsdlScreenshotToWord.java

Run:

java -cp .:selenium-java-4.x.x.jar:poi-ooxml-5.x.x.jar WsdlScreenshotToWord



3. Output:

The Word file WSDL_Screenshots.docx will contain screenshots for each URL.





---

Example Word Output:

Page 1:

Screenshot for URL: https://example.com/wsdl1
[Screenshot Image]

Page 2:

Screenshot for URL: https://example.com/wsdl2
[Screenshot Image]


Let me k

