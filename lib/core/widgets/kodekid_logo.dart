import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class KodeKidLogo extends StatelessWidget {
  const KodeKidLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Overlapping circles
        Stack(
          children: [
            // Left circle (olive green)
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.oliveGreen,
                shape: BoxShape.circle,
              ),
            ),
            // Right circle (orange) - overlapping
            Positioned(
              left: 20,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.orange,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 12),
        // KodeKid text
        Text(
          'KodeKid',
          style: AppTextStyles.logoText(),
        ),
      ],
    );
  }
}

