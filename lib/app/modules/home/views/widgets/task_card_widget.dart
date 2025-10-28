import 'package:do_task_project/app/core/constants/image_assets.dart';
import 'package:do_task_project/app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class TaskCardWidget extends StatelessWidget {
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback? onTap;

  const TaskCardWidget({
    Key? key,
    required this.title,
    required this.description,
    required this.buttonText,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 2, bottom: 10),
      decoration: BoxDecoration(
        color: AppTheme.bgColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 任务图标
          Container(
            width: 32,
            height: 32,
            margin: const EdgeInsets.only(left: 13, top: 11),
            decoration: BoxDecoration(
              color: const Color(0xFFFF8E6A),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Image.asset(ImageAssets.homeTask, width: 14, height: 14),
          ),
          const SizedBox(width: 14),
          // 任务信息
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 9),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.threeColor,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    description,
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppTheme.nineColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          // 开始按钮
          SizedBox(
            height: 80, // 给按钮区域一个固定高度
            child: Align(
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.only(left: 11, right: 12),
                child: GestureDetector(
                  onTap: onTap,
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4A90E2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      buttonText,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
