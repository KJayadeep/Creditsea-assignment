
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;

import '../../../data/repositories/auth_repository.dart';
import '../views/form_view.dart';

class PasswordController extends GetxController {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  final AuthRepository _authRepository = AuthRepository();

  final RxBool hidePassword = true.obs;
  final RxBool hideConfirmPassword = true.obs;
  final RxBool isLoading = false.obs;

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

  Future<void> createPassword() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (isLoading.value) return;

    try {
      isLoading.value = true;

      final response = await _authRepository.register(
        password: passwordController.text,
      );

      Get.snackbar(
        'Success',
        response.data['message'] ?? 'Account created successfully',
        snackPosition: SnackPosition.BOTTOM,
      );

      // Navigate to personal details
      Get.to(
        () => const FormView(),
        transition: Transition.rightToLeft,
      );

    } catch (error) {
      String message = 'Registration failed. Please try again.';

      if (error is dio.DioException) {
        final data = error.response?.data;

        if (data is Map && data['message'] != null) {
          message = data['message'].toString();
        }
      }

      Get.snackbar(
        'Registration failed',
        message,
        snackPosition: SnackPosition.BOTTOM,
      );

    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
