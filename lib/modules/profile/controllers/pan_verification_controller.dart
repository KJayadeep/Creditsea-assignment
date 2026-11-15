
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../loan_calculator/views/loan_calculator_view.dart';

class PanVerificationController extends GetxController {
  final panController = TextEditingController();

  final isVerified = false.obs;

  String? validatePan(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your PAN number';
    }

    final pan = value.trim().toUpperCase();

    if (!RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$').hasMatch(pan)) {
      return 'Enter a valid PAN number';
    }

    return null;
  }

  void verifyPan() {
    final error = validatePan(panController.text);

    if (error != null) {
      Get.snackbar(
        'Invalid PAN',
        error,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Development-only mock verification.
    isVerified.value = true;

    Get.snackbar(
      'Success',
      'PAN verification completed successfully.',
      snackPosition: SnackPosition.BOTTOM,
    );
    Get.to(() => LoanCalculatorView());
  }

  @override
  void onClose() {
    panController.dispose();
    super.onClose();
  }
}
