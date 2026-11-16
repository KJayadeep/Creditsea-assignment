import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class OtpInputRow extends StatelessWidget {
  final int length;
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final void Function(String value, int index) onChanged;
  final double boxWidth;
  final double boxHeight;

  const OtpInputRow({
    super.key,
    required this.length,
    required this.controllers,
    required this.focusNodes,
    required this.onChanged,
    this.boxWidth = 52,
    this.boxHeight = 52,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        length,
        (index) => Container(
          width: boxWidth,
          height: boxHeight,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          child: TextField(
            controller: controllers[index],
            focusNode: focusNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
            decoration: InputDecoration(
              counterText: '',
              contentPadding: EdgeInsets.zero,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: AppColors.action,
                  width: 1.5,
                ),
              ),
            ),
            onChanged: (value) => onChanged(value, index),
          ),
        ),
      ),
    );
  }
}
