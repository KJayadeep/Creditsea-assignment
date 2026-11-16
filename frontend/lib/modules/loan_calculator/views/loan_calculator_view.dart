import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/components/app_header.dart';
import '../../../core/components/primary_button.dart';
import '../controllers/loan_calculator_controller.dart';
import 'widgets/loan_purpose_dropdown.dart';
import 'widgets/loan_slider.dart';
import 'widgets/repayment_summary_card.dart';

class LoanCalculatorView extends StatelessWidget {
  LoanCalculatorView({super.key});

  final LoanCalculatorController controller =
      Get.isRegistered<LoanCalculatorController>()
          ? Get.find<LoanCalculatorController>()
          : Get.put(LoanCalculatorController());

  static const Color blue = Color(0xFF087AFF);
  static const Color darkText = Color(0xFF383838);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Logo
            SizedBox(
              height: 75,
              child: Center(
                child: SvgPicture.asset(
                  'assets/images/logo-3.svg',
                  width: 155,
                  height: 42,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // Calculator Card
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x10000000),
                      blurRadius: 12,
                      offset: Offset(0, -3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppHeader(
                              title: 'Apply for loan',
                              fontSize: 16,
                              onBack: () =>
                                  Get.offAllNamed(AppRoutes.dashboard),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              "We've calculated your loan eligibility. Select "
                              'your preferred loan amount and tenure.',
                              style: TextStyle(
                                fontSize: 11,
                                height: 1.35,
                                color: darkText,
                              ),
                            ),
                            const SizedBox(height: 14),

                            // Interest & Fee Chips
                            Row(
                              children: [
                                Expanded(
                                  child: _infoChip('Interest Per Day 1%'),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _infoChip('Processing Fee 10%'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Divider(color: Color(0xFFEEEEEE)),
                            const SizedBox(height: 14),

                            // Purpose Selector
                            Obx(
                              () => LoanPurposeDropdown(
                                selectedValue: controller.selectedPurpose.value,
                                purposes: controller.loanPurposes,
                                onChanged: (val) =>
                                    controller.selectedPurpose.value = val ?? '',
                              ),
                            ),
                            const SizedBox(height: 18),

                            // Principal Amount Slider
                            Obx(
                              () => LoanSlider(
                                title: 'Principal Amount',
                                valueDisplay: controller.formatCurrency(
                                  controller.principalAmount.value,
                                ),
                                value: controller.principalAmount.value,
                                min: 5000,
                                max: 100000,
                                divisions: 95,
                                onChanged: controller.updatePrincipal,
                              ),
                            ),
                            const SizedBox(height: 14),

                            // Tenure Slider
                            Obx(
                              () => LoanSlider(
                                title: 'Tenure',
                                valueDisplay:
                                    '${controller.tenure.value.toInt()} Days',
                                value: controller.tenure.value,
                                min: 20,
                                max: 45,
                                divisions: 25,
                                minLabel: '20 Days',
                                maxLabel: '45 Days',
                                onChanged: controller.updateTenure,
                              ),
                            ),
                            const SizedBox(height: 22),

                            // Summary Breakdown
                            Obx(
                              () => RepaymentSummaryCard(
                                principal: controller.formatCurrency(
                                  controller.principalAmount.value,
                                ),
                                interest: controller.formatCurrency(
                                  controller.interest,
                                ),
                                processingFee: controller.formatCurrency(
                                  controller.processingFee,
                                ),
                                totalPayable: controller.formatCurrency(
                                  controller.totalPayable,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            const Center(
                              child: Text(
                                'Thank you for choosing CreditSea. Please\n'
                                'accept to proceed with the loan details.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 10,
                                  height: 1.3,
                                  color: Color(0xFF008FBB),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Bottom Action Buttons
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                      child: Column(
                        children: [
                          PrimaryButton(
                            text: 'Apply',
                            height: 44,
                            fontSize: 13,
                            onPressed: controller.applyForLoan,
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            height: 38,
                            child: OutlinedButton(
                              onPressed: () =>
                                  Get.offAllNamed(AppRoutes.dashboard),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: darkText,
                                side: const BorderSide(color: blue),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(fontSize: 11),
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
          ],
        ),
      ),
    );
  }

  Widget _infoChip(String text) {
    return Container(
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F8FE),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: const Color(0xFF72B7F7),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 9.5,
          color: Color(0xFF008FBB),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
