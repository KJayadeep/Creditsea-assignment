import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../views/signup_view.dart';

class SigninController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  final RxBool hidePassword = true.obs;
  final RxBool isLoading = false.obs;

  void togglePasswordVisibility() {
    hidePassword.toggle();
  }

  String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your mobile number';
    }

    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value.trim())) {
      return 'Enter a valid 10-digit mobile number';
    }

    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }

    return null;
  }

  void signIn() {
    if (!formKey.currentState!.validate()) {
      return;
    }

    // Backend authentication will be connected later.
    Get.snackbar(
      'Demo Sign In',
      'Login API integration is coming next.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void forgotPassword() {
    Get.snackbar(
      'Forgot Password',
      'Password recovery will be implemented with OTP verification.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void goToSignup() {
    Get.off(
      () => const SignupView(),
      transition: Transition.rightToLeft,
    );
  }

  @override
  void onClose() {
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}