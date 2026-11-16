import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

import '../../../data/repositories/user_repository.dart';
import '../../loan_calculator/views/loan_calculator_view.dart';

class PanVerificationController extends GetxController {
  final panController = TextEditingController();

  final UserRepository _userRepository = UserRepository();

  final isVerified = false.obs;
  final isLoading = false.obs;

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

  Future<void> verifyPan() async {
    if (isLoading.value) return;

    final pan = panController.text.trim().toUpperCase();
    final error = validatePan(pan);

    if (error != null) {
      Get.snackbar(
        'Invalid PAN',
        error,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;

    try {
      final response = await _userRepository.verifyPAN(
        panNumber: pan,
      );

      isVerified.value = true;

      Get.snackbar(
        'Success',
        response.data['message'] ??
            'PAN verification completed successfully.',
        snackPosition: SnackPosition.BOTTOM,
      );

      Get.to(() => LoanCalculatorView());

    } on DioException catch (error) {
      final data = error.response?.data;

      Get.snackbar(
        'Error',
        data is Map
            ? data['message']?.toString() ?? 'PAN verification failed'
            : 'PAN verification failed',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (error) {
      debugPrint('PAN verification error: $error');

      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    panController.dispose();
    super.onClose();
  }
}
