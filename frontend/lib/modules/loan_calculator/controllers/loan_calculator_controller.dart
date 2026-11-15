
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../loan_application/views/loan_offer_view.dart';

class LoanCalculatorController extends GetxController {
  final selectedPurpose = ''.obs;

  final principalAmount = 30000.0.obs;
  final tenure = 40.0.obs;

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

  void applyForLoan() {
  if (selectedPurpose.value.isEmpty) {
    Get.snackbar(
      'Required',
      'Please select your loan purpose.',
      snackPosition: SnackPosition.BOTTOM,
    );
    return;
  }

  Get.to(
    () => LoanOfferView(),
    arguments: {
      'principal': principalAmount.value,
      'tenure': tenure.value,
      'interest': interest,
      'processingFee': processingFee,
      'totalPayable': totalPayable,
      'purpose': selectedPurpose.value,
    },
  );
}
}
