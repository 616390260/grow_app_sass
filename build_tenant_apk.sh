#!/bin/bash
# ============================================================
# 租户专属APK自动化打包脚本
# 用法: bash build_tenant_apk.sh <tenantId> <appName> <logoUrl> <apiBaseUrl> <flutterProject> <outputDir> <gitRepo> <versionName>
# ============================================================

set -e

# ============ 低内存服务器保护 ============

# 检查可用内存（MB），低于 1.5GB 时拒绝打包，防止 OOM 影响其他服务
AVAIL_MEM_MB=$(awk '/MemAvailable/ {printf "%d", $2/1024}' /proc/meminfo 2>/dev/null || echo "0")
if [ "$AVAIL_MEM_MB" -gt 0 ] && [ "$AVAIL_MEM_MB" -lt 1500 ]; then
    echo "错误: 可用内存仅 ${AVAIL_MEM_MB}MB，低于 1500MB 安全阈值，请稍后再试"
    exit 1
fi
echo "当前可用内存: ${AVAIL_MEM_MB}MB"

# 检查 swap，没有则提示
SWAP_TOTAL=$(awk '/SwapTotal/ {printf "%d", $2/1024}' /proc/meminfo 2>/dev/null || echo "0")
if [ "$SWAP_TOTAL" -lt 1024 ]; then
    echo "警告: Swap仅 ${SWAP_TOTAL}MB，建议至少 4GB swap 防止 OOM"
    echo "  创建方法: fallocate -l 4G /swapfile && chmod 600 /swapfile && mkswap /swapfile && swapon /swapfile"
fi

# 防止并发打包：用文件锁确保同一时刻只有一个打包任务
LOCK_FILE="/tmp/flutter_build.lock"
exec 200>"$LOCK_FILE"
if ! flock -n 200; then
    echo "错误: 另一个打包任务正在运行，请等待完成后再试"
    exit 1
fi

# 限制 Gradle/Java 进程内存
export GRADLE_OPTS="-Xmx2g -XX:MaxMetaspaceSize=512m"

# ============ 环境变量 ============

# 设置环境变量（Java进程执行时PATH可能不包含这些路径）
export PATH="/opt/flutter/bin:/opt/android-sdk/cmdline-tools/latest/bin:/opt/android-sdk/platform-tools:$PATH"
export ANDROID_HOME="/opt/android-sdk"
export JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64"
export GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i /data/ssh-keys/id_ed25519"

TENANT_ID=$1
APP_NAME=$2
LOGO_URL=$3
API_BASE_URL=$4
FLUTTER_PROJECT=$5
OUTPUT_DIR=$6
GIT_REPO=$7
VERSION_NAME=$8

# 默认值
FLUTTER_PROJECT=${FLUTTER_PROJECT:-"/data/flutter-app"}
OUTPUT_DIR=${OUTPUT_DIR:-"/data/apk-output"}
API_BASE_URL=${API_BASE_URL:-"https://api.gows.vip"}
VERSION_NAME=${VERSION_NAME:-"1.0.0"}

echo "============================================================"
echo "开始为租户 ${TENANT_ID} 打包APK"
echo "App名称: ${APP_NAME}"
echo "Logo URL: ${LOGO_URL}"
echo "API地址: ${API_BASE_URL}"
echo "版本号: ${VERSION_NAME}"
echo "Flutter项目: ${FLUTTER_PROJECT}"
echo "输出目录: ${OUTPUT_DIR}"
echo "============================================================"

# 1. 检查Flutter SDK
if ! command -v flutter &> /dev/null; then
    echo "错误: 未找到Flutter SDK，请先安装"
    exit 1
fi

echo "Flutter版本: $(flutter --version --machine 2>/dev/null | head -1 || flutter --version 2>&1 | head -1)"

# 2. 如果项目不存在，从GitHub克隆
if [ ! -d "$FLUTTER_PROJECT" ]; then
    if [ -z "$GIT_REPO" ]; then
        echo "错误: Flutter项目目录不存在且未配置Git仓库地址"
        exit 1
    fi
    echo "项目不存在，从GitHub克隆..."
    git clone "$GIT_REPO" "$FLUTTER_PROJECT"
fi

cd "$FLUTTER_PROJECT"

# 3. 拉取最新代码
echo ">>> 拉取最新代码..."
git fetch origin
git reset --hard origin/$(git rev-parse --abbrev-ref HEAD)
echo "当前commit: $(git log --oneline -1)"

# 4. 安装依赖
echo ">>> 安装Flutter依赖..."
flutter pub get

# 5. 替换App名称（修改 strings.xml，AndroidManifest 通过 @string/app_name 引用）
if [ -n "$APP_NAME" ]; then
    echo ">>> 替换App名称为: ${APP_NAME}"
    STRINGS_FILE="android/app/src/main/res/values/strings.xml"
    if [ -f "$STRINGS_FILE" ]; then
        sed -i.bak "s|<string name=\"app_name\">.*</string>|<string name=\"app_name\">${APP_NAME}</string>|" "$STRINGS_FILE"
        rm -f "${STRINGS_FILE}.bak"
    fi
fi

# 6. 替换启动器图标（实际图标文件为 logo.jpg，AndroidManifest 引用 @mipmap/logo）
if [ -n "$LOGO_URL" ] && [ "$LOGO_URL" != "" ]; then
    echo ">>> 下载并替换App图标..."
    LOGO_TEMP="/tmp/tenant_${TENANT_ID}_logo.png"

    if curl -sS -o "$LOGO_TEMP" "$LOGO_URL" 2>/dev/null; then
        if command -v convert &> /dev/null; then
            echo "使用ImageMagick生成各分辨率图标..."
            convert "$LOGO_TEMP" -resize 48x48   "android/app/src/main/res/mipmap-mdpi/logo.jpg" 2>/dev/null || true
            convert "$LOGO_TEMP" -resize 72x72   "android/app/src/main/res/mipmap-hdpi/logo.jpg" 2>/dev/null || true
            convert "$LOGO_TEMP" -resize 96x96   "android/app/src/main/res/mipmap-xhdpi/logo.jpg" 2>/dev/null || true
            convert "$LOGO_TEMP" -resize 144x144 "android/app/src/main/res/mipmap-xxhdpi/logo.jpg" 2>/dev/null || true
            convert "$LOGO_TEMP" -resize 192x192 "android/app/src/main/res/mipmap-xxxhdpi/logo.jpg" 2>/dev/null || true
            echo "图标替换完成"
        else
            echo "警告: 未安装ImageMagick，跳过图标替换。请安装: apt-get install imagemagick"
        fi
        rm -f "$LOGO_TEMP"
    else
        echo "警告: 下载Logo失败，跳过图标替换"
    fi
fi

# 7. Flutter打包
#    --build-name  覆盖 pubspec.yaml 中的 version（versionName）
#    --build-number 覆盖 versionCode（递增整数，默认1）
#    --dart-define=TENANT_ID   → EnvironmentConfig.compileTenantId → TenantService 自动初始化
#    --dart-define=APP_NAME    → EnvironmentConfig.compileAppName  → Flutter内部名称回退值
#    --dart-define=BASE_URL    → EnvironmentConfig._getRuntimeUrl  → API基础地址
echo ">>> 开始Flutter打包..."
flutter build apk --release \
    --build-name="${VERSION_NAME}" \
    --build-number="${BUILD_NUMBER:-1}" \
    --dart-define=TENANT_ID=${TENANT_ID} \
    --dart-define=APP_NAME="${APP_NAME}" \
    --dart-define=BASE_URL="${API_BASE_URL}"

# 8. 复制产物
echo ">>> 复制APK产物..."
mkdir -p "$OUTPUT_DIR"
APK_SOURCE="build/app/outputs/flutter-apk/app-release.apk"
APK_TARGET="${OUTPUT_DIR}/app_tenant_${TENANT_ID}.apk"

if [ -f "$APK_SOURCE" ]; then
    cp "$APK_SOURCE" "$APK_TARGET"
    APK_SIZE=$(stat -f%z "$APK_TARGET" 2>/dev/null || stat -c%s "$APK_TARGET" 2>/dev/null || echo "unknown")
    echo "APK文件: ${APK_TARGET}"
    echo "文件大小: ${APK_SIZE} bytes"
else
    echo "错误: APK文件不存在: ${APK_SOURCE}"
    exit 1
fi

# 9. 还原修改（恢复Git状态，确保下次打包干净）
echo ">>> 还原项目文件..."
git checkout -- android/app/src/main/res/values/strings.xml 2>/dev/null || true
git checkout -- android/app/src/main/res/ 2>/dev/null || true

# 10. 清理构建缓存（低磁盘服务器防止撑满）
echo ">>> 清理构建缓存..."
rm -rf build/app/intermediates 2>/dev/null || true
rm -rf build/app/tmp 2>/dev/null || true

echo "============================================================"
echo "租户 ${TENANT_ID} APK打包完成!"
echo "APK路径: ${APK_TARGET}"
echo "============================================================"
