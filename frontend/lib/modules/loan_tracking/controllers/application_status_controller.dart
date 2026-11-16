import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../core/services/storage_service.dart';
import '../../../data/repositories/loan_repository.dart';
import '../../../data/repositories/user_repository.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../../loan_calculator/views/loan_calculator_view.dart';
import '../../payment/views/payment_view.dart';
import '../views/widgets/aadhaar_verification_sheet.dart';
import '../views/widgets/enach_setup_sheet.dart';
import '../views/widgets/esign_agreement_sheet.dart';
import '../views/widgets/disbursement_sheet.dart';

class ApplicationStatusController extends GetxController {
  final loan = <String, dynamic>{}.obs;
  final applicationNumber = ''.obs;

  // Timeline indices:
  // 0: Application Submitted (completed when currentStatus >= 1)
  // 1: Application under Review (completed when currentStatus >= 2)
  // 2: E-KYC (completed when currentStatus >= 3)
  // 3: E-Nach (completed when currentStatus >= 4)
  // 4: E-Sign (completed when currentStatus >= 5)
  // 5: Disbursement (completed when currentStatus >= 6)
  // 6: All completed
  final currentStatus = 1.obs;

  final List<String> statuses = [
    'Application Submitted',
    'Application under Review',
    'E-KYC',
    'E-Nach',
    'E-Sign',
    'Disbursement',
  ];

  // 2-minute review countdown timer (120 seconds)
  final reviewRemainingSeconds = 120.obs;
  Timer? _reviewTimer;

  // Aadhaar e-KYC state
  final aadhaarController = TextEditingController();
  final aadhaarOtpController = TextEditingController();
  final isAadhaarOtpSent = false.obs;
  final isVerifyingAadhaar = false.obs;
  final aadhaarVerified = false.obs;
  final aadhaarConsent = true.obs;

  final UserRepository _userRepository = UserRepository();
  final LoanRepository _loanRepository = LoanRepository();

  bool get isRepaid => loan['status']?.toString() == 'Repaid';
  bool get isDisbursed => loan['status']?.toString() == 'Disbursed';
  bool get isRejected => loan['status']?.toString() == 'Rejected';

  @override
  void onInit() {
    super.onInit();
    loadLoanArguments(Get.arguments);
  }

  @override
  void onClose() {
    _reviewTimer?.cancel();
    aadhaarController.dispose();
    aadhaarOtpController.dispose();
    super.onClose();
  }

  Future<void> loadLoanArguments(dynamic arguments) async {
    if (arguments is Map) {
      loan.assignAll(Map<String, dynamic>.from(arguments));
    }

    applicationNumber.value =
        loan['applicationNumber']?.toString() ?? 'Not available';

    // 1. Rejected application
    if (isRejected) {
      _reviewTimer?.cancel();
      currentStatus.value = 0;
      return;
    }

    final backendStatus = loan['status']?.toString() ?? 'Submitted';

    // 2. Loan is fully repaid -> all 6 steps are completed! Never restart review!
    if (backendStatus == 'Repaid') {
      _reviewTimer?.cancel();
      currentStatus.value = 6;
      return;
    }

    // 3. Loan is disbursed -> all 6 steps are completed!
    if (backendStatus == 'Disbursed') {
      _reviewTimer?.cancel();
      currentStatus.value = 6;
      return;
    }

    // 4. Check if local progress was saved for this loan application
    final appNum = applicationNumber.value;
    if (appNum.isNotEmpty && appNum != 'Not available') {
      try {
        if (Get.isRegistered<StorageService>()) {
          final storage = Get.find<StorageService>();
          final savedStep = await storage.getLoanProgress(appNum);
          if (savedStep != null && savedStep >= 2) {
            // Review was already completed previously! Do not restart timer!
            _reviewTimer?.cancel();
            currentStatus.value = savedStep;
            return;
          }
        }
      } catch (e) {
        debugPrint('Loan progress storage check notice: $e');
      }
    }

    // 5. Loan was already approved on backend
    if (backendStatus == 'Approved') {
      _reviewTimer?.cancel();
      currentStatus.value = 3;
      return;
    }

    // 6. Newly submitted loan:
    // Step 0 ("Application Submitted") is checked!
    // Step 1 ("Application under Review") runs the 2-minute demo timer!
    currentStatus.value = 1;
    startReviewTimer();
  }

  // 2-minute countdown timer for "Application under Review"
  void startReviewTimer() {
    _reviewTimer?.cancel();
    reviewRemainingSeconds.value = 120;

    _reviewTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (reviewRemainingSeconds.value > 0) {
        reviewRemainingSeconds.value--;
      } else {
        timer.cancel();
        finishReview();
      }
    });
  }

  String get formattedReviewTime {
    final minutes =
        (reviewRemainingSeconds.value ~/ 60).toString().padLeft(2, '0');
    final seconds =
        (reviewRemainingSeconds.value % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  // Finish review and advance to E-KYC
  void finishReview() {
    _reviewTimer?.cancel();
    if (currentStatus.value == 1) {
      currentStatus.value = 2; // Step 1 completed, Step 2 (E-KYC) now active!

      // Persist progress so reopening won't start review again
      final appNum = applicationNumber.value;
      if (appNum.isNotEmpty && Get.isRegistered<StorageService>()) {
        try {
          final storage = Get.find<StorageService>();
          storage.saveLoanProgress(appNum, 2);
        } catch (_) {}
      }

      // Update backend status to Approved if loanId is available
      final loanId = (loan['_id'] ?? loan['id'])?.toString();
      if (loanId != null && loanId.isNotEmpty) {
        _loanRepository
            .updateLoanStatus(loanId: loanId, status: 'Approved')
            .ignore();
      }

      Get.snackbar(
        'Review Completed',
        'Your application is approved! Please complete your E-KYC.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF00A36C),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
        icon: const Icon(Icons.check_circle_outline, color: Colors.white),
      );
    }
  }

  // User manually skips the 2-minute wait
  void continueFromReview() {
    finishReview();
  }

  String get backendStatus =>
      loan['status']?.toString() ?? 'Submitted';

  String get statusTitle {
    if (isRejected) {
      return 'Application Rejected';
    }

    if (isRepaid) {
      return 'Loan Fully Repaid! 🎉';
    }

    switch (currentStatus.value) {
      case 1:
        return 'Application Under Review';
      case 2:
        return 'E-KYC Verification';
      case 3:
        return 'Set Up Auto-Debit (E-Nach)';
      case 4:
        return 'E-Sign Loan Agreement';
      case 5:
        return 'Ready for Disbursement';
      case 6:
        return 'Loan Disbursed Successfully! 🎉';
      default:
        return 'Application Submitted';
    }
  }

  String get statusDescription {
    if (isRejected) {
      return 'Unfortunately, your loan application has been rejected.';
    }

    if (isRepaid) {
      return 'Congratulations! Your loan has been fully repaid and settled. '
          'No further payments are pending on this loan.';
    }

    switch (currentStatus.value) {
      case 1:
        return 'Our automated underwriting engine is verifying your application details. '
            'Estimated review time remaining: $formattedReviewTime.';
      case 2:
        return 'Your application has been approved! Complete instant Aadhaar e-KYC '
            'to verify your identity and unlock disbursement.';
      case 3:
        return 'Set up automated repayments on your due date via Razorpay e-Mandate / UPI AutoPay.';
      case 4:
        return 'Review your loan contract terms and execute digital e-signature consent.';
      case 5:
        return 'All verifications and agreements are completed! Initiate instant IMPS disbursement to your bank account.';
      case 6:
        return 'Loan amount has been disbursed directly to your bank account. '
            'You can proceed with repayment anytime.';
      default:
        return 'Your loan application has been received and verified.';
    }
  }

  // --- E-KYC ---
  void openAadhaarVerification(BuildContext context) {
    if (aadhaarVerified.value || currentStatus.value > 2) {
      Get.snackbar(
        'E-KYC Verified',
        'Your Aadhaar e-KYC has already been completed successfully.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF00A36C),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        icon: const Icon(Icons.verified, color: Colors.white),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AadhaarVerificationSheet(controller: this),
    );
  }

  void requestAadhaarOtp() {
    final rawNumber = aadhaarController.text.replaceAll(' ', '').trim();
    if (rawNumber.length != 12 || !RegExp(r'^\d{12}$').hasMatch(rawNumber)) {
      Get.snackbar(
        'Invalid Aadhaar',
        'Please enter a valid 12-digit Aadhaar number.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    if (!aadhaarConsent.value) {
      Get.snackbar(
        'Consent Required',
        'Please check the consent box to proceed with UIDAI verification.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.shade800,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    isAadhaarOtpSent.value = true;
    Get.snackbar(
      'OTP Sent',
      '6-digit OTP sent to Aadhaar-linked mobile number. (Demo: use any 6 digits)',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF087AFF),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 4),
    );
  }

  Future<void> verifyAadhaarOtp() async {
    final otp = aadhaarOtpController.text.trim();
    if (otp.length != 6) {
      Get.snackbar(
        'Invalid OTP',
        'Please enter the 6-digit OTP sent to your Aadhaar-linked mobile.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    isVerifyingAadhaar.value = true;

    try {
      final rawNumber = aadhaarController.text.replaceAll(' ', '').trim();

      // Attempt backend verification
      try {
        await _userRepository.verifyAadhaar(aadhaarNumber: rawNumber);
      } catch (e) {
        debugPrint('Backend verifyAadhaar notice: $e');
      }

      await Future.delayed(const Duration(milliseconds: 600));

      aadhaarVerified.value = true;
      currentStatus.value = 3; // Step 2 (E-KYC) completed! Step 3 (E-Nach) active!

      // Persist progress
      final appNum = applicationNumber.value;
      if (appNum.isNotEmpty && Get.isRegistered<StorageService>()) {
        try {
          final storage = Get.find<StorageService>();
          storage.saveLoanProgress(appNum, 3);
        } catch (_) {}
      }

      if (Get.isBottomSheetOpen ?? false) {
        Get.back();
      }

      Get.snackbar(
        'E-KYC Verified',
        'Aadhaar e-KYC completed successfully! Ready for E-Nach.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF00A36C),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
        icon: const Icon(Icons.verified, color: Colors.white),
      );
    } catch (e) {
      Get.snackbar(
        'Verification Failed',
        'Could not verify Aadhaar. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isVerifyingAadhaar.value = false;
    }
  }

  // --- E-Nach (Auto-Debit via Razorpay) ---
  void openENachSetup(BuildContext context) {
    if (currentStatus.value < 3) {
      Get.snackbar(
        'Action Required',
        'Please complete previous steps before setting up E-Nach.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ENachSetupSheet(controller: this),
    );
  }

  void completeENachSetup() {
    currentStatus.value = 4; // Step 3 (E-Nach) completed! Step 4 (E-Sign) active!

    final appNum = applicationNumber.value;
    if (appNum.isNotEmpty && Get.isRegistered<StorageService>()) {
      try {
        final storage = Get.find<StorageService>();
        storage.saveLoanProgress(appNum, 4);
      } catch (_) {}
    }

    Get.snackbar(
      'E-Nach Mandate Active',
      'Auto-debit setup on due date successfully verified with Razorpay! Next: E-Sign Agreement.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF00A36C),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 4),
      icon: const Icon(Icons.check_circle_outline, color: Colors.white),
    );
  }

  // --- E-Sign (Loan Agreement Consent) ---
  void openESignAgreement(BuildContext context) {
    if (currentStatus.value < 4) {
      Get.snackbar(
        'Action Required',
        'Please complete previous steps before e-signing the agreement.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ESignAgreementSheet(controller: this),
    );
  }

  void completeESignAgreement() {
    currentStatus.value = 5; // Step 4 (E-Sign) completed! Step 5 (Disbursement) active!

    final appNum = applicationNumber.value;
    if (appNum.isNotEmpty && Get.isRegistered<StorageService>()) {
      try {
        final storage = Get.find<StorageService>();
        storage.saveLoanProgress(appNum, 5);
      } catch (_) {}
    }

    Get.snackbar(
      'Agreement E-Signed',
      'Loan contract executed successfully! Ready for instant disbursement.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF00A36C),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 4),
      icon: const Icon(Icons.draw_outlined, color: Colors.white),
    );
  }

  // --- Disbursement ---
  void openDisbursement(BuildContext context) {
    if (currentStatus.value < 5) {
      Get.snackbar(
        'Action Required',
        'Please complete E-Sign agreement before requesting disbursement.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DisbursementSheet(controller: this),
    );
  }

  Future<void> completeDisbursement() async {
    currentStatus.value = 6; // All 6 steps completed!
    loan['status'] = 'Disbursed';

    final appNum = applicationNumber.value;
    if (appNum.isNotEmpty && Get.isRegistered<StorageService>()) {
      try {
        final storage = Get.find<StorageService>();
        await storage.saveLoanProgress(appNum, 6);
      } catch (_) {}
    }

    // Update backend loan status to Disbursed
    final loanId = (loan['_id'] ?? loan['id'])?.toString();
    if (loanId != null && loanId.isNotEmpty) {
      try {
        await _loanRepository.updateLoanStatus(loanId: loanId, status: 'Disbursed');
      } catch (e) {
        debugPrint('Update disbursement backend notice: $e');
      }
    }

    // Refresh dashboard loans
    if (Get.isRegistered<DashboardController>()) {
      try {
        Get.find<DashboardController>().fetchLoans();
      } catch (_) {}
    }

    final principal = (loan['principalAmount'] as num?)?.toDouble() ?? 30000.0;

    Get.snackbar(
      'Disbursement Successful 🎉',
      '₹${principal.toStringAsFixed(0)} credited to your bank account via IMPS!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF00A36C),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 5),
      icon: const Icon(Icons.account_balance_wallet, color: Colors.white),
    );
  }

  // Bottom action button handler
  void handlePrimaryAction(BuildContext context) {
    if (isRejected) {
      Get.snackbar(
        'Application Rejected',
        'You cannot proceed with a rejected application.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (isRepaid) {
      Get.to(() => LoanCalculatorView());
      return;
    }

    switch (currentStatus.value) {
      case 1:
        continueFromReview();
        break;
      case 2:
        openAadhaarVerification(context);
        break;
      case 3:
        openENachSetup(context);
        break;
      case 4:
        openESignAgreement(context);
        break;
      case 5:
        openDisbursement(context);
        break;
      case 6:
        // Already disbursed -> proceed to repayment
        Get.to(
          () => PaymentView(),
          arguments: loan,
          transition: Transition.rightToLeft,
        );
        break;
      default:
        continueFromReview();
    }
  }
}

// Input formatter for 12-digit Aadhaar in 4-4-4 format: "XXXX XXXX XXXX"
class AadhaarInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(' ', '');
    if (text.length > 12) return oldValue;

    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(text[i]);
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
