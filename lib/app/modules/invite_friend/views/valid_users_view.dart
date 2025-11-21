import 'package:do_task_project/app/core/base/base_view.dart';
import 'package:do_task_project/app/core/i18n/i18n_keys.dart';
import 'package:do_task_project/app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/valid_users_controller.dart';

class ValidUsersView extends BaseView<ValidUsersController> {
  const ValidUsersView({Key? key}) : super(key: key);

  @override
  Widget buildContent(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          I18nKeys.validUsersTitle.tr,
          style: const TextStyle(fontSize: 17, color: Colors.white),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 24, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        // 沉浸式状态栏配置
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children:[
            // 蓝色渐变背景头部
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF477DF2), // 20% 位置
                    const Color(0xFF47ABF2), // 60% 位置
                    const Color(0xFFF9F9F9), // 100% 位置
                  ],
                  stops: const [0.4, 0.8, 1],
                ),
              ),
              padding: const EdgeInsets.only(top: 99, left: 15, right: 15),
              child: Column(
                children: [
                  // 有效用户条件统计
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          I18nKeys.validUsersConditions.tr,
                          style: TextStyle(
                            fontSize: 15,
                            color: AppTheme.threeColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 22),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _buildStatItem(
                              I18nKeys.growthValue.tr,
                              controller.growth.value.toString(),
                            ),
                            _buildStatItem(I18nKeys.registerDays.tr, '≥${controller.registerDays.value}'),
                            _buildStatItem(I18nKeys.sendCount.tr, controller.sendCount.value.toString()),
                          ],
                        ),
                        const SizedBox(height: 9),
                      ],
                    ),
                  ),
                  // 筛选区域
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 15,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          I18nKeys.directUsers.tr,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.threeColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              I18nKeys.validUsers.tr,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.threeColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Obx(
                              () => Switch(
                                value: controller.isFiltered.value,
                                onChanged: (value) => controller.toggleFilter(),
                                activeThumbColor: Colors.white,
                                activeTrackColor: AppTheme.primaryColor,
                                inactiveThumbColor: const Color(0xFFD9D9D9),
                                inactiveTrackColor: const Color(0xFFF5F5F5),
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  // 用户列表
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        // 列表头部
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 55,
                            vertical: 18,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: const Color(0xFFF0F0F0),
                                width: 0.5,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  I18nKeys.phoneNumber.tr,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.threeColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  I18nKeys.messagesSent.tr,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.threeColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // 列表内容
                        Obx(
                          () => ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: controller.validUsers.length,
                            itemBuilder: (context, index) {
                              final user = controller.validUsers[index];
                              return Container(
                                padding: const EdgeInsets.only(
                                  left: 35,
                                  top: 15,
                                  bottom: 15,
                                  right: 75,
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom:
                                        index < controller.validUsers.length - 1 
                                        ? BorderSide(
                                            color: const Color(0xFFF0F0F0),
                                            width: 0.5,
                                          )
                                        : BorderSide.none,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        user.account ?? user.phone ?? I18nKeys.unknownUser.tr,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppTheme.sixColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        (user.sendCount ?? 0).toString(),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppTheme.primaryColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.threeColor,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: AppTheme.sixColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
