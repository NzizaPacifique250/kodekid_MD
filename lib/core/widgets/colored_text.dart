import 'package:flutter/material.dart';
import '../constants/app_text_styles.dart';

class ColoredText extends StatelessWidget {
  final List<TextSegment> segments;
  final TextStyle? baseStyle;

  const ColoredText({
    super.key,
    required this.segments,
    this.baseStyle,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: baseStyle ?? AppTextStyles.heroHeadline(),
        children: segments.map((segment) {
          return TextSpan(
            text: segment.text,
            style: (baseStyle ?? AppTextStyles.heroHeadline()).copyWith(
              color: segment.color,
            ),
          );
        }).toList(),
      ),
    );
  }
}

class TextSegment {
  final String text;
  final Color color;

  TextSegment(this.text, this.color);
}

