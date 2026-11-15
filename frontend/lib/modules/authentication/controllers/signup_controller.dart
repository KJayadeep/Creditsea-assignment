import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;

import '../../../data/repositories/auth_repository.dart';
import '../views/otp_view.dart';
import '../views/signin_view.dart';

class SignupController extends GetxController {
  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final AuthRepository _authRepository = AuthRepository();

  final RxBool acceptedTerms = true.obs;
  final RxBool isLoading = false.obs;

  void toggleTerms(bool value) {
    acceptedTerms.value = value;
  }

  Future<void> requestOtp() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (!acceptedTerms.value) {
      Get.snackbar(
        'Terms required',
        'Please accept the privacy policy and terms.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (isLoading.value) return;

    final phone = phoneController.text.trim();

    try {
      isLoading.value = true;

      final response = await _authRepository.sendOTP(phone);

      Get.snackbar(
        'OTP sent',
        response.data['message'] ?? 'OTP sent successfully',
        snackPosition: SnackPosition.BOTTOM,
      );

      Get.to(
        () => const OtpView(),
        arguments: {
          'phone': phone,
        },
        transition: Transition.rightToLeft,
      );
    } catch (error) {
      String message = 'Unable to send OTP. Please try again.';

      // Extract backend error messag
          if (error is dio.DioException) {
      final data = error.response?.data;

      if (data is Map && data['message'] != null) {
        message = data['message'].toString();
      }
    }

      Get.snackbar(
        'OTP failed',
        message,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void goToSignin() {
    Get.off(
      () => const SigninView(),
      transition: Transition.rightToLeft,
    );
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }
}
