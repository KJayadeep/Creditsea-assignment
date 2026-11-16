import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

import '../../../data/repositories/user_repository.dart';
import '../../profile/views/pan_verification_view.dart';

class EmailVerificationController extends GetxController {
  final emailController = TextEditingController();

  final otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  final focusNodes = List.generate(
    6,
    (_) => FocusNode(),
  );

  final UserRepository _userRepository = UserRepository();

  final isOtpSent = false.obs;
  final isVerified = false.obs;
  final isLoading = false.obs;
  final secondsRemaining = 30.obs;

  Timer? _timer;

  static const String mockOtp = '123456';

  String get enteredOtp =>
      otpControllers.map((controller) => controller.text).join();

  void sendOtp() {
    final email = emailController.text.trim();

    if (!GetUtils.isEmail(email)) {
      Get.snackbar(
        'Invalid email',
        'Please enter a valid email address.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isOtpSent.value = true;
    isVerified.value = false;

    for (final controller in otpControllers) {
      controller.clear();
    }

    startTimer();

    Get.snackbar(
      'OTP sent',
      'Development OTP: $mockOtp',
      snackPosition: SnackPosition.BOTTOM,
    );

    focusNodes.first.requestFocus();
  }

  void startTimer() {
    _timer?.cancel();
    secondsRemaining.value = 30;

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (secondsRemaining.value > 0) {
          secondsRemaining.value--;
        } else {
          timer.cancel();
        }
      },
    );
  }

  void resendOtp() {
    if (secondsRemaining.value > 0) return;
    sendOtp();
  }

  Future<void> verifyOtp() async {
    if (isLoading.value) return;

    final email = emailController.text.trim();
    if (!GetUtils.isEmail(email)) {
      Get.snackbar(
        'Required',
        'Please enter a valid email address.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (!isOtpSent.value) {
      sendOtp();
      return;
    }

    if (enteredOtp.length != 6) {
      Get.snackbar(
        'Invalid OTP',
        'Please enter all 6 digits.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (enteredOtp != mockOtp) {
      Get.snackbar(
        'Invalid OTP',
        'Please enter the correct OTP.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;

    try {
      final response = await _userRepository.verifyEmail(
        email: email,
      );

      isVerified.value = true;

      Get.snackbar(
        'Success',
        response.data['message']?.toString() ?? 'Email verified successfully.',
        snackPosition: SnackPosition.BOTTOM,
      );

      Get.to(() => PanVerificationView());
    } on DioException catch (error) {
      final data = error.response?.data;
      Get.snackbar(
        'Error',
        data is Map
            ? data['message']?.toString() ?? 'Failed to verify email'
            : 'Failed to verify email',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (error) {
      debugPrint('Email verification error: $error');
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void onOtpChanged(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }
  }

  @override
  void onClose() {
    _timer?.cancel();

    emailController.dispose();

    for (final controller in otpControllers) {
      controller.dispose();
    }

    for (final node in focusNodes) {
      node.dispose();
    }

    super.onClose();
  }
}
