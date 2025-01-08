public static boolean isJSONvalueEqualToExpectedStringInArray(String responseJsonPath, String expectedValue) {
    
    
    // Read the array of error details
    List<String> errorDescriptions = JsonPath.read(responseJson, responseJsonPath);

    // Check if any errorDesc matches the expected value
    boolean matchFound = errorDescriptions.stream().anyMatch(desc -> desc.equals(expectedValue));

    if (matchFound) {
        logger.info("Actual Response matches the expected response: " + expectedValue);
        return true;
    } else {
        logger.error("Expected value: " + expectedValue + " was not found in errorDetailsList");
        Assert.fail("Test failed: Expected value not found in the response");
        return false;
    }
}