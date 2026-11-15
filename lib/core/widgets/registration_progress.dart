import 'package:flutter/material.dart';

class RegistrationProgress extends StatelessWidget {
  final int activeStep;

  const RegistrationProgress({
    super.key,
    this.activeStep = 1,
  });

  static const Color activeColor = Color(0xFF087AFF);
  static const Color inactiveColor = Color(0xFFEEEEEE);
  static const Color inactiveText = Color(0xFF888888);
  static const Color inactiveNumber = Color(0xFF555555);

  static const List<String> steps = [
    'Register',
    'Offer',
    'Approval',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(steps.length, (index) {
          final stepNumber = index + 1;
          final isActive = stepNumber == activeStep; // only current step is blue

          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive ? activeColor : inactiveColor,
                ),
                child: Text(
                  '$stepNumber',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isActive ? Colors.white : inactiveNumber,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                steps[index],
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isActive ? activeColor : inactiveText,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}