import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/application_status_controller.dart';

class ESignAgreementSheet extends StatefulWidget {
  final ApplicationStatusController controller;

  const ESignAgreementSheet({
    super.key,
    required this.controller,
  });

  @override
  State<ESignAgreementSheet> createState() => _ESignAgreementSheetState();
}

class _ESignAgreementSheetState extends State<ESignAgreementSheet> {
  static const Color blue = Color(0xFF087AFF);
  static const Color darkText = Color(0xFF263238);

  bool consentAgreed = true;
  bool isSigning = false;
  final signatureNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    signatureNameController.text =
        widget.controller.loan['borrowerName']?.toString() ?? 'Authorized Borrower';
  }

  @override
  void dispose() {
    signatureNameController.dispose();
    super.dispose();
  }

  double get principal =>
      (widget.controller.loan['principalAmount'] as num?)?.toDouble() ?? 30000.0;
  int get tenure =>
      (widget.controller.loan['tenure'] as num?)?.toInt() ?? 30;
  double get totalPayable =>
      (widget.controller.loan['totalPayable'] as num?)?.toDouble() ?? 45000.0;

  Future<void> _handleSign() async {
    if (!consentAgreed) {
      Get.snackbar(
        'Consent Required',
        'Please check the consent box to e-sign the loan agreement.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.shade800,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    setState(() => isSigning = true);

    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;
    setState(() => isSigning = false);

    Get.back(); // Close bottom sheet
    widget.controller.completeESignAgreement();
  }

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

            // Header
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
                    Icons.draw_outlined,
                    color: blue,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'E-Sign Loan Agreement',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: darkText,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Electronic consent & execution of loan contract',
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
            const SizedBox(height: 18),

            // Loan Contract Summary Box
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F9FC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E7ED)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Principal Disbursable',
                        style: TextStyle(fontSize: 12, color: Color(0xFF6C757D)),
                      ),
                      Text(
                        '₹${principal.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: darkText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tenure & Interest',
                        style: TextStyle(fontSize: 12, color: Color(0xFF6C757D)),
                      ),
                      Text(
                        '$tenure Days (1% per day)',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: darkText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Repayable on Due Date',
                        style: TextStyle(fontSize: 12, color: Color(0xFF6C757D)),
                      ),
                      Text(
                        '₹${totalPayable.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: blue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Terms & Consent Text Box
            Container(
              height: 100,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFAFAFA),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE5E5E5)),
              ),
              child: const SingleChildScrollView(
                child: Text(
                  'DIGITAL LOAN SANCTION CONTRACT\n\n'
                  '1. By executing this electronic consent, the Borrower confirms the accuracy of all submitted KYC information.\n'
                  '2. The Borrower authorizes CreditSea NBFC to disburse the approved principal directly to the verified bank account.\n'
                  '3. The Borrower agrees to repay the total dues via registered e-Mandate / UPI AutoPay on the specified maturity date.\n'
                  '4. This electronic signature carries legal validity under Section 10A of the Information Technology Act, 2000.',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF555555),
                    height: 1.4,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Consent Checkbox
            InkWell(
              onTap: () => setState(() => consentAgreed = !consentAgreed),
              borderRadius: BorderRadius.circular(6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: Checkbox(
                      value: consentAgreed,
                      activeColor: blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      onChanged: (val) =>
                          setState(() => consentAgreed = val ?? false),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'I have read and agree to all terms of the CreditSea Loan Agreement. I authorize the e-signature & disbursement.',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: darkText,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isSigning ? null : _handleSign,
                style: ElevatedButton.styleFrom(
                  backgroundColor: blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: isSigning
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Digitally E-Sign & Accept Loan',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
