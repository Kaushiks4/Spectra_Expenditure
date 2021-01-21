class Encrypt {
  static String encodeString(String string) {
    return string.replaceAll("#", "%");
  }

  static String decodeString(String string) {
    return string.replaceAll("%", "#");
  }
}
