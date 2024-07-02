/// A utility class providing various helper methods.
class Utils {
  /// Checks if the given string is in URL format.
  ///
  /// Returns true if the [data] contains "http://" or "https://", false otherwise.
  ///
  /// Example:
  /// ```dart
  /// bool result = Utils.isUrlFormat("https://example.com");
  /// print(result); // true
  /// ```
  ///
  /// - Parameters:
  ///   - data: The string to be checked for URL format.
  /// - Returns: A boolean indicating if the string is a URL.
  static isUrlFormat(String data) {
    if (data.contains("http://") || data.contains("https://")) {
      return true;
    } else {
      return false;
    }
  }
}
