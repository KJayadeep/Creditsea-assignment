import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;

import '../../../data/repositories/auth_repository.dart';
import 'otp_controller.dart';
import '../views/signin_view.dart';

class SignupController extends GetxController {
  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final pageController = PageController();

  final AuthRepository _authRepository = AuthRepository();

  final RxBool acceptedTerms = true.obs;
  final RxBool isLoading = false.obs;
  final RxInt currentStep = 0.obs;

  void toggleTerms(bool value) {
    acceptedTerms.value = value;
  }

  void goToStep(int step) {
    currentStep.value = step;
    if (pageController.hasClients) {
      pageController.animateToPage(
        step,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
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
      final data = response.data;
      final otp = data is Map ? data['otp']?.toString() : null;

      final otpController = Get.isRegistered<OtpController>()
          ? Get.find<OtpController>()
          : Get.put(OtpController());
      otpController.setPhoneNumber(phone);

      goToStep(1);

      Get.snackbar(
        'OTP Sent',
        otp != null
            ? 'Your verification code is: $otp'
            : (data is Map && data['message'] != null
                ? data['message'].toString()
                : 'OTP sent successfully'),
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFF175397),
        colorText: Colors.white,
        icon: const Icon(Icons.sms_outlined, color: Colors.white),
        duration: const Duration(seconds: 6),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        borderRadius: 10,
        mainButton: otp != null
            ? TextButton(
                onPressed: () {
                  otpController.fillOtp(otp);
                  if (Get.isSnackbarOpen) {
                    Get.back();
                  }
                },
                child: const Text(
                  'Auto-fill',
                  style: TextStyle(
                    color: Color(0xFF20C9A0),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : null,
      );
    } catch (error) {
      String message = 'Unable to send OTP. Please try again.';

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
    pageController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
