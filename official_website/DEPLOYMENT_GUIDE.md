# Flutter Web 部署指南 - 内网服务器

本文档说明如何将 Flutter Web 项目部署到内网服务器 `192.168.2.14:3000`

## 📋 前提条件

1. Flutter SDK 已安装
2. 后端 API 运行在 `192.168.2.14:8080`（或其他端口）
3. 确保网络可以访问 `192.168.2.14`

## 🚀 快速部署

### 步骤 1: 构建项目

在项目根目录执行：

```bash
./build_staging.sh
```

这个脚本会：
- ✅ 清理旧的构建文件
- ✅ 使用 staging 环境配置构建
- ✅ 设置 API 地址为 `http://192.168.2.14:8080/api`
- ✅ 生成优化的生产版本

构建完成后，文件在 `build/web/` 目录。

### 步骤 2: 启动服务器

**方式 A: 使用 Node.js (推荐)**

```bash
./start_server_node.sh 3000
```

**方式 B: 使用 Python**

```bash
./start_server.sh 3000
```

**方式 C: 手动指定端口**

```bash
# 使用端口 2000
./start_server_node.sh 2000

# 或使用端口 8080
./start_server_node.sh 8080
```

### 步骤 3: 访问应用

打开浏览器，访问：

```
http://192.168.2.14:3000
```

如果使用其他端口，替换 3000 为实际端口号。

## 🔧 配置说明

### API 地址配置

当前配置的 API 地址：`http://192.168.2.14:8080/api`

如果你的后端运行在其他端口，需要修改配置：

**方法 1: 修改配置文件**

编辑 `lib/core/config/app_config.dart`：

```dart
case Environment.staging:
  return const String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://192.168.2.14:YOUR_PORT/api', // 修改端口
  );
```

**方法 2: 构建时指定**

修改 `build_staging.sh`，修改构建命令中的 API 地址：

```bash
flutter build web \
  --dart-define=ENV=staging \
  --dart-define=API_BASE_URL=http://192.168.2.14:YOUR_PORT/api \
  --release
```

### 服务器端口配置

默认端口：`3000`

可通过以下方式修改：

1. **启动时指定**（推荐）
   ```bash
   ./start_server_node.sh 2000  # 使用端口 2000
   ```

2. **修改脚本**
   编辑 `start_server_node.sh`，修改 `PORT` 变量

## 📦 部署到远程服务器

如果要部署到远程 Linux 服务器：

### 使用 SCP 复制文件

```bash
# 本地构建
./build_staging.sh

# 复制到远程服务器
scp -r build/web/* user@192.168.2.14:/var/www/html/
```

### 使用 rsync 同步

```bash
# 本地构建
./build_staging.sh

# 同步到远程服务器（增量同步，更快）
rsync -avz --delete build/web/ user@192.168.2.14:/var/www/html/
```

### 在服务器上使用 Nginx

**安装 Nginx:**

```bash
sudo apt update
sudo apt install nginx
```

**配置 Nginx:**

创建配置文件 `/etc/nginx/sites-available/flutter-app`:

```nginx
server {
    listen 3000;
    server_name 192.168.2.14;

    root /var/www/html;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }

    # API 代理（可选，如果前后端在同一服务器）
    location /api {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

**启用配置:**

```bash
# 创建软链接
sudo ln -s /etc/nginx/sites-available/flutter-app /etc/nginx/sites-enabled/

# 测试配置
sudo nginx -t

# 重启 Nginx
sudo systemctl restart nginx
```

## 🔄 持续部署

### 自动化部署脚本

创建 `deploy.sh`:

```bash
#!/bin/bash

# 1. 构建
echo "🔨 构建项目..."
./build_staging.sh

# 2. 同步到服务器
echo "📤 部署到服务器..."
rsync -avz --delete build/web/ user@192.168.2.14:/var/www/html/

# 3. 清理本地缓存
echo "🧹 清理缓存..."
rm -rf build/web

echo "✅ 部署完成！"
echo "🌐 访问: http://192.168.2.14:3000"
```

使用：

```bash
chmod +x deploy.sh
./deploy.sh
```

## 🐛 常见问题

### 问题 1: 构建失败

**错误**: `flutter: command not found`

**解决**: 确保 Flutter 已安装并在 PATH 中

```bash
# 检查 Flutter
flutter doctor

# 重新安装 Flutter（如果需要）
# 参考: https://flutter.dev/docs/get-started/install
```

### 问题 2: 无法访问服务器

**可能原因**:

1. **防火墙阻止**
   ```bash
   # 开放端口 3000
   sudo ufw allow 3000
   ```

2. **服务器未绑定到 192.168.2.14**
   - 确保服务器启动时使用 `-a 192.168.2.14` 参数

3. **端口被占用**
   ```bash
   # 检查端口占用
   lsof -i :3000
   
   # 杀死占用进程
   kill -9 <PID>
   ```

### 问题 3: API 请求失败

**检查**:

1. 后端 API 是否正在运行
   ```bash
   curl http://192.168.2.14:8080/api/health
   ```

2. CORS 配置是否正确
   - 后端需要允许跨域请求
   - 使用 `--cors` 参数启动服务器

3. 浏览器控制台查看具体错误
   - 按 F12 打开开发者工具
   - 查看 Console 和 Network 标签

### 问题 4: 页面刷新后 404

**原因**: Flutter Web 是单页应用，需要配置服务器重定向

**Nginx 解决方案**:
```nginx
location / {
    try_files $uri $uri/ /index.html;
}
```

**http-server 解决方案**:
已经默认支持，无需额外配置

## 📊 性能优化

### 1. 启用 Gzip 压缩（Nginx）

```nginx
gzip on;
gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;
gzip_min_length 1000;
```

### 2. 启用缓存

```nginx
location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
    expires 1y;
    add_header Cache-Control "public, immutable";
}
```

### 3. CDN 加速

如果使用 CDN，将 `build/web/` 上传到 CDN，并修改 `AppConfig.cdnBaseUrl`

## 📱 移动端访问

部署成功后，移动设备可以通过以下方式访问：

**同一局域网内:**
```
http://192.168.2.14:3000
```

**如果配置了域名:**
```
http://your-domain.com:3000
```

## 🔒 安全建议

1. **生产环境使用 HTTPS**
   ```bash
   # 使用 Let's Encrypt 免费证书
   sudo apt install certbot python3-certbot-nginx
   sudo certbot --nginx -d yourdomain.com
   ```

2. **设置防火墙规则**
   ```bash
   sudo ufw allow 80
   sudo ufw allow 443
   sudo ufw enable
   ```

3. **定期更新依赖**
   ```bash
   flutter pub upgrade
   flutter pub get
   ```

## 📞 技术支持

如有问题，请检查：
1. Flutter 版本: `flutter --version`
2. 构建日志: 查看构建过程中的错误信息
3. 浏览器控制台: F12 查看运行时错误
4. 网络请求: Network 标签查看 API 调用

---

**最后更新**: 2026-03-11  
**部署环境**: 内网 192.168.2.14:3000
