import 'package:flutter/material.dart';

class LoanSlider extends StatelessWidget {
  final String title;
  final String valueDisplay;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final void Function(double) onChanged;
  final String? minLabel;
  final String? maxLabel;
  final Color activeColor;

  const LoanSlider({
    super.key,
    required this.title,
    required this.valueDisplay,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
    this.minLabel,
    this.maxLabel,
    this.activeColor = const Color(0xFF087AFF),
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF383838),
              ),
            ),
            Container(
              height: 25,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFCCCCCC)),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                valueDisplay,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF383838),
                ),
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 5,
            thumbShape: const RectangularSliderThumb(width: 3, height: 22),
            overlayShape: SliderComponentShape.noOverlay,
            activeTrackColor: activeColor,
            inactiveTrackColor: const Color(0xFFE6F0FF),
            thumbColor: activeColor,
          ),
          child: Slider(
            min: min,
            max: max,
            divisions: divisions,
            value: value,
            onChanged: onChanged,
          ),
        ),
        if (minLabel != null && maxLabel != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(minLabel!, style: const TextStyle(fontSize: 8)),
              Text(maxLabel!, style: const TextStyle(fontSize: 8)),
            ],
          ),
      ],
    );
  }
}

class RectangularSliderThumb extends SliderComponentShape {
  final double width;
  final double height;

  const RectangularSliderThumb({
    this.width = 4,
    this.height = 20,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) =>
      Size(width, height);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;
    final paint = Paint()
      ..color = sliderTheme.thumbColor ?? Colors.blue
      ..style = PaintingStyle.fill;

    final rect = Rect.fromCenter(
      center: center,
      width: width,
      height: height,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(2)),
      paint,
    );
  }
}
