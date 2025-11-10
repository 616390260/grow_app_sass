import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeatureCardWidget extends StatelessWidget {
  final String title;
  final String iconPath;
  final Gradient gradient;
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  const FeatureCardWidget({
    Key? key,
    required this.title,
    required this.iconPath,
    required this.gradient,
    this.onTap,
    this.width,
    this.height = 50,
  }) : super(key: key);

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
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
            ),
            Container(
              width: 30,
              height: 30,
              margin: const EdgeInsets.only(right: 12),
              child: Image.asset(iconPath, fit: BoxFit.cover,width: 30,height: 30,),
            ),
          ],
        ),
      ),
    );
  }
}