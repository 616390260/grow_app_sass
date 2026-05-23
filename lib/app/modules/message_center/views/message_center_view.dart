import 'package:do_task_project/app/core/base/base_view.dart';
import 'package:do_task_project/app/core/constants/image_assets.dart';
import 'package:do_task_project/app/core/i18n/i18n_keys.dart';
import 'package:do_task_project/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:do_task_project/app/core/widgets/rich_html_text.dart';

import '../controllers/message_center_controller.dart';

class MessageCenterView extends BaseView<MessageCenterController> {
  const MessageCenterView({super.key});

  @override
  Widget buildContent(BuildContext context) {
    // 实现沉浸式状态栏
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: controller.onBackPress,
        ),
        centerTitle: true,
        title: Text(
          I18nKeys.messageCenter.tr,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Obx(() {
        // 处理空状态
        if (controller.sysAnnouncement.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  ImageAssets.msgEmpty,
                  width: 140,
                  height: 140,
                ),
                const SizedBox(height: 16),
                Text(
                  I18nKeys.noMessage.tr,
                  style: const TextStyle(
                    color: Color(0xFF999999),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }
        
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: controller.sysAnnouncement.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final message = controller.sysAnnouncement[index];
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.createTime ?? '',
                    style: const TextStyle(
                      color: Color(0xFF999999),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    message.title ?? '',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // message.isExpanded
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            (message.contentIsRichText == '1')
                                ? RichHtmlText(
                                    html: message.content ?? '',
                                    style: const TextStyle(
                                      color: Color(0xFF666666),
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.left,
                                  )
                                : Text(
                                    message.content ?? '',
                                    style: const TextStyle(
                                      color: Color(0xFF666666),
                                      fontSize: 14,
                                    ),
                                  ),
                            const SizedBox(height: 12),
                          ],
                        )
                  //     : Container(),
                  // GestureDetector(
                  //   onTap: () => controller.toggleMessageExpansion(index),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.end,
                  //     children: [
                  //       Text(
                  //         message['isExpanded']
                  //             ? I18nKeys.collapse.tr
                  //             : I18nKeys.expand.tr,
                  //         style: const TextStyle(
                  //           color: Color(0xFF4A90E2),
                  //           fontSize: 14,
                  //         ),
                  //       ),
                  //       Icon(
                  //         message['isExpanded']
                  //             ? Icons.keyboard_arrow_up
                  //             : Icons.keyboard_arrow_down,
                  //         color: const Color(0xFF4A90E2),
                  //         size: 18,
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            );
          },
        );
      }),
    );
  }

}
