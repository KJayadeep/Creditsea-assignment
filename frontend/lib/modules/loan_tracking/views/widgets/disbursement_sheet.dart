import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/application_status_controller.dart';

class DisbursementSheet extends StatefulWidget {
  final ApplicationStatusController controller;

  const DisbursementSheet({
    super.key,
    required this.controller,
  });

  @override
  State<DisbursementSheet> createState() => _DisbursementSheetState();
}

class _DisbursementSheetState extends State<DisbursementSheet> {
  static const Color blue = Color(0xFF087AFF);
  static const Color green = Color(0xFF00A36C);
  static const Color darkText = Color(0xFF263238);

  bool isDisbursing = false;

  double get principal =>
      (widget.controller.loan['principalAmount'] as num?)?.toDouble() ?? 30000.0;
  double get processingFee =>
      (widget.controller.loan['processingFee'] as num?)?.toDouble() ?? 3000.0;

  Future<void> _handleDisburse() async {
    setState(() => isDisbursing = true);

    await Future.delayed(const Duration(milliseconds: 1400));

    if (!mounted) return;
    setState(() => isDisbursing = false);

    Get.back(); // Close bottom sheet
    await widget.controller.completeDisbursement();
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
                    color: green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.payments_outlined,
                    color: green,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Instant Loan Disbursement',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: darkText,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Direct IMPS credit to your verified bank account',
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

            // Disbursement Details Box
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
                        'Net Disbursable Amount',
                        style: TextStyle(fontSize: 13, color: Color(0xFF6C757D)),
                      ),
                      Text(
                        '₹${principal.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: green,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Destination Bank',
                        style: TextStyle(fontSize: 12, color: Color(0xFF6C757D)),
                      ),
                      Text(
                        'HDFC Bank (•••• 4291)',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: darkText),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Transfer Mode',
                        style: TextStyle(fontSize: 12, color: Color(0xFF6C757D)),
                      ),
                      Text(
                        'IMPS 24×7 Instant',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: blue),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Estimated Credit Time',
                        style: TextStyle(fontSize: 12, color: Color(0xFF6C757D)),
                      ),
                      Text(
                        '< 60 Seconds',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: darkText),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            const Row(
              children: [
                Icon(Icons.verified_user_outlined, size: 14, color: green),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'RBI NBFC Digital Lending Guidelines compliant payout.',
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
                onPressed: isDisbursing ? null : _handleDisburse,
                style: ElevatedButton.styleFrom(
                  backgroundColor: green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: isDisbursing
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Disbursing to Bank Account...',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                        ],
                      )
                    : Text(
                        'Disburse ₹${principal.toStringAsFixed(0)} Now',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
