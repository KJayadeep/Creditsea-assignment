import 'package:flutter/material.dart';
import 'package:creditsea_app/core/theme/app_colors.dart';
import 'empty_state.dart';
import 'loan_card.dart';

class RecentActivity extends StatelessWidget {
  const RecentActivity({
    super.key,
    required this.loans,
    required this.isLoading,
    required this.error,
    required this.onRetry,
  });

  final List<Map<String, dynamic>> loans;
  final bool isLoading;
  final String error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (isLoading && loans.isEmpty) {
      content = const Center(child: Padding(
        padding: EdgeInsets.all(18),
        child: CircularProgressIndicator(color: AppColors.primary),
      ));
    } else if (error.isNotEmpty && loans.isEmpty) {
      content = _ActivityError(message: error, onRetry: onRetry);
    } else if (loans.isEmpty) {
      content = const EmptyState(
        title: 'No recent activity',
        message: 'Your loan application updates will appear here.',
      );
    } else {
      content = Column(
        children: loans.map((loan) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: LoanActivityTile(loan: loan),
        )).toList(),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Recent Activity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        const SizedBox(height: 15),
        content,
      ],
    );
  }
}

class LoanActivityTile extends StatelessWidget {
  const LoanActivityTile({super.key, required this.loan});
  final Map<String, dynamic> loan;

  @override
  Widget build(BuildContext context) {
    final amount = (loan['principalAmount'] as num?)?.toDouble() ?? 0;
    final number = loan['applicationNumber']?.toString() ?? 'N/A';
    final status = loan['status']?.toString() ?? 'Submitted';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          const Icon(Icons.account_balance_wallet_outlined, color: AppColors.actionBlue, size: 25),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Loan ₹${amount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Text(number, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(status, textAlign: TextAlign.end,
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: loanStatusColor(status))),
          ),
        ],
      ),
    );
  }
}

class _ActivityError extends StatelessWidget {
  const _ActivityError({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
            TextButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      );
}
