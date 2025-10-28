import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'base_controller.dart';
import '../theme/loading_style.dart';

/// 基础视图类，封装通用UI组件
abstract class BaseView<T extends BaseController> extends GetView<T> {
  const BaseView({Key? key}) : super(key: key);

  /// 构建页面内容，子类必须实现
  Widget buildContent(BuildContext context);

  /// 构建AppBar，子类可重写
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  /// 构建FloatingActionButton，子类可重写
  Widget? buildFloatingActionButton(BuildContext context) => null;

  /// 构建底部导航栏，子类可重写
  Widget? buildBottomNavigationBar(BuildContext context) => null;

  /// 构建抽屉，子类可重写
  Widget? buildDrawer(BuildContext context) => null;

  /// 是否显示加载状态
  bool get showLoadingState => true;

  /// 是否显示错误状态
  bool get showErrorState => true;

  /// 是否显示空数据状态
  bool get showEmptyState => true;

  /// 是否可以下拉刷新
  bool get enableRefresh => false;

  /// 背景颜色
  Color? get backgroundColor => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: buildAppBar(context),
      body: _buildBody(context),
      floatingActionButton: buildFloatingActionButton(context),
      bottomNavigationBar: buildBottomNavigationBar(context),
      drawer: buildDrawer(context),
    );
  }

  /// 构建页面主体
  Widget _buildBody(BuildContext context) {
    return Obx(() {
      switch (controller.pageState) {
        case PageState.loading:
          return showLoadingState ? _buildLoadingWidget() : buildContent(context);
        case PageState.error:
          return showErrorState ? _buildErrorContent(context) : buildContent(context);
        case PageState.empty:
          return showEmptyState ? _buildEmptyWidget() : buildContent(context);
        default:
          return enableRefresh ? _buildRefreshableContent(context) : buildContent(context);
      }
    });
  }

  /// 构建可刷新的内容
  Widget _buildRefreshableContent(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        controller.refreshData();
      },
      child: buildContent(context),
    );
  }

  /// 构建加载状态组件
  Widget _buildLoadingWidget() {
    return LoadingStyle.buildLoadingWidget();
  }

  /// 构建错误状态组件
  Widget _buildErrorWidget() {
    return LoadingStyle.buildErrorWidget(
      message: controller.errorMessage.isNotEmpty 
          ? controller.errorMessage 
          : '未知错误',
      onRetry: () => controller.refreshData(),
    );
  }

  /// 构建带错误提示的内容
  Widget _buildErrorContent(BuildContext context) {
    return Column(
      children: [
        // 错误提示条
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: Colors.red.shade50,
          child: Row(
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red.shade600,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  controller.errorMessage.isNotEmpty 
                      ? controller.errorMessage 
                      : '网络请求失败',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontSize: 14,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => controller.refreshData(),
                child: Text(
                  '重试',
                  style: TextStyle(
                    color: Colors.red.shade600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
        // 正常内容
        Expanded(
          child: enableRefresh ? _buildRefreshableContent(context) : buildContent(context),
        ),
      ],
    );
  }

  /// 构建空状态组件
  Widget _buildEmptyWidget() {
    return LoadingStyle.buildEmptyWidget(
      message: '点击刷新重新加载',
      onRefresh: () => controller.refreshData(),
    );
  }
}

/// 带有SafeArea的基础视图
abstract class SafeBaseView<T extends BaseController> extends BaseView<T> {
  const SafeBaseView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: super.build(context),
    );
  }
}

/// 带有滚动功能的基础视图
abstract class ScrollableBaseView<T extends BaseController> extends BaseView<T> {
  const ScrollableBaseView({Key? key}) : super(key: key);

  /// 滚动控制器
  ScrollController? get scrollController => null;

  /// 滚动方向
  Axis get scrollDirection => Axis.vertical;

  /// 是否反向滚动
  bool get reverse => false;

  /// 滚动物理效果
  ScrollPhysics? get physics => null;

  @override
  Widget buildContent(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      scrollDirection: scrollDirection,
      reverse: reverse,
      physics: physics,
      child: buildScrollableContent(context),
    );
  }

  /// 构建可滚动的内容，子类实现
  Widget buildScrollableContent(BuildContext context);
}