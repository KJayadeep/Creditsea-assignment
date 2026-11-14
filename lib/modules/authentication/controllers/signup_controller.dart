import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final RxBool acceptedTerms = true.obs;

  void toggleTerms(bool value) {
    acceptedTerms.value = value;
  }

  void requestOtp() {
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

    final phone = phoneController.text.trim();

    // Temporary navigation until we implement OTP verification.
    Get.snackbar(
      'OTP requested',
      'Demo OTP flow for +91 $phone',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }
}