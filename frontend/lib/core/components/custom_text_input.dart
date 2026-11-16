import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';

class CustomTextInput extends StatelessWidget {
  final String? label;
  final String hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final int? maxLength;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChanged;
  final bool readOnly;
  final VoidCallback? onTap;

  const CustomTextInput({
    super.key,
    this.label,
    required this.hintText,
    this.controller,
    this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.prefixIcon,
    this.maxLength,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.onChanged,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF383838),
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: controller,
          validator: validator,
          obscureText: obscureText,
          keyboardType: keyboardType,
          maxLength: maxLength,
          textCapitalization: textCapitalization,
          inputFormatters: inputFormatters,
          onChanged: onChanged,
          readOnly: readOnly,
          onTap: onTap,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF333333),
          ),
          decoration: InputDecoration(
            counterText: '',
            hintText: hintText,
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
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
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
      ],
    );
  }
}
