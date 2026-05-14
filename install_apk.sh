#!/bin/bash

echo "🚀 DoTask APK 安装脚本"
echo "========================"

# ── 用法 ──────────────────────────────────────────────────────────
#   ./install_apk.sh                  仅安装已有的 release APK（旧行为）
#   ./install_apk.sh <TENANT_ID>      先用指定租户ID重新打包再安装
#
# 说明：APK 端的租户ID只能在打包时通过 --dart-define=TENANT_ID 注入，
#       不传则 TenantService 拿不到 tenantId，X-Tenant-Id 请求头为空，
#       app/tenant/template 不会被请求，logo 等品牌配置会回落到默认值。
#       （H5 端是运行时从浏览器域名取租户，所以不受影响。）
#
# 可选：通过环境变量额外指定生产域名
#   RELEASE_BASE_URL=https://api.xxx.com/ ./install_apk.sh <TENANT_ID>
# ─────────────────────────────────────────────────────────────────

TENANT_ID="$1"

# 检查ADB是否安装
if ! command -v adb &> /dev/null; then
    echo "❌ ADB未安装，请先安装Android SDK Platform Tools"
    echo "   下载地址: https://developer.android.com/studio/releases/platform-tools"
    exit 1
fi

# 如果传入了 TENANT_ID，则先重新打包
if [[ -n "$TENANT_ID" ]]; then
    echo "🏷️  租户ID: $TENANT_ID"
    BUILD_ARGS="--release --dart-define=TENANT_ID=$TENANT_ID"
    if [[ -n "$RELEASE_BASE_URL" ]]; then
        echo "🌐 生产域名: $RELEASE_BASE_URL"
        BUILD_ARGS="$BUILD_ARGS --dart-define=RELEASE_BASE_URL=$RELEASE_BASE_URL"
    fi
    echo "🔨 正在打包: flutter build apk $BUILD_ARGS"
    flutter build apk $BUILD_ARGS
    if [[ $? -ne 0 ]]; then
        echo "❌ 打包失败"
        exit 1
    fi
else
    echo "ℹ️  未传入 TENANT_ID，将直接安装已有的 release APK"
    echo "   如需指定租户重新打包：./install_apk.sh <TENANT_ID>"
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
    echo "请先运行: flutter build apk --release --dart-define=TENANT_ID=<租户ID>"
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
