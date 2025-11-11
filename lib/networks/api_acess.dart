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
import '../features/settings/data/rx_post_logout/rx.dart';

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
