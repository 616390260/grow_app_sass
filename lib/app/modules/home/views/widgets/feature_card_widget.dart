import 'package:flutter/material.dart';

class FeatureCardWidget extends StatelessWidget {
  final String title;
  final String iconPath;
  final Gradient gradient;
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  const FeatureCardWidget({
    super.key,
    required this.title,
    required this.iconPath,
    required this.gradient,
    this.onTap,
    this.width,
    this.height = 50,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 4),
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Image.asset(iconPath, width: 26, height: 26, fit: BoxFit.contain),
            ),
          ],
        ),
      ),
    );
  }
}
