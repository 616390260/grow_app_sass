import 'package:do_task_project/app/core/base/base_controller.dart';
import 'package:do_task_project/app/core/i18n/i18n_keys.dart';
import 'package:do_task_project/app/modules/invite_friend/models/invite_info_response_model.dart';
import 'package:do_task_project/app/modules/invite_friend/models/valid_user_model.dart';
import 'package:get/get.dart';
import '../services/valid_users_api_service.dart';

class ValidUsersController extends BaseController {
  // 有效用户列表
  final validUsers = <ValidUserModel>[].obs;
  
  // 筛选状态
  final isFiltered = true.obs;
  
  // 统计数据
  final sendCount = 0.obs;
  final growth = 0.obs;
  final registerDays = 0.obs;
  
  // API服务
  final ValidUsersApiService _apiService = ValidUsersApiService();

  @override
  void onInit() {
    super.onInit();
    loadValidUsers();
  }

  /// 加载有效用户列表
  Future<void> loadValidUsers() async {
    safeApiCall(
      // API调用函数
      () async {
        final status = isFiltered.value ? 1 : 0;
        return await _apiService.getInviteInfo(status: status);
      },
      // 成功回调函数
      (InviteInfoResponseModel result) {
        // 更新统计数据
        sendCount.value = result.sendCount ?? 0;
        growth.value = result.growth ?? 0;
        registerDays.value = result.registerDays ?? 0;
        
        // 更新用户列表
        if (result.user?.records != null) {
          final users = result.user!.records!.map((inviteUser) {
            return ValidUserModel(
              phone: inviteUser.phone,
              account: inviteUser.account,
              points: inviteUser.points,
              createTime: inviteUser.createTime,
              sendCount: 0, // API返回的数据中没有sendCount字段，使用默认值
            );
          }).toList();
          
          validUsers.assignAll(users);
        } else {
          validUsers.clear();
        }
        
        setSuccess();
      },
      // 自定义错误消息
      errorMessage: I18nKeys.loadValidUsersFailed.tr,
      // 显示加载状态
      showLoading: true,
    );
  }
  
  /// 切换筛选状态
  void toggleFilter() {
    isFiltered.value = !isFiltered.value;
    // 重新加载数据
    loadValidUsers();
  }
}