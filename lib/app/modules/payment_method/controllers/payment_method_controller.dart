import 'package:get/get.dart';
import '../../../core/base/base_controller.dart';
import '../../../core/i18n/i18n_keys.dart';

class PaymentMethodController extends BaseController {
  // 银行名称
  RxString bankName = ''.obs;
  
  // 收款账号
  RxString accountNumber = ''.obs;
  
  // 收款姓名
  RxString accountName = ''.obs;
  
  // 登录密码
  RxString loginPassword = ''.obs;
  
  // 国家/地区（从上个页面传递）
  String country = Get.arguments?['country'] ?? 'nigeria';
  
  @override
  void onInit() {
    super.onInit();
    // 初始化数据
    loadPaymentData();
  }
  
  // 加载支付信息
  void loadPaymentData() async {
    setLoading(true);
    try {
      // 模拟从API获取数据
      await Future.delayed(const Duration(seconds: 1));
      setSuccess();
    } catch (e) {
      setError(I18nKeys.errorUnknown.tr);
      showErrorMessage(I18nKeys.errorUnknown.tr);
    }
  }
  
  // 设置银行名称
  void setBankName(String name) {
    bankName.value = name;
  }
  
  // 设置收款账号
  void setAccountNumber(String number) {
    accountNumber.value = number;
  }
  
  // 设置收款姓名
  void setAccountName(String name) {
    accountName.value = name;
  }
  
  // 设置登录密码
  void setLoginPassword(String password) {
    loginPassword.value = password;
  }
  
  // 验证表单
  bool validateForm() {
    if (bankName.value.isEmpty) {
      showErrorMessage('请输入开户银行');
      return false;
    }
    if (accountNumber.value.isEmpty) {
      showErrorMessage('请输入收款账号');
      return false;
    }
    if (accountName.value.isEmpty) {
      showErrorMessage('请输入收款姓名');
      return false;
    }
    if (loginPassword.value.isEmpty) {
      showErrorMessage('请输入登录密码');
      return false;
    }
    return true;
  }
  
  // 提交收款信息
  void submitPaymentInfo() {
    if (!validateForm()) return;
    
    setLoading(true);
    
    // 模拟网络请求
    Future.delayed(const Duration(seconds: 2), () {
      setSuccess();
      showSuccessMessage('收款信息保存成功');
      
      // 返回上一页并传递数据
      Get.back(result: {
        'bankName': bankName.value,
        'accountNumber': accountNumber.value,
        'accountName': accountName.value,
      });
    });
  }
}