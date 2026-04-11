// 用于检查i18n_keys.dart中的所有key是否在app_translations.dart的zh_CN部分都有对应的翻译
import 'dart:io';

void main() {
  final Stopwatch stopwatch = Stopwatch()..start();
  
  try {
    // 文件路径
    final String i18nKeysPath = 'lib/app/core/i18n/i18n_keys.dart';
    final String appTranslationsPath = 'lib/app/core/i18n/app_translations.dart';
    
    // 检查文件是否存在
    if (!File(i18nKeysPath).existsSync()) {
      print('❌ 文件不存在: $i18nKeysPath');
      return;
    }
    
    if (!File(appTranslationsPath).existsSync()) {
      print('❌ 文件不存在: $appTranslationsPath');
      return;
    }
    
    // 读取文件内容
    final String i18nKeysContent = File(i18nKeysPath).readAsStringSync();
    final String appTranslationsContent = File(appTranslationsPath).readAsStringSync();
    
    // 从i18n_keys.dart中提取所有key值（使用简单的正则表达式）
    final Set<String> allKeys = <String>{};
    // 简单的正则表达式，避免复杂的引号转义
    final RegExp keyRegex = RegExp("static const [a-zA-Z_]+ = '(.*?)'|static const [a-zA-Z_]+ = \"(.*?)\"");
    
    for (final match in keyRegex.allMatches(i18nKeysContent)) {
      if (match.group(1) != null) {
        allKeys.add(match.group(1)!);
      } else if (match.group(2) != null) {
        allKeys.add(match.group(2)!);
      }
    }
    
    // 从app_translations.dart的en_US部分提取已有的翻译key
    final Set<String> translatedKeys = <String>{};
    
    // 找到en_US部分的开始和结束位置
    final int enUSStart = appTranslationsContent.indexOf("'en_US': {");
    if (enUSStart != -1) {
      // 找到匹配的大括号结束位置
      int braceCount = 1;
      int enUSEnd = enUSStart + 8; // 跳过'en_US': {"'
      
      while (enUSEnd < appTranslationsContent.length && braceCount > 0) {
        enUSEnd++;
        if (appTranslationsContent[enUSEnd] == '{') {
          braceCount++;
        } else if (appTranslationsContent[enUSEnd] == '}') {
          braceCount--;
        }
      }
      
      if (braceCount == 0 && enUSEnd > enUSStart) {
        final String enUSContent = appTranslationsContent.substring(enUSStart + 8, enUSEnd);
        
        // 提取所有key
        final RegExp keyMatchRegex = RegExp("'([a-zA-Z_]+)':");
        for (final match in keyMatchRegex.allMatches(enUSContent)) {
          if (match.group(1) != null) {
            translatedKeys.add(match.group(1)!);
          }
        }
      }
    }
    
    // 检查遗漏的key
    final List<String> missingKeys = allKeys.where((key) => !translatedKeys.contains(key)).toList();
    missingKeys.sort();
    
    // 输出结果
    print('📊 扫描结果：');
    print('  总键值数量: ${allKeys.length}');
    print('  已翻译键值: ${translatedKeys.length}');
    print('  缺失键值: ${missingKeys.length}');
    
    if (missingKeys.isEmpty) {
      print('\n✅ 所有的i18n keys在en_US中都有对应的翻译！');
    } else {
      print('\n❌ 发现以下key在en_US中缺少翻译：');
      for (final String key in missingKeys) {
        print('- $key');
      }
      
      // 生成添加缺失键值的代码建议
      print('\n💡 缺失键值的翻译代码建议：');
      for (final String key in missingKeys) {
        print("  '$key': 'TODO: $key',");
      }
      
      // 生成完整的翻译代码
      print('\n📋 完整的en_US翻译部分（包含所有i18n_keys）：');
      print("'en_US': {");
      
      // 先打印已有的翻译
      final List<String> allKeysList = allKeys.toList();
      allKeysList.sort();
      
      for (final String key in allKeysList) {
        if (translatedKeys.contains(key)) {
          // 找到现有的翻译值
          final RegExp valueRegex = RegExp("'$key':s*'([^']*)'|'$key':s*\"([^\"]*)\"");
          final match = valueRegex.firstMatch(appTranslationsContent);
          String value;
          if (match != null) {
            value = match.group(1) ?? match.group(2) ?? key;
          } else {
            value = key; // 如果找不到，就用key作为值
          }
          print("  '$key': '$value',");
        } else {
          // 缺失的翻译，使用默认值
          print("  '$key': 'TODO: $key',");
        }
      }
      print("}");
    }
    
    // 检查在app_translations中但不在i18n_keys中的键值
    final List<String> extraKeys = translatedKeys.where((key) => !allKeys.contains(key)).toList();
    extraKeys.sort();
    
    if (extraKeys.isNotEmpty) {
      print('\n⚠️  发现以下key在app_translations中但不在i18n_keys中：');
      for (final String key in extraKeys) {
        print('- $key');
      }
    }
    
  } catch (e) {
    print('❌ 执行过程中出错: $e');
  } finally {
    stopwatch.stop();
    print('\n⏱️  执行时间: ${stopwatch.elapsedMilliseconds} 毫秒');
  }
}