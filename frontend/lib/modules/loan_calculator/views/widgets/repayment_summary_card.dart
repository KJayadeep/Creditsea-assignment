import 'package:flutter/material.dart';

class RepaymentSummaryCard extends StatelessWidget {
  final String principal;
  final String interest;
  final String processingFee;
  final String totalPayable;
  final Color borderColor;

  const RepaymentSummaryCard({
    super.key,
    required this.principal,
    required this.interest,
    required this.processingFee,
    required this.totalPayable,
    this.borderColor = const Color(0xFF087AFF),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          _row('Principal Amount', principal),
          const SizedBox(height: 9),
          _row('Interest', interest),
          const SizedBox(height: 9),
          _row('Processing Fee', processingFee),
          const SizedBox(height: 9),
          _row('Total Payable', totalPayable, isBold: true),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: const Color(0xFF383838),
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 10,
            color: const Color(0xFF383838),
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
