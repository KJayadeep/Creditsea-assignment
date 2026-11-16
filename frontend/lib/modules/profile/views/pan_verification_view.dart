import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../core/components/app_header.dart';
import '../../../core/components/custom_text_input.dart';
import '../../../core/components/primary_button.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/registration_progress.dart';
import '../controllers/pan_verification_controller.dart';

class PanVerificationView extends StatelessWidget {
  PanVerificationView({super.key});

  final PanVerificationController controller =
      Get.isRegistered<PanVerificationController>()
          ? Get.find<PanVerificationController>()
          : Get.put(PanVerificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const RegistrationProgress(activeStep: 1),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x08000000),
                      blurRadius: 15,
                      offset: Offset(0, -4),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(24, 24, 20, 0),
                        child: AppHeader(
                          title: 'Verify PAN Number',
                          fontSize: 20,
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: SizedBox(
                            width: 200,
                            height: 160,
                            child: SvgPicture.asset(
                              'assets/images/pan_card.svg',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextInput(
                              label: 'Enter Your PAN Number*',
                              hintText: 'e.g., ABCDE1234F',
                              controller: controller.panController,
                              textCapitalization: TextCapitalization.characters,
                              maxLength: 10,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[a-zA-Z0-9]'),
                                ),
                                UpperCaseTextFormatter(),
                              ],
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
                      const SizedBox(height: 36),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
                        child: Obx(
                          () => PrimaryButton(
                            text: controller.isVerified.value
                                ? 'Verified'
                                : 'Verify',
                            isLoading: controller.isLoading.value,
                            backgroundColor: controller.isVerified.value
                                ? Colors.green
                                : AppColors.action,
                            onPressed: controller.isVerified.value
                                ? null
                                : controller.verifyPan,
                            height: 50,
                          ),
                        ),
                      ),
                    ],
                  ),
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
