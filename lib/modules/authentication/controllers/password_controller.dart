import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PasswordController extends GetxController {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  final RxBool hidePassword = true.obs;
  final RxBool hideConfirmPassword = true.obs;

  void togglePasswordVisibility() {
    hidePassword.toggle();
  }

  void toggleConfirmPasswordVisibility() {
    hideConfirmPassword.toggle();
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }

    if (value.length < 8) {
      return 'Password must contain at least 8 characters';
    }

    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>_\-+=]').hasMatch(value)) {
      return 'Include at least one special character';
    }

    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != passwordController.text) {
      return 'Passwords do not match';
    }

    return null;
  }

  void createPassword() {
    if (!formKey.currentState!.validate()) {
      return;
    }

    Get.snackbar(
      'Success',
      'Password created successfully!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}