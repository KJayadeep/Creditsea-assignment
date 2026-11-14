import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtpController extends GetxController {
  final List<TextEditingController> otpControllers =
      List.generate(4, (_) => TextEditingController());

  final List<FocusNode> focusNodes =
      List.generate(4, (_) => FocusNode());

  final RxInt remainingSeconds = 30.obs;
  final RxBool canResend = false.obs;
  final RxBool isVerifying = false.obs;

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

  void resendOtp() {
    if (!canResend.value) return;

    clearOtp();
    startTimer();

    Get.snackbar(
      'OTP sent',
      'Your demo OTP is 1234',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void clearOtp() {
    for (final controller in otpControllers) {
      controller.clear();
    }

    focusNodes[0].requestFocus();
  }

  void verifyOtp() {
    if (enteredOtp.length != 4) {
      Get.snackbar(
        'Invalid OTP',
        'Please enter all 4 digits.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (enteredOtp != '1234') {
      Get.snackbar(
        'Verification failed',
        'Incorrect OTP. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );

      clearOtp();
      return;
    }

    Get.snackbar(
      'Success',
      'Mobile number verified successfully!',
      snackPosition: SnackPosition.BOTTOM,
    );

    // Create Password screen will be connected in Stage 5.
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