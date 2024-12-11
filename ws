


---

Java Code for Validating WSDL via URL

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import org.w3c.dom.*;
import java.util.Arrays;
import java.util.List;

public class WsdlValidator {

    public static void main(String[] args) {
        // List of WSDL URLs
        List<String> wsdlUrls = Arrays.asList(
            "https://example.com/wsdl1",
            "https://example.com/wsdl2",
            "https://example.com/wsdl3"
        );

        // List of statuses to check under CompanyStatus
        List<String> expectedStatuses = Arrays.asList(
            
        );

        for (String wsdlUrl : wsdlUrls) {
            validateWsdl(wsdlUrl, expectedStatuses);
        }
    }

    public static void validateWsdl(String wsdlUrl, List<String> expectedStatuses) {
        try {
            // Fetch WSDL content from the URL
            String wsdlContent = fetchWsdl(wsdlUrl);

            // Parse the WSDL content
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            factory.setNamespaceAware(true); // Enable namespace handling
            DocumentBuilder builder = factory.newDocumentBuilder();
            Document document = builder.parse(new java.io.ByteArrayInputStream(wsdlContent.getBytes()));

            // Get the "CompanyStatus" simpleType
            NodeList simpleTypes = document.getElementsByTagName("xs:simpleType");
            boolean allStatusesFound = true;

            for (int i = 0; i < simpleTypes.getLength(); i++) {
                Element simpleType = (Element) simpleTypes.item(i);
                if ("CompanyStatus".equals(simpleType.getAttribute("name"))) {
                    // Check the enumerations under "CompanyStatus"
                    NodeList enumerations = simpleType.getElementsByTagName("xs:enumeration");

                    // Keep track of statuses found
                    for (String status : expectedStatuses) {
                        boolean statusFound = false;
                        for (int j = 0; j < enumerations.getLength(); j++) {
                            Element enumeration = (Element) enumerations.item(j);
                            if (status.equals(enumeration.getAttribute("value"))) {
                                statusFound = true;
                                break;
                            }
                        }

                        // If any status is missing, mark it as not found
                        if (!statusFound) {
                            allStatusesFound = false;
                            System.out.println(wsdlUrl + ": Status '" + status + "' not found.");
                        }
                    }

                    break; // Exit after finding and processing "CompanyStatus"
                }
            }

            // Print result for the WSDL
            if (allStatusesFound) {
                System.out.println(wsdlUrl + ": All statuses found.");
            }

        } catch (Exception e) {
            System.out.println(wsdlUrl + ": Error - " + e.getMessage());
        }
    }

    public static String fetchWsdl(String wsdlUrl) throws Exception {
        StringBuilder result = new StringBuilder();
        URL url = new URL(wsdlUrl);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");

        try (BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()))) {
            String line;
            while ((line = reader.readLine()) != null) {
                result.append(line);
            }
        }

        return result.toString();
    }
}


---


3

