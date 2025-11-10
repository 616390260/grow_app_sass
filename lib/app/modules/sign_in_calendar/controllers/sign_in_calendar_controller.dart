import 'dart:developer';

import 'package:do_task_project/app/core/i18n/i18n_keys.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/base/base_controller.dart';
import '../../../data/services/sign_in_api_service.dart';

class SignInCalendarController extends BaseController {
  final box = GetStorage('sign_in_calendar');
  final _signInApiService = SignInApiService();

  final DateTime today = DateTime.now();
  late DateTime currentMonth;

  final RxSet<int> checkedDays = <int>{}.obs;
  final streakDays = 0.obs;
  final rewardPoints = 0.obs;
  final RxBool isLoadingRemoteData = false.obs;
  final RxBool isCheckedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    currentMonth = DateTime(today.year, today.month);

    // 先加载本地数据，添加更严格的类型检查
    final savedData = box.read('checkedDays_${currentMonth.year}_${currentMonth.month}');
    List<int> saved = [];
    
    // 安全地处理可能的类型
    if (savedData is List) {
      saved = savedData.whereType<int>().toList();
    } else if (savedData is int) {
      // 处理可能存储为单个整数的情况
      saved = [savedData];
    }
    checkedDays.addAll(saved);
    streakDays.value = _calculateStreak();

    // 然后异步加载服务器数据
    loadSignInInfo();
    isCheckedInToday();
  }

  /// 从服务器加载签到信息
  Future<void> loadSignInInfo() async {
    try {
      isLoadingRemoteData.value = true;
      final record = await _signInApiService.getSignInInfo();
      
      // 更新UI状态
      streakDays.value = record.continuousCheckInDays;
      rewardPoints.value = record.points;
      
      // 处理checkInDaysList，提取当月已签到的天数
      checkedDays.clear();
      if (record.checkInDaysList.isNotEmpty) {
        final currentYearMonth = '${currentMonth.year}-${currentMonth.month.toString().padLeft(2, '0')}';
        for (final dateStr in record.checkInDaysList) {
          if (dateStr.startsWith(currentYearMonth)) {
            // 提取日期部分（假设格式为YYYY-MM-DD）
            final parts = dateStr.split('-');
            if (parts.length == 3) {
              final day = int.tryParse(parts[2]);
              if (day != null) {
                checkedDays.add(day);
              }
            }
          }
        }
      }
      
      // 保存到本地存储，确保保存为列表类型
      box.write('checkedDays_${currentMonth.year}_${currentMonth.month}', checkedDays.toList().cast<int>());
      
      setSuccess();
    } catch (e) {
      // 即使网络请求失败，也要确保UI正常显示本地数据
      setSuccess();
    } finally {
      isLoadingRemoteData.value = false;
    }
  }

  int get daysInMonth {
    final nextMonth = DateTime(currentMonth.year, currentMonth.month + 1, 0);
    return nextMonth.day;
  }

  int get firstWeekdayOffset {
    final first = DateTime(currentMonth.year, currentMonth.month, 1);
    return first.weekday % 7; // 周日为0偏移
  }

  /// 本地检查今日是否已签到
  bool get checkedToday => checkedDays.contains(today.day);
  
  /// 从服务器检查今日是否已签到并同步到本地状态
  void isCheckedInToday() async {
    try {
        isCheckedIn.value = await _signInApiService.isCheckIn();
        print('isCheckedIn.value: ${isCheckedIn.value}');
        // 如果服务器返回已签到，但本地状态未更新，则更新本地状态
      if (isCheckedIn.value && !checkedToday) {
        checkedDays.add(today.day);
        // 保存到本地存储
        box.write('checkedDays_${currentMonth.year}_${currentMonth.month}', checkedDays.toList());
        // 重新计算连续签到天数
        streakDays.value = _calculateStreak();
        // 更新UI
        update();
      }
      
      setSuccess();
    } catch (e) {
      // 发生错误时，回退到本地判断
      setSuccess();
    }
  }

  int get daysRemainingToReward {
    final need = 7;
    final remain = need - (streakDays.value % need);
    return remain == 0 ? need : remain;
  }

  Future<void> checkInToday() async {
    // 先检查服务器是否已签到，避免重复签到
    if (isCheckedIn.value || checkedToday) return;
    
    try {
      setLoading(true);
      
      // 1. 先执行本地签到逻辑
      checkedDays.add(today.day);
      // 安全地保存为列表类型
      box.write('checkedDays_${currentMonth.year}_${currentMonth.month}', checkedDays.toList());
      
      // 2. 计算新的连续签到天数
      streakDays.value = _calculateStreak();
      
      // 3. 调用服务器签到API
      await _signInApiService.checkIn();
      
      // 4. 显示成功消息
      showSuccessMessage('${I18nKeys.receivedPoints.tr} ${rewardPoints.value} ${I18nKeys.points.tr}');
      
      // 5. 重新加载最新的签到信息
      await loadSignInInfo();
      
      setSuccess();
    } catch (e) {
      showErrorMessage(I18nKeys.checkInFailedRetry.tr);
      // 回滚本地操作，确保状态一致性
      checkedDays.remove(today.day);
      streakDays.value = _calculateStreak();
      // 重新保存正确的状态
      box.write('checkedDays_${currentMonth.year}_${currentMonth.month}', checkedDays.toList());
    } finally {
      // 无论成功还是失败，确保加载状态被重置
      setLoading(false);
      // 同时更新页面状态为成功，确保加载指示器消失
      setSuccess();
      // 确保UI状态更新
      update();
    }
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