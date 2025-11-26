import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../features/ai_recipe_generator/presentation/ai_recipe_generator_screen.dart';
import '../features/ai_recipe_generator_chat/presentation/ai_receipe_generator_chat_screen.dart';
import '../features/authentication/forget_otp/forget_otp_screen.dart';
import '../features/authentication/forget_password/forget_passwod._screen.dart';
import '../features/authentication/reset_password/reset_password_screen.dart';
import '../features/authentication/sign_up/sign_up_screen.dart';
import '../features/authentication/signin/sign_in_screen.dart';
import '../features/authentication/signup_otp/signup_otp_screen.dart';
import '../features/cusom_plan_ready/custom_plan_ready_screen.dart';
import '../features/download_countdown/download_countdown_screen.dart';
import '../features/download_progress/download_progress_screen.dart';
import '../features/dynamic_workout/dynamic_workout_screen.dart';
import '../features/exercise_see/exercise_see_screen.dart';
import '../features/exercise_video/exercise_video_screen.dart';
import '../features/food_analyzer/food_analyzer_screen.dart';
import '../features/free_trial/free_trial_screen.dart';
import '../features/get_started/get_started_screen.dart';
import '../features/great_job/great_job_screen.dart';
import '../features/meal_result/meal_result_screen.dart';
import '../features/onboarding/presentation/chef_boarding/chef_boarding_1_screen.dart';
import '../features/onboarding/presentation/chef_boarding/chef_boarding_2_screen.dart';
import '../features/onboarding/presentation/chef_boarding/chef_boarding_3_screen.dart';
import '../features/onboarding/presentation/chef_boarding/chef_boarding_4_screen.dart';
import '../features/onboarding/presentation/chef_boarding/chef_boarding_5_screen.dart';
import '../features/onboarding/presentation/onboarding_screen_1.dart';
import '../features/onboarding/presentation/onboarding_screen_10.dart';
import '../features/onboarding/presentation/onboarding_screen_11.dart';
import '../features/onboarding/presentation/onboarding_screen_12.dart';
import '../features/onboarding/presentation/onboarding_screen_13.dart';
import '../features/onboarding/presentation/onboarding_screen_14.dart';
import '../features/onboarding/presentation/onboarding_screen_15.dart';
import '../features/onboarding/presentation/onboarding_screen_16.dart';
import '../features/onboarding/presentation/onboarding_screen_17.dart';
import '../features/onboarding/presentation/onboarding_screen_2.dart';
import '../features/onboarding/presentation/onboarding_screen_4.dart';
import '../features/onboarding/presentation/onboarding_screen_5.dart';
import '../features/onboarding/presentation/onboarding_screen_7.dart';
import '../features/onboarding/presentation/onboarding_screen_8.dart';
import '../features/onboarding/presentation/onboarding_screen_9.dart';
import '../features/onboarding/presentation/one_time_onboarding/onboard_screen_1.dart';
import '../features/payment_free/payment_free_screen.dart';
import '../features/plan_ready/plan_ready_screen.dart';
import '../features/rating/rating_screen.dart';
import '../features/rewiring_benefits/rewiring_benefit_screen.dart';
import '../features/trial_continue/presentation/trial_continue_screen.dart';
import '../features/video/video_screen.dart';
import '../loading.dart';
import '../navigation_screen.dart';

final class Routes {
  static final Routes _routes = Routes._internal();
  Routes._internal();
  static Routes get instance => _routes;

  static const String loadingScreen = '/Loading';

  static const String signUpScreen = '/signUpScreen';

  static const String signInScreen = '/signInScreen';

  static const String resetPasswordScreen = '/resetPasswordScreen';

  static const String signupOtpScreen = '/signupOtpScreen';

  static const String forgetOtpScreen = '/forgetOtpScreen';

  static const String onboardingScreen2 = '/onboardingScreen2';

  static const String onboardingScreen4 = '/onboardingScreen4';

  static const String onboardingScreen5 = '/onboardingScreen5';

  static const String onboardingScreen7 = '/onboardingScreen7';

  static const String onboardingScreen1 = '/onboardingScreen1';

  static const String forgetPasswordScreen = '/forgetPasswordScreen';

  static const String onboardingScreen8 = '/onboardingScreen8';

  static const String onboardingScreen9 = '/onboardingScreen9';

  static const String onboardingScreen12 = '/onboardingScreen12';
  static const String onboardingScreen11 = '/onboardingScreen11';

  static const String onboardingScreen10 = '/onboardingScreen10';

  static const String onboardingScreen13 = '/onboardingScreen13';

  static const String onboardingScreen14 = '/onboardingScreen14';

  static const String onboardingScreen15 = '/onboardingScreen15';

  static const String onboardingScreen16 = '/onboardingScreen16';

  static const String onboardingScreen17 = '/onboardingScreen17';

  static const String getStartedScreen = '/getStartedScreen';

  static const String chefBoardingScreen1 = '/chefBoardingScreen1';
  static const String chefBoardingScreen2 = '/chefBoardingScreen2';
  static const String chefBoardingScreen3 = '/chefBoardingScreen3';
  static const String chefBoardingScreen4 = '/chefBoardingScreen4';
  static const String chefBoardingScreen5 = '/chefBoardingScreen5';

  static const String foodAnalyzerScreen = '/foodAnalyzerScreen';

  static const String mealResultScreen = '/mealResultScreen';

  static const String greatJobScreen = '/greatJobScreen';
  static const String aiReceipeGeneratorScreen = '/aiReceipeGeneratorScreen';
  static const String aiReceipeGeneratorChatScreen =
      '/aiReceipeGeneratorChatScreen';

  static const String videoScreen = '/videoScreen';

  static const String downloadProgressScreen = '/downloadProgressScreen';

  static const String downloadCountdownScreen = '/downloadCountdownScreen';

  static const String exerciseVideoScreen = '/exerciseVideoScreen';

  static const String navigationScreen = '/navigationScreen';

  static const String oneTimeOnboardingScreen = '/oneTimeOnboardingScreen';

  static const String exceriseSeeScreen = '/exceriseSeeScreen';
  static const String rewiringBenefitScreen = '/rewiringBenefitScreen';
  static const String ratingScreen = '/ratingScreen';
  static const String planReadyScreen = '/planReadyScreen';
  static const String customPlanReadyScreen = '/customPlanReadyScreen';
  static const String paymentFreeScreen = '/paymentFreeScreen';
  static const String freeTrialScreen = '/freeTrialScreen';
  static const String trialContinueScreen = '/trialContinueScreen';
  static const String dynamicWorkoutScreen = '/dynamicWorkoutScreen';
}

//
final class RouteGenerator {
  static final RouteGenerator _routeGenerator = RouteGenerator._internal();
  RouteGenerator._internal();
  static RouteGenerator get instanc => _routeGenerator;

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.trialContinueScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
              widget: TrialContinueScreen(),
              settings: settings,
            )
            : CupertinoPageRoute(builder: (context) => TrialContinueScreen());
      case Routes.freeTrialScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
              widget: FreeTrialScreen(),
              settings: settings,
            )
            : CupertinoPageRoute(builder: (context) => FreeTrialScreen());
      case Routes.paymentFreeScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
              widget: PaymentFreeScreen(),
              settings: settings,
            )
            : CupertinoPageRoute(builder: (context) => PaymentFreeScreen());
      case Routes.customPlanReadyScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
              widget: CustomPlanReadyScreen(),
              settings: settings,
            )
            : CupertinoPageRoute(builder: (context) => CustomPlanReadyScreen());
      case Routes.planReadyScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
              widget: PlanReadyScreen(),
              settings: settings,
            )
            : CupertinoPageRoute(builder: (context) => PlanReadyScreen());
      case Routes.ratingScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(widget: RatingScreen(), settings: settings)
            : CupertinoPageRoute(builder: (context) => RatingScreen());
      case Routes.rewiringBenefitScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
              widget: RewiringBenefitScreen(),
              settings: settings,
            )
            : CupertinoPageRoute(builder: (context) => RewiringBenefitScreen());
      case Routes.dynamicWorkoutScreen:
        final args = settings.arguments as Map;
        return Platform.isAndroid
            ? _FadedTransitionRoute(
              widget: DynamicWorkoutScreen(
                type: args["type"],

                id: args["id"],
                levelType: args["levelType"],
              ),
              settings: settings,
            )
            : CupertinoPageRoute(
              builder:
                  (context) => DynamicWorkoutScreen(
                    type: args["type"],

                    id: args["id"],
                    levelType: args["levelType"],
                  ),
            );
      case Routes.exceriseSeeScreen:
        final args = settings.arguments as Map;
        return Platform.isAndroid
            ? _FadedTransitionRoute(
              widget: ExceriseSeeScreen(
                categoryType: args["categoryType"],

                trainingLevel: args["trainingLevel"],
                type: args["type"],
              ),
              settings: settings,
            )
            : CupertinoPageRoute(
              builder:
                  (context) => ExceriseSeeScreen(
                    categoryType: args["categoryType"],

                    trainingLevel: args["trainingLevel"],
                    type: args["type"],
                  ),
            );

      case Routes.navigationScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
              widget: const NavigationScreen(),
              settings: settings,
            )
            : CupertinoPageRoute(
              builder: (context) => const NavigationScreen(),
            );

      case Routes.exerciseVideoScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
              widget: const ExerciseVideoScreen(),
              settings: settings,
            )
            : CupertinoPageRoute(
              builder: (context) => const ExerciseVideoScreen(),
            );

      case Routes.downloadCountdownScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
              widget: const DownloadCountdownScreen(),
              settings: settings,
            )
            : CupertinoPageRoute(
              builder: (context) => const DownloadCountdownScreen(),
            );

      case Routes.downloadProgressScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
              widget: const DownloadProgressScreen(),
              settings: settings,
            )
            : CupertinoPageRoute(
              builder: (context) => const DownloadProgressScreen(),
            );

      case Routes.videoScreen:
        final args = settings.arguments as Map;
        return Platform.isAndroid
            ? _FadedTransitionRoute(
              widget: VideoScreen(themeId: args["themeId"]),
              settings: settings,
            )
            : CupertinoPageRoute(
              builder: (context) => VideoScreen(themeId: args["themeId"]),
            );

      case Routes.aiReceipeGeneratorChatScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
              widget: const AiReceipeGeneratorChatScreen(),
              settings: settings,
            )
            : CupertinoPageRoute(
              builder: (context) => const AiReceipeGeneratorChatScreen(),
            );

      case Routes.aiReceipeGeneratorScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
              widget: const AiReceipeGeneratorScreen(),
              settings: settings,
            )
            : CupertinoPageRoute(
              builder: (context) => const AiReceipeGeneratorScreen(),
            );

      case Routes.greatJobScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
              widget: const GreatJobScreen(),
              settings: settings,
            )
            : CupertinoPageRoute(builder: (context) => const GreatJobScreen());

      case Routes.mealResultScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
              widget: const MealResultScreen(),
              settings: settings,
            )
            : CupertinoPageRoute(
              builder: (context) => const MealResultScreen(),
            );

      case Routes.foodAnalyzerScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
              widget: const FoodAnalyzerScreen(),
              settings: settings,
            )
            : CupertinoPageRoute(
              builder: (context) => const FoodAnalyzerScreen(),
            );

      case Routes.chefBoardingScreen1:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
              widget: const ChefBoardingScreen1(),
              settings: settings,
            )
            : CupertinoPageRoute(
              builder: (context) => const ChefBoardingScreen1(),
            );

      case Routes.chefBoardingScreen2:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
              widget: const ChefBoardingScreen2(),
              settings: settings,
            )
            : CupertinoPageRoute(
              builder: (context) => const ChefBoardingScreen2(),
            );

      case Routes.chefBoardingScreen3:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
              widget: const ChefBoardingScreen3(),
              settings: settings,
            )
            : CupertinoPageRoute(
              builder: (context) => const ChefBoardingScreen3(),
            );
      case Routes.chefBoardingScreen4:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
              widget: const ChefBoardingScreen4(),
              settings: settings,
            )
            : CupertinoPageRoute(
              builder: (context) => const ChefBoardingScreen4(),
            );

      case Routes.chefBoardingScreen5:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
              widget: const ChefBoardingScreen5(),
              settings: settings,
            )
            : CupertinoPageRoute(
              builder: (context) => const ChefBoardingScreen5(),
            );

      case Routes.getStartedScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
              widget: const GetStartedScreen(),
              settings: settings,
            )
            : CupertinoPageRoute(
              builder: (context) => const GetStartedScreen(),
            );

      case Routes.onboardingScreen17:
        final args = settings.arguments as Map;

        return Platform.isAndroid
            ? _FadedTransitionRoute(
              widget: OnboardingScreen17(
                onboard1: args["onboard1"],
                onboard2: args["onboard2"],
                onboard4: args["onboard4"],
                onboard5: args["onboard5"],
                onboard7HeightUnit: args["onboard7HeightUnit"],
                onboard7HeightValue: args["onboard7HeightValue"],

                onboard8WeightUnit: args["onboard8WeightUnit"],
                onboard8WeightValue: args["onboard8WeightValue"],

                onboard9TargetWeightUnit: args["onboard9TargetWeightUnit"],
                onboard9TargetWeightValue: args["onboard9TargetWeightValue"],

                selectedDate: args["selectedDate"],

                bmi: args["bmi"],

                onboard12: args["onboard12"],

                onboard13: args["onboard13"],

                onboard15: args["onboard15"],
              ),
              settings: settings,
            )
            : CupertinoPageRoute(
              builder:
                  (context) => OnboardingScreen17(
                    onboard1: args["onboard1"],
                    onboard2: args["onboard2"],
                    onboard4: args["onboard4"],
                    onboard5: args["onboard5"],
                    onboard7HeightUnit: args["onboard7HeightUnit"],
                    onboard7HeightValue: args["onboard7HeightValue"],

                    onboard8WeightUnit: args["onboard8WeightUnit"],
                    onboard8WeightValue: args["onboard8WeightValue"],

                    onboard9TargetWeightUnit: args["onboard9TargetWeightUnit"],
                    onboard9TargetWeightValue:
                        args["onboard9TargetWeightValue"],

                    selectedDate: args["selectedDate"],

                    bmi: args["bmi"],

                    onboard12: args["onboard12"],

                    onboard13: args["onboard13"],

                    onboard15: args["onboard15"],
                  ),
            );

      case Routes.onboardingScreen16:
        final args = settings.arguments as Map;

        return Platform.isAndroid
            ? _FadedTransitionRoute(
              widget: OnboardingScreen16(
                onboard1: args["onboard1"],
                onboard2: args["onboard2"],
                onboard4: args["onboard4"],
                onboard5: args["onboard5"],
                onboard7HeightUnit: args["onboard7HeightUnit"],
                onboard7HeightValue: args["onboard7HeightValue"],

                onboard8WeightUnit: args["onboard8WeightUnit"],
                onboard8WeightValue: args["onboard8WeightValue"],

                onboard9TargetWeightUnit: args["onboard9TargetWeightUnit"],
                onboard9TargetWeightValue: args["onboard9TargetWeightValue"],

                selectedDate: args["selectedDate"],

                bmi: args["bmi"],

                onboard12: args["onboard12"],

                onboard13: args["onboard13"],

                onboard15: args["onboard15"],
              ),
              settings: settings,
            )
            : CupertinoPageRoute(
              builder:
                  (context) => OnboardingScreen16(
                    onboard1: args["onboard1"],
                    onboard2: args["onboard2"],
                    onboard4: args["onboard4"],
                    onboard5: args["onboard5"],
                    onboard7HeightUnit: args["onboard7HeightUnit"],
                    onboard7HeightValue: args["onboard7HeightValue"],

                    onboard8WeightUnit: args["onboard8WeightUnit"],
                    onboard8WeightValue: args["onboard8WeightValue"],

                    onboard9TargetWeightUnit: args["onboard9TargetWeightUnit"],
                    onboard9TargetWeightValue:
                        args["onboard9TargetWeightValue"],

                    selectedDate: args["selectedDate"],

                    bmi: args["bmi"],

                    onboard12: args["onboard12"],

                    onboard13: args["onboard13"],

                    onboard15: args["onboard15"],
                  ),
            );

      case Routes.onboardingScreen15:
        final args = settings.arguments as Map;

        return Platform.isAndroid
            ? _FadedTransitionRoute(
              widget: OnboardingScreen15(
                onboard1: args["onboard1"],
                onboard2: args["onboard2"],
                onboard4: args["onboard4"],
                onboard5: args["onboard5"],
                onboard7HeightUnit: args["onboard7HeightUnit"],
                onboard7HeightValue: args["onboard7HeightValue"],

                onboard8WeightUnit: args["onboard8WeightUnit"],
                onboard8WeightValue: args["onboard8WeightValue"],

                onboard9TargetWeightUnit: args["onboard9TargetWeightUnit"],
                onboard9TargetWeightValue: args["onboard9TargetWeightValue"],

                selectedDate: args["selectedDate"],

                bmi: args["bmi"],

                onboard12: args["onboard12"],

                onboard13: args["onboard13"],
              ),
              settings: settings,
            )
            : CupertinoPageRoute(
              builder:
                  (context) => OnboardingScreen15(
                    onboard1: args["onboard1"],
                    onboard2: args["onboard2"],
                    onboard4: args["onboard4"],
                    onboard5: args["onboard5"],
                    onboard7HeightUnit: args["onboard7HeightUnit"],
                    onboard7HeightValue: args["onboard7HeightValue"],

                    onboard8WeightUnit: args["onboard8WeightUnit"],
                    onboard8WeightValue: args["onboard8WeightValue"],

                    onboard9TargetWeightUnit: args["onboard9TargetWeightUnit"],
                    onboard9TargetWeightValue:
                        args["onboard9TargetWeightValue"],

                    selectedDate: args["selectedDate"],

                    bmi: args["bmi"],

                    onboard12: args["onboard12"],

                    onboard13: args["onboard13"],
                  ),
            );

      case Routes.onboardingScreen14:
        final args = settings.arguments as Map;

        return Platform.isAndroid
            ? _FadedTransitionRoute(
              widget: OnboardingScreen14(
                onboard1: args["onboard1"],
                onboard2: args["onboard2"],
                onboard4: args["onboard4"],
                onboard5: args["onboard5"],
                onboard7HeightUnit: args["onboard7HeightUnit"],
                onboard7HeightValue: args["onboard7HeightValue"],

                onboard8WeightUnit: args["onboard8WeightUnit"],
                onboard8WeightValue: args["onboard8WeightValue"],

                onboard9TargetWeightUnit: args["onboard9TargetWeightUnit"],
                onboard9TargetWeightValue: args["onboard9TargetWeightValue"],

                selectedDate: args["selectedDate"],

                bmi: args["bmi"],

                onboard12: args["onboard12"],

                onboard13: args["onboard13"],
              ),
              settings: settings,
            )
            : CupertinoPageRoute(
              builder:
                  (context) => OnboardingScreen14(
                    onboard1: args["onboard1"],
                    onboard2: args["onboard2"],
                    onboard4: args["onboard4"],
                    onboard5: args["onboard5"],
                    onboard7HeightUnit: args["onboard7HeightUnit"],
                    onboard7HeightValue: args["onboard7HeightValue"],

                    onboard8WeightUnit: args["onboard8WeightUnit"],
                    onboard8WeightValue: args["onboard8WeightValue"],

                    onboard9TargetWeightUnit: args["onboard9TargetWeightUnit"],
                    onboard9TargetWeightValue:
                        args["onboard9TargetWeightValue"],

                    selectedDate: args["selectedDate"],

                    bmi: args["bmi"],

                    onboard12: args["onboard12"],

                    onboard13: args["onboard13"],
                  ),
            );

      case Routes.onboardingScreen13:
        final args = settings.arguments as Map;

        return Platform.isAndroid
            ? _FadedTransitionRoute(
              widget: OnboardingScreen13(
                onboard1: args["onboard1"],
                onboard2: args["onboard2"],
                onboard4: args["onboard4"],
                onboard5: args["onboard5"],
                onboard7HeightUnit: args["onboard7HeightUnit"],
                onboard7HeightValue: args["onboard7HeightValue"],

                onboard8WeightUnit: args["onboard8WeightUnit"],
                onboard8WeightValue: args["onboard8WeightValue"],

                onboard9TargetWeightUnit: args["onboard9TargetWeightUnit"],
                onboard9TargetWeightValue: args["onboard9TargetWeightValue"],

                selectedDate: args["selectedDate"],

                bmi: args["bmi"],

                onboard12: args["onboard12"],
              ),
              settings: settings,
            )
            : CupertinoPageRoute(
              builder:
                  (context) => OnboardingScreen13(
                    onboard1: args["onboard1"],
                    onboard2: args["onboard2"],
                    onboard4: args["onboard4"],
                    onboard5: args["onboard5"],
                    onboard7HeightUnit: args["onboard7HeightUnit"],
                    onboard7HeightValue: args["onboard7HeightValue"],

                    onboard8WeightUnit: args["onboard8WeightUnit"],
                    onboard8WeightValue: args["onboard8WeightValue"],

                    onboard9TargetWeightUnit: args["onboard9TargetWeightUnit"],
                    onboard9TargetWeightValue:
                        args["onboard9TargetWeightValue"],

                    selectedDate: args["selectedDate"],

                    bmi: args["bmi"],

                    onboard12: args["onboard12"],
                  ),
            );

      case Routes.onboardingScreen11:
        final args = settings.arguments as Map;

        return Platform.isAndroid
            ? _FadedTransitionRoute(
              widget: OnboardingScreen11(
                onboard1: args["onboard1"],
                onboard2: args["onboard2"],
                onboard4: args["onboard4"],
                onboard5: args["onboard5"],
                onboard7HeightUnit: args["onboard7HeightUnit"],
                onboard7HeightValue: args["onboard7HeightValue"],

                onboard8WeightUnit: args["onboard8WeightUnit"],
                onboard8WeightValue: args["onboard8WeightValue"],

                onboard9TargetWeightUnit: args["onboard9TargetWeightUnit"],
                onboard9TargetWeightValue: args["onboard9TargetWeightValue"],

                selectedDate: args["selectedDate"],
              ),
              settings: settings,
            )
            : CupertinoPageRoute(
              builder:
                  (context) => OnboardingScreen11(
                    onboard1: args["onboard1"],
                    onboard2: args["onboard2"],
                    onboard4: args["onboard4"],
                    onboard5: args["onboard5"],
                    onboard7HeightUnit: args["onboard7HeightUnit"],
                    onboard7HeightValue: args["onboard7HeightValue"],

                    onboard8WeightUnit: args["onboard8WeightUnit"],
                    onboard8WeightValue: args["onboard8WeightValue"],

                    onboard9TargetWeightUnit: args["onboard9TargetWeightUnit"],
                    onboard9TargetWeightValue:
                        args["onboard9TargetWeightValue"],

                    selectedDate: args["selectedDate"],
                  ),
            );

      case Routes.onboardingScreen10:
        final args = settings.arguments as Map;
        return Platform.isAndroid
            ? _FadedTransitionRoute(
              widget: OnboardingScreen10(
                onboard1: args["onboard1"],
                onboard2: args["onboard2"],
                onboard4: args["onboard4"],
                onboard5: args["onboard5"],
                onboard7HeightUnit: args["onboard7HeightUnit"],
                onboard7HeightValue: args["onboard7HeightValue"],

                onboard8WeightUnit: args["onboard8WeightUnit"],
                onboard8WeightValue: args["onboard8WeightValue"],

                onboard9TargetWeightUnit: args["onboard9TargetWeightUnit"],
                onboard9TargetWeightValue: args["onboard9TargetWeightValue"],
              ),
              settings: settings,
            )
            : CupertinoPageRoute(
              builder:
                  (context) => OnboardingScreen10(
                    onboard1: args["onboard1"],
                    onboard2: args["onboard2"],
                    onboard4: args["onboard4"],
                    onboard5: args["onboard5"],
                    onboard7HeightUnit: args["onboard7HeightUnit"],
                    onboard7HeightValue: args["onboard7HeightValue"],

                    onboard8WeightUnit: args["onboard8WeightUnit"],
                    onboard8WeightValue: args["onboard8WeightValue"],

                    onboard9TargetWeightUnit: args["onboard9TargetWeightUnit"],
                    onboard9TargetWeightValue:
                        args["onboard9TargetWeightValue"],
                  ),
            );

      case Routes.onboardingScreen12:
        final args = settings.arguments as Map;
        return Platform.isAndroid
            ? _FadedTransitionRoute(
              widget: OnboardingScreen12(
                onboard1: args["onboard1"],
                onboard2: args["onboard2"],
                onboard4: args["onboard4"],
                onboard5: args["onboard5"],
                onboard7HeightUnit: args["onboard7HeightUnit"],
                onboard7HeightValue: args["onboard7HeightValue"],

                onboard8WeightUnit: args["onboard8WeightUnit"],
                onboard8WeightValue: args["onboard8WeightValue"],

                onboard9TargetWeightUnit: args["onboard9TargetWeightUnit"],
                onboard9TargetWeightValue: args["onboard9TargetWeightValue"],

                selectedDate: args["selectedDate"],

                bmi: args["bmi"],
              ),
              settings: settings,
            )
            : CupertinoPageRoute(
              builder:
                  (context) => OnboardingScreen12(
                    onboard1: args["onboard1"],
                    onboard2: args["onboard2"],
                    onboard4: args["onboard4"],
                    onboard5: args["onboard5"],
                    onboard7HeightUnit: args["onboard7HeightUnit"],
                    onboard7HeightValue: args["onboard7HeightValue"],

                    onboard8WeightUnit: args["onboard8WeightUnit"],
                    onboard8WeightValue: args["onboard8WeightValue"],

                    onboard9TargetWeightUnit: args["onboard9TargetWeightUnit"],
                    onboard9TargetWeightValue:
                        args["onboard9TargetWeightValue"],

                    selectedDate: args["selectedDate"],

                    bmi: args["bmi"],
                  ),
            );

      case Routes.forgetPasswordScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
              widget: const ForgetPasswordScreen(),
              settings: settings,
            )
            : CupertinoPageRoute(
              builder: (context) => const ForgetPasswordScreen(),
            );

      case Routes.onboardingScreen1:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
              widget: const OnboardingScreen1(),
              settings: settings,
            )
            : CupertinoPageRoute(
              builder: (context) => const OnboardingScreen1(),
            );

      case Routes.oneTimeOnboardingScreen:
        final args = settings.arguments as Map;
        return Platform.isAndroid
            ? _FadedTransitionRoute(
              widget: OneTimeOnboardingScreen(
                onboard1: args["onboard1"],
                onboard2: args["onboard2"],
                onboard4: args["onboard4"],
                onboard5: args["onboard5"],
              ),
              settings: settings,
            )
            : CupertinoPageRoute(
              builder:
                  (context) => OneTimeOnboardingScreen(
                    onboard1: args["onboard1"],
                    onboard2: args["onboard2"],
                    onboard4: args["onboard4"],
                    onboard5: args["onboard5"],
                  ),
            );

      case Routes.onboardingScreen9:
        final args = settings.arguments as Map;

        return Platform.isAndroid
            ? _FadedTransitionRoute(
              widget: OnboardingScreen9(
                onboard1: args["onboard1"],
                onboard2: args["onboard2"],
                onboard4: args["onboard4"],
                onboard5: args["onboard5"],
                onboard7HeightUnit: args["onboard7HeightUnit"],
                onboard7HeightValue: args["onboard7HeightValue"],

                onboard8WeightUnit: args["onboard8WeightUnit"],
                onboard8WeightValue: args["onboard8WeightValue"],
              ),
              settings: settings,
            )
            : CupertinoPageRoute(
              builder:
                  (context) => OnboardingScreen9(
                    onboard1: args["onboard1"],
                    onboard2: args["onboard2"],
                    onboard4: args["onboard4"],
                    onboard5: args["onboard5"],
                    onboard7HeightUnit: args["onboard7HeightUnit"],
                    onboard7HeightValue: args["onboard7HeightValue"],

                    onboard8WeightUnit: args["onboard8WeightUnit"],
                    onboard8WeightValue: args["onboard8WeightValue"],
                  ),
            );

      case Routes.onboardingScreen8:
        final args = settings.arguments as Map;
        return Platform.isAndroid
            ? _FadedTransitionRoute(
              widget: OnboardingScreen8(
                onboard1: args["onboard1"],
                onboard2: args["onboard2"],
                onboard4: args["onboard4"],
                onboard5: args["onboard5"],
                onboard7HeightUnit: args["onboard7HeightUnit"],
                onboard7HeightValue: args["onboard7HeightValue"],
              ),
              settings: settings,
            )
            : CupertinoPageRoute(
              builder:
                  (context) => OnboardingScreen8(
                    onboard1: args["onboard1"],
                    onboard2: args["onboard2"],
                    onboard4: args["onboard4"],
                    onboard5: args["onboard5"],
                    onboard7HeightUnit: args["onboard7HeightUnit"],
                    onboard7HeightValue: args["onboard7HeightValue"],
                  ),
            );

      case Routes.onboardingScreen7:
        final args = settings.arguments as Map;
        return Platform.isAndroid
            ? _FadedTransitionRoute(
              widget: OnboardingScreen7(
                onboard1: args["onboard1"],
                onboard2: args["onboard2"],
                onboard4: args["onboard4"],
                onboard5: args["onboard5"],
              ),
              settings: settings,
            )
            : CupertinoPageRoute(
              builder:
                  (context) => OnboardingScreen7(
                    onboard1: args["onboard1"],
                    onboard2: args["onboard2"],
                    onboard4: args["onboard4"],
                    onboard5: args["onboard5"],
                  ),
            );

      case Routes.onboardingScreen5:
        final args = settings.arguments as Map;
        return Platform.isAndroid
            ? _FadedTransitionRoute(
              widget: OnboardingScreen5(
                onboard1: args["onboard1"],
                onboard2: args["onboard2"],
                onboard4: args["onboard4"],
              ),
              settings: settings,
            )
            : CupertinoPageRoute(
              builder:
                  (context) => OnboardingScreen5(
                    onboard1: args["onboard1"],
                    onboard2: args["onboard2"],
                    onboard4: args["onboard4"],
                  ),
            );

      case Routes.onboardingScreen4:
        final args = settings.arguments as Map;
        return Platform.isAndroid
            ? _FadedTransitionRoute(
              widget: OnboardingScreen4(
                onboard1: args["onboard1"],
                onboard2: args["onboard2"],
              ),
              settings: settings,
            )
            : CupertinoPageRoute(
              builder:
                  (context) => OnboardingScreen4(
                    onboard1: args["onboard1"],
                    onboard2: args["onboard2"],
                  ),
            );

      case Routes.onboardingScreen2:
        final args = settings.arguments as Map;
        return Platform.isAndroid
            ? _FadedTransitionRoute(
              widget: OnboardingScreen2(onboard1: args["onboard1"]),
              settings: settings,
            )
            : CupertinoPageRoute(
              builder:
                  (context) => OnboardingScreen2(onboard1: args["onboard1"]),
            );

      case Routes.forgetOtpScreen:
        final args = settings.arguments as Map;
        return Platform.isAndroid
            ? _FadedTransitionRoute(
              widget: ForgetOtpScreen(email: args["email"]),
              settings: settings,
            )
            : CupertinoPageRoute(
              builder: (context) => ForgetOtpScreen(email: args["email"]),
            );

      case Routes.signupOtpScreen:
        final args = settings.arguments as Map;
        return Platform.isAndroid
            ? _FadedTransitionRoute(
              widget: SignupOtpScreen(email: args["email"]),
              settings: settings,
            )
            : CupertinoPageRoute(
              builder: (context) => SignupOtpScreen(email: args["email"]),
            );

      case Routes.resetPasswordScreen:
        final args = settings.arguments as Map;
        return Platform.isAndroid
            ? _FadedTransitionRoute(
              widget: ResetPasswordScreen(
                email: args["email"],
                token: args["token"],
              ),
              settings: settings,
            )
            : CupertinoPageRoute(
              builder:
                  (context) => ResetPasswordScreen(
                    email: args["email"],
                    token: args["token"],
                  ),
            );

      case Routes.signInScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
              widget: const SignInScreen(),
              settings: settings,
            )
            : CupertinoPageRoute(builder: (context) => const SignInScreen());

      case Routes.loadingScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(widget: const Loading(), settings: settings)
            : CupertinoPageRoute(builder: (context) => const Loading());

      case Routes.signUpScreen:
        return Platform.isAndroid
            ? _FadedTransitionRoute(
              widget: const SignUpScreen(),
              settings: settings,
            )
            : CupertinoPageRoute(builder: (context) => const SignUpScreen());

      default:
        return null;
    }
  }
}

//  weenAnimationBuilder(
//   child: Widget,
//   tween: Tween<double>(begin: 0, end: 1),
//   duration: Duration(milliseconds: 1000),
//   curve: Curves.bounceIn,
//   builder: (BuildContext context, double _val, Widget child) {
//     return Opacity(
//       opacity: _val,
//       child: Padding(
//         padding: EdgeInsets.only(top: _val * 50),
//         child: child
//       ),
//     );
//   },
// );

class _FadedTransitionRoute extends PageRouteBuilder {
  final Widget widget;
  @override
  final RouteSettings settings;

  _FadedTransitionRoute({required this.widget, required this.settings})
    : super(
        settings: settings,
        reverseTransitionDuration: const Duration(milliseconds: 1),
        pageBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          return widget;
        },
        transitionDuration: const Duration(milliseconds: 1),
        transitionsBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
        ) {
          return FadeTransition(
            opacity: CurvedAnimation(parent: animation, curve: Curves.ease),
            child: child,
          );
        },
      );
}

class ScreenTitle extends StatelessWidget {
  final Widget widget;

  const ScreenTitle({super.key, required this.widget});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: .5, end: 1),
      duration: const Duration(milliseconds: 500),
      curve: Curves.bounceIn,
      builder: (context, value, child) {
        return Opacity(opacity: value, child: child);
      },
      child: widget,
    );
  }
}
