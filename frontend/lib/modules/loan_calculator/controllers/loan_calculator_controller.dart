
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

import '../../../data/repositories/loan_repository.dart';
import '../../loan_application/views/loan_offer_view.dart';

class LoanCalculatorController extends GetxController {
  final selectedPurpose = ''.obs;

  final principalAmount = 30000.0.obs;
  final tenure = 40.0.obs;

  final LoanRepository _loanRepository = LoanRepository();
  final isLoading = false.obs;

  static const double interestPerDay = 0.01;
  static const double processingFeeRate = 0.10;

  final List<String> loanPurposes = [
    'Medical Expenses',
    'Education',
    'Travel',
    'Shopping',
    'Emergency',
    'Business',
    'Other',
  ];

  double get interest =>
      principalAmount.value * interestPerDay * tenure.value;

  double get processingFee =>
      principalAmount.value * processingFeeRate;

  double get totalPayable =>
      principalAmount.value + interest + processingFee;

  String formatCurrency(double amount) {
    return NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    ).format(amount);
  }

  void updatePrincipal(double value) {
    principalAmount.value = value;
  }

  void updateTenure(double value) {
    tenure.value = value;
  }

  
Future<void> applyForLoan() async {
  if (isLoading.value) return;

  if (selectedPurpose.value.isEmpty) {
    Get.snackbar('Required', 'Please select a loan purpose');
    return;
  }

  isLoading.value = true;

  try {
    final response = await _loanRepository.calculateOffer(
      principalAmount: principalAmount.value,
      tenure: tenure.value.round(),
      purpose: selectedPurpose.value,
    );

    final offer = response.data['offer'];

    Get.to(
      () => LoanOfferView(),
      arguments: offer,
    );
  } on DioException catch (error) {
    final data = error.response?.data;

    Get.snackbar(
      'Error',
      data is Map
          ? data['message']?.toString() ?? 'Unable to calculate offer'
          : 'Unable to calculate offer',
    );
  } catch (error) {
    debugPrint('Loan offer error: $error');
    Get.snackbar('Error', 'Something went wrong');
  } finally {
    isLoading.value = false;
  }
}

}
