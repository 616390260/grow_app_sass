import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import '../../../core/base/base_controller.dart';

class SignInCalendarController extends BaseController {
  final box = GetStorage('sign_in_calendar');

  final DateTime today = DateTime.now();
  late DateTime currentMonth;

  final RxSet<int> checkedDays = <int>{}.obs;
  final streakDays = 0.obs;
  final rewardPoints = 5000;

  @override
  void onInit() {
    super.onInit();
    currentMonth = DateTime(today.year, today.month);

    final saved = box.read<List>('checkedDays_${currentMonth.year}_${currentMonth.month}')?.cast<int>() ?? [];
    checkedDays.addAll(saved);

    streakDays.value = _calculateStreak();
    setSuccess();
  }

  int get daysInMonth {
    final nextMonth = DateTime(currentMonth.year, currentMonth.month + 1, 0);
    return nextMonth.day;
  }

  int get firstWeekdayOffset {
    final first = DateTime(currentMonth.year, currentMonth.month, 1);
    return first.weekday % 7; // 周日为0偏移
  }

  bool get checkedToday => checkedDays.contains(today.day);

  int get daysRemainingToReward {
    final need = 7;
    final remain = need - (streakDays.value % need);
    return remain == 0 ? need : remain;
  }

  void checkInToday() {
    if (checkedToday) return;
    checkedDays.add(today.day);
    box.write('checkedDays_${currentMonth.year}_${currentMonth.month}', checkedDays.toList());

    streakDays.value = _calculateStreak();
    showSuccessMessage('获得 $rewardPoints 积分');
  }

  int _calculateStreak() {
    int streak = 0;
    for (int d = today.day; d >= 1; d--) {
      if (checkedDays.contains(d)) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }
}