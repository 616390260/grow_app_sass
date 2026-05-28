import 'dart:math';
import 'package:do_task_project/app/domain/entities/winning_record.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/base/base_controller.dart';
import '../../../core/i18n/i18n_keys.dart';
import '../../../data/services/winning_api_service.dart';


class LuckyWheelController extends BaseController with GetSingleTickerProviderStateMixin {
  // 动画控制器
  late AnimationController animationController;
  late Animation<double> rotationAnimation;

  // 转盘状态
  final _isSpinning = false.obs;
  bool get isSpinning => _isSpinning.value;

  // 用户积分
  final _userPoints = 0.obs;
  int get userPoints => _userPoints.value;

  // 转盘消耗积分
  final _spinCost = 0.obs;
  int get spinCost => _spinCost.value;

  // 奖品列表
  final RxList<WinningRecord> prizes = <WinningRecord>[].obs;

  // 当前选中的奖品索引
  final _selectedPrizeIndex = 0.obs;
  int get selectedPrizeIndex => _selectedPrizeIndex.value;

  // API服务
  final WinningApiService _winningApiService = WinningApiService();

  @override
  void onInit() {
    super.onInit();
    _initAnimation();
    _loadPrizes();
  }

  /// 加载奖品列表
  Future<void> _loadPrizes() async {
    safeApiCall(
      () => _winningApiService.getWinningList(),
      (wheelData) {
        prizes.assignAll(wheelData.winningSettings as Iterable<WinningRecord>);
        _userPoints.value = wheelData.availablePoints;
        _spinCost.value = wheelData.points;
      },
      errorMessage: I18nKeys.loadPrizeListFailed.tr,
    );
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }

  /// 初始化动画
  void _initAnimation() {
    animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOutCubic,
    ));
  }

  /// 开始转盘
  Future<void> startSpin() async {
    if (isSpinning) return;

    // 检查积分是否足够
    // if (userPoints < spinCost) {
    //   showErrorMessage(I18nKeys.insufficientPoints.tr);
    //   return;
    // }

    _isSpinning.value = true;
    _userPoints.value -= spinCost;

    safeApiCall(
      () => _winningApiService.doLottery(spinCost),
      (lotteryResult) {
        
        // 从接口返回结果中提取中奖信息
        int targetIndex;
        
        try {
          // 首先检查lotteryResult是否为字符串类型的数字（如"667"）
          // 尝试解析为数字
          final prizeValue = int.tryParse(lotteryResult);
          if (prizeValue != null) {
            targetIndex = _findPrizeIndexByValue(prizeValue);
            print('解析到有效奖品索引: $targetIndex');
          } else {
            throw FormatException(I18nKeys.invalidPrizeIndex.tr);
          }
                  
          // 确保索引在有效范围内
          if (targetIndex < 0 || targetIndex >= prizes.length) {
            targetIndex = 0;
          }
        } catch (e) {
          print('解析抽奖结果异常: $e');
          // 发生异常时随机选择一个奖品
          final random = Random();
          targetIndex = random.nextInt(prizes.length);
        }
        
        _selectedPrizeIndex.value = targetIndex;

        // 计算旋转角度 - 精确停在分区中间位置
        final baseRotations = 5; // 基础旋转圈数
        
        // 计算每个分区的角度（弧度）
        // 确保索引在有效范围内
        final int sectorCount = prizes.length;
        print('扇形数量: $sectorCount');
        
        // 角度计算逻辑：
// 关键点：
// 1. 绘制代码中扇形的起始角度 = i * sectorAngle - pi/2
// 2. 绘制代码中扇形的中心角度 = i * sectorAngle
// 3. 指针固定在顶部位置（-pi/2）

// 在绘制代码中，第i个扇形的起始角度是 i * sectorAngle - pi/2
// 但它的中心角应该是起始角 + sectorAngle/2 = i * sectorAngle - pi/2 + sectorAngle/2 = i * sectorAngle - pi/4

// 我们的目标：让选中的扇形中心旋转到指针位置（-pi/2）
// 也就是说，我们希望目标扇形的中心角经过旋转后变成 -pi/2

// 计算目标旋转角度（总旋转圈数）
// 首先计算从当前角度到目标角度需要旋转的圈数
// 当前第targetIndex个扇形的中心角度 = targetIndex * sectorAngle - pi/4
// 我们希望它旋转到 -pi/2 的位置
// 所以需要的总旋转角度 = -pi/2 - (targetIndex * sectorAngle - pi/4) + baseRotations * 2 * pi
        
        // 计算每个分区的角度（弧度）
        final double sectorAngle = 2 * pi / sectorCount;
        
        // 确保索引在有效范围内
        if (targetIndex < 0) {
          targetIndex = 0;
        } else if (targetIndex >= sectorCount) {
          targetIndex = sectorCount - 1;
        }
        
        // 计算目标角度
        double targetAngle = -pi/2 - (targetIndex * sectorAngle - pi/4) + baseRotations * 2 * pi+sectorAngle/2;
        
        // 确保目标角度为正数（顺时针旋转）
        if (targetAngle < 0) {
          targetAngle += 2 * pi;
        }
        
        // 转换为总旋转圈数（包括基础圈数）
        final totalRotations = baseRotations + (targetAngle / (2 * pi));

        // 更新动画 - 每次都从0开始计算新的旋转，避免偏移量累积
        rotationAnimation = Tween<double>(
          begin: 0.0,
          end: totalRotations,
        ).animate(CurvedAnimation(
          parent: animationController,
          curve: Curves.easeOutCubic,
        ));

        // 重置并开始动画
        animationController.reset();
        animationController.forward().then((_) {
          // 动画结束后显示结果
          _showPrizeResult();
          _isSpinning.value = false;
        });
      },
      errorMessage: I18nKeys.wheelFailed.tr,
      showLoading: false, // 自定义加载状态，因为有特殊的UI处理
      onError: () {
        _isSpinning.value = false;
        _userPoints.value += spinCost; // 失败时返还积分
      },
    );
  }

  /// 显示中奖结果
  void _showPrizeResult() {
    // 验证选中的奖品索引有效
    if (selectedPrizeIndex >= 0 && selectedPrizeIndex < prizes.length) {
      final prize = prizes[selectedPrizeIndex];
      _userPoints.value += prize.prizeValue;
      
      showSuccessMessage('${I18nKeys.congratulations.tr}! ${I18nKeys.youWon.tr} ${prize.prizeValue} ${I18nKeys.points.tr}');
    } else {
      // 如果索引无效，给出默认奖励并记录错误
      showErrorMessage('Invalid prize index: $selectedPrizeIndex');
      _userPoints.value += 10; // 默认奖励
      showSuccessMessage('${I18nKeys.congratulations.tr}! ${I18nKeys.youWon.tr} 10 ${I18nKeys.points.tr}');
    }
  }

  /// 检查是否可以转盘
  bool canSpin() {
    return !isSpinning && userPoints >= spinCost;
  }

  /// 获取转盘按钮文本
  String getSpinButtonText() {
    if (isSpinning) {
      return I18nKeys.spinning.tr;
    } else if (userPoints < spinCost) {
      return I18nKeys.insufficientPoints.tr;
    } else {
      return '${I18nKeys.spinCost.tr}$spinCost${I18nKeys.points.tr}';
    }
  }

  /// 返回上一页
  void goBack() {
    Get.back();
  }
  
  /// 根据API返回结果查找对应的奖品索引
  int _findPrizeIndexByResult(Map<String, dynamic> resultData) {
    // 尝试多种可能的字段匹配
    final possibleKeys = ['prizeId', 'id', 'prizeId', 'winningId'];
    
    for (var key in possibleKeys) {
      if (resultData.containsKey(key)) {
        final prizeId = resultData[key];
        // 在奖品列表中查找匹配的ID
        for (int i = 0; i < prizes.length; i++) {
          if (prizes[i].id == prizeId) {
            return i;
          }
        }
      }
    }
    
    // 尝试根据奖品值匹配
    if (resultData.containsKey('prizeValue') || resultData.containsKey('value')) {
      final prizeValue = resultData['prizeValue'] ?? resultData['value'];
      return _findPrizeIndexByValue(prizeValue);
    }
    
    // 默认返回第一个奖品
    return 0;
  }

  /// 根据积分值查找对应的奖品索引
  int _findPrizeIndexByValue(dynamic prizeValue) {
    if (prizeValue == null) return 0;
    
    final targetValue = prizeValue is int ? prizeValue : int.tryParse(prizeValue.toString()) ?? 0;
    
    // 首先尝试精确匹配
    for (int i = 0; i < prizes.length; i++) {
      if (prizes[i].prizeValue == targetValue) {
        return i;
      }
    }
    
    // 如果没有精确匹配，找到最接近的奖品值
    int closestIndex = 0;
    int minDifference = (prizes[0].prizeValue - targetValue).abs();
    
    for (int i = 1; i < prizes.length; i++) {
      final difference = (prizes[i].prizeValue - targetValue).abs();
      if (difference < minDifference) {
        minDifference = difference;
        closestIndex = i;
      }
    }
    
    return closestIndex;
  }
}
