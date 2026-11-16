import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;

import '../../../core/network/api_client.dart';
import '../../../core/services/storage_service.dart';
import '../../../data/repositories/auth_repository.dart';
import '../views/signup_view.dart';
import '../../dashboard/views/dashboard_view.dart';

class SigninController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  final AuthRepository _authRepository = AuthRepository();

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

  Future<void> signIn() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (isLoading.value) return;

    try {
      isLoading.value = true;

      final response = await _authRepository.login(
        phone: phoneController.text.trim(),
        password: passwordController.text,
      );

      final data = response.data;
      if (data is Map && data['token'] != null) {
        final token = data['token'].toString();
        ApiClient.authToken = token;
        if (Get.isRegistered<StorageService>()) {
          await Get.find<StorageService>().saveToken(token);
          await Get.find<StorageService>().savePhone(phoneController.text.trim());
        }
      }

      Get.snackbar(
        'Success',
        response.data['message'] ?? 'Login successful',
        snackPosition: SnackPosition.BOTTOM,
      );

      Get.offAll(
        () => DashboardView(),
        transition: Transition.rightToLeft,
      );
    } catch (error) {
      String message = 'Login failed. Please check your credentials.';

      if (error is dio.DioException) {
        final data = error.response?.data;
        if (data is Map && data['message'] != null) {
          message = data['message'].toString();
        }
      }

      Get.snackbar(
        'Login failed',
        message,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
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
