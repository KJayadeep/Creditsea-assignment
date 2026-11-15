
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../core/widgets/registration_progress.dart';
import '../controllers/pan_verification_controller.dart';

class PanVerificationView extends StatelessWidget {
  PanVerificationView({super.key});

  final PanVerificationController controller =
      Get.put(PanVerificationController());

  static const Color primaryBlue = Color(0xFF087AFF);
  static const Color primaryText = Color(0xFF383838);
  static const Color borderColor = Color(0xFFEAEAEA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Registration progress
            const RegistrationProgress(activeStep: 1),

            // Main content
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x08000000),
                      blurRadius: 15,
                      offset: Offset(0, -4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        25, 24, 20, 0,
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: const Icon(
                              Icons.arrow_back,
                              size: 23,
                              color: primaryText,
                            ),
                          ),
                          const SizedBox(width: 17),
                          const Text(
                            'Verify PAN Number',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: primaryText,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // PAN card illustration
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 22,
                          bottom: 25,
                        ),
                        child: SizedBox(
                          width: 200,
                          height: 165,
                          child: SvgPicture.asset(
                            'assets/images/pan_card.svg',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),

                    // PAN input
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Enter Your PAN Number*',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: primaryText,
                            ),
                          ),

                          const SizedBox(height: 13),

                          TextField(
                            controller: controller.panController,
                            textCapitalization:
                                TextCapitalization.characters,
                            keyboardType: TextInputType.text,
                            maxLength: 10,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z0-9]'),
                              ),
                              UpperCaseTextFormatter(),
                            ],
                            decoration: InputDecoration(
                              hintText: 'e.g., ABCDE1234F',
                              counterText: '',
                              hintStyle: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF999999),
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 15,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                                borderSide: const BorderSide(
                                  color: borderColor,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                                borderSide: const BorderSide(
                                  color: primaryBlue,
                                ),
                              ),
                            ),
                          ),

                          Obx(
                            () => controller.isVerified.value
                                ? const Padding(
                                    padding: EdgeInsets.only(top: 12),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                          size: 18,
                                        ),
                                        SizedBox(width: 7),
                                        Text(
                                          'PAN verified successfully',
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    // Verify button
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        25, 12, 25, 58,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: 51,
                        child: Obx(
                          () => ElevatedButton(
                            onPressed: controller.isVerified.value
                                ? null
                                : controller.verifyPan,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryBlue,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: Colors.green,
                              elevation: 3,
                              shadowColor:
                                  primaryBlue.withValues(alpha: 0.3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7),
                              ),
                            ),
                            child: Text(
                              controller.isVerified.value
                                  ? 'Verified'
                                  : 'Verify',
                              style: const TextStyle(
                                fontSize: 15,
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
            ),
          ],
        ),
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
