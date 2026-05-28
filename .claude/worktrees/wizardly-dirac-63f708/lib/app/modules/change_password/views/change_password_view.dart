import 'package:do_task_project/app/core/theme/app_theme.dart';
import 'package:do_task_project/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/base/base_view.dart';
import '../../../core/i18n/i18n_keys.dart';
import '../controllers/change_password_controller.dart';

class ChangePasswordView extends BaseView<ChangePasswordController> {
  const ChangePasswordView({Key? key}) : super(key: key);

  @override
  Widget buildContent(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (Get.key.currentState!.canPop()) {
              Get.back();
            } else {
              // 刷新后 fallback 到首页
              Get.offAllNamed(Routes.root);
            }
          },
        ),
        title: Text(
          I18nKeys.changePassword.tr,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 23),
              _buildOldPasswordField(),
              const SizedBox(height: 20),
              _buildNewPasswordField(),
              const SizedBox(height: 25),
              _buildConfirmButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOldPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          I18nKeys.oldPassword.tr,
          style: TextStyle(
            fontSize: 15,
            color: AppTheme.threeColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 15),
        Obx(
          () => TextField(
            controller: controller.oldPasswordController,
            focusNode: controller.oldPasswordFocus,
            obscureText: !controller.isOldPasswordVisible.value,
            style: const TextStyle(fontSize: 16, color: Colors.black),
            decoration: InputDecoration(
              hintText: I18nKeys.enterOldPassword.tr,
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(color: AppTheme.nineColor, width: 0.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(color: AppTheme.nineColor, width: 0.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: Colors.blue, width: 1),
              ),
              errorText: controller.oldPasswordError.value.isNotEmpty
                  ? controller.oldPasswordError.value
                  : null,
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.red, width: 1),
              ),
              // suffixIcon: IconButton(
              //   icon: Icon(
              //     controller.isOldPasswordVisible.value
              //         ? Icons.visibility
              //         : Icons.visibility_off,
              //     color: Colors.grey,
              //   ),
              //   onPressed: controller.toggleOldPasswordVisibility,
              // ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNewPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          I18nKeys.newPassword.tr,
          style: TextStyle(
            fontSize: 15,
            color: AppTheme.threeColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 15),
        Obx(
          () => TextField(
            controller: controller.newPasswordController,
            focusNode: controller.newPasswordFocus,
            obscureText: !controller.isNewPasswordVisible.value,
            style: const TextStyle(fontSize: 16, color: Colors.black),
            decoration: InputDecoration(
              hintText: I18nKeys.enterNewPassword.tr,
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(color: AppTheme.nineColor, width: 0.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(color: AppTheme.nineColor, width: 0.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: Colors.blue, width: 1),
              ),
              errorText: controller.newPasswordError.value.isNotEmpty
                  ? controller.newPasswordError.value
                  : null,
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.red, width: 1),
              ),
              // suffixIcon: IconButton(
              //   icon: Icon(
              //     controller.isNewPasswordVisible.value
              //         ? Icons.visibility
              //         : Icons.visibility_off,
              //     color: Colors.grey,
              //   ),
              //   onPressed: controller.toggleNewPasswordVisibility,
              // ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmButton() {
    return ElevatedButton(
      onPressed: controller.isLoading ? null : controller.changePassword,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.primaryColor,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      child: controller.isLoading
          ? const CircularProgressIndicator(color: Colors.white)
          : Text(
              I18nKeys.confirm.tr,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
    );
  }
}