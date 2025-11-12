
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
    isLoadingRemoteData.value = true;
    await safeApiCall(
      () async => await _signInApiService.getSignInInfo(),
      (record) {
        streakDays.value = record.continuousCheckInDays;
        rewardPoints.value = record.points;
        checkedDays.clear();
        if (record.checkInDaysList.isNotEmpty) {
          final currentYearMonth = '${currentMonth.year}-${currentMonth.month.toString().padLeft(2, '0')}';
          for (final dateStr in record.checkInDaysList) {
            if (dateStr.startsWith(currentYearMonth)) {
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
        box.write('checkedDays_${currentMonth.year}_${currentMonth.month}', checkedDays.toList().cast<int>());
        setSuccess();
        isLoadingRemoteData.value = false;
      },
      errorMessage: I18nKeys.loadSignInInfoFailed.tr,
      showLoading: false,
      onError: () {
        setSuccess();
        isLoadingRemoteData.value = false;
      },
    );
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
    await safeApiCall<bool>(
      () async => await _signInApiService.isCheckIn(),
      (checked) {
        isCheckedIn.value = checked;
        if (isCheckedIn.value && !checkedToday) {
          checkedDays.add(today.day);
          box.write('checkedDays_${currentMonth.year}_${currentMonth.month}', checkedDays.toList());
          streakDays.value = _calculateStreak();
          update();
        }
        setSuccess();
      },
      errorMessage: I18nKeys.getSignInStatusFailed.tr,
      showLoading: false,
      onError: () {
        setSuccess();
      },
    );
  }

  int get daysRemainingToReward {
    final need = 7;
    final remain = need - (streakDays.value % need);
    return remain == 0 ? need : remain;
  }

  Future<void> checkInToday() async {
    // 先检查服务器是否已签到，避免重复签到
    if (isCheckedIn.value || checkedToday) return;
    checkedDays.add(today.day);
    box.write('checkedDays_${currentMonth.year}_${currentMonth.month}', checkedDays.toList());
    streakDays.value = _calculateStreak();
    await safeApiCall<void>(
      () async => await _signInApiService.checkIn(),
      (_) async {
        showSuccessMessage('${I18nKeys.receivedPoints.tr} ${rewardPoints.value} ${I18nKeys.points.tr}');
        await loadSignInInfo();
        setSuccess();
        update();
      },
      errorMessage: I18nKeys.checkInFailed.tr,
      showLoading: true,
      onError: () {
        showErrorMessage(I18nKeys.checkInFailedRetry.tr);
        checkedDays.remove(today.day);
        streakDays.value = _calculateStreak();
        box.write('checkedDays_${currentMonth.year}_${currentMonth.month}', checkedDays.toList());
        setSuccess();
        update();
      },
    );
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
