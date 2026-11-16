import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/components/bottom_sheet_container.dart';
import '../../../core/components/custom_text_input.dart';
import '../../../core/components/phone_input.dart';
import '../../../core/components/primary_button.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/promo_header.dart';
import '../controllers/signin_controller.dart';

class SigninView extends StatelessWidget {
  const SigninView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<SigninController>()
        ? Get.find<SigninController>()
        : Get.put(SigninController());

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Column(
          children: [
            const Expanded(
              flex: 10,
              child: PromoHeader(),
            ),
            Expanded(
              flex: 11,
              child: BottomSheetContainer(
                padding: EdgeInsets.zero,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 16),
                  physics: const ClampingScrollPhysics(),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text(
                            'Please enter your credentials',
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
                        PhoneInput(
                          controller: controller.phoneController,
                          validator: controller.validatePhone,
                        ),
                        const SizedBox(height: 14),
                        Obx(
                          () => CustomTextInput(
                            label: 'Password',
                            hintText: 'Enter your password',
                            controller: controller.passwordController,
                            obscureText: controller.hidePassword.value,
                            validator: controller.validatePassword,
                            suffixIcon: IconButton(
                              onPressed: controller.togglePasswordVisibility,
                              icon: Icon(
                                controller.hidePassword.value
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: controller.forgotPassword,
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(50, 22),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.action,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Obx(
                          () => PrimaryButton(
                            text: 'Sign In',
                            height: 48,
                            fontSize: 14,
                            isLoading: controller.isLoading.value,
                            onPressed: controller.signIn,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Center(
                          child: TextButton(
                            onPressed: controller.goToSignup,
                            child: const Text.rich(
                              TextSpan(
                                style: TextStyle(fontSize: 13),
                                children: [
                                  TextSpan(
                                    text: 'New to CreditSea? ',
                                    style: TextStyle(
                                      color: Color(0xFF383838),
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Create an account',
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
