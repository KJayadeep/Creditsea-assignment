import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/application_status_controller.dart';

class ENachSetupSheet extends StatefulWidget {
  final ApplicationStatusController controller;

  const ENachSetupSheet({
    super.key,
    required this.controller,
  });

  @override
  State<ENachSetupSheet> createState() => _ENachSetupSheetState();
}

class _ENachSetupSheetState extends State<ENachSetupSheet> {
  static const Color blue = Color(0xFF087AFF);
  static const Color green = Color(0xFF00A36C);
  static const Color darkText = Color(0xFF263238);

  int selectedMethod = 0; // 0: UPI AutoPay, 1: NetBanking / Debit Card
  final upiController = TextEditingController(text: 'user@okhdfcbank');
  final bankAccountController = TextEditingController(text: '•••• •••• 4291');
  final ifscController = TextEditingController(text: 'HDFC0001234');
  bool isAuthenticating = false;

  @override
  void dispose() {
    upiController.dispose();
    bankAccountController.dispose();
    ifscController.dispose();
    super.dispose();
  }

  double get totalPayable =>
      (widget.controller.loan['totalPayable'] as num?)?.toDouble() ?? 45000.0;

  Future<void> _handleSetup() async {
    setState(() => isAuthenticating = true);

    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;
    setState(() => isAuthenticating = false);

    Get.back(); // Close bottom sheet
    widget.controller.completeENachSetup();
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
                    Icons.account_balance_outlined,
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
                        'Set Up Auto-Debit (E-Nach)',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: darkText,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Auto-debit on due date via Razorpay e-Mandate',
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

            // Mandate Summary Card
            Container(
              padding: const EdgeInsets.all(16),
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
                        'Auto-Debit Amount',
                        style: TextStyle(fontSize: 13, color: Color(0xFF6C757D)),
                      ),
                      Text(
                        '₹${totalPayable.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: darkText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Frequency',
                        style: TextStyle(fontSize: 13, color: Color(0xFF6C757D)),
                      ),
                      Text(
                        'On Due Date Only',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Gateway Partner',
                        style: TextStyle(fontSize: 13, color: Color(0xFF6C757D)),
                      ),
                      Text(
                        'Razorpay e-Mandate',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: blue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Method Selector: UPI AutoPay vs NetBanking
            const Text(
              'Select Auto-Debit Method',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: darkText,
              ),
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => selectedMethod = 0),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: selectedMethod == 0
                            ? blue.withValues(alpha: 0.08)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: selectedMethod == 0
                              ? blue
                              : const Color(0xFFE2E7ED),
                          width: selectedMethod == 0 ? 1.8 : 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.mobile_friendly_outlined,
                            color: selectedMethod == 0 ? blue : const Color(0xFF78838F),
                            size: 22,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'UPI AutoPay',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: selectedMethod == 0 ? blue : darkText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => selectedMethod = 1),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: selectedMethod == 1
                            ? blue.withValues(alpha: 0.08)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: selectedMethod == 1
                              ? blue
                              : const Color(0xFFE2E7ED),
                          width: selectedMethod == 1 ? 1.8 : 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.credit_card_outlined,
                            color: selectedMethod == 1 ? blue : const Color(0xFF78838F),
                            size: 22,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'NetBanking / Card',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: selectedMethod == 1 ? blue : darkText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            if (selectedMethod == 0) ...[
              const Text(
                'UPI ID (VPA)',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: darkText),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: upiController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.alternate_email, size: 20, color: blue),
                  hintText: 'e.g. mobile@upi',
                  filled: true,
                  fillColor: const Color(0xFFF7F9FB),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFE2E7ED)),
                  ),
                ),
              ),
            ] else ...[
              const Text(
                'Bank Account',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: darkText),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: bankAccountController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.account_balance, size: 20, color: blue),
                  filled: true,
                  fillColor: const Color(0xFFF7F9FB),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFE2E7ED)),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 14),

            const Row(
              children: [
                Icon(Icons.lock_outline, size: 14, color: green),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Razorpay e-Mandate: Auto-debit occurs only on your loan due date.',
                    style: TextStyle(fontSize: 11, color: Color(0xFF6C757D)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isAuthenticating ? null : _handleSetup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: isAuthenticating
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Authenticate Auto-Debit with Razorpay',
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
