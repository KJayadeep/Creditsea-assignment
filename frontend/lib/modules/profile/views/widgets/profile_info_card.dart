import 'package:flutter/material.dart';

class ProfileFieldItem {
  final IconData icon;
  final String label;
  final dynamic value;

  ProfileFieldItem({
    required this.icon,
    required this.label,
    required this.value,
  });
}

class ProfileInfoCard extends StatelessWidget {
  final List<ProfileFieldItem> fields;
  final Color primaryColor;
  final Color textGrey;
  final Color textDark;

  const ProfileInfoCard({
    super.key,
    required this.fields,
    this.primaryColor = const Color(0xFF175397),
    this.textGrey = const Color(0xFF78838F),
    this.textDark = const Color(0xFF263238),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          for (int i = 0; i < fields.length; i++) ...[
            _row(fields[i]),
            if (i != fields.length - 1)
              const Divider(height: 1, color: Color(0xFFEEEEEE)),
          ],
        ],
      ),
    );
  }

  Widget _row(ProfileFieldItem field) {
    final value = field.value?.toString().trim();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Icon(field.icon, color: primaryColor, size: 21),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  field.label,
                  style: TextStyle(color: textGrey, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  value == null || value.isEmpty ? 'Not provided' : value,
                  style: TextStyle(
                    color: textDark,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (field.label == 'PAN Verification')
            Icon(
              value == 'Verified' ? Icons.check_circle : Icons.info_outline,
              color: value == 'Verified' ? Colors.green : Colors.orange,
              size: 19,
            ),
        ],
      ),
    );
  }
}
