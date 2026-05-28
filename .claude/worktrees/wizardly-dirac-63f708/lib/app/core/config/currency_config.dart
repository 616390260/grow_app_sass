/// 货币符号配置
class CurrencyConfig {



  /// 计算积分换算金额
  /// 
  /// [points] 积分数量
  /// [exchangeRate] 汇率（每1积分换算的金额）
  /// [currencyCode] 货币代码
  static double calculateAmount(double points, double? exchangeRate) {
    if (exchangeRate == null || exchangeRate <= 0) {
      return 0.0;
    }
    return points * exchangeRate;
  }

  /// 格式化金额显示
  /// 
  /// [amount] 金额
  /// [currencyCode] 货币代码
  /// [decimals] 小数位数，默认为2
  static String formatAmount(double amount, String currencyCode, {int decimals = 2}) {
    final formattedAmount = amount.toStringAsFixed(decimals);
    return formattedAmount;
  }
}