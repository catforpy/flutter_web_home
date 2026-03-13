# 环境配置说明

本文档说明如何配置不同环境的 API 地址。

## 📋 架构说明

网络层采用**三层分离架构**：

```
┌─────────────────────────────────────────────┐
│  1. 配置层 (AppConfig)                       │
│     - 管理所有环境的配置                      │
│     - 支持开发/测试/生产三种环境               │
│     - 集中管理 API 地址、CDN 地址等           │
└─────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────┐
│  2. 接口定义层 (ApiConfig)                   │
│     - 定义所有 API 接口路径                   │
│     - 不包含具体域名，只有路径                 │
│     - 例如: /auth/login, /articles           │
└─────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────┐
│  3. 网络层 (ApiClient)                       │
│     - 处理所有 HTTP 连接                      │
│     - Token 管理、错误处理、日志              │
│     - 不包含具体接口地址                      │
└─────────────────────────────────────────────┘
```

## 🌍 环境配置

### 支持的环境

1. **Development** (开发环境)
   - 本地开发使用
   - 地址: `http://localhost:8080/api`
   - 启用详细日志

2. **Staging** (测试环境)
   - 测试服务器使用
   - 地址: `https://test-api.yourdomain.com`
   - 启用日志

3. **Production** (生产环境)
   - 正式服务器使用
   - 地址: `https://api.yourdomain.com`
   - 关闭调试日志

### 配置文件位置

所有配置在 `lib/core/config/app_config.dart` 中管理。

### 修改各环境地址

直接修改 `app_config.dart` 中的 `defaultValue`：

```dart
static String get apiBaseUrl {
  switch (currentEnvironment) {
    case Environment.production:
      return const String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: 'https://api.yourdomain.com', // 👈 修改这里（生产环境）
      );

    case Environment.staging:
      return const String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: 'https://test-api.yourdomain.com', // 👈 修改这里（测试环境）
      );

    case Environment.development:
    default:
      return const String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: 'http://localhost:8080/api', // 👈 修改这里（开发环境）
      );
  }
}
```

## 🚀 运行不同环境

### 方法 1: 使用命令行参数（推荐）

**开发环境（本地）：**
```bash
flutter run
```

**测试环境：**
```bash
flutter run --dart-define=ENV=staging
```

**生产环境：**
```bash
flutter run --dart-define=ENV=production
```

### 方法 2: 自定义 API 地址

如果需要临时使用不同的 API 地址：

```bash
# 开发环境，但使用自定义本地 IP
flutter run --dart-define=API_BASE_URL=http://192.168.1.100:8080/api

# 生产环境，但使用自定义域名
flutter run --dart-define=ENV=production --dart-define=API_BASE_URL=https://api.custom.com
```

### 方法 3: 创建运行脚本

创建不同环境的启动脚本：

**开发环境脚本 (dev.sh):**
```bash
#!/bin/bash
flutter run --dart-define=ENV=development
```

**测试环境脚本 (staging.sh):**
```bash
#!/bin/bash
flutter run --dart-define=ENV=staging
```

**生产环境脚本 (prod.sh):**
```bash
#!/bin/bash
flutter run --dart-define=ENV=production
```

**构建生产版本:**
```bash
flutter build web --dart-define=ENV=production
```

## 📱 查看当前配置

启动应用后，在控制台会打印当前配置：

```
╔═══════════════════════════════════════════════════════╗
║          App Configuration                          ║
╠═══════════════════════════════════════════════════════╣
║ Environment:  Development                            ║
║ API Base URL: http://localhost:8080/api              ║
║ WebSocket URL: ws://localhost:8080/api/ws            ║
║ CDN Base URL: http://localhost:8080/api              ║
║ Debug Mode:   true                                   ║
║ Enable Log:   true                                   ║
╚═══════════════════════════════════════════════════════╝
```

## 🔧 配置说明

### API 地址相关

- **apiBaseUrl**: API 基础地址
- **websocketUrl**: WebSocket 连接地址（自动从 apiBaseUrl 转换）
- **cdnBaseUrl**: CDN 资源地址（图片、视频等）

### 日志相关

- **isDebugMode**: 是否调试模式（生产环境为 false）
- **enableLog**: 是否启用日志
- **enableNetworkLog**: 是否启用网络请求日志

### 超时设置

- **connectTimeout**: 连接超时时间（秒）
- **receiveTimeout**: 接收超时时间（秒）

## 📝 开发流程示例

### 1. 本地开发阶段

```bash
# 使用默认的开发环境
flutter run

# API 地址: http://localhost:8080/api
```

### 2. 联调测试阶段

后端部署到测试服务器后：

```bash
# 切换到测试环境
flutter run --dart-define=ENV=staging

# API 地址: https://test-api.yourdomain.com
```

### 3. 生产部署阶段

```bash
# 构建生产版本
flutter build web --dart-define=ENV=production

# API 地址: https://api.yourdomain.com
```

生成的文件在 `build/web/` 目录，部署到你的服务器即可。

## ⚠️ 注意事项

1. **不要在代码中硬编码 API 地址**
   - ❌ 错误: `final url = 'http://192.168.1.100/api';`
   - ✅ 正确: `final url = AppConfig.apiBaseUrl;`

2. **生产环境构建时务必指定环境**
   ```bash
   flutter build web --dart-define=ENV=production
   ```

3. **修改配置后重新运行**
   - 修改 `app_config.dart` 后需要重新运行 `flutter run`

4. **敏感信息不要提交到 Git**
   - 如果包含真实域名，确保 `.gitignore` 正确配置

## 🎯 最佳实践

1. **本地开发使用默认配置**
   - 不需要额外参数，直接 `flutter run`

2. **团队成员统一使用测试环境**
   - 每个人运行: `flutter run --dart-define=ENV=staging`

3. **生产环境使用自动化脚本**
   - 创建 CI/CD 脚本，构建时自动添加 `--dart-define=ENV=production`

4. **定期检查配置文件**
   - 确保 `app_config.dart` 中的地址是最新的

## 🔄 迁移指南

### 从本地迁移到服务器

1. **开发阶段**（本地）
   ```bash
   flutter run  # 使用 localhost
   ```

2. **后端部署到服务器后**

   编辑 `app_config.dart`，修改开发环境的地址：

   ```dart
   case Environment.development:
   default:
     return const String.fromEnvironment(
       'API_BASE_URL',
       defaultValue: 'http://192.168.1.100:8080/api', // 改为服务器 IP
     );
   ```

3. **使用命令行临时切换**（无需修改代码）
   ```bash
   flutter run --dart-define=API_BASE_URL=http://192.168.1.100:8080/api
   ```

4. **正式部署到生产**
   ```bash
   flutter build web --dart-define=ENV=production --dart-define=API_BASE_URL=https://api.yourdomain.com
   ```

---

**最后更新**: 2026-03-11
**维护者**: 开发团队
