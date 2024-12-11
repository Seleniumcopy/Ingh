import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.apache.poi.xwpf.usermodel.XWPFParagraph;
import org.apache.poi.xwpf.usermodel.XWPFRun;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;

import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileOutputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.imageio.ImageIO;

public class WsdlScreenshotToWord {

    public static void main(String[] args) {
        // List of WSDL URLs to visit
        List<String> wsdlUrls = List.of(
            "https://sit1a.example.com/wsdl1",
            "https://sit1b.example.com/wsdl2",
            "https://sit1a.example.com/wsdl3"
        );

        // Set up WebDriver (ensure you have ChromeDriver in PATH)
        System.setProperty("webdriver.chrome.driver", "/path/to/chromedriver");
        WebDriver driver = new ChromeDriver();

        try {
            for (String url : wsdlUrls) {
                driver.get(url);

                // Wait for the page to load
                Thread.sleep(3000);

                // Extract environment and WSDL name from URL
                String environment = extractEnvironment(url);
                String wsdlName = extractWsdlName(url);

                // Take screenshot of the full screen using Robot
                File screenshotFile = takeScreenshotWithRobot(environment, wsdlName);

                // Create a Word document with the screenshot
                createWordDocument(environment, wsdlName, screenshotFile);

                System.out.println("Document created for: " + url);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // Close the browser
            driver.quit();
        }
    }

    /**
     * Extracts the environment (e.g., sit1a, sit1b) from the URL.
     */
    public static String extractEnvironment(String url) {
        return url.split("\\.")[0].replace("https://", "");
    }

    /**
     * Extracts the WSDL name from the URL.
     */
    public static String extractWsdlName(String url) {
        return url.substring(url.lastIndexOf("/") + 1).replace(".wsdl", "");
    }

    /**
     * Takes a screenshot of the full screen using Robot and saves it as a file.
     */
    public static File takeScreenshotWithRobot(String environment, String wsdlName) throws Exception {
        // Capture the full screen
        Robot robot = new Robot();
        Rectangle screenRect = new Rectangle(Toolkit.getDefaultToolkit().getScreenSize());
        BufferedImage screenCapture = robot.createScreenCapture(screenRect);

        // Generate filename with environment and WSDL name
        String timestamp = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
        String fileName = environment + "_" + wsdlName + "_" + timestamp + ".png";

        // Save the screenshot to the screenshots/ directory
        File screenshotFile = new File("./screenshots/" + fileName);
        screenshotFile.getParentFile().mkdirs(); // Ensure directory exists
        ImageIO.write(screenCapture, "png", screenshotFile);

        System.out.println("Screenshot saved as: " + screenshotFile.getAbsolutePath());
        return screenshotFile;
    }

    /**
     * Creates a Word document and inserts the screenshot.
     */
    public static void createWordDocument(String environment, String wsdlName, File screenshotFile) throws Exception {
        // Create a new Word document
        XWPFDocument document = new XWPFDocument();

        // Add a title paragraph
        XWPFParagraph title = document.createParagraph();
        XWPFRun titleRun = title.createRun();
        titleRun.setBold(true);
        titleRun.setFontSize(14);
        titleRun.setText("Environment: " + environment + " | WSDL: " + wsdlName);
        titleRun.addBreak();

        // Add the screenshot image
        XWPFParagraph imageParagraph = document.createParagraph();
        XWPFRun imageRun = imageParagraph.createRun();
        imageRun.addPicture(
            new FileInputStream(screenshotFile),
            XWPFDocument.PICTURE_TYPE_PNG,
            screenshotFile.getName(),
            Units.toEMU(500), // Width in EMUs
            Units.toEMU(300)  // Height in EMUs
        );

        // Generate Word document filename
        String docFileName = "./documents/" + environment + "_" + wsdlName + ".docx";
        File wordFile = new File(docFileName);
        wordFile.getParentFile().mkdirs(); // Ensure directory exists

        // Save the Word document
        try (FileOutputStream out = new FileOutputStream(wordFile)) {
            document.write(out);
        }

        System.out.println("Word document saved as: " + wordFile.getAbsolutePath());
    }
}