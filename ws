

import java.io.File;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import org.w3c.dom.*;
import java.util.Arrays;
import java.util.List;

public class WsdlValidator {

    public static void main(String[] args) {
        // Path to the directory containing WSDL files
        String wsdlDirectoryPath = "/path/to/wsdl/files";
        File wsdlDirectory = new File(wsdlDirectoryPath);

        if (!wsdlDirectory.isDirectory()) {
            System.out.println("Invalid directory path!");
            return;
        }

        // List of statuses to check under CompanyStatus
        List<String> expectedStatuses = Arrays.asList(
                
        );

        // Process each WSDL file in the directory
        File[] wsdlFiles = wsdlDirectory.listFiles((dir, name) -> name.endsWith(".wsdl"));
        if (wsdlFiles != null) {
            for (File wsdlFile : wsdlFiles) {
                validateWsdl(wsdlFile, expectedStatuses);
            }
        } else {
            System.out.println("No WSDL files found in the directory.");
        }
    }

    public static void validateWsdl(File wsdlFile, List<String> expectedStatuses) {
        try {
            // Parse the WSDL file
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            factory.setNamespaceAware(true); // Enable namespace handling
            DocumentBuilder builder = factory.newDocumentBuilder();
            Document document = builder.parse(wsdlFile);

            // Get the "CompanyStatus" simpleType
            NodeList simpleTypes = document.getElementsByTagName("xs:simpleType");
            boolean allStatusesFound = true;

            for (int i = 0; i < simpleTypes.getLength(); i++) {
                Element simpleType = (Element) simpleTypes.item(i);
                if ("co".equals(simpleType.getAttribute("name"))) {
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
                            System.out.println(wsdlFile.getName() + ": Status '" + status + "' not found.");
                        }
                    }

                    break; // Exit after finding and processing "CompanyStatus"
                }
            }

            // Print result for the WSDL
            if (allStatusesFound) {
                System.out.println(wsdlFile.getName() + ": All statuses found.");
            }

        } catch (Exception e) {
            System.out.println(wsdlFile.getName() + ": Error - " + e.getMessage());
        }
    }
}


---

Changes Made

1. List of Expected Statuses:

Defined a list of multiple statuses (expectedStatuses) to validate under CompanyStatus. Add as many statuses as required:

List<String> expectedStatuses = Arrays.asList(
        "PROSPECT_ACTIVE",
        "PROSPECT_DEACTIVATE",
        "PROSPECT_DELETED",
        "ACTIVE",
        "DEACTIVATE"
);



2. Iterate Over All Expected Statuses:

The program checks each expected status in expectedStatuses to ensure all are present.



3. Report Missing Statuses:

If a status is missing in a WSDL file, the program logs it





---

Running the Program

1. Compile and Run:

Save the updated code as WsdlValidator.java.

Compile it:

javac WsdlValidator.java

Run it:

java WsdlValidator



2. Output:

The program will display whether all expected statuses are present in each WSDL file, or list the missing statuses.





---



