import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class BottomSheetContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double topBorderWidth;
  final Color topBorderColor;
  final double borderRadius;

  const BottomSheetContainer({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.topBorderWidth = 4,
    this.topBorderColor = AppColors.accent,
    this.borderRadius = 18,
  });

  @override
  Widget build(BuildContext context) {
    if (topBorderWidth <= 0) {
      return Container(
        width: double.infinity,
        padding: padding,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(borderRadius),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0C000000),
              blurRadius: 14,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: child,
      );
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: topBorderColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(borderRadius),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 14,
            offset: Offset(0, -3),
          ),
        ],
      ),
      padding: EdgeInsets.only(top: topBorderWidth),
      child: Container(
        width: double.infinity,
        padding: padding,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(borderRadius > topBorderWidth ? borderRadius - topBorderWidth : 0),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: child,
      ),
    );
  }
}
