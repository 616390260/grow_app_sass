import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/promotion_controller.dart';
import '../../../core/base/base_view.dart';
import 'package:do_task_project/app/core/widgets/localized_app_bar.dart';
import 'package:do_task_project/app/core/i18n/i18n_keys.dart';

class PromotionView extends BaseView<PromotionController> {
  const PromotionView({Key? key}) : super(key: key);

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return const LocalizedAppBar(
      titleKey: I18nKeys.promotion,
      backgroundColor: Color(0xFF4A90E2),
      foregroundColor: Colors.white,
    );
  }

  @override
  Widget buildContent(BuildContext context) {
    return Center(
      child: Text(
        I18nKeys.promotionPage.tr,
        style: const TextStyle(fontSize: 24),
      ),
    );
  }
}