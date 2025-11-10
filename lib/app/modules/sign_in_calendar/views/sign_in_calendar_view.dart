import 'package:do_task_project/app/core/constants/image_assets.dart';
import 'package:do_task_project/app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../core/base/base_view.dart';
import '../../../core/i18n/i18n_keys.dart';
import '../controllers/sign_in_calendar_controller.dart';

class SignInCalendarView extends BaseView<SignInCalendarController> {
  const SignInCalendarView({Key? key}) : super(key: key);

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    // 设置状态栏为透明文字
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // 状态栏透明
        statusBarIconBrightness: Brightness.light, // 状态栏图标为白色
        statusBarBrightness: Brightness.dark, // iOS状态栏图标为暗色
      ),
    );

    // 返回null表示不显示AppBar
    return null;
  }

  @override
  Color? get backgroundColor => Colors.white;

  @override
  Widget buildContent(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF477DF2), Color(0xFF47ABF2), Color(0xFFF9F9F9)],
          stops: [0.0, 0.4, 0.7],
        ),
      ),
      child: Column(
        children: [
          // 添加状态栏高度的占位空间
          SizedBox(height: MediaQuery.of(context).padding.top),
          // 添加返回按钮和标题
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () => Get.back(),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      I18nKeys.signIn.tr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 48), // 平衡返回按钮的宽度
              ],
            ),
          ),
          // 使用Expanded包装内容，确保填充剩余空间
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildTopSection(),
                  _buildCalendarCard(),
                 const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopSection() {
    return Obx(() {
      final streak = controller.streakDays.value;
      final remaining = controller.daysRemainingToReward;
      final rewardPoints = controller.rewardPoints.value;
      return Container(
        padding: const EdgeInsets.only(left: 21, right: 19),
        child: Row(
          children: [
            // 左侧文字信息
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // "已连续签到 7 天"
                  Row(
                    children: [
                      Text(
                        I18nKeys.continuouslySignedInFor.tr,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$streak',
                        style: const TextStyle(
                            color: AppTheme.signYellowColor,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        I18nKeys.days.tr,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // "再连续 7 天领 5000 积分" 胶囊
                  Row(
                    children: [
                      Text(
                        I18nKeys.signInAgainFor.tr,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '$remaining',
                        style: const TextStyle(
                            color: AppTheme.signYellowColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        I18nKeys.daysToClaim.tr,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${rewardPoints} ',
                        style: const TextStyle(
                          color: AppTheme.signYellowColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${I18nKeys.points.tr}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // 右侧图片
            Image.asset(ImageAssets.signBg, width: 145, height: 110),
          ],
        ),
      );
    });
  }

  Widget _buildCalendarCard() {
    return Obx(() {
      final year = controller.currentMonth.year;
      final month = controller.currentMonth.month;
      final totalDays = controller.daysInMonth;
      final offset = controller.firstWeekdayOffset;
      final today = controller.today;
      final checked = controller.checkedDays.value;

      final cells = offset + totalDays;

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
        ),
        child: Column(
          children: [
            const SizedBox(height: 14),
            Text(
              '${I18nKeys.signInCalendar.tr} $year.${month.toString().padLeft(2, '0')}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppTheme.threeColor,
              ),
            ),
            const SizedBox(height: 16),
            // 周标签
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _WeekLabel(I18nKeys.weekDaySunday.tr),
                  _WeekLabel(I18nKeys.weekDayMonday.tr),
                  _WeekLabel(I18nKeys.weekDayTuesday.tr),
                  _WeekLabel(I18nKeys.weekDayWednesday.tr),
                  _WeekLabel(I18nKeys.weekDayThursday.tr),
                  _WeekLabel(I18nKeys.weekDayFriday.tr),
                  _WeekLabel(I18nKeys.weekDaySaturday.tr),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // 日历格子
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 2,
              ), // 增加垂直padding
              child: GridView.builder(
                padding: EdgeInsets.zero, // 移除默认padding
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 2, // 减少行间距
                  crossAxisSpacing: 8,
                  childAspectRatio: 0.7, // 调整宽高比给更多垂直空间
                ),
                itemCount: cells,
                itemBuilder: (context, index) {
                  if (index < offset) {
                    return const SizedBox.shrink();
                  }
                  final day = index - offset + 1;
                  final isToday =
                      day == today.day &&
                      month == today.month &&
                      year == today.year;
                  final isChecked = checked.contains(day);
                  // 计算是否为未选中状态：小于今天的日期且不在checked列表中
                  final isBeforeToday = (
                    year < today.year ||
                    (year == today.year && month < today.month) ||
                    (year == today.year && month == today.month && day < today.day)
                  ) && !isChecked;
                  
                  return _DayCell(
                    day: day,
                    isToday: isToday,
                    isChecked: isChecked,
                    unChecked: isBeforeToday,
                  );
                },
              ),
            ),
            const SizedBox(height: 10), 
             _buildSignButton(),
            const SizedBox(height: 22), // 增加底部间距
          ],
        ),
      );
    });
  }

  Widget _buildSignButton() {
    return Obx(() {
      // ignore: invalid_use_of_protected_member
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 50),
        child: GestureDetector(
          onTap: !controller.isCheckedIn.value ? controller.checkInToday : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            height: 44,
            decoration: BoxDecoration(
              gradient: !controller.isCheckedIn.value
                  ? const LinearGradient(
                      colors: [Color(0xFF47B9F2), Color(0xFF477DF2 )],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : LinearGradient(
                      colors: [Colors.grey.shade400, Colors.grey.shade500],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: !controller.isCheckedIn.value
                  ? [
                      BoxShadow(
                        color: const Color(0xFF3D8BFF).withValues(alpha: 0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
            alignment: Alignment.center,
            child: Text(
                !controller.isCheckedIn.value ? I18nKeys.signInNow.tr : I18nKeys.alreadySignedInToday.tr,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5
                ),
              ),
          ),
        ),
      );
    });
  }
}

class _WeekLabel extends StatelessWidget {
  final String text;
  const _WeekLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        color: AppTheme.threeColor,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  final int day;
  final bool isToday;
  final bool isChecked;
  final bool unChecked;
  const _DayCell({
    required this.day,
    required this.isToday,
    required this.isChecked,
    required this.unChecked,
  });

  @override
  Widget build(BuildContext context) {
    final Color bgColor;
    final Color borderColor;
    final Color textColor;

    if (isToday||isChecked) {
      bgColor = const Color(0xFF3D8BFF);
      borderColor = const Color(0xFF3D8BFF);
      textColor = Colors.white;
    } else if (unChecked) {
      bgColor = const Color(0xFF427AF2).withOpacity(0.1);
      borderColor = Colors.transparent;
      textColor = AppTheme.primaryColor;
    } else {
      bgColor = Colors.transparent;
      borderColor = Colors.transparent;
      textColor = const Color(0xFF2C3E50);
    }

    return SizedBox(
      height: 50, // 固定高度确保对齐
      child: Column(
        children: [
          // 日期圆圈 - 固定位置
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
              border: Border.all(color: borderColor, width: 1),
            ),
            alignment: Alignment.center,
            child: Text(
              '$day',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ),
          // 今天标签 - 占用剩余空间
          Expanded(
            child: isToday
                ? Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                        I18nKeys.today.tr,
                        style: const TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF3D8BFF),
                        ),
                      ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
