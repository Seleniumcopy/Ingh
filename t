
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

if ("timestamp".equalsIgnoreCase(expectedValue)) {
    if (actualValue == null) {
        throw new AssertionError("Expected a timestamp, but found NULL in column '" + columnName + "'");
    }

    String formattedTimestamp;

    if (actualValue instanceof Timestamp) {
        // Convert to LocalDateTime
        LocalDateTime localDateTime = ((Timestamp) actualValue).toLocalDateTime();

        // Use Java's default format (similar to what you see in logs)
        DateTimeFormatter defaultFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSS");

        // Format timestamp
        formattedTimestamp = localDateTime.format(defaultFormatter);
    } else {
        formattedTimestamp = actualValue.toString().trim();
    }

    System.out.println("Formatted Timestamp: " + formattedTimestamp);

    // Validate by parsing it using the same format
    try {
        LocalDateTime.parse(formattedTimestamp, defaultFormatter);
    } catch (Exception e) {
        throw new AssertionError("Column '" + columnName + "' does not contain a valid timestamp: " + actualValue);
    }
}


-
y


