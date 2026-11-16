import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/payment_controller.dart';

class PaymentView extends StatelessWidget {
  PaymentView({super.key});

  final PaymentController controller =
      Get.isRegistered<PaymentController>()
          ? (Get.find<PaymentController>()..loadLoanArguments(Get.arguments))
          : Get.put(PaymentController());

  static const Color blue = Color(0xFF087AFF);
  static const Color darkText = Color(0xFF383838);
  static const Color grey = Color(0xFF777777);

  String formatAmount(double amount) {
    return NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 2,
    ).format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: darkText,
        title: const Text(
          'Loan Repayment',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Complete your repayment',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: darkText,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Review your loan details and proceed '
                      'with secure payment.',
                      style: TextStyle(
                        fontSize: 14,
                        color: grey,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Total payable card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: blue,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Total Amount Payable',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            formatAmount(
                              controller.totalPayable,
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 12),

                          Text(
                            'Application #${controller.loan['applicationNumber'] ?? 'N/A'}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    const Text(
                      'Repayment Breakdown',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: darkText,
                      ),
                    ),

                    const SizedBox(height: 18),

                    _amountRow(
                      'Principal Amount',
                      controller.loan['principalAmount'],
                    ),

                    _amountRow(
                      'Interest',
                      controller.loan['interestAmount'],
                    ),

                    _amountRow(
                      'Processing Fee',
                      controller.loan['processingFee'],
                    ),

                    const Divider(height: 30),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Payable',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: darkText,
                          ),
                        ),

                        Text(
                          formatAmount(
                            controller.totalPayable,
                          ),
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: blue,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.lock_outline,
                            color: Colors.green,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Secure payment powered by Razorpay. '
                              'UPI, cards and net banking are '
                              'available through Checkout.',
                              style: TextStyle(
                                fontSize: 13,
                                color: grey,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Pay button
            Container(
              padding: const EdgeInsets.fromLTRB(
                22, 14, 22, 22,
              ),
              color: Colors.white,
              child: SizedBox(
                width: double.infinity,
                height: 58,
                child: Obx(
                  () => ElevatedButton(
                    onPressed:
                        controller.isLoading.value ||
                                controller.isVerifying.value
                            ? null
                            : controller.payLoanAmount,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: blue,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor:
                          blue.withValues(alpha: 0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: controller.isLoading.value ||
                            controller.isVerifying.value
                        ? const SizedBox(
                            height: 23,
                            width: 23,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'Pay ${formatAmount(controller.totalPayable)}',
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _amountRow(String title, dynamic value) {
    final amount = value is num
        ? value.toDouble()
        : 0.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: grey,
            ),
          ),
          Text(
            formatAmount(amount),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: darkText,
            ),
          ),
        ],
      ),
    );
  }
}
