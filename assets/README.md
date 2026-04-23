# 多语言Assets使用指南

## 文件夹结构

```
assets/
└── images/
    ├── zh_CN/          # 中文简体
    ├── en_US/          # 英语
    ├── id_ID/          # 印尼语
    ├── bn_BD/          # 孟加拉语
    ├── hi_IN/          # 印地语
    ├── es_ES/          # 西班牙语
    └── default/        # 默认资源（当指定语言不存在时使用）
```

## 使用方法

### 1. 基本使用

```dart
import 'package:do_task_project/app/core/utils/localized_assets.dart';

// 获取本地化图片路径
String imagePath = LocalizedAssets.getImagePath('welcome_banner.png');

// 直接获取AssetImage对象
AssetImage image = LocalizedAssets.getLocalizedImage('logo.png');

// 在Widget中使用
Image.asset(LocalizedAssets.getImagePath('welcome_banner.png'))

// 或者
Image(image: LocalizedAssets.getLocalizedImage('logo.png'))
```

### 2. 使用扩展方法

```dart
// 更简洁的写法
Image.asset('welcome_banner.png'.localizedImagePath)

// 或者
Image(image: 'logo.png'.localizedImage)
```

### 3. 带回退机制的使用

```dart
// 如果当前语言的图片不存在，会自动使用default文件夹中的图片
String imagePath = LocalizedAssets.getImagePathWithFallback('special_banner.png');
```

## 添加新的多语言图片

1. 将图片文件放入对应语言的文件夹中
2. 确保所有语言文件夹都有相同文件名的图片
3. 在default文件夹中放置默认版本作为回退

## 注意事项

- 图片文件名在所有语言文件夹中应保持一致
- 建议在default文件夹中放置所有图片的默认版本
- 支持的图片格式：PNG, JPG, JPEG, GIF, WebP, SVG等Flutter支持的格式
- 建议使用SVG格式以获得更好的缩放效果和更小的文件大小