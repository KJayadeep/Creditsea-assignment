import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;

import '../../../data/repositories/auth_repository.dart';
import '../views/password_view.dart';

class OtpController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  final List<TextEditingController> otpControllers =
      List.generate(4, (_) => TextEditingController());

  final List<FocusNode> focusNodes =
      List.generate(4, (_) => FocusNode());

  final RxInt remainingSeconds = 30.obs;
  final RxBool canResend = false.obs;
  final RxBool isVerifying = false.obs;
  final RxBool isResending = false.obs;

  Timer? _timer;

  String get phoneNumber =>
      Get.arguments?['phone'] ?? '';

  String get enteredOtp =>
      otpControllers.map((controller) => controller.text).join();

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  void startTimer() {
    _timer?.cancel();

    remainingSeconds.value = 30;
    canResend.value = false;

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (remainingSeconds.value > 0) {
          remainingSeconds.value--;
        } else {
          canResend.value = true;
          timer.cancel();
        }
      },
    );
  }

  void onOtpChanged(String value, int index) {
    if (value.isNotEmpty && index < 3) {
      focusNodes[index + 1].requestFocus();
    }

    if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }
  }

  // Resend OTP through backend
  Future<void> resendOtp() async {
    if (!canResend.value || isResending.value) return;

    try {
      isResending.value = true;

      await _authRepository.sendOTP(phoneNumber);

      clearOtp();
      startTimer();

      Get.snackbar(
        'OTP sent',
        'A new OTP has been generated.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (error) {
      String message = 'Unable to resend OTP.';

      if (error is dio.DioException) {
        final data = error.response?.data;

        if (data is Map && data['message'] != null) {
          message = data['message'].toString();
        }
      }

      Get.snackbar(
        'Resend failed',
        message,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isResending.value = false;
    }
  }

  void clearOtp() {
    for (final controller in otpControllers) {
      controller.clear();
    }

    focusNodes[0].requestFocus();
  }

  // Verify OTP through backend
  Future<void> verifyOtp() async {
    if (isVerifying.value) return;

    if (enteredOtp.length != 4) {
      Get.snackbar(
        'Invalid OTP',
        'Please enter all 4 digits.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isVerifying.value = true;

      final response = await _authRepository.verifyOTP(
        phone: phoneNumber,
        otp: enteredOtp,
      );

      Get.snackbar(
        'Success',
        response.data['message'] ??
            'Mobile number verified successfully!',
        snackPosition: SnackPosition.BOTTOM,
      );

      Get.to(
        () => const PasswordView(),
        arguments: {
          'phone': phoneNumber,
        },
        transition: Transition.rightToLeft,
      );
    } catch (error) {
      String message = 'OTP verification failed.';

      if (error is dio.DioException) {
          final data = error.response?.data;

          if (data is Map && data['message'] != null) {
            message = data['message'].toString();
          }
      }

      Get.snackbar(
        'Verification failed',
        message,
        snackPosition: SnackPosition.BOTTOM,
      );

      clearOtp();
    } finally {
      isVerifying.value = false;
    }
  }

  @override
  void onClose() {
    _timer?.cancel();

    for (final controller in otpControllers) {
      controller.dispose();
    }

    for (final node in focusNodes) {
      node.dispose();
    }

    super.onClose();
  }
}
