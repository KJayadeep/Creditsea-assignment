import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_colors.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    super.key,
    required this.userName,
    required this.onProfileTap,
  });

  final String userName;
  final VoidCallback onProfileTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top bar with CreditSea logo (logo-3.svg) and Profile avatar button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/logo-3.svg',
              height: 38,
              fit: BoxFit.contain,
            ),
            Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              elevation: 1,
              shadowColor: Colors.black12,
              child: InkWell(
                onTap: onProfileTap,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE8EEF5)),
                  ),
                  child: const Icon(
                    Icons.person_outline,
                    color: AppColors.primary,
                    size: 26,
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 22),

        // User greeting
        const Text(
          'Welcome back,',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Hello, $userName 👋',
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }
}
