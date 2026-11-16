import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../core/components/app_header.dart';
import '../../../core/components/custom_text_input.dart';
import '../../../core/components/otp_input_row.dart';
import '../../../core/components/primary_button.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/registration_progress.dart';
import '../controllers/email_verification_controller.dart';

class EmailVerificationView extends StatelessWidget {
  EmailVerificationView({super.key});

  final EmailVerificationController controller =
      Get.isRegistered<EmailVerificationController>()
          ? Get.find<EmailVerificationController>()
          : Get.put(EmailVerificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const RegistrationProgress(activeStep: 1),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x08000000),
                      blurRadius: 15,
                      offset: Offset(0, -4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 22),
                            const AppHeader(
                              title: 'Personal Email ID',
                              fontSize: 20,
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 24),
                                child: SizedBox(
                                  width: 160,
                                  height: 150,
                                  child: SvgPicture.asset(
                                    'assets/images/email_verification.svg',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                            CustomTextInput(
                              label: 'Email ID*',
                              hintText: 'e.g., example@domain.com',
                              controller: controller.emailController,
                              keyboardType: TextInputType.emailAddress,
                              suffixIcon: IconButton(
                                icon: const Icon(
                                  Icons.arrow_forward,
                                  size: 18,
                                  color: AppColors.action,
                                ),
                                onPressed: controller.sendOtp,
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Verification Code',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF383838),
                              ),
                            ),
                            const SizedBox(height: 10),
                            OtpInputRow(
                              length: 6,
                              boxWidth: 42,
                              boxHeight: 48,
                              controllers: controller.otpControllers,
                              focusNodes: controller.focusNodes,
                              onChanged: controller.onOtpChanged,
                            ),
                            const SizedBox(height: 12),
                            Obx(
                              () => Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        "Didn't receive it? ",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF383838),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: controller.secondsRemaining.value == 0
                                            ? controller.resendOtp
                                            : null,
                                        child: Text(
                                          'Resend Code',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: controller.secondsRemaining.value == 0
                                                ? AppColors.action
                                                : Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '00:${controller.secondsRemaining.value.toString().padLeft(2, '0')}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF383838),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Obx(
                              () => controller.isVerified.value
                                  ? const Padding(
                                      padding: EdgeInsets.only(top: 12),
                                      child: Text(
                                        'Email verified successfully!',
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 12, 24, 34),
                      child: Obx(
                        () => PrimaryButton(
                          text: controller.isVerified.value
                              ? 'Verified'
                              : 'Verify',
                          isLoading: controller.isLoading.value,
                          backgroundColor: controller.isVerified.value
                              ? Colors.green
                              : AppColors.action,
                          onPressed: controller.isVerified.value
                              ? null
                              : controller.verifyOtp,
                          height: 50,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
