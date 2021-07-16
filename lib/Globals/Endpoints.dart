class EndPoints {
  static String baseURL = "http://159.89.175.218/";

  static String get login => baseURL + "auth/local";

  static String get rescuerRegister => login + "/register";

  static String get uploadAttachments => baseURL + "upload/";

  static String get helpRequest => baseURL + "help-requests";

  static String get saveToken => "https://push.falconsdesert.com/saveToken";

  static String helpRequests(String? phoneNumber) {
    if (phoneNumber == null) {
      return baseURL + "help-requests";
    } else {
      return baseURL + "help-requests?RequeterMobile=$phoneNumber";
    }
  }

  static String checkoutRequest(int requestID) =>
      baseURL + "help-requests/$requestID";

  static String areasRequest = "http://falconsdesert.com/request-areas";

  static String removeToken(String id) =>
      "https://push.falconsdesert.com/removeToken/$id";
}
