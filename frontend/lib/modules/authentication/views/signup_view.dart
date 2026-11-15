import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/promo_header.dart';
import '../controllers/signup_controller.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Column(
          children: [
            // Promotional blue section
            Expanded(
              flex: 5,
              child: const PromoHeader(),
            ),

            // Registration form
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(18),
                  ),
                  border: Border(
                    top: BorderSide(
                      color: AppColors.accent,
                      width: 4,
                    ),
                  ),
                ),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          'Welcome to Credit Sea!',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      const Text(
                        'Mobile Number',
                        style: TextStyle(fontSize: 12),
                      ),

                      const SizedBox(height: 7),

                      Row(
                        children: [
                          // Country code
                          Container(
                            height: 43,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.border,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Row(
                              children: [
                                Text('🇮🇳'),
                                SizedBox(width: 5),
                                Text(
                                  '+91',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 8),

                          // Mobile number
                          Expanded(
                            child: TextFormField(
                              controller: controller.phoneController,
                              keyboardType: TextInputType.phone,
                              maxLength: 10,
                              decoration: const InputDecoration(
                                counterText: '',
                                hintText: 'Please enter your mobile no.',
                                hintStyle: TextStyle(fontSize: 11),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 12,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Enter mobile number';
                                }

                                if (!RegExp(r'^[6-9]\d{9}$')
                                    .hasMatch(value.trim())) {
                                  return 'Enter a valid 10-digit number';
                                }

                                return null;
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // Privacy policy checkbox
                      Obx(
                        () => Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 22,
                              height: 22,
                              child: Checkbox(
                                value: controller.acceptedTerms.value,
                                activeColor: AppColors.accent,
                                onChanged: (value) {
                                  controller.toggleTerms(value ?? false);
                                },
                              ),
                            ),
                            const SizedBox(width: 7),
                            const Expanded(
                              child: Text.rich(
                                TextSpan(
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.black54,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'By continuing, you agree to our ',
                                    ),
                                    TextSpan(
                                      text: 'privacy policies',
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    TextSpan(text: ' and '),
                                    TextSpan(
                                      text: 'Terms & Conditions.',
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Request OTP button
                      SizedBox(
                        width: double.infinity,
                        height: 43,
                        child: ElevatedButton(
                          onPressed: controller.requestOtp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.action,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            elevation: 3,
                          ),
                          child: const Text(
                            'Request OTP',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),

                      const Spacer(),

                      // Sign in navigation placeholder
                      Center(
                        child: TextButton(
                          onPressed: controller.goToSignin,
                          child: const Text(
                            'Existing User? Sign in',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
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
}