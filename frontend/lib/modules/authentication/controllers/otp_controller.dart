import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;

import '../../../data/repositories/auth_repository.dart';
import 'password_controller.dart';
import 'signup_controller.dart';
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
  final RxString _phone = ''.obs;

  Timer? _timer;

  String get phoneNumber =>
      _phone.value.isNotEmpty ? _phone.value : (Get.arguments?['phone'] ?? '');

  String get enteredOtp =>
      otpControllers.map((controller) => controller.text).join();

  void setPhoneNumber(String phone) {
    _phone.value = phone;
    clearOtp();
    startTimer();
  }

  @override
  void onInit() {
    super.onInit();
    final argsPhone = Get.arguments?['phone'];
    if (argsPhone != null && argsPhone.toString().isNotEmpty) {
      _phone.value = argsPhone.toString();
    }
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

      final response = await _authRepository.sendOTP(phoneNumber);
      final data = response.data;
      final otp = data is Map ? data['otp']?.toString() : null;

      clearOtp();
      startTimer();

      Get.snackbar(
        'OTP Sent',
        otp != null
            ? 'Your verification code is: $otp'
            : 'A new OTP has been generated.',
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
                  fillOtp(otp);
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

  void fillOtp(String code) {
    for (int i = 0; i < otpControllers.length && i < code.length; i++) {
      otpControllers[i].text = code[i];
    }
    if (code.length >= 4 && focusNodes.isNotEmpty) {
      focusNodes.last.unfocus();
    }
  }

  void clearOtp() {
    for (final controller in otpControllers) {
      controller.clear();
    }

    if (focusNodes.isNotEmpty) {
      focusNodes[0].requestFocus();
    }
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

      if (Get.isRegistered<SignupController>()) {
        final signupController = Get.find<SignupController>();
        final passwordController = Get.isRegistered<PasswordController>()
            ? Get.find<PasswordController>()
            : Get.put(PasswordController());
        passwordController.setPhone(phoneNumber);
        signupController.goToStep(2);
      } else {
        Get.to(
          () => const PasswordView(),
          arguments: {
            'phone': phoneNumber,
          },
          transition: Transition.rightToLeft,
        );
      }
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

  void goBack() {
    if (Get.isRegistered<SignupController>()) {
      Get.find<SignupController>().goToStep(0);
    } else {
      Get.back();
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
