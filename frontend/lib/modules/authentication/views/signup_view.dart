import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/components/bottom_sheet_container.dart';
import '../../../core/components/custom_text_input.dart';
import '../../../core/components/otp_input_row.dart';
import '../../../core/components/phone_input.dart';
import '../../../core/components/primary_button.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/promo_header.dart';
import '../controllers/otp_controller.dart';
import '../controllers/password_controller.dart';
import '../controllers/signup_controller.dart';
import 'widgets/terms_checkbox.dart';

class SignupView extends StatefulWidget {
  final int initialStep;

  const SignupView({super.key, this.initialStep = 0});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  late final SignupController signupController;
  late final OtpController otpController;
  late final PasswordController passwordController;

  @override
  void initState() {
    super.initState();

    signupController = Get.isRegistered<SignupController>()
        ? Get.find<SignupController>()
        : Get.put(SignupController());

    otpController = Get.isRegistered<OtpController>()
        ? Get.find<OtpController>()
        : Get.put(OtpController());

    passwordController = Get.isRegistered<PasswordController>()
        ? Get.find<PasswordController>()
        : Get.put(PasswordController());

    if (widget.initialStep > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        signupController.goToStep(widget.initialStep);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Column(
          children: [
            // Fixed top header part that stays persistent across all steps
            const Expanded(
              flex: 10,
              child: PromoHeader(),
            ),

            // Sliding bottom form container (only this changes between Signup -> OTP -> Password)
            Expanded(
              flex: 11,
              child: BottomSheetContainer(
                padding: EdgeInsets.zero,
                child: PageView(
                  controller: signupController.pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildSignupStep(context),
                    _buildOtpStep(context),
                    _buildPasswordStep(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Step 0: Mobile number input (Create Account)
  Widget _buildSignupStep(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 16),
      physics: const ClampingScrollPhysics(),
      child: Form(
        key: signupController.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Welcome to Credit Sea!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF263238),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Mobile Number',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF383838),
              ),
            ),
            const SizedBox(height: 8),
            PhoneInput(controller: signupController.phoneController),
            const SizedBox(height: 16),
            Obx(
              () => TermsCheckbox(
                value: signupController.acceptedTerms.value,
                onChanged: signupController.toggleTerms,
              ),
            ),
            const SizedBox(height: 20),
            Obx(
              () => PrimaryButton(
                text: 'Request OTP',
                height: 48,
                fontSize: 14,
                isLoading: signupController.isLoading.value,
                onPressed: signupController.requestOtp,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: signupController.goToSignin,
                child: const Text.rich(
                  TextSpan(
                    style: TextStyle(fontSize: 13),
                    children: [
                      TextSpan(
                        text: 'Existing User? ',
                        style: TextStyle(
                          color: Color(0xFF383838),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      TextSpan(
                        text: 'Sign in',
                        style: TextStyle(
                          color: AppColors.action,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Step 1: OTP Verification
  Widget _buildOtpStep(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 16),
      physics: const ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(
                  Icons.arrow_back,
                  color: Color(0xFF383838),
                  size: 22,
                ),
                onPressed: otpController.goBack,
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    'Enter OTP',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF263238),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 22),
            ],
          ),
          const SizedBox(height: 16),
          Obx(
            () => Text(
              'Verify OTP, Sent on +91 ${otpController.phoneNumber}',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF78838F),
              ),
            ),
          ),
          const SizedBox(height: 20),
          OtpInputRow(
            length: 4,
            controllers: otpController.otpControllers,
            focusNodes: otpController.focusNodes,
            onChanged: otpController.onOtpChanged,
          ),
          const SizedBox(height: 16),
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '00:${otpController.remainingSeconds.value.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF383838),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (otpController.canResend.value)
                  GestureDetector(
                    onTap: otpController.isResending.value
                        ? null
                        : otpController.resendOtp,
                    child: const Text(
                      'Resend OTP',
                      style: TextStyle(
                        color: AppColors.action,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Obx(
            () => PrimaryButton(
              text: 'Verify',
              height: 48,
              fontSize: 14,
              isLoading: otpController.isVerifying.value,
              onPressed: otpController.verifyOtp,
            ),
          ),
        ],
      ),
    );
  }

  // Step 2: Password Creation
  Widget _buildPasswordStep(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 16),
      physics: const ClampingScrollPhysics(),
      child: Form(
        key: passwordController.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Color(0xFF383838),
                    size: 22,
                  ),
                  onPressed: passwordController.goBack,
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      'Enter Password',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF263238),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 22),
              ],
            ),
            const SizedBox(height: 14),
            Obx(
              () => CustomTextInput(
                label: 'Password',
                hintText: 'Enter your password',
                controller: passwordController.passwordController,
                obscureText: passwordController.hidePassword.value,
                validator: passwordController.validatePassword,
                suffixIcon: IconButton(
                  onPressed: passwordController.togglePasswordVisibility,
                  icon: Icon(
                    passwordController.hidePassword.value
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Obx(
              () => CustomTextInput(
                label: 'Confirm Password',
                hintText: 'Confirm your password',
                controller: passwordController.confirmPasswordController,
                obscureText: passwordController.hideConfirmPassword.value,
                validator: passwordController.validateConfirmPassword,
                suffixIcon: IconButton(
                  onPressed: passwordController.toggleConfirmPasswordVisibility,
                  icon: Icon(
                    passwordController.hideConfirmPassword.value
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '*Password must contain at least 8 characters and one special character.',
              style: TextStyle(
                fontSize: 10,
                color: Color(0xFF78838F),
              ),
            ),
            const SizedBox(height: 20),
            Obx(
              () => PrimaryButton(
                text: 'Continue',
                height: 48,
                fontSize: 14,
                isLoading: passwordController.isLoading.value,
                onPressed: passwordController.createPassword,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
