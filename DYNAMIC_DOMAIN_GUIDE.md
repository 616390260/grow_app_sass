# 动态域名配置指南

## 概述
现在您可以通过多种方式在打包时动态改变域名，无需修改代码即可切换不同的API地址。

## 使用方法

### 方法一：通过 Flutter 构建参数配置（推荐）

#### 1. 通用域名配置
```bash
# 开发环境
flutter run -d PERM00 --dart-define=BASE_URL=https://dev-api.yourdomain.com/

# 发布到Android
flutter build apk --dart-define=BASE_URL=https://prod-api.yourdomain.com/

# 发布到iOS
flutter build ios --dart-define=BASE_URL=https://prod-api.yourdomain.com/
```

#### 2. 环境特定域名配置
```bash
# 只为调试环境配置域名
flutter run -d PERM00 --dart-define=DEBUG_BASE_URL=https://debug-api.yourdomain.com/

# 只为发布环境配置域名
flutter build apk --dart-define=RELEASE_BASE_URL=https://prod-api.yourdomain.com/
```

#### 3. 同时配置多个环境
```bash
# 同时配置调试和生产环境
flutter build apk \
  --dart-define=DEBUG_BASE_URL=https://debug-api.yourdomain.com/ \
  --dart-define=RELEASE_BASE_URL=https://prod-api.yourdomain.com/
```

### 方法二：通过配置文件

#### 1. 创建配置文件
在项目根目录创建 `config.env` 文件：
```env
# 开发环境配置
DEBUG_BASE_URL=https://debug-api.yourdomain.com/

# 生产环境配置
RELEASE_BASE_URL=https://prod-api.yourdomain.com/

# 通用配置
BASE_URL=https://default-api.yourdomain.com/
```

#### 2. 使用配置文件构建
```bash
# 读取配置文件并构建
source config.env && flutter build apk --dart-define=BASE_URL="$BASE_URL"
```

### 方法三：通过CI/CD脚本

在您的构建脚本中：
```bash
#!/bin/bash
# 根据环境变量选择域名
if [ "$BUILD_ENV" = "production" ]; then
  DOMAIN="https://prod-api.yourdomain.com/"
elif [ "$BUILD_ENV" = "staging" ]; then
  DOMAIN="https://staging-api.yourdomain.com/"
else
  DOMAIN="https://dev-api.yourdomain.com/"
fi

flutter build apk --dart-define=BASE_URL="$DOMAIN"
```

## 优先级规则

当配置多个域名时，按以下优先级使用：

1. **环境专用URL** - `DEBUG_BASE_URL` 或 `RELEASE_BASE_URL`
2. **通用URL** - `BASE_URL`
3. **代码中默认URL** - `environment_config.dart` 中的 fallback

## 验证配置

在应用启动时，您可以通过以下方式验证当前使用的域名：

```dart
// 在应用启动时调用
EnvironmentConfig.instance.printEnvironmentInfo();
```

控制台会输出类似：
```
=== 环境配置信息 ===
当前环境: debug
基础URL: https://dev-api.yourdomain.com/
应用名称: DoTask (Debug)
连接超时: 30000ms
接收超时: 30000ms
启用日志: true
启用网络日志: true
缓存过期时间: 60s
最大重试次数: 1
==================
```

## 不同环境的域名示例

### 开发阶段
```bash
flutter run -d PERM00 --dart-define=BASE_URL=http://localhost:8080/
```

### 测试阶段
```bash
flutter build apk --dart-define=BASE_URL=https://test-api.yourdomain.com/
```

### 生产阶段
```bash
flutter build apk --dart-define=RELEASE_BASE_URL=https://api.WorkGosys.com/
```

### Web版本打包

#### 构建Web版本
```bash
# 开发环境运行Web版本
flutter run -d chrome --dart-define=BASE_URL=https://dev-api.yourdomain.com/

# 构建Web版本
flutter build web --dart-define=BASE_URL=https://api.WorkGosys.com/
```

#### Web版本特定配置
```bash
# 为Web版本指定特定的域名
flutter build web \
  --dart-define=BASE_URL=https://api.WorkGosys.com/ \
  --web-renderer html \
  --dart-define=WEB_BASE_URL=https://api.WorkGosys.com/

# 优化构建（生产环境推荐）
flutter build web \
  --dart-define=RELEASE_BASE_URL=https://api.WorkGosys.com/ \
  --release \
  --dart-define=flutter.web.disableBuildTimestamp=true
```

#### 在CI/CD中部署Web版本
```bash
#!/bin/bash
# Web版本部署脚本
BUILD_ENV=${1:-production}

if [ "$BUILD_ENV" = "production" ]; then
  DOMAIN="https://api.WorkGosys.com/"
elif [ "$BUILD_ENV" = "staging" ]; then
  DOMAIN="https://staging-api.yourdomain.com/"
else
  DOMAIN="https://dev-api.yourdomain.com/"
fi

# 构建Web版本
flutter build web \
  --dart-define=BASE_URL="$DOMAIN" \
  --release \
  --dart-define=flutter.web.disableBuildTimestamp=true

# 输出构建结果
echo "Web版本已构建完成，API地址: $DOMAIN"
```

## 运行打包好的Web Release包

### 方法一：使用构建脚本（推荐）

我已经为您创建了 `build_web.sh` 脚本，使用非常简单：

```bash
# 给脚本添加执行权限
chmod +x build_web.sh

# 构建开发环境版本并启动本地服务器
./build_web.sh dev

# 构建生产环境版本并启动本地服务器
./build_web.sh prod

# 构建测试环境版本并启动本地服务器
./build_web.sh staging
```

### 方法二：手动运行

#### 1. 构建Web包
```bash
# 构建Web版本
flutter build web --dart-define=BASE_URL=https://api.WorkGosys.com/ --release

# 构建完成后，文件在 build/web 目录下
```

#### 2. 本地测试运行

**使用Python服务器（推荐）：**
```bash
# 进入构建目录
cd build/web

# 使用Python3启动服务器
python3 -m http.server 8080

# 或者使用Python2
python -m SimpleHTTPServer 8080

# 然后在浏览器中访问: http://localhost:8080
```

**使用Node.js服务器：**
```bash
# 全局安装 serve
npm install -g serve

# 启动服务器
serve -s build/web -l 8080

# 浏览器访问: http://localhost:8080
```

**使用PHP服务器：**
```bash
# 使用PHP内置服务器
cd build/web
php -S localhost:8080
```

### 方法三：直接打开文件

对于简单测试，可以直接用浏览器打开：
```bash
# 在 macOS 上直接打开
open build/web/index.html

# 在 Windows 上直接打开
start build/web/index.html

# 在 Linux 上直接打开
xdg-open build/web/index.html
```

**注意：** 直接打开文件可能会有跨域问题，建议使用HTTP服务器。

### 部署到Web服务器

#### 1. 上传到服务器
将 `build/web/` 目录的所有内容上传到您的Web服务器：

```bash
# 使用 scp 上传（示例）
scp -r build/web/* user@your-server.com:/var/www/html/

# 使用 rsync 同步
rsync -avz build/web/ user@your-server.com:/var/www/html/
```

#### 2. Nginx配置示例
```nginx
server {
    listen 80;
    server_name yourdomain.com;
    
    root /var/www/html;
    index index.html;
    
    # Flutter Web特定配置
    location / {
        try_files $uri $uri/ /index.html;
    }
    
    # 缓存静态资源
    location /assets/ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
    
    # Gzip压缩
    gzip on;
    gzip_types text/css application/javascript application/json;
}
```

#### 3. Apache配置示例
```apache
<VirtualHost *:80>
    ServerName yourdomain.com
    DocumentRoot /var/www/html
    
    # Flutter Web路由支持
    FallbackResource /index.html
    
    # 启用压缩
    LoadModule deflate_module modules/mod_deflate.so
    <Location />
        SetOutputFilter DEFLATE
    </Location>
</VirtualHost>
```

### Docker部署

创建 `Dockerfile`：
```dockerfile
FROM nginx:alpine

# 复制构建文件
COPY build/web/ /usr/share/nginx/html/

# 复制Nginx配置
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
```

构建和运行：
```bash
# 构建Docker镜像
docker build -t dotask-web .

# 运行容器
docker run -p 8080:80 dotask-web
```

### 常见问题解决

#### 1. 跨域问题
如果遇到API请求失败，检查：
- 确保API地址配置正确
- 检查服务器CORS配置
- 验证网络连接

#### 2. 路由404问题
确保Web服务器配置了回退路由，将所有路径重定向到 `index.html`

#### 3. 资源加载失败
检查服务器是否正确配置了静态文件服务，确保 `/assets/` 目录可访问

## 注意事项

1. **安全性**: 生产环境不要使用HTTP，必须使用HTTPS
2. **一致性**: 确保构建时指定的域名与后端服务对应
3. **调试**: 使用 `--dart-define=BASE_URL=` 可以快速切换到其他域名进行调试
4. **CI/CD**: 在持续集成中使用环境变量来动态设置域名

## 常见问题

**Q: 如何在运行时切换域名？**
A: 这个方案主要用于构建时配置。如果需要运行时切换，建议集成类似 `flutter_config` 的包。

**Q: 如何防止构建时忘记配置域名？**
A: 可以保留代码中的默认URL作为fallback，或者在CI/CD脚本中添加验证。

**Q: 可以配置多个域名吗？**
A: 目前方案支持不同环境的独立配置，如上所述通过 `DEBUG_BASE_URL` 和 `RELEASE_BASE_URL`。