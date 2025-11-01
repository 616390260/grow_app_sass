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
          _buildFilterBar(),
          Expanded(
            child: Obx(() {
              if (controller.orders.isEmpty) {
                return _buildEmptyState();
              } else {
                return ListView.builder(
                  itemCount: controller.orders.length,
                  itemBuilder: (context, index) {
                    final order = controller.orders[index];
                    return _buildOrderItem(order);
                  },
                );
              }
            }),
          ),
        ],
      ),
    );
  }

  // 构建筛选栏
  Widget _buildFilterBar() {
    return Container(
      color: AppTheme.primaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildFilterButton(
            title: controller.selectedType.value,
            options: controller.typeOptions,
            onSelect: controller.selectType,
          ),
          _buildFilterButton(
            title: controller.selectedTimeRange.value,
            options: controller.timeRangeOptions,
            onSelect: controller.selectTimeRange,
          ),
        ],
      ),
    );
  }

  // 构建筛选按钮
  Widget _buildFilterButton({
    required String title,
    required List<String> options,
    required Function(String) onSelect,
  }) {
    return PopupMenuButton<String>(
      itemBuilder: (context) {
        return options.map((option) {
          return PopupMenuItem(
            value: option,
            child: Text(option),
          );
        }).toList();
      },
      onSelected: onSelect,
      child: Row(
        children: [
          Text(title, style: const TextStyle(fontSize: 15, color: Colors.white,fontWeight: FontWeight.w500)),
          const SizedBox(width: 4),
          const Icon(Icons.arrow_drop_down, size: 16, color: Colors.white),
        ],
      ),
    );
  }

  // 构建订单列表项
  Widget _buildOrderItem(WithdrawalOrder order) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                I18nKeys.withdrawalAmount.tr,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                ),
              ),
              Text(
                '¥${order.amount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE53935),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                I18nKeys.status.tr,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                ),
              ),
              Text(
                order.status,
                style: TextStyle(
                  fontSize: 14,
                  color: _getStatusColor(order.status),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                I18nKeys.time.tr,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                ),
              ),
              Text(
                order.time,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                ),
              ),
            ],
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
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(60),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                Icon(
                  Icons.inbox_outlined,
                  size: 40,
                  color: Colors.blue.withOpacity(0.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            I18nKeys.noData.tr,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF999999),
            ),
          ),
        ],
      ),
    );
  }
}