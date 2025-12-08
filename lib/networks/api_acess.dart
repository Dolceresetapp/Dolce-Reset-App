import 'package:gritti_app/features/excerises/data/rx_get_category/model/category_response_model.dart';
import 'package:gritti_app/features/excerises/data/rx_get_category/rx.dart';
import 'package:gritti_app/features/settings/data/model/logout_response_model.dart';
import 'package:rxdart/subjects.dart';

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
import '../features/authentication/signup_otp/data/rx_post_sign_up_otp/model/signup_otp_response_model.dart';
import '../features/authentication/signup_otp/data/rx_post_sign_up_otp/rx.dart';
import '../features/authentication/signup_otp/data/rx_post_sign_up_otp_resend/rx.dart';
import '../features/dynamic_workout/data/model/dynamic_workout_response_model.dart';
import '../features/dynamic_workout/data/rx_get/rx.dart';
import '../features/excerises/data/rx_get_my_workout/model/my_workout_response_model.dart';
import '../features/excerises/data/rx_get_my_workout/rx.dart';
import '../features/excerises/data/rx_get_theme/model/theme_response_model.dart';
import '../features/excerises/data/rx_get_theme/rx.dart';
import '../features/exercise_video/data/model/workour_save_response_model.dart';
import '../features/exercise_video/data/rx_post_sign_in/rx.dart';
import '../features/onboarding/data/model/onboarding_response_model.dart';
import '../features/onboarding/data/rx_post_onboard/rx.dart';
import '../features/onboarding/presentation/chef_boarding/data/model/chef_response_model.dart';
import '../features/onboarding/presentation/chef_boarding/data/rx_post_chef/rx.dart';
import '../features/rating/data/model/rating_response_model.dart';
import '../features/rating/data/rx_get_rating/rx.dart';
import '../features/ready/data/model/workout_video_response_model.dart';
import '../features/ready/data/rx_get/rx.dart';
import '../features/settings/data/rx_post_logout/rx.dart';
import '../features/trial_continue/data/rx_get_plan/model/plan_response_model.dart';
import '../features/trial_continue/data/rx_get_plan/rx.dart';
import '../features/trial_continue/data/rx_post_confirn_subscription/model/confirm_subscription_response_model.dart';
import '../features/trial_continue/data/rx_post_confirn_subscription/rx.dart';
import '../features/trial_continue/data/rx_post_payment_sheet/model/payment_sheet_response_model.dart';
import '../features/trial_continue/data/rx_post_payment_sheet/rx.dart';
import '../features/trial_continue/data/rx_post_subscription/model/subscription_response_model.dart';
import '../features/trial_continue/data/rx_post_subscription/rx.dart';
import '../features/video/data/model/theme_wise_video_response_model.dart';
import '../features/video/data/rx_get_video/rx.dart';

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
ThemeWiseVideoRx themeWiseVideoRxObj = ThemeWiseVideoRx(
  empty: ThemeWiseVideoResponseModel(),
  dataFetcher: BehaviorSubject<ThemeWiseVideoResponseModel>(),
);

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
  empty: SignupResendOtpResponseModel(),
  dataFetcher: BehaviorSubject<SignupResendOtpResponseModel>(),
);

SignupResendOtpRx signupResendOtpRxObj = SignupResendOtpRx(
  empty: SignupResendOtpResponseModel(),
  dataFetcher: BehaviorSubject<SignupResendOtpResponseModel>(),
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
