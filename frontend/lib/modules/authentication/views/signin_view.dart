import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/promo_header.dart';
import '../controllers/signin_controller.dart';

class SigninView extends StatelessWidget {
  const SigninView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SigninController());

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Column(
          children: [
            // Promotional blue header
            const Expanded(
              flex: 5,
              child: PromoHeader(),
            ),

            // Sign in form
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
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
                          'Please enter your credentials',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Mobile number label
                      const Text(
                        'Mobile Number',
                        style: TextStyle(fontSize: 12),
                      ),

                      const SizedBox(height: 7),

                      // Country code and mobile input
                      Row(
                        children: [
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

                          Expanded(
                            child: TextFormField(
                              controller: controller.phoneController,
                              keyboardType: TextInputType.phone,
                              maxLength: 10,
                              validator: controller.validatePhone,
                              decoration: const InputDecoration(
                                counterText: '',
                                hintText: 'Please enter your mobile no.',
                                hintStyle: TextStyle(fontSize: 11),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // Password label
                      const Text(
                        'Enter password',
                        style: TextStyle(fontSize: 12),
                      ),

                      const SizedBox(height: 7),

                      // Password input
                      Obx(
                        () => TextFormField(
                          controller: controller.passwordController,
                          obscureText: controller.hidePassword.value,
                          validator: controller.validatePassword,
                          decoration: InputDecoration(
                            hintText: 'Enter password',
                            hintStyle: const TextStyle(fontSize: 11),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 12,
                            ),
                            suffixIcon: IconButton(
                              onPressed:
                                  controller.togglePasswordVisibility,
                              icon: Icon(
                                controller.hidePassword.value
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                size: 19,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Forgot password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: controller.forgotPassword,
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: 5,
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'Forgot password?',
                            style: TextStyle(
                              color: AppColors.action,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Sign in button
                      SizedBox(
                        width: double.infinity,
                        height: 43,
                        child: ElevatedButton(
                          onPressed: controller.signIn,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.action,
                            foregroundColor: Colors.white,
                            elevation: 3,
                            shadowColor: AppColors.action.withValues(
                              alpha: 0.3,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const Spacer(),

                      // Create account navigation
                      Center(
                        child: TextButton(
                          onPressed: controller.goToSignup,
                          child: const Text.rich(
                            TextSpan(
                              style: TextStyle(fontSize: 11),
                              children: [
                                TextSpan(
                                  text: 'New to CreditSea? ',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Create an account',
                                  style: TextStyle(
                                    color: AppColors.primary,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}