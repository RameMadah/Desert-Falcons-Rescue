class EndPoints {
  static String baseURL = "http://159.89.175.218/";

  static String get login => baseURL + "auth/local";

  static String get rescuerRegister => login + "/register";

  static String get uploadAttachments => baseURL + "upload/";
}
