import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../i18n/i18n_keys.dart';
import 'base_controller.dart';
import '../theme/loading_style.dart';

/// 基础视图类，封装通用UI组件
abstract class BaseView<T extends BaseController> extends GetView<T> {
  const BaseView({super.key});

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

  /// 键盘弹起时是否自动调整 body 高度（默认 true，与 Scaffold 一致）。
  /// 子页若有固定背景 / 装饰元素需要保持位置不被键盘推动，可重写为 false，
  /// 并在内部 ScrollView 上补 `padding: EdgeInsets.only(bottom: viewInsets.bottom)`
  /// 以保证焦点输入框仍能滚动到可见区域。
  bool get resizeToAvoidBottomInset => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: buildAppBar(context),
      body: _buildBody(context),
      floatingActionButton: buildFloatingActionButton(context),
      bottomNavigationBar: buildBottomNavigationBar(context),
      drawer: buildDrawer(context),
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    );
  }

  /// 构建页面主体
  Widget _buildBody(BuildContext context) {
    return Obx(() {
      // 基础内容
      Widget content;
      
      // 根据页面状态确定显示的基础内容
      if (controller.pageState == PageState.error && showErrorState) {
        content = _buildErrorContent(context);
      } else if (controller.pageState == PageState.empty && showEmptyState) {
        content = _buildEmptyWidget();
      } else {
        content = enableRefresh ? _buildRefreshableContent(context) : buildContent(context);
      }
      
      // 如果是加载状态，在内容上方显示对话框样式的加载指示器
      if (controller.pageState == PageState.loading && showLoadingState) {
        return Stack(
          children: [
            // 基础内容保持可见
            content,
            // 在上层显示对话框样式的加载指示器（半透明背景）
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: EdgeInsets.all(20.0), // 添加内边距
                child: _buildLoadingWidget(),
              ),
            ),
          ],
        );
      }
      
      return content;
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
                      : I18nKeys.networkRequestFailed.tr,
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontSize: 14,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => controller.refreshData(),
                child: Text(
                  I18nKeys.retry.tr,
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
      message: I18nKeys.tapToRefresh.tr,
      onRefresh: () => controller.refreshData(),
    );
  }
}

/// 带有SafeArea的基础视图
abstract class SafeBaseView<T extends BaseController> extends BaseView<T> {
  const SafeBaseView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: super.build(context),
    );
  }
}

/// 带有滚动功能的基础视图
abstract class ScrollableBaseView<T extends BaseController> extends BaseView<T> {
  const ScrollableBaseView({super.key});

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
