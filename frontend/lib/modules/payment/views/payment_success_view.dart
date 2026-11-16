import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../app/routes/app_routes.dart';

class PaymentSuccessView extends StatelessWidget {
  PaymentSuccessView({super.key});

  final Map<String, dynamic> payment =
      Get.arguments is Map
          ? Map<String, dynamic>.from(Get.arguments)
          : {};

  String formatAmount(dynamic value) {
    final amount = value is num
        ? value / 100
        : (double.tryParse(value?.toString() ?? '') ?? 0.0) / 100;

    return NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 2,
    ).format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final amount = payment['amount'];
    final paymentId =
        payment['razorpayPaymentId']?.toString() ?? 'N/A';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 110,
                width: 110,
                decoration: const BoxDecoration(
                  color: Color(0xFFE4F8EE),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Color(0xFF00A36C),
                  size: 75,
                ),
              ),

              const SizedBox(height: 28),

              const Text(
                'Payment Successful!',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF383838),
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Your loan repayment has been successfully verified.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 35),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F6F8),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Amount Paid',
                      style: TextStyle(color: Colors.grey),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      formatAmount(amount),
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00A36C),
                      ),
                    ),

                    const Divider(height: 30),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Payment ID'),
                        Flexible(
                          child: Text(
                            paymentId,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 35),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    Get.offAllNamed(AppRoutes.dashboard);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF087AFF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Back to Dashboard',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
