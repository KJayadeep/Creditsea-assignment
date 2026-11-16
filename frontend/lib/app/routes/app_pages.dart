import 'package:get/get.dart';

import 'app_routes.dart';
import '../../modules/splash/views/splash_view.dart';
import '../../modules/onboarding/views/onboarding_view.dart';
import '../../modules/onboarding/controllers/onboarding_controller.dart';
import '../../modules/authentication/views/signup_view.dart';
import '../../modules/authentication/controllers/signup_controller.dart';
import '../../modules/authentication/views/otp_view.dart';
import '../../modules/authentication/controllers/otp_controller.dart';
import '../../modules/authentication/views/password_view.dart';
import '../../modules/authentication/controllers/password_controller.dart';
import '../../modules/authentication/views/signin_view.dart';
import '../../modules/authentication/controllers/signin_controller.dart';
import '../../modules/authentication/views/form_view.dart';
import '../../modules/authentication/controllers/form_controller.dart';
import '../../modules/authentication/views/email_verification_view.dart';
import '../../modules/authentication/controllers/email_verification_controller.dart';
import '../../modules/profile/views/pan_verification_view.dart';
import '../../modules/profile/controllers/pan_verification_controller.dart';
import '../../modules/loan_calculator/views/loan_calculator_view.dart';
import '../../modules/loan_calculator/controllers/loan_calculator_controller.dart';
import '../../modules/loan_application/views/loan_offer_view.dart';
import '../../modules/loan_tracking/views/application_status_view.dart';
import '../../modules/loan_tracking/controllers/application_status_controller.dart';
import '../../modules/dashboard/views/dashboard_view.dart';
import '../../modules/dashboard/bindings/dashboard_binding.dart';
import '../../modules/profile/views/profile_view.dart';
import '../../modules/payment/views/payment_view.dart';
import '../../modules/payment/views/payment_success_view.dart';
import '../../modules/payment/controllers/payment_controller.dart';

class AppPages {
  static const initial = AppRoutes.splash;

  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<OnboardingController>(() => OnboardingController());
      }),
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => const SignupView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<SignupController>(() => SignupController());
        Get.lazyPut<OtpController>(() => OtpController());
        Get.lazyPut<PasswordController>(() => PasswordController());
      }),
    ),
    GetPage(
      name: AppRoutes.otp,
      page: () => const OtpView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<OtpController>(() => OtpController());
      }),
    ),
    GetPage(
      name: AppRoutes.password,
      page: () => const PasswordView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<PasswordController>(() => PasswordController());
      }),
    ),
    GetPage(
      name: AppRoutes.signin,
      page: () => const SigninView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<SigninController>(() => SigninController());
      }),
    ),
    GetPage(
      name: AppRoutes.personalDetails,
      page: () => const FormView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<FormController>(() => FormController());
      }),
    ),
    GetPage(
      name: AppRoutes.emailVerification,
      page: () => EmailVerificationView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<EmailVerificationController>(
          () => EmailVerificationController(),
        );
      }),
    ),
    GetPage(
      name: AppRoutes.panVerification,
      page: () => PanVerificationView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<PanVerificationController>(
          () => PanVerificationController(),
        );
      }),
    ),
    GetPage(
      name: AppRoutes.loanCalculator,
      page: () => LoanCalculatorView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<LoanCalculatorController>(
          () => LoanCalculatorController(),
        );
      }),
    ),
    GetPage(
      name: AppRoutes.loanOffer,
      page: () => const LoanOfferView(),
    ),
    GetPage(
      name: AppRoutes.applicationStatus,
      page: () => ApplicationStatusView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<ApplicationStatusController>(
          () => ApplicationStatusController(),
        );
      }),
    ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => ProfileView(),
    ),
    GetPage(
      name: AppRoutes.payment,
      page: () => PaymentView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<PaymentController>(() => PaymentController());
      }),
    ),
    GetPage(
      name: AppRoutes.paymentSuccess,
      page: () => PaymentSuccessView(),
    ),
  ];
}
