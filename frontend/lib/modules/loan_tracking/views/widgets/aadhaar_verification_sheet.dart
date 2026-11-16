import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controllers/application_status_controller.dart';

class AadhaarVerificationSheet extends StatelessWidget {
  final ApplicationStatusController controller;

  const AadhaarVerificationSheet({
    super.key,
    required this.controller,
  });

  static const Color blue = Color(0xFF087AFF);
  static const Color green = Color(0xFF00A36C);
  static const Color darkText = Color(0xFF263238);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Color(0x1F000000),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(
        22,
        14,
        22,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFD6DBE1),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Sheet Header with Icon
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.fingerprint,
                    color: blue,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Aadhaar e-KYC Verification',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: darkText,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Instant UIDAI Identity Verification',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF78838F),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 22),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Step Content
            Obx(() {
              if (!controller.isAadhaarOtpSent.value) {
                return _buildAadhaarInputStep(context);
              } else {
                return _buildOtpVerificationStep(context);
              }
            }),
          ],
        ),
      ),
    );
  }

  // Step 1: Enter 12-digit Aadhaar Number
  Widget _buildAadhaarInputStep(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '12-Digit Aadhaar Number',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: darkText,
          ),
        ),
        const SizedBox(height: 8),

        TextField(
          controller: controller.aadhaarController,
          keyboardType: TextInputType.number,
          maxLength: 14, // 12 digits + 2 spaces
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            AadhaarInputFormatter(),
          ],
          style: const TextStyle(
            fontSize: 17,
            letterSpacing: 2,
            fontWeight: FontWeight.w600,
            color: darkText,
          ),
          decoration: InputDecoration(
            counterText: '',
            hintText: 'XXXX  XXXX  XXXX',
            hintStyle: TextStyle(
              fontSize: 15,
              letterSpacing: 2,
              color: Colors.grey.shade400,
            ),
            prefixIcon: const Icon(
              Icons.credit_card_outlined,
              color: blue,
              size: 22,
            ),
            filled: true,
            fillColor: const Color(0xFFF7F9FB),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE2E7ED)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE2E7ED)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: blue, width: 1.6),
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Consent checkbox
        Obx(
          () => InkWell(
            onTap: () =>
                controller.aadhaarConsent.value = !controller.aadhaarConsent.value,
            borderRadius: BorderRadius.circular(6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: Checkbox(
                    value: controller.aadhaarConsent.value,
                    activeColor: blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    onChanged: (val) =>
                        controller.aadhaarConsent.value = val ?? false,
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'I hereby give consent to CreditSea to use my Aadhaar number for e-KYC authentication with UIDAI under the Aadhaar Act.',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF6C757D),
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 22),

        // Submit Button
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: controller.requestAadhaarOtp,
            style: ElevatedButton.styleFrom(
              backgroundColor: blue,
              foregroundColor: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Request Aadhaar OTP',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Step 2: Enter 6-digit Aadhaar OTP
  Widget _buildOtpVerificationStep(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Aadhaar: ${controller.aadhaarController.text}',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: darkText,
              ),
            ),
            GestureDetector(
              onTap: () => controller.isAadhaarOtpSent.value = false,
              child: const Text(
                'Change',
                style: TextStyle(
                  fontSize: 12,
                  color: blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        const Text(
          'Enter 6-Digit Aadhaar OTP',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: darkText,
          ),
        ),
        const SizedBox(height: 8),

        TextField(
          controller: controller.aadhaarOtpController,
          keyboardType: TextInputType.number,
          maxLength: 6,
          textAlign: TextAlign.center,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          style: const TextStyle(
            fontSize: 22,
            letterSpacing: 8,
            fontWeight: FontWeight.bold,
            color: darkText,
          ),
          decoration: InputDecoration(
            counterText: '',
            hintText: '• • • • • •',
            hintStyle: TextStyle(
              fontSize: 20,
              letterSpacing: 8,
              color: Colors.grey.shade400,
            ),
            filled: true,
            fillColor: const Color(0xFFF7F9FB),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE2E7ED)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE2E7ED)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: blue, width: 1.6),
            ),
          ),
        ),
        const SizedBox(height: 8),

        const Row(
          children: [
            Icon(Icons.info_outline, size: 14, color: Color(0xFF78838F)),
            SizedBox(width: 5),
            Text(
              'Demo OTP: Enter any 6 digits (e.g. 123456)',
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFF78838F),
              ),
            ),
          ],
        ),
        const SizedBox(height: 22),

        // Verify Button
        Obx(
          () => SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: controller.isVerifyingAadhaar.value
                  ? null
                  : controller.verifyAadhaarOtp,
              style: ElevatedButton.styleFrom(
                backgroundColor: green,
                foregroundColor: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: controller.isVerifyingAadhaar.value
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Verify & Complete e-KYC',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
