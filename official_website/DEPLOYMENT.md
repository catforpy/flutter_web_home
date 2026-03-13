# Flutter Web 项目部署说明

## 📋 部署信息

- **部署地址**: http://192.168.2.14:3000
- **项目路径**: `/Volumes/DudaDate/微信小程序开发/flutter官网开发/official_website`
- **构建目录**: `build/web`

---

## 🚀 快速部署

### 方法一：使用部署脚本（推荐）

```bash
cd /Volumes/DudaDate/微信小程序开发/flutter官网开发/official_website
./deploy.sh
```

### 方法二：手动启动

```bash
cd /Volumes/DudaDate/微信小程序开发/flutter官网开发/official_website/build/web
python3 -m http.server 3000 --bind 0.0.0.0
```

---

## 📝 部署步骤详解

### 1. 构建Web应用（如果未构建）

```bash
cd /Volumes/DudaDate/微信小程序开发/flutter官网开发/official_website
flutter build web --release
```

**构建时间**: 首次构建约2-3分钟，后续构建更快

**构建输出**: `build/web/` 目录

### 2. 启动Web服务器

```bash
cd build/web
python3 -m http.server 3000 --bind 0.0.0.0
```

**参数说明**:
- `3000`: 端口号
- `--bind 0.0.0.0`: 监听所有网络接口（允许外部访问）

### 3. 访问应用

- **局域网访问**: http://192.168.2.14:3000
- **本机访问**: http://localhost:3000

---

## 🛠️ 其他Web服务器选项

### 使用 Node.js http-server

```bash
cd build/web
npx http-server -p 3000 --cors
```

### 使用 Python 2

```bash
cd build/web
python -m SimpleHTTPServer 3000
```

### 使用 live-server (需要Node.js)

```bash
cd build/web
npx live-server --port=3000 --host=0.0.0.0
```

---

## 🔍 故障排查

### 问题1: 端口3000已被占用

**错误信息**: `OSError: [Errno 48] Address already in use`

**解决方案**:
```bash
# 查找占用端口的进程
lsof -i :3000

# 杀死进程
kill -9 <PID>

# 或使用其他端口
python3 -m http.server 8080 --bind 0.0.0.0
```

### 问题2: 无法从其他设备访问

**检查项**:
1. 确保防火墙允许3000端口
2. 确保设备在同一局域网
3. 确保使用 `0.0.0.0` 而不是 `127.0.0.1`

**测试连接**:
```bash
# 在服务器机器上测试
curl http://192.168.2.14:3000

# 在客户端机器上测试
ping 192.168.2.14
```

### 问题3: 页面空白或资源加载失败

**检查项**:
1. 浏览器控制台是否有CORS错误
2. 网络请求是否被阻止
3. 资源文件是否完整

**解决方案**:
```bash
# 重新构建应用
flutter clean
flutter pub get
flutter build web --release
```

---

## 📊 性能优化建议

### 生产环境部署

对于生产环境，建议使用：

1. **Nginx** (推荐)
2. **Apache**
3. **云服务** (阿里云OSS、腾讯云COS等)

### Nginx配置示例

```nginx
server {
    listen 3000;
    server_name 192.168.2.14;

    root /path/to/build/web;

    location / {
        try_files $uri $uri/ /index.html;
    }

    # 启用gzip压缩
    gzip on;
    gzip_types text/plain text/css application/json application/javascript;
}
```

---

## 🎯 开发模式 vs 生产模式

### 开发模式（热重载）
```bash
flutter run -d chrome --web-port 3000 --web-hostname 0.0.0.0
```

### 生产模式（已构建）
```bash
./deploy.sh
```

---

## 📞 联系与支持

如有问题，请检查：
1. Flutter版本: `flutter --version` (建议 >=3.3.0)
2. Python版本: `python3 --version` (建议 >= 3.6)
3. 网络连接: `ping 192.168.2.14`
