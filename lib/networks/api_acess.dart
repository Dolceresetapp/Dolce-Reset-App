import 'package:gritti_app/features/excerises/data/rx_get_category/model/category_response_model.dart';
import 'package:gritti_app/features/excerises/data/rx_get_category/rx.dart';
import 'package:gritti_app/features/settings/data/model/logout_response_model.dart';
import 'package:rxdart/subjects.dart';

import '../features/ai_coach/data/model/coach_response_model.dart';
import '../features/ai_coach/data/rx_post_ai_coach/rx.dart';
import '../features/ai_recipe_generator/data/model/ai_generate_response_model.dart';
import '../features/ai_recipe_generator/data/rx_post_generate/rx.dart';
import '../features/authentication/forget_otp/data/model/forget_password_otp_response_model.dart';
import '../features/authentication/forget_otp/data/rx_post_forget_password_otp/rx.dart';
import '../features/authentication/forget_password/data/model/forget_password_response_model.dart';
import '../features/authentication/forget_password/data/rx_post_forget_password/rx.dart';
import '../features/authentication/reset_password/data/model/reset_password_response_model.dart';
import '../features/authentication/reset_password/data/rx_post_reset_password/rx.dart';
import '../features/authentication/sign_up/data/model/sign_up_response_model.dart';
import '../features/authentication/sign_up/data/rx_post_sign_up/rx.dart';
import '../features/authentication/signin/data/model/sign_in_response_model.dart';
import '../features/authentication/signin/data/rx_post_sign_in/rx.dart';
import '../features/authentication/signup_otp/data/rx_post_sign_up_otp/model/signup_otp_verify_response_model.dart';
import '../features/authentication/signup_otp/data/rx_post_sign_up_otp/rx.dart';
import '../features/authentication/signup_otp/data/rx_post_sign_up_otp_resend/rx.dart';
import '../features/barcode/data/model/scan_response_model.dart';
import '../features/barcode/data/rx_get_/rx.dart';
import '../features/chef/data/model/ai_receipe_response_model.dart';
import '../features/chef/data/rx_get_receipe/rx.dart';
import '../features/dynamic_workout/data/model/dynamic_workout_response_model.dart';
import '../features/dynamic_workout/data/rx_get/rx.dart';
import '../features/excerises/data/rx_get_my_workout/model/my_workout_response_model.dart';
import '../features/excerises/data/rx_get_my_workout/rx.dart';
import '../features/excerises/data/rx_get_theme/model/theme_response_model.dart';
import '../features/excerises/data/rx_get_theme/rx.dart';
import '../features/exercise_video/data/model/workour_save_response_model.dart';
import '../features/exercise_video/data/rx_post_sign_in/rx.dart';
import '../features/meal_result/data/model/meal_result_response_model.dart';
import '../features/meal_result/data/rx_post_meal/rx.dart';
import '../features/onboarding/data/model/onboarding_response_model.dart';
import '../features/onboarding/data/rx_post_onboard/rx.dart';
import '../features/onboarding/presentation/chef_boarding/data/model/chef_response_model.dart';
import '../features/onboarding/presentation/chef_boarding/data/rx_post_chef/rx.dart';
import '../features/rating/data/model/rating_response_model.dart';
import '../features/rating/data/rx_get_rating/rx.dart';
import '../features/ready/data/model/workout_video_response_model.dart';
import '../features/ready/data/rx_get/rx.dart';
import '../features/settings/data/rx_post_logout/rx.dart';
import '../features/settings/data/rx_update_profile/rx.dart';
import '../features/settings/data/rx_change_password/rx.dart';
import '../features/settings/data/rx_faq/rx.dart';
import '../features/settings/data/rx_units_metrics/rx.dart';
import '../features/settings/data/rx_delete_account/rx.dart';
import '../features/settings/data/rx_update_avatar/rx.dart';
import '../features/settings/data/rx_wellness_goals/rx.dart';
import '../features/settings/data/rx_subscription/rx.dart' show SubscriptionManagementRx;
import '../features/trial_continue/data/rx_get_plan/model/plan_response_model.dart';
import '../features/trial_continue/data/rx_get_plan/rx.dart';
import '../features/trial_continue/data/rx_post_confirn_subscription/model/confirm_subscription_response_model.dart';
import '../features/trial_continue/data/rx_post_confirn_subscription/rx.dart';
import '../features/trial_continue/data/rx_post_payment_sheet/model/payment_sheet_response_model.dart';
import '../features/trial_continue/data/rx_post_payment_sheet/rx.dart';
import '../features/trial_continue/data/rx_post_subscription/model/subscription_response_model.dart';
import '../features/trial_continue/data/rx_post_subscription/rx.dart';
//

// ScanBarcodeRx scanBarcodeRxObj = ScanBarcodeRx(
//   empty: ScanResonseModel(),
//   dataFetcher: BehaviorSubject<ScanResonseModel>(),
// );

MealResultRx mealResultRxObj = MealResultRx(
  empty: MealResponseModel(),
  dataFetcher: BehaviorSubject<MealResponseModel>(),
);

ScanBarcodeRx scanBarcodeRxObj = ScanBarcodeRx(
  empty: ScanResonseModel(),
  dataFetcher: BehaviorSubject<ScanResonseModel>(),
);

MotivationCoachRx motivationCoachRxObj = MotivationCoachRx(
  empty: CoachResponseModel(),
  dataFetcher: BehaviorSubject<CoachResponseModel>(),
);

AiGenerateRx aiGenerateRxStreamObj = AiGenerateRx(
  empty: AiGenerateResponseModel(),
  dataFetcher: BehaviorSubject<AiGenerateResponseModel>(),
);

AiReceipeRx aiReceipeRxObj = AiReceipeRx(
  empty: AiReceipeResponseModel(),
  dataFetcher: BehaviorSubject<AiReceipeResponseModel>(),
);

ChefRx chefRxObj = ChefRx(
  empty: ChefResponseModel(),
  dataFetcher: BehaviorSubject<ChefResponseModel>(),
);

ConfirmSubscriptionRx confirmSubscriptionRxObj = ConfirmSubscriptionRx(
  empty: ConfirmSubscriptionResponseModel(),
  dataFetcher: BehaviorSubject<ConfirmSubscriptionResponseModel>(),
);

ActiveWorkoutSaveRx activeWorkoutSaveRxObj = ActiveWorkoutSaveRx(
  empty: ActiveWorkoutResponseModel(),
  dataFetcher: BehaviorSubject<ActiveWorkoutResponseModel>(),
);

SubscriptionRx subscriptionRxObj = SubscriptionRx(
  empty: SubscriptionResponseModel(),
  dataFetcher: BehaviorSubject<SubscriptionResponseModel>(),
);

PaymentmentSheetRx paymentmentSheetRxObj = PaymentmentSheetRx(
  empty: PaymentSheetResponseModel(),
  dataFetcher: BehaviorSubject<PaymentSheetResponseModel>(),
);

PlanRx plannRxObj = PlanRx(
  empty: PlanResponseModel(),
  dataFetcher: BehaviorSubject<PlanResponseModel>(),
);

MyWorkoutRx myWorkoutRxObj = MyWorkoutRx(
  empty: MyWorkoutResponseModel(),
  dataFetcher: BehaviorSubject<MyWorkoutResponseModel>(),
);
WorkoutVideoRx workoutVideoRxObj = WorkoutVideoRx(
  empty: WorkoutWiseVideoResponseModel(),
  dataFetcher: BehaviorSubject<WorkoutWiseVideoResponseModel>(),
);
DynamicWorkoutRx dynamicWorkoutRxObj = DynamicWorkoutRx(
  empty: DynamicWorkoutResponseModel(),
  dataFetcher: BehaviorSubject<DynamicWorkoutResponseModel>(),
);
RatingRx ratingRxObj = RatingRx(
  empty: RatingResponseModel(),
  dataFetcher: BehaviorSubject<RatingResponseModel>(),
);
// ThemeWiseVideoRx themeWiseVideoRxObj = ThemeWiseVideoRx(
//   empty: ThemeWiseVideoResponseModel(),
//   dataFetcher: BehaviorSubject<ThemeWiseVideoResponseModel>(),
// );

ThemeRx themeRxObj = ThemeRx(
  empty: ThemeResponseModel(),
  dataFetcher: BehaviorSubject<ThemeResponseModel>(),
);

CategoryRx categoryRxObj = CategoryRx(
  empty: CategoryResponseModel(),
  dataFetcher: BehaviorSubject<CategoryResponseModel>(),
);

OnboardingRx onboardingRxObj = OnboardingRx(
  empty: OnboardingResponseModel(),
  dataFetcher: BehaviorSubject<OnboardingResponseModel>(),
);

SignupRx signupRxObj = SignupRx(
  empty: SignupResponseModel(),
  dataFetcher: BehaviorSubject<SignupResponseModel>(),
);

SignupOtpRx signupOtpRxObj = SignupOtpRx(
  empty: SignupOtpVerifyResponseModel(),
  dataFetcher: BehaviorSubject<SignupOtpVerifyResponseModel>(),
);

SignupResendOtpRx signupResendOtpRxObj = SignupResendOtpRx(
  empty: SignupOtpVerifyResponseModel(),
  dataFetcher: BehaviorSubject<SignupOtpVerifyResponseModel>(),
);

SignInRx signInRxObj = SignInRx(
  empty: SignInResponseModel(),
  dataFetcher: BehaviorSubject<SignInResponseModel>(),
);

ForgetPasswordRx forgetPasswordRxObj = ForgetPasswordRx(
  empty: ForgetPasswordResponseModel(),
  dataFetcher: BehaviorSubject<ForgetPasswordResponseModel>(),
);

ForgetPasswordOtpRx forgetPasswordOtpRxObj = ForgetPasswordOtpRx(
  empty: ForgetPasswordOtpResponseModel(),
  dataFetcher: BehaviorSubject<ForgetPasswordOtpResponseModel>(),
);

ResetPasswordRx resetPasswordRxObj = ResetPasswordRx(
  empty: ResetPasswordResponseModel(),
  dataFetcher: BehaviorSubject<ResetPasswordResponseModel>(),
);

LogoutRx logoutRxObj = LogoutRx(
  empty: LogoutResponseModel(),
  dataFetcher: BehaviorSubject<LogoutResponseModel>(),
);

// Settings
UpdateProfileRx updateProfileRxObj = UpdateProfileRx();
UpdateAvatarRx updateAvatarRxObj = UpdateAvatarRx();
ChangePasswordRx changePasswordRxObj = ChangePasswordRx();
FaqRx faqRxObj = FaqRx();
UnitsMetricsRx unitsMetricsRxObj = UnitsMetricsRx();
DeleteAccountRx deleteAccountRxObj = DeleteAccountRx();
WellnessGoalsRx wellnessGoalsRxObj = WellnessGoalsRx();
SubscriptionManagementRx subscriptionManagementRxObj = SubscriptionManagementRx();
