import 'package:flutter/material.dart';

class StatusStepCard extends StatelessWidget {
  final String title;
  final Color color;
  final bool isCompleted;
  final bool isCurrent;
  final VoidCallback? onTap;

  const StatusStepCard({
    super.key,
    required this.title,
    required this.color,
    required this.isCompleted,
    required this.isCurrent,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(7),
        child: Container(
          width: double.infinity,
          height: 46,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: color,
              width: 1.8,
            ),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Row(
            children: [
              const SizedBox(width: 16),
              Icon(
                isCompleted
                    ? Icons.assignment_turned_in_outlined
                    : Icons.assignment_outlined,
                color: color,
                size: 23,
              ),
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (onTap != null)
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Icon(
                    Icons.chevron_right,
                    size: 18,
                    color: color,
                  ),
                )
              else
                const SizedBox(width: 30),
            ],
          ),
        ),
      ),
    );
  }
}
