import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';

class PhoneInput extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const PhoneInput({
    super.key,
    required this.controller,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE0E0E0)),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('🇮🇳', style: TextStyle(fontSize: 18)),
              SizedBox(width: 8),
              Text(
                '+91',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.phone,
            maxLength: 10,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF333333),
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            onChanged: onChanged,
            validator: validator ??
                (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter mobile number';
                  }
                  if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value.trim())) {
                    return 'Enter a valid 10-digit number';
                  }
                  return null;
                },
            decoration: InputDecoration(
              counterText: '',
              hintText: 'Please enter your mobile no.',
              hintStyle: const TextStyle(
                fontSize: 13,
                color: Color(0xFFA0A0A0),
                fontWeight: FontWeight.w400,
              ),
              filled: true,
              fillColor: Colors.white,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
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
              errorStyle: const TextStyle(fontSize: 11),
            ),
          ),
        ),
      ],
    );
  }
}
