import 'package:flutter/material.dart';
import 'package:creditsea_app/core/theme/app_colors.dart';

class LoanOverviewCard extends StatelessWidget {
  const LoanOverviewCard({super.key, required this.loan});
  final Map<String, dynamic>? loan;

  @override
  Widget build(BuildContext context) {
    final amount = (loan?['principalAmount'] as num?)?.toDouble() ?? 0;
    final number = loan?['applicationNumber']?.toString() ?? 'N/A';
    final status = loan?['status']?.toString() ?? 'Submitted';
    final purpose = loan?['purpose']?.toString() ?? '';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'YOUR LOAN OVERVIEW',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              letterSpacing: 1,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            loan == null ? 'No loan applications yet' : '₹${amount.toStringAsFixed(0)}',
            style: const TextStyle(color: Colors.white, fontSize: 27, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(
            loan == null
                ? 'Apply for a loan to see your details here.'
                : 'Requested loan amount${purpose.isEmpty ? '' : ' • $purpose'}',
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          if (loan != null) ...[
            const SizedBox(height: 20),
            Container(height: 1, color: Colors.white24),
            const SizedBox(height: 15),
            Row(
              children: [
                const Icon(Icons.receipt_long_outlined, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(number, overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontSize: 12)),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(status, overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class LoanOverviewLoading extends StatelessWidget {
  const LoanOverviewLoading({super.key});

  @override
  Widget build(BuildContext context) => Container(
        height: 190,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(22),
        ),
        child: const Center(child: CircularProgressIndicator(color: Colors.white)),
      );
}
