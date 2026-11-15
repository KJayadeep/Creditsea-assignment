import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/promo_header.dart';
import '../controllers/password_controller.dart';

class PasswordView extends StatelessWidget {
  const PasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PasswordController());

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Column(
          children: [
            const Expanded(
              flex: 5,
              child: PromoHeader(),
            ),

            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 22,
                ),
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
                          'Create Your Password',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      const Text(
                        'Password',
                        style: TextStyle(fontSize: 12),
                      ),

                      const SizedBox(height: 7),

                      Obx(
                        () => TextFormField(
                          controller: controller.passwordController,
                          obscureText: controller.hidePassword.value,
                          validator: controller.validatePassword,
                          decoration: InputDecoration(
                            hintText: 'Enter your password',
                            hintStyle: const TextStyle(fontSize: 12),
                            suffixIcon: IconButton(
                              onPressed:
                                  controller.togglePasswordVisibility,
                              icon: Icon(
                                controller.hidePassword.value
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      const Text(
                        'Confirm Password',
                        style: TextStyle(fontSize: 12),
                      ),

                      const SizedBox(height: 7),

                      Obx(
                        () => TextFormField(
                          controller:
                              controller.confirmPasswordController,
                          obscureText:
                              controller.hideConfirmPassword.value,
                          validator:
                              controller.validateConfirmPassword,
                          decoration: InputDecoration(
                            hintText: 'Confirm your password',
                            hintStyle: const TextStyle(fontSize: 12),
                            suffixIcon: IconButton(
                              onPressed: controller
                                  .toggleConfirmPasswordVisibility,
                              icon: Icon(
                                controller.hideConfirmPassword.value
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      const Text(
                        'Password must contain at least 8 characters '
                        'and one special character.',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.black54,
                        ),
                      ),

                      const Spacer(),

                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: controller.createPassword,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.action,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: const Text(
                            'Continue',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      Center(
                        child: TextButton(
                          onPressed: Get.back,
                          child: const Text(
                            'Back',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 11,
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