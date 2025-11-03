import 'package:do_task_project/app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import '../../../core/base/base_view.dart';
import '../../../core/i18n/i18n_keys.dart';
import '../controllers/withdrawal_orders_controller.dart';

class WithdrawalOrdersView extends BaseView<WithdrawalOrdersController> {
  const WithdrawalOrdersView({Key? key}) : super(key: key);

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    // 设置沉浸式状态栏
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // 透明状态栏
        statusBarIconBrightness: Brightness.light, // 状态栏图标为白色
        statusBarBrightness: Brightness.dark, // iOS状态栏内容为深色
      ),
    );

    return AppBar(
      title: Text(
        I18nKeys.withdrawalOrders.tr,
        style: const TextStyle(
          fontSize: 17,
          color: Colors.white, // 白色标题
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.white, // 白色返回按钮
        ),
        onPressed: controller.goBack,
      ),
      elevation: 0,
      backgroundColor: AppTheme.primaryColor,
      // 沉浸式状态栏配置
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
  }

  @override
  Color? get backgroundColor => const Color(0xFFF5F5F5);  

  @override
  Widget buildContent(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F5),
      child: Column(
        children: [
          _buildFilterSection(),
          _buildListHeader(),
          Expanded(
            child: Obx(() {
              if (controller.orders.isEmpty) {
                return _buildEmptyState();
              } else {
                return ListView.builder(
                  itemCount: controller.orders.length,
                  itemBuilder: (context, index) {
                    final order = controller.orders[index];
                    return _buildOrderItem(order, index);
                  },
                );
              }
            }),
          ),
        ],
      ),
    );
  }

  // 构建列表头部
  Widget _buildListHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 16, top: 13, bottom: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              I18nKeys.withdrawalAmount.tr,
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.threeColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              I18nKeys.status.tr,
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.threeColor,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              I18nKeys.time.tr,
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.threeColor,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // 构建筛选区域
  Widget _buildFilterSection() {
    return Container(
      color: AppTheme.primaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 52, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildFilterButton(
            controller.selectedType.value,
            controller.selectedType.value,
                () {
              _showTypeFilterDialog();
            },
          ),
          _buildFilterButton(
            controller.selectedTimeRange.value,
            controller.selectedTimeRange.value,
                () {
              _showTimeFilterDialog();
            },
          ),
        ],
      ),
    );
  }

  // 构建筛选按钮
  Widget _buildFilterButton(
    String title,
    String currentValue,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Text(
            currentValue,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.arrow_drop_down, color: Colors.white),
        ],
      ),
    );
  }

  // 显示类型筛选对话框
  void _showTypeFilterDialog() {
    showModalBottomSheet(
      context: Get.context!,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                I18nKeys.selectType.tr,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.threeColor,
                ),
              ),
              const SizedBox(height: 16),
              _buildFilterItem(
                I18nKeys.allTypes.tr,
                controller.selectedType.value,
                    (value) {
                  controller.selectType(value);
                  Get.back();
                },
              ),
              // 添加其他类型选项
              _buildFilterItem(
                '提现',
                controller.selectedType.value,
                    (value) {
                  controller.selectType(value);
                  Get.back();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // 显示时间筛选对话框
  void _showTimeFilterDialog() {
    showModalBottomSheet(
      context: Get.context!,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                I18nKeys.selectTime.tr,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.threeColor,
                ),
              ),
              const SizedBox(height: 16),
              _buildFilterItem(
                I18nKeys.allTime.tr,
                controller.selectedTimeRange.value,
                    (value) {
                  controller.selectTimeRange(value);
                  Get.back();
                },
              ),
              _buildFilterItem(
                I18nKeys.today.tr,
                controller.selectedTimeRange.value,
                    (value) {
                  controller.selectTimeRange(value);
                  Get.back();
                },
              ),
              _buildFilterItem(
                I18nKeys.thisWeek.tr,
                controller.selectedTimeRange.value,
                    (value) {
                  controller.selectTimeRange(value);
                  Get.back();
                },
              ),
              _buildFilterItem(
                I18nKeys.thisMonth.tr,
                controller.selectedTimeRange.value,
                    (value) {
                  controller.selectTimeRange(value);
                  Get.back();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // 构建筛选选项项
  Widget _buildFilterItem(
    String title,
    String currentValue,
    void Function(String) onSelect,
  ) {
    return GestureDetector(
      onTap: () => onSelect(title),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: AppTheme.eeeColor)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 14, color: AppTheme.threeColor),
            ),
            if (title == currentValue)
              const Icon(Icons.check, color: AppTheme.primaryColor),
          ],
        ),
      ),
    );
  }

  // 构建订单列表项
  Widget _buildOrderItem(WithdrawalOrder order, int index) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // 提现金额
                Expanded(
                  flex: 2,
                  child: Text(
                    '¥${order.amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                // 状态
                Expanded(
                  flex: 2,
                  child: Text(
                    order.status,
                    style: TextStyle(
                      fontSize: 14,
                      color: _getStatusColor(order.status),
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                // 时间
                Expanded(
                  flex: 3,
                  child: Text(
                    order.time,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.sixColor,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          // 添加分隔线
          Container(
            height: 0.5,
            color: AppTheme.dddColor,
            margin: const EdgeInsets.only(left: 19),
          ),
        ],
      ),
    );
  }

  // 根据状态获取颜色
  Color _getStatusColor(String status) {
    switch (status) {
      case '成功':
        return Colors.green;
      case '处理中':
        return Colors.orange;
      case '失败':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // 构建空状态
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 60,
            color: AppTheme.nineColor,
          ),
          const SizedBox(height: 16),
          Text(
            I18nKeys.noData.tr,
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.nineColor,
            ),
          ),
        ],
      ),
    );
  }
}