import 'package:flutter/material.dart';
import 'package:creditsea_app/core/theme/app_colors.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({
    super.key,
    required this.onApply,
    required this.onCalculator,
    required this.onMyLoans,
  });

  final VoidCallback onApply;
  final VoidCallback onCalculator;
  final VoidCallback onMyLoans;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Quick Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(child: _ActionCard(icon: Icons.add_circle_outline, title: 'Apply Loan', onTap: onApply)),
              const SizedBox(width: 12),
              Expanded(child: _ActionCard(icon: Icons.calculate_outlined, title: 'Calculator', onTap: onCalculator)),
              const SizedBox(width: 12),
              Expanded(child: _ActionCard(icon: Icons.description_outlined, title: 'My Loans', onTap: onMyLoans)),
            ],
          ),
        ],
      );
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({required this.icon, required this.title, required this.onTap});
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
            child: Column(
              children: [
                Icon(icon, color: AppColors.actionBlue, size: 28),
                const SizedBox(height: 10),
                Text(title, textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              ],
            ),
          ),
        ),
      );
}
