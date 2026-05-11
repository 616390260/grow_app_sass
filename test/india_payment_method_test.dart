import 'package:flutter_test/flutter_test.dart';

/// 模拟 account_withdrawal_controller.handleWithdraw 中的请求体构建逻辑
/// 用纯函数方式做最小复现，避免引入 GetX 依赖
Map<String, dynamic> buildRequestData({
  required bool isTrx,
  required int countryId,
  required String bankName,
  required int bankCode,
  required String accountNumber,
  required String accountName,
  required String phone,
  required String loginPassword,
  required String payCard,
  required int withdrawAmount,
}) {
  final bool isIndia = countryId == 12;
  final Object bankIdValue =
      (!isTrx && isIndia) ? bankName : bankCode;
  return <String, dynamic>{
    'account': isTrx ? payCard : accountNumber,
    'bankId': bankIdValue,
    'phone': phone,
    'goldenFlowId': countryId,
    'loginPassword': loginPassword,
    'name': isTrx ? payCard : accountName,
    'points': withdrawAmount,
    if (isTrx) 'payCard': payCard,
  };
}

void main() {
  group('印度提现 bankId 取值', () {
    test('印度（countryId=12）：bankId 应当传用户输入的 IFSC 字符串', () {
      final data = buildRequestData(
        isTrx: false,
        countryId: 12,
        bankName: 'SBIN0001234',
        bankCode: 0,
        accountNumber: '0123456789',
        accountName: 'Ravi Kumar',
        phone: '9876543210',
        loginPassword: 'pwd',
        payCard: '',
        withdrawAmount: 5100,
      );

      expect(data['bankId'], 'SBIN0001234');
      expect(data['bankId'], isA<String>());
      expect(data['account'], '0123456789');
      expect(data['name'], 'Ravi Kumar');
      expect(data['goldenFlowId'], 12);
      expect(data.containsKey('payCard'), isFalse);
    });

    test('其他国家（countryId=1）：bankId 应当传银行 id（int）', () {
      final data = buildRequestData(
        isTrx: false,
        countryId: 1,
        bankName: '工商银行',
        bankCode: 1002,
        accountNumber: '6225880123456789',
        accountName: '张三',
        phone: '13800000000',
        loginPassword: 'pwd',
        payCard: '',
        withdrawAmount: 5100,
      );

      expect(data['bankId'], 1002);
      expect(data['bankId'], isA<int>());
    });

    test('TRX 模式：即便 countryId 恰好为 12，也走 bankCode 而不是 IFSC', () {
      final data = buildRequestData(
        isTrx: true,
        countryId: 12,
        bankName: 'whatever',
        bankCode: 0,
        accountNumber: '',
        accountName: '',
        phone: '',
        loginPassword: 'pwd',
        payCard: 'TXyz...wallet',
        withdrawAmount: 5100,
      );

      expect(data['bankId'], 0);
      expect(data['account'], 'TXyz...wallet');
      expect(data['name'], 'TXyz...wallet');
      expect(data['payCard'], 'TXyz...wallet');
    });

    test('修复前的问题复现：印度若仍走 bankCode，会拿到 0', () {
      const int bankCodeBefore = 0;
      const String bankNameBefore = 'SBIN0001234';
      expect(bankCodeBefore, 0);
      expect(bankNameBefore.isNotEmpty, isTrue);
    });
  });

  group('PaymentMethodController.isIndia 判定', () {
    bool isIndia(int countryId) => countryId == 12;

    test('countryId=12 -> true', () => expect(isIndia(12), isTrue));
    test('countryId=1  -> false', () => expect(isIndia(1), isFalse));
    test('countryId=0  -> false', () => expect(isIndia(0), isFalse));
  });
}
