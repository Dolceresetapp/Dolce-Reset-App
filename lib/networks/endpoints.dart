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
  static String reviews() => "/reviews";

  // onboading
  static String onboardUserInfo() => "/user/info";

  // Excercise  Screen

  static String category({String? search}) {
    if (search != null && search.isNotEmpty) {
      return "/category?search=$search";
    }
    return "/category";
  }

  static String theme({String? search}) {
    if (search != null && search.isNotEmpty) {
      return "/themes?search=$search";
    }
    return "/themes";
  }

  static String dynamicWorkout({String? type, int? id, String? levelType}) {
    if (type == "body_part_exercise" && id != null) {
      return "/categoryWiseWorkouts/$id";
    } else if (type == "theme_workout" && id != null) {
      return "/themeWiseWorkouts/$id";
    } else if (type == "training_level" && levelType != null) {
      return "/trainingLevelWiseWorkouts?type=$levelType";
    } else {
      return "";
    }
  }

  static String themeWiseVideo({required int themeId}) =>
      "/themes_wise_video/$themeId";

  static String workoutVideo({required int id}) => "/workoutWiseVideos/$id";
  static String myWorkout() => "/work_out_list";
  static String plan() => "/plans/app";
   static String paymentSheet() => "/payment/stripe/app/checkout";

    static String subscription() => "/payment/stripe/app/trail";

        static String activeWorkoutSave() => "/active_workouts/save";
}
// https://admin.dolcereset.com/api/work_out_list