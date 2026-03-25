#!/bin/bash

echo "🚀 DoTask APK 安装脚本"
echo "========================"

# 检查ADB是否安装
if ! command -v adb &> /dev/null; then
    echo "❌ ADB未安装，请先安装Android SDK Platform Tools"
    echo "   下载地址: https://developer.android.com/studio/releases/platform-tools"
    exit 1
fi

# 检查设备连接
echo "📱 检查设备连接..."
adb devices

echo ""
read -p "设备列表显示正确吗？(y/N): " confirm
if [[ $confirm != [yY] ]]; then
    echo "请确保设备已连接且已开启USB调试"
    exit 1
fi

# 安装APK
APK_PATH="build/app/outputs/flutter-apk/app-release.apk"
if [[ ! -f "$APK_PATH" ]]; then
    echo "❌ APK文件不存在: $APK_PATH"
    echo "请先运行: flutter build apk --release"
    exit 1
fi

echo "📦 正在安装APK..."
adb install -r "$APK_PATH"

if [[ $? -eq 0 ]]; then
    echo "✅ 安装成功！"
    echo "🎉 DoTask应用已安装到您的设备"
else
    echo "❌ 安装失败，请检查设备权限和存储空间"
fi