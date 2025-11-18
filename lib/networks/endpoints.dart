// ignore_for_file: constant_identifier_names, unnecessary_string_interpolations

// const String url = String.fromEnvironment("BASE_URL");
const String url = "https://admin.dolcereset.com/api";
// ignore: unnecessary_brace_in_string_interps
const String imageUrl = "${url}";

final class NetworkConstants {
  NetworkConstants._();
  static const ACCEPT = "Accept";
  static const APP_KEY = "App-Key";
  static const ACCEPT_LANGUAGE = "Accept-Language";
  static const ACCEPT_LANGUAGE_VALUE = "pt";
  static const APP_KEY_VALUE = String.fromEnvironment("APP_KEY_VALUE");
  static const ACCEPT_TYPE = "application/json";
  static const AUTHORIZATION = "Authorization";
  static const CONTENT_TYPE = "content-Type";
}

final class Endpoints {
  Endpoints._();
  //backend_url
  //New
  static String signUp() => "/register";
  static String signUpEmailVerify() => "/verify-email";
  static String signUpResendOtp() => "/resend-otp";
  static String signIn() => "/login";
  static String forgetPassword() => "/forget-password";
  static String forgetPasswordOtp() => "/otp-token";
  static String resetPassword() => "/reset-password";
  static String logout() => "/logout";

  // onboading
  static String onboardUserInfo() => "/user/info";

  // Excercise  Screen

  static String category({String? search}) {
    if (search != null && search.isNotEmpty) {
      return "/category?search=$search";
    }
    return "/category";
  }

  static String categoryWiseTheme({
    int? categoryId,
    String? type,
    String? search,
  }) {
    String endpoint = "/category_wise_themes";
    List<String> queryParams = [];

    if (categoryId != null) {
      queryParams.add("category_id=$categoryId");
    }
    if (type != null && type.isNotEmpty) {
      queryParams.add("type=$type");
    }

    if (search != null && search.isNotEmpty) {
      queryParams.add("name=$search");
    }

    if (queryParams.isNotEmpty) {
      endpoint += "?${queryParams.join("&")}";
    }
    return endpoint;
  }

  static String themeWiseVideo({required int themeId}) =>
      "/themes_wise_video/$themeId";
}
