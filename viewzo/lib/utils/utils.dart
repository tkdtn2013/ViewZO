class Utils {
  static isUrlFormat(String data) {
    if (data.contains("http://") || data.contains("https://")) {
      return true;
    } else {
      return false;
    }
  }
}