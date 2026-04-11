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
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  title,
                  overflow: TextOverflow.visible,
                  softWrap: true,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
            ),
            Container(
              width: 42,
              height: 30,
              padding: EdgeInsets.only(right: 12),
              child: Image.asset(iconPath, fit: BoxFit.cover,width: 30,height: 30,),
            ),
          ],
        ),
      ),
    );
  }
}
