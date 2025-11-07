import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:do_task_project/app/core/base/base_view.dart';
import 'package:do_task_project/app/core/i18n/i18n_keys.dart';
import 'package:do_task_project/app/core/theme/app_theme.dart';
import 'package:do_task_project/app/modules/income_details/controllers/income_details_controller.dart';

class IncomeDetailsPage extends BaseView<IncomeDetailsController> {
  @override
  Widget buildContent(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  // 构建顶部导航栏
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.primaryColor,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: controller.onBackPress,
      ),
      title: Text(
        I18nKeys.incomeDetails.tr,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.w500,
        ),
      ),
      centerTitle: true,
    );
  }

  // 构建主内容区域
  Widget _buildBody() {
    return Column(
      children: [
        _buildFilterSection(),
        _buildListHeader(),
        Expanded(child: _buildIncomeList()),
      ],
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
            I18nKeys.allTypes.tr,
            controller.selectedType.value,
            () {
              _showTypeFilterDialog();
            },
          ),
          _buildFilterButton(
            I18nKeys.allTime.tr,
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

  // 构建列表头部
  Widget _buildListHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 16, top: 13,bottom: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              I18nKeys.incomeType.tr,
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
              I18nKeys.incomeAmount.tr,
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
              I18nKeys.incomeTime.tr,
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
              Obx(() {
                return Container(
                  height: 300,
                  child: SingleChildScrollView(
                    child: Column(
                      children: controller.typeOptions.map((type) {
                        return _buildFilterItem(
                          type,
                          controller.selectedType.value,
                          (value) {
                            controller.onTypeFilterChanged(value);
                            Get.back();
                          },
                        );
                      }).toList(),
                    ),
                  ),
                );
              }),
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
              Obx(() {
                return Container(
                  height: 300,
                  child: SingleChildScrollView(
                    child: Column(
                      children: controller.timeRangeOptions.map((timeRange) {
                        return _buildFilterItem(
                          timeRange,
                          controller.selectedTimeRange.value,
                          (value) {
                            controller.onTimeFilterChanged(value);
                            Get.back();
                          },
                        );
                      }).toList(),
                    ),
                  ),
                );
              }),
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

  // 构建收益列表
  Widget _buildIncomeList() {
    return Obx(() {
      final incomeList = controller.incomeList;
      if (incomeList.isEmpty) {
        return Center(
          child: Text(
            I18nKeys.noData.tr,
            style: TextStyle(color: AppTheme.nineColor, fontSize: 14),
          ),
        );
      }

      return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          // 当用户滚动到列表底部时，加载更多数据
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            controller.loadMoreData();
          }
          return false;
        },
        child: ListView.builder(
          itemCount: incomeList.length + 1, // 添加一个额外的item用于加载更多指示器
          itemBuilder: (context, index) {
            // 如果是最后一个item，显示加载更多指示器
            if (index == incomeList.length) {
              return _buildLoadMoreIndicator();
            }

            final item = incomeList[index];
            return _buildIncomeItem(item, index);
          },
        ),
      );
    });
  }

  // 构建加载更多指示器
  Widget _buildLoadMoreIndicator() {
    return Obx(() {
      // 如果没有更多数据，不显示任何内容
      // 如果有更多数据，显示加载指示器
      return Container(
        padding: const EdgeInsets.all(16),
        alignment: Alignment.center,
        child: controller.isLoading ? const CircularProgressIndicator() : null,
      );
    });
  }

  // 构建收益列表项
  Widget _buildIncomeItem(IncomeItem item, int index) {
    return Container(
      color: Colors.white,
      
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
            children: [
              // 提现类型
              Expanded(
                flex: 2,
                child: Text(
                  item.type,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.sixColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              // 收益金额
              Expanded(
                flex: 2,
                child: Text(
                  '${item.amount}',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              // 时间
              Expanded(
                flex: 3,
                child: Text(
                  item.time,
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
          
          Container(
            height: 0.5,
            color: AppTheme.dddColor,
            margin: const EdgeInsets.only(left: 19),
          ),
        ],
      ),
    );
  }
}
