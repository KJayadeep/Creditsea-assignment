import 'package:flutter/material.dart';
import 'package:creditsea_app/core/theme/app_colors.dart';

class LoanCard extends StatelessWidget {
  const LoanCard({super.key, required this.loan, required this.onViewStatus});
  final Map<String, dynamic> loan;
  final VoidCallback onViewStatus;

  @override
  Widget build(BuildContext context) {
    final amount = (loan['principalAmount'] as num?)?.toDouble() ?? 0;
    final total = (loan['totalPayable'] as num?)?.toDouble() ?? 0;
    final purpose = loan['purpose']?.toString() ?? 'Loan';
    final number = loan['applicationNumber']?.toString() ?? 'N/A';
    final status = loan['status']?.toString() ?? 'Submitted';
    final color = loanStatusColor(status);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(purpose, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(20)),
                child: Text(status, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text('₹${amount.toStringAsFixed(0)}', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.primary)),
          const SizedBox(height: 5),
          const Text('Requested loan amount', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          const SizedBox(height: 16),
          const Divider(color: Color(0xFFEEEEEE)),
          const SizedBox(height: 12),
          _DetailRow(label: 'Application number', value: number),
          const SizedBox(height: 10),
          _DetailRow(label: 'Total repayment', value: '₹${total.toStringAsFixed(0)}'),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 42,
            child: OutlinedButton(
              onPressed: onViewStatus,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.actionBlue,
                side: const BorderSide(color: AppColors.actionBlue),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('View Application Status', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          const SizedBox(width: 12),
          Flexible(
            child: Text(value, textAlign: TextAlign.end,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          ),
        ],
      );
}

Color loanStatusColor(String status) {
  switch (status) {
    case 'Approved':
    case 'Disbursed':
    case 'Repaid':
      return Colors.green;
    case 'Rejected':
      return Colors.red;
    case 'Under Review':
      return Colors.orange;
    default:
      return AppColors.actionBlue;
  }
}
