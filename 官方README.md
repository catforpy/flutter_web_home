# Flutter Web 官网项目

一个基于Flutter Web技术栈构建的现代化、模块化、高性能的官方网站。

## ✨ 特性

- 🎨 **现代化UI** - Material Design 3设计语言
- 🚀 **高性能** - 代码分割、懒加载、图片优化
- 🧩 **模块化** - 可动态配置的内容模块
- 📱 **响应式** - 完美适配各种屏幕尺寸
- 🎭 **丰富动画** - Lottie和自定义动画
- 🔍 **SEO友好** - 支持搜索引擎优化
- 🌐 **多语言** - 支持国际化
- 📊 **可观测** - 集成日志、监控和分析

## 🚀 快速开始

### 运行项目

```bash
cd "/Volumes/DudaDate/微信小程序开发/flutter官网开发/official_website"

# 使用启动脚本
./run.sh

# 或直接运行
flutter run -d chrome --web-port 8080
```

### 访问地址

- **本地**: http://localhost:8080
- **DevTools**: http://localhost:9103

### 外网访问

```bash
# 启动ngrok
ngrok http 8080

# 分享生成的地址
```

## 📚 文档

所有文档均为中文，方便阅读：

- 📖 [快速启动指南](快速启动指南.md) - 3分钟运行项目 ⭐ 推荐首先阅读
- 📖 [项目说明](项目说明.md) - 完整的项目文档
- 📖 [技术架构手册](技术架构手册.md) - 系统架构详解
- 📖 [开发指南](DEVELOPMENT.md) - 开发流程和规范
- 📖 [项目路线图](PROJECT_ROADMAP.md) - 开发计划和里程碑
- 📖 [文档目录](文档目录.md) - 所有文档索引

## 🛠️ 技术栈

### 核心框架
- Flutter 3.19+
- Dart 3.3+

### 状态管理
- flutter_bloc 8.1+ (BLoC模式)

### 路由管理
- go_router 14.6+ (声明式路由)

### UI与动画
- lottie 3.0+
- flutter_animate 4.3+
- responsive_framework 1.1+

### 网络与数据
- dio 5.4+
- retrofit 4.0+
- cached_network_image 3.3+
- hive 2.2+

## 📁 项目结构

```
lib/
├── main.dart                    # 应用入口
├── core/                        # 核心层
│   ├── config/                  # 配置
│   ├── error/                   # 错误处理
│   └── network/                 # 网络请求
├── application/                 # 应用层
│   └── blocs/                   # 状态管理（BLoC）
└── presentation/                # 表现层
    ├── routes/                  # 路由配置
    ├── theme/                   # 主题系统
    ├── pages/                   # 页面
    └── widgets/                 # 组件
```

## 🎯 核心功能

### 页面
- ✅ 首页 (`/`) - Hero区域、特性展示、状态管理演示
- ✅ 关于页面 (`/about`) - 项目介绍
- ✅ 联系页面 (`/contact`) - 联系表单
- ✅ 404页面 - 错误提示

### 功能
- ✅ 路由导航（go_router）
- ✅ 状态管理（BLoC）
- ✅ 主题系统（Material Design 3）
- ✅ 响应式布局
- ✅ 表单验证

### 演示示例
- ✅ 计数器 - 状态管理演示
- ✅ 主题切换 - 主题系统演示

## 🔧 开发

### 热重载

应用运行后：
- 按 `r` 键 - 热重载
- 按 `R` 键 - 热重启
- 按 `q` 键 - 退出

### 常用命令

```bash
# 运行项目
flutter run -d chrome

# 构建生产版本
flutter build web --release

# 清理项目
flutter clean

# 运行测试
flutter test
```

### 自定义

#### 修改主题颜色
编辑 `lib/presentation/theme/app_colors.dart`:
```dart
static const Color primary = Color(0xFF2196F3);
```

#### 添加新页面
1. 创建页面文件
2. 在 `lib/presentation/routes/app_router.dart` 中注册路由
3. 使用 `AppRouter.goToYourPage(context)` 导航

## 🌐 部署

### Vercel（推荐）
```bash
flutter build web --release
cd build/web
vercel
```

### Netlify
```bash
flutter build web --release
cd build/web
netlify deploy
```

### GitHub Pages
```bash
flutter build web --release
git push origin main
# 在GitHub设置中启用Pages
```

## 📖 学习资源

### 官方文档
- [Flutter官方文档](https://flutter.dev/docs)
- [go_router文档](https://pub.dev/packages/go_router)
- [flutter_bloc文档](https://bloclibrary.dev)

### 项目文档
- [快速启动指南](快速启动指南.md)
- [项目说明](项目说明.md)
- [技术架构手册](技术架构手册.md)

## 🤝 贡献

欢迎贡献代码！请遵循以下步骤：

1. Fork本仓库
2. 创建功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'feat: Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 创建Pull Request

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情

## 📞 联系我们

- **网站**: https://example.com
- **邮箱**: contact@example.com
- **GitHub**: [https://github.com/your-org/official_website](https://github.com/your-org/official_website)

## 🙏 致谢

感谢所有为本项目做出贡献的开发者和设计师！

---

**最后更新**: 2026-03-04
**版本**: 1.0.0

**祝你开发顺利！** 🚀
