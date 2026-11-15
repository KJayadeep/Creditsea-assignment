
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../core/widgets/registration_progress.dart';
import '../controllers/email_verification_controller.dart';

class EmailVerificationView extends StatelessWidget {
  EmailVerificationView({super.key});

  final EmailVerificationController controller =
      Get.put(EmailVerificationController());

  static const Color primaryBlue = Color(0xFF087AFF);
  static const Color primaryText = Color(0xFF383838);
  static const Color borderColor = Color(0xFFEAEAEA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top registration progress
            const RegistrationProgress(activeStep: 1),

            // Main white content panel
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x08000000),
                      blurRadius: 15,
                      offset: Offset(0, -4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        25, 24, 20, 0,
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: const Icon(
                              Icons.arrow_back,
                              size: 23,
                              color: primaryText,
                            ),
                          ),
                          const SizedBox(width: 17),
                          const Text(
                            'Personal Email ID',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: primaryText,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Email illustration
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 27,
                          bottom: 30,
                        ),
                        child: SizedBox(
                          width: 165,
                          height: 155,
                          child: SvgPicture.asset(
                            'assets/images/email_verification.svg',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),

                    // Email and OTP section
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Email label
                            const Text(
                              'Email ID*',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: primaryText,
                              ),
                            ),

                            const SizedBox(height: 13),

                            // Email input
                            TextField(
                              controller: controller.emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hintText: 'Enter your email ID',
                                hintStyle: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF999999),
                                ),
                                contentPadding:
                                    const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 15,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(7),
                                  borderSide: const BorderSide(
                                    color: borderColor,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(7),
                                  borderSide: const BorderSide(
                                    color: primaryBlue,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 27),

                            // OTP heading
                            const Text(
                              'OTP Verification',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: primaryText,
                              ),
                            ),

                            const SizedBox(height: 13),

                            // Six OTP boxes
                            Row(
                              children: List.generate(
                                6,
                                (index) => Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      right: index == 5 ? 0 : 5,
                                    ),
                                    child: SizedBox(
                                      height: 50,
                                      child: TextField(
                                        controller: controller
                                            .otpControllers[index],
                                        focusNode:
                                            controller.focusNodes[index],
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        maxLength: 1,
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                        ],
                                        onChanged: (value) {
                                          controller.onOtpChanged(
                                            value,
                                            index,
                                          );
                                        },
                                        decoration: InputDecoration(
                                          counterText: '',
                                          contentPadding: EdgeInsets.zero,
                                          enabledBorder:
                                              OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(7),
                                            borderSide: const BorderSide(
                                              color: borderColor,
                                            ),
                                          ),
                                          focusedBorder:
                                              OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(7),
                                            borderSide: const BorderSide(
                                              color: primaryBlue,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 9),

                            // Resend OTP and countdown
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
                                          color: primaryText,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: controller
                                                    .secondsRemaining.value ==
                                                0
                                            ? controller.resendOtp
                                            : null,
                                        child: Text(
                                          'Resend Code',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: controller
                                                        .secondsRemaining
                                                        .value ==
                                                    0
                                                ? primaryBlue
                                                : primaryBlue,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '00:${controller.secondsRemaining.value.toString().padLeft(2, '0')}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: primaryText,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Verification success message
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

                    // Bottom Verify button
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        25, 12, 25, 58,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: 51,
                        child: Obx(
                          () => ElevatedButton(
                            onPressed: controller.isVerified.value
                                ? null
                                : controller.verifyOtp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryBlue,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: Colors.green,
                              elevation: 3,
                              shadowColor:
                                  primaryBlue.withValues(alpha: 0.3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7),
                              ),
                            ),
                            child: Text(
                              controller.isVerified.value
                                  ? 'Verified'
                                  : 'Verify',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
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
