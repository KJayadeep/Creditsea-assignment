
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

import '../../../core/components/primary_button.dart';
import '../../../core/widgets/registration_progress.dart';
import '../../../data/repositories/loan_repository.dart';
import '../../loan_calculator/views/loan_calculator_view.dart';
import '../../loan_tracking/views/application_status_view.dart';

class LoanOfferView extends StatefulWidget {
  const LoanOfferView({super.key});

  @override
  State<LoanOfferView> createState() => _LoanOfferViewState();
}

class _LoanOfferViewState extends State<LoanOfferView> {
  static const Color blue = Color(0xFF087AFF);
  static const Color darkText = Color(0xFF383838);

  final Map arguments =
      Get.arguments is Map ? Get.arguments as Map : {};

  final LoanRepository _loanRepository = LoanRepository();

  bool isLoading = false;

  double get principal =>
      (arguments['principalAmount'] as num?)?.toDouble() ?? 0;

  int get tenure =>
      (arguments['tenure'] as num?)?.toInt() ?? 0;

  String get purpose =>
      arguments['purpose']?.toString() ?? '';

  double get totalPayable =>
      (arguments['totalPayable'] as num?)?.toDouble() ?? 0;

  String get amount => _currency(principal);

  String get payable => _currency(totalPayable);

  static String _currency(double value) {
    return '₹${value.round()}';
  }

  Future<void> acceptOffer() async {
    if (isLoading) return;

    setState(() => isLoading = true);

    try {
      final response = await _loanRepository.acceptOffer(
        principalAmount: principal,
        tenure: tenure,
        purpose: purpose,
      );

      final loan = response.data['loan'];

      Get.off(
        () => ApplicationStatusView(),
        arguments: loan,
      );

    } on DioException catch (error) {
      final data = error.response?.data;

      Get.snackbar(
        'Error',
        data is Map
            ? data['message']?.toString() ?? 'Unable to accept offer'
            : 'Unable to accept offer',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (error) {
      debugPrint('Accept offer error: $error');

      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void extendOffer() {
    if (Navigator.canPop(context)) {
      Get.back();
    } else {
      Get.off(() => LoanCalculatorView());
    }
  }

  @override
  Widget build(BuildContext context) {
    const bold = TextStyle(fontWeight: FontWeight.w700);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const RegistrationProgress(activeStep: 2),
            Expanded(
              child: Column(
                children: [
                  const Spacer(flex: 3),

                  const Text(
                    'Our Offerings',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: darkText,
                    ),
                  ),

                  const Spacer(flex: 3),

                  Image.asset(
                    'assets/images/coin.gif',
                    width: 200,
                    height: 200,
                    fit: BoxFit.contain,
                  ),

                  const Spacer(flex: 3),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: darkText,
                        ),
                        children: [
                          const TextSpan(
                            text: 'Congratulations! ',
                            style: TextStyle(color: Color(0xFF36C900)),
                          ),
                          const TextSpan(text: 'We can offer you '),
                          TextSpan(text: amount, style: bold),
                          const TextSpan(text: ' Amount Within '),
                          const TextSpan(
                            text: '30 minutes',
                            style: bold,
                          ),
                          TextSpan(
                            text: ' for $tenure days, with a payable amount of ',
                          ),
                          TextSpan(text: payable, style: bold),
                          const TextSpan(
                            text: '. Just with few more steps.',
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Proceed further to',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: darkText,
                    ),
                  ),

                  const Spacer(flex: 3),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                    child: Column(
                      children: [
                        PrimaryButton(
                          text: 'Accept Offer',
                          height: 48,
                          isLoading: isLoading,
                          onPressed: acceptOffer,
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: OutlinedButton(
                            onPressed: isLoading ? null : extendOffer,
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: darkText,
                              side: const BorderSide(
                                color: blue,
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            child: const Text(
                              'Extend Offer',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
