import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;

import '../../../core/network/api_client.dart';
import '../../../core/services/storage_service.dart';
import '../../../data/repositories/auth_repository.dart';
import 'signup_controller.dart';
import '../views/form_view.dart';

class PasswordController extends GetxController {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  final AuthRepository _authRepository = AuthRepository();

  final RxBool hidePassword = true.obs;
  final RxBool hideConfirmPassword = true.obs;
  final RxBool isLoading = false.obs;
  final RxString _phone = ''.obs;

  String get phoneNumber =>
      _phone.value.isNotEmpty ? _phone.value : (Get.arguments?['phone'] ?? '');

  void setPhone(String p) {
    _phone.value = p;
  }

  @override
  void onInit() {
    super.onInit();
    final argsPhone = Get.arguments?['phone'];
    if (argsPhone != null && argsPhone.toString().isNotEmpty) {
      _phone.value = argsPhone.toString();
    }
  }

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
        phone: phoneNumber,
        password: passwordController.text,
      );

      final data = response.data;
      if (data is Map && data['token'] != null) {
        final token = data['token'].toString();
        ApiClient.authToken = token;
        if (Get.isRegistered<StorageService>()) {
          await Get.find<StorageService>().saveToken(token);
          await Get.find<StorageService>().savePhone(phoneNumber);
        }
      }

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

  void goBack() {
    if (Get.isRegistered<SignupController>()) {
      Get.find<SignupController>().goToStep(1);
    } else {
      Get.back();
    }
  }

  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
