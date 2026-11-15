import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/widgets/registration_progress.dart';
import '../../loan_tracking/views/application_status_view.dart';

class LoanOfferView extends StatelessWidget {
  LoanOfferView({super.key});

  static const Color blue = Color(0xFF087AFF);
  static const Color darkText = Color(0xFF383838);

  final Map arguments = Get.arguments is Map ? Get.arguments as Map : {};

  String get amount =>
      _currency((arguments['principal'] as num?)?.toDouble() ?? 10000);

  String get tenure => '${(arguments['tenure'] as num?)?.toInt() ?? 90}';

  String get payable =>
      _currency((arguments['totalPayable'] as num?)?.toDouble() ?? 10600);

  static String _currency(double value) {
    final formatted = value.round().toString();
    final buffer = StringBuffer();

    for (int i = 0; i < formatted.length; i++) {
      buffer.write(formatted[i]);
      final remaining = formatted.length - i - 1;
      if (remaining > 0) {
        if (remaining == 3 || (remaining > 3 && (remaining - 3) % 2 == 0)) {
          buffer.write(',');
        }
      }
    }

    return 'Rs. ${buffer.toString()}';
  }

  void acceptOffer() {
    Get.snackbar(
      'Offer Accepted',
      'Your loan offer has been accepted.',
      snackPosition: SnackPosition.BOTTOM,
    );
    Get.to(
        () => ApplicationStatusView(),
    );
  }

  void extendOffer() {
    Get.snackbar(
      'Offer Extension',
      'Offer extension will be available in the next stage.',
      snackPosition: SnackPosition.BOTTOM,
    );
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

                  // Coin illustration
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
                          const TextSpan(text: '30 minutes', style: bold),
                          TextSpan(
                              text: ' for $tenure days, with a payable amount of '),
                          TextSpan(text: payable, style: bold),
                          const TextSpan(text: '. Just with few more steps.'),
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
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: acceptOffer,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: blue,
                              foregroundColor: Colors.white,
                              elevation: 6,
                              shadowColor: blue.withValues(alpha: 0.4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            child: const Text(
                              'Accept Offer',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Container(
                          width: double.infinity,
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: blue.withValues(alpha: 0.2),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: OutlinedButton(
                            onPressed: extendOffer,
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: darkText,
                              side: const BorderSide(color: blue, width: 1.5),
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