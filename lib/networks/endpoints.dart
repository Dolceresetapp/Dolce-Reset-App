// ignore_for_file: constant_identifier_names, unnecessary_string_interpolations

// const String url = String.fromEnvironment("BASE_URL");
const String url = "https://poswell.app";
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

// final class PaymentGateway {
//   PaymentGateway._();
//   static String gateway(String orderId) =>  "https://demo.vivapayments.com/web/checkout?ref={$orderId}";
// }

final class Endpoints {
  Endpoints._();
  //backend_url
  //New
  static String signUp() => "/api/register";
  static String logIn() => "/api/login";
  static String logout() => "/api/logout";
  static String getBabyProfile() => "/api/baby/profile/show";
  static String getProfile() => "/api/user/data";
  static String getCourseModules(String id) => "/api/course/module/$id";
  static String getCourseArticle(String id) => "/api/course/article/$id";
  static String getDailyReadArticle(String id) => "/api/course/daily-read/article/$id";
  static String getAllCourses() => "/api/courses";
  static String getRecommendedCourses() => "/api/recommend/course";
  static String addBabyProfile() => "/api/baby/profile/store";
  static String updateBabyProfile(String id) => "/api/baby/profile/update/$id";
  static String updateProfile() => "/api/update-profile";
  static String getMyCloset() => "/api/user/clothing/show";
  static String addCloset() => "/api/user/clothing/store";
  static String forgotPassword() => "/api/forgot-password";
  static String setPassword() => "/api/reset-password";
  static String verifyOtp() => "/api/verify-otp";
  static String registrationOtpVerify() => "/api/verify/registration";
  static String getAvaiableItems(int temp) => "/api/clothing/filter?temperature=$temp";
  static String getAdvices(String perams) => "/api/clothing/select?$perams";


  // course
  static String courseType() => "/api/course/types";
  static String survey(int id) => "/api/survay/questions/$id";
  static String postsurvey(int id) => "/api/survay/questions/answer/store/$id";
  static String surveyMark(int id) => "/api/survay/marks/$id";
  static String recomendedCourse() => "/api/recommend/course";


  //article
    static String getBookmark() => "/api/bookmarks";
    static String getSingleArticle(int id) => "/api/course/single-article/$id";



}
