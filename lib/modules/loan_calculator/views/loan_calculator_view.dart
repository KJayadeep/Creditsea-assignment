
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../controllers/loan_calculator_controller.dart';
import '../../loan_application/views/loan_offer_view.dart';

class LoanCalculatorView extends StatelessWidget {
  LoanCalculatorView({super.key});

  final LoanCalculatorController controller =
      Get.put(LoanCalculatorController());

  static const Color blue = Color(0xFF087AFF);
  static const Color darkText = Color(0xFF383838);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // CreditSea logo
            SizedBox(
              height: 82,
              child: Center(
                child: SvgPicture.asset(
                  'assets/images/logo-3.svg',
                  width: 160,
                  height: 45,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // Main loan calculator panel
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(25),
                  ),
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
                        padding: const EdgeInsets.fromLTRB(
                          16, 15, 16, 12,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Heading
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => Get.back(),
                                  child: const Icon(
                                    Icons.arrow_back,
                                    size: 21,
                                    color: darkText,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Apply for loan',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: darkText,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 5),

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

                            // Interest and processing fee
                            Row(
                              children: [
                                Expanded(
                                  child: _infoChip(
                                    'Interest Per Day 1%',
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _infoChip(
                                    'Processing Fee 10%',
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 17),
                            const Divider(color: Color(0xFFEEEEEE)),
                            const SizedBox(height: 15),

                            // Loan purpose
                            const Text(
                              'Purpose of Loan*',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: darkText,
                              ),
                            ),

                            const SizedBox(height: 9),

                            Obx(
                              () => Container(
                                height: 36,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0xFFEAEAEA),
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: controller
                                            .selectedPurpose.value.isEmpty
                                        ? null
                                        : controller.selectedPurpose.value,
                                    isExpanded: true,
                                    hint: const Text(
                                      'Select purpose of loan',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down,
                                      size: 18,
                                    ),
                                    items: controller.loanPurposes.map(
                                      (purpose) {
                                        return DropdownMenuItem<String>(
                                          value: purpose,
                                          child: Text(
                                            purpose,
                                            style: const TextStyle(
                                              fontSize: 11,
                                            ),
                                          ),
                                        );
                                      },
                                    ).toList(),
                                    onChanged: (value) {
                                      controller.selectedPurpose.value =
                                          value ?? '';
                                    },
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 18),

                            // Principal amount
                            Obx(
                              () => Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Principal Amount',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: darkText,
                                        ),
                                      ),
                                      _valueBox(
                                        controller.formatCurrency(
                                          controller.principalAmount.value,
                                        ),
                                      ),
                                    ],
                                  ),

                                  SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      trackHeight: 5,
                                      thumbShape:
                                          const RectangularSliderThumb(
                                        width: 3,
                                        height: 22,
                                      ),
                                      overlayShape:
                                          SliderComponentShape.noOverlay,
                                      activeTrackColor: blue,
                                      inactiveTrackColor:
                                          const Color(0xFFE6F0FF),
                                      thumbColor: blue,
                                    ),
                                    child: Slider(
                                      min: 5000,
                                      max: 100000,
                                      divisions: 95,
                                      value: controller.principalAmount.value,
                                      onChanged:
                                          controller.updatePrincipal,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 4),

                            // Tenure
                            Obx(
                              () => Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Tenure',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: darkText,
                                        ),
                                      ),
                                      _valueBox(
                                        '${controller.tenure.value.toInt()} Days',
                                      ),
                                    ],
                                  ),

                                  SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      trackHeight: 5,
                                      thumbShape:
                                          const RectangularSliderThumb(
                                        width: 3,
                                        height: 22,
                                      ),
                                      overlayShape:
                                          SliderComponentShape.noOverlay,
                                      activeTrackColor: blue,
                                      inactiveTrackColor:
                                          const Color(0xFFE6F0FF),
                                      thumbColor: blue,
                                    ),
                                    child: Slider(
                                      min: 20,
                                      max: 45,
                                      divisions: 25,
                                      value: controller.tenure.value,
                                      onChanged: controller.updateTenure,
                                    ),
                                  ),

                                  const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '20 Days',
                                        style: TextStyle(fontSize: 8),
                                      ),
                                      Text(
                                        '45 Days',
                                        style: TextStyle(fontSize: 8),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 25),

                            // Repayment summary
                            Obx(
                              () => Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(11),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: blue,
                                    width: 1,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x08000000),
                                      blurRadius: 5,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    _summaryRow(
                                      'Principal Amount',
                                      controller.formatCurrency(
                                        controller.principalAmount.value,
                                      ),
                                    ),
                                    const SizedBox(height: 9),
                                    _summaryRow(
                                      'Interest',
                                      controller.formatCurrency(
                                        controller.interest,
                                      ),
                                    ),
                                    const SizedBox(height: 9),
                                    _summaryRow(
                                      'Processing Fee',
                                      controller.formatCurrency(
                                        controller.processingFee,
                                      ),
                                    ),
                                    const SizedBox(height: 9),
                                    _summaryRow(
                                      'Total Payable',
                                      controller.formatCurrency(
                                        controller.totalPayable,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 18),

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

                    // Bottom actions
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        16, 5, 16, 16,
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 42,
                            child: ElevatedButton(
                              onPressed: controller.applyForLoan,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: blue,
                                foregroundColor: Colors.white,
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              child: const Text(
                                'Apply',
                                style: TextStyle(fontSize: 11),
                              ),
                            ),
                          ),

                          const SizedBox(height: 9),

                          SizedBox(
                            width: double.infinity,
                            height: 35,
                            child: OutlinedButton(
                              onPressed: () => Get.back(),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: darkText,
                                side: const BorderSide(color: blue),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(fontSize: 10),
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
      height: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFF72B7F7),
          style: BorderStyle.solid,
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 9,
          color: darkText,
        ),
      ),
    );
  }

  Widget _valueBox(String value) {
    return Container(
      constraints: const BoxConstraints(minWidth: 68),
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFEAEAEA)),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        value,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 10,
          color: darkText,
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: darkText,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF087AFF),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// Rectangular slider thumb similar to the Figma design.
class RectangularSliderThumb extends SliderComponentShape {
  final double width;
  final double height;

  const RectangularSliderThumb({
    this.width = 3,
    this.height = 22,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(width, height);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final paint = Paint()
      ..color = sliderTheme.thumbColor ?? const Color(0xFF087AFF);

    context.canvas.drawRect(
      Rect.fromCenter(
        center: center,
        width: width,
        height: height,
      ),
      paint,
    );
  }
}
