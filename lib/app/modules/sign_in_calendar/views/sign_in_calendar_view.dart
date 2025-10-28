import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/base/base_view.dart';
import '../../../core/i18n/i18n_keys.dart';
import '../controllers/sign_in_calendar_controller.dart';

class SignInCalendarView extends BaseView<SignInCalendarController> {
  const SignInCalendarView({Key? key}) : super(key: key);

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF4A90E2),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => Get.back(),
      ),
      centerTitle: true,
      title: Text(
        '签到', // 参考图标题
        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_horiz, color: Colors.white),
          onPressed: () {},
        )
      ],
    );
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
          colors: [Color(0xFF4A90E2), Color(0xFF7BB3F0), Color(0xFFF5F7FA)],
          stops: [0.0, 0.4, 1.0],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildTopSection(),
                const SizedBox(height: 16),
                _buildCalendarCard(),
                const SizedBox(height: 20),
                _buildSignButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopSection() {
    return Obx(() {
      final streak = controller.streakDays.value;
      final remaining = controller.daysRemainingToReward;
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Row(
          children: [
            // 左侧文字信息
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // "已连续签到 7 天"
                  Row(
                    children: [
                      const Text(
                        '已连续签到',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.yellow.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$streak',
                          style: const TextStyle(color: Colors.yellow, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        '天',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // "再连续 7 天领 5000 积分" 胶囊
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      '再连续 $remaining 天领 ${controller.rewardPoints} ${I18nKeys.points.tr}',
                      style: const TextStyle(
                        color: Colors.black87, 
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // 右侧图片
            Expanded(
              flex: 1,
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Center(
                  child: Icon(Icons.calendar_month, color: Colors.white, size: 56),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildHero() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Center(
          child: Icon(Icons.calendar_month, color: Colors.white, size: 56),
        ),
      ),
    );
  }

  Widget _buildTopInfo() {
    return Obx(() {
      final streak = controller.streakDays.value;
      final remaining = controller.daysRemainingToReward;
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            // "已连续签到 7 天"
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '已连续签到',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.yellow.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$streak',
                    style: const TextStyle(color: Colors.yellow, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  '天',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // "再连续 7 天领 5000 积分" 胶囊
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                '再连续 $remaining 天领 ${controller.rewardPoints} ${I18nKeys.points.tr}',
                style: const TextStyle(
                  color: Colors.black87, 
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
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
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Text(
              '签到日历 $year.${month.toString().padLeft(2, '0')}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
            ),
            const SizedBox(height: 16),
            // 周标签
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  _WeekLabel('日'), _WeekLabel('一'), _WeekLabel('二'), _WeekLabel('三'), _WeekLabel('四'), _WeekLabel('五'), _WeekLabel('六'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // 日历格子
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24), // 增加垂直padding
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 12, // 减少行间距
                  crossAxisSpacing: 8,
                  childAspectRatio: 0.6, // 调整宽高比给更多垂直空间
                ),
                itemCount: cells,
                itemBuilder: (context, index) {
                  if (index < offset) {
                    return const SizedBox.shrink();
                  }
                  final day = index - offset + 1;
                  final isToday = day == today.day && month == today.month && year == today.year;
                  final isChecked = checked.contains(day);
                  return _DayCell(day: day, isToday: isToday, isChecked: isChecked);
                },
              ),
            ),
            const SizedBox(height: 8), // 增加底部间距
          ],
        ),
      );
    });
  }

  Widget _buildSignButton() {
    return Obx(() {
      final canSign = !controller.checkedDays.value.contains(controller.today.day);
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        child: GestureDetector(
          onTap: canSign ? controller.checkInToday : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              gradient: canSign 
                ? const LinearGradient(
                    colors: [Color(0xFF5CB3FF), Color(0xFF3D8BFF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : LinearGradient(
                    colors: [Colors.grey.shade400, Colors.grey.shade500],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: canSign ? [
                BoxShadow(
                  color: const Color(0xFF3D8BFF).withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ] : [],
            ),
            alignment: Alignment.center,
            child: Text(
              canSign ? '立即签到' : '今天已签到',
              style: const TextStyle(
                color: Colors.white, 
                fontSize: 16, 
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
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
      style: const TextStyle(fontSize: 12, color: Color(0xFF7F8C8D), fontWeight: FontWeight.w500),
    );
  }
}

class _DayCell extends StatelessWidget {
  final int day;
  final bool isToday;
  final bool isChecked;
  const _DayCell({required this.day, required this.isToday, required this.isChecked});

  @override
  Widget build(BuildContext context) {
    final Color bgColor;
    final Color borderColor;
    final Color textColor;
    
    if (isToday) {
      bgColor = const Color(0xFF3D8BFF);
      borderColor = const Color(0xFF3D8BFF);
      textColor = Colors.white;
    } else if (isChecked) {
      bgColor = const Color(0xFFEAF3FF);
      borderColor = const Color(0xFF3D8BFF);
      textColor = const Color(0xFF3D8BFF);
    } else {
      bgColor = Colors.transparent;
      borderColor = const Color(0xFFE0E0E0);
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
                color: textColor
              ),
            ),
          ),
          // 今天标签 - 占用剩余空间
          Expanded(
            child: isToday 
              ? Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    '今天',
                    style: const TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w500, 
                      color: Color(0xFF3D8BFF)
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