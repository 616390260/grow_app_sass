import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/base/base_controller.dart';
import '../../../core/i18n/i18n_keys.dart';
import '../../../routes/app_pages.dart';

/// 奖品数据模型
class Prize {
  final String name;
  final int value;
  final Color color;

  Prize({
    required this.name,
    required this.value,
    required this.color,
  });
}

class LuckyWheelController extends BaseController with GetSingleTickerProviderStateMixin {
  // 动画控制器
  late AnimationController animationController;
  late Animation<double> rotationAnimation;

  // 转盘状态
  final _isSpinning = false.obs;
  bool get isSpinning => _isSpinning.value;

  // 用户积分
  final _userPoints = 100.obs;
  int get userPoints => _userPoints.value;

  // 转盘消耗积分
  final int spinCost = 10;

  // 奖品列表
  final List<Prize> prizes = [
    Prize(name: '1', value: 1, color: const Color(0xFFFFE4E1)),
    Prize(name: '200', value: 200, color: const Color(0xFFFFB6C1)),
    Prize(name: '20', value: 20, color: const Color(0xFFFFE4E1)),
    Prize(name: '10', value: 10, color: const Color(0xFFFFB6C1)),
    Prize(name: '300', value: 300, color: const Color(0xFFFFE4E1)),
    Prize(name: '188', value: 188, color: const Color(0xFFFFB6C1)),
  ];

  // 当前选中的奖品索引
  final _selectedPrizeIndex = 0.obs;
  int get selectedPrizeIndex => _selectedPrizeIndex.value;

  @override
  void onInit() {
    super.onInit();
    _initAnimation();
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
    if (userPoints < spinCost) {
      showErrorMessage(I18nKeys.insufficientPoints.tr);
      return;
    }

    try {
      _isSpinning.value = true;
      _userPoints.value -= spinCost;

      // 模拟API调用
      await Future.delayed(const Duration(milliseconds: 2000));
      
      // 随机选择奖品
      final random = Random();
      final targetIndex = random.nextInt(prizes.length);
      final prize = prizes[targetIndex];
      
      _selectedPrizeIndex.value = targetIndex;

      // 计算旋转角度 - 精确停在分区中间位置
      final baseRotations = 5; // 基础旋转圈数
      // 计算每个分区的角度（弧度）
      final sectorAngle = 2 * pi / prizes.length;
      // 计算目标分区的中心角度（弧度），减去pi/2以匹配UI坐标系
      // 确保角度在0到2π范围内
      double targetAngle = (targetIndex * sectorAngle + sectorAngle / 2 - pi / 2);
      // 规范化角度到[0, 2π)范围
      while (targetAngle < 0) targetAngle += 2 * pi;
      while (targetAngle >= 2 * pi) targetAngle -= 2 * pi;
      
      // 转换为总旋转圈数（包括基础圈数）
      final totalRotations = baseRotations + targetAngle / (2 * pi);

      // 更新动画
      rotationAnimation = Tween<double>(
        begin: rotationAnimation.value,
        end: rotationAnimation.value + totalRotations,
      ).animate(CurvedAnimation(
        parent: animationController,
        curve: Curves.easeOutCubic,
      ));

      // 重置并开始动画
      animationController.reset();
      await animationController.forward();

      // 动画结束后显示结果
      _showPrizeResult();
      _isSpinning.value = false;
    } catch (e) {
      _isSpinning.value = false;
      _userPoints.value += spinCost; // 失败时返还积分
      setError('转盘失败: $e');
      showErrorMessage('转盘失败: $e');
    }
  }

  /// 显示中奖结果
  void _showPrizeResult() {
    // 验证选中的奖品索引有效
    if (selectedPrizeIndex >= 0 && selectedPrizeIndex < prizes.length) {
      final prize = prizes[selectedPrizeIndex];
      _userPoints.value += prize.value;
      
      showSuccessMessage('${I18nKeys.congratulations.tr}！${I18nKeys.youWon.tr} ${prize.value} ${I18nKeys.points.tr}');
    } else {
      // 如果索引无效，给出默认奖励并记录错误
      showErrorMessage('Invalid prize index: $selectedPrizeIndex');
      _userPoints.value += 10; // 默认奖励
      showSuccessMessage('${I18nKeys.congratulations.tr}！${I18nKeys.youWon.tr} 10 ${I18nKeys.points.tr}');
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
}