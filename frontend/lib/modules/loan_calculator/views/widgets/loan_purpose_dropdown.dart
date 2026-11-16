import 'package:flutter/material.dart';

class LoanPurposeDropdown extends StatelessWidget {
  final String? selectedValue;
  final List<String> purposes;
  final void Function(String?) onChanged;

  const LoanPurposeDropdown({
    super.key,
    required this.selectedValue,
    required this.purposes,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Purpose of Loan*',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Color(0xFF383838),
          ),
        ),
        const SizedBox(height: 9),
        Container(
          height: 38,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFEAEAEA)),
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedValue?.isEmpty ?? true ? null : selectedValue,
              isExpanded: true,
              hint: const Text(
                'Select purpose of loan',
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
              icon: const Icon(Icons.keyboard_arrow_down, size: 18),
              items: purposes.map((purpose) {
                return DropdownMenuItem<String>(
                  value: purpose,
                  child: Text(
                    purpose,
                    style: const TextStyle(fontSize: 11),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
