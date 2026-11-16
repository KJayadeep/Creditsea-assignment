import 'package:flutter/material.dart';
import 'package:creditsea_app/core/theme/app_colors.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.title,
    required this.message,
    this.buttonLabel,
    this.onAction,
  });

  final String title;
  final String message;
  final String? buttonLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
        child: Column(
          children: [
            const Icon(Icons.receipt_long_outlined, size: 45, color: AppColors.textSecondary),
            const SizedBox(height: 14),
            Text(title, textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
            if (buttonLabel != null && onAction != null) ...[
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.add),
                label: Text(buttonLabel!),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.actionBlue, foregroundColor: Colors.white),
              ),
            ],
          ],
        ),
      );
}

class ErrorState extends StatelessWidget {
  const ErrorState({
    super.key,
    required this.message,
    required this.onRetry,
    this.dark = false,
  });

  final String message;
  final VoidCallback onRetry;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final foreground = dark ? Colors.white : AppColors.textPrimary;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: dark ? AppColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(Icons.error_outline, color: foreground, size: 32),
          const SizedBox(height: 10),
          Text(message, textAlign: TextAlign.center, style: TextStyle(color: foreground)),
          TextButton(onPressed: onRetry, child: Text('Retry', style: TextStyle(color: foreground))),
        ],
      ),
    );
  }
}
