import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onBack;
  final Widget? trailing;
  final double fontSize;
  final Color textColor;

  const AppHeader({
    super.key,
    required this.title,
    this.onBack,
    this.trailing,
    this.fontSize = 19,
    this.textColor = const Color(0xFF383838),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onBack ?? Get.back,
          behavior: HitTestBehavior.opaque,
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 2),
            child: Icon(
              Icons.arrow_back,
              size: 23,
              color: Color(0xFF333333),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ),
        ?trailing,
      ],
    );
  }
}
