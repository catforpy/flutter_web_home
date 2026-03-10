# Official Website - Flutter Web

一个基于Flutter Web技术栈构建的现代化、模块化、高性能的官方网站。

## 📋 项目概述

本项目采用Clean Architecture架构模式,实现了模块化内容管理系统,支持动态配置和灵活扩展。具有精美的UI设计和流畅的动画效果,提供出色的用户体验。

### ✨ 核心特性

- 🎨 **现代化UI**: Material Design 3设计语言,支持亮/暗主题切换
- 🚀 **高性能**: 代码分割、懒加载、图片优化等性能优化策略
- 🧩 **模块化**: 可动态配置的内容模块,支持启用/禁用/排序
- 📱 **响应式**: 完美适配各种屏幕尺寸和设备类型
- 🎭 **丰富动画**: 使用Lottie和自定义动画,提升用户体验
- 🔍 **SEO友好**: 支持搜索引擎优化,提升网站排名
- 🌐 **多语言**: 支持国际化,轻松添加新语言
- 📊 **可观测**: 集成日志、监控和分析工具

## 🛠️ 技术栈

### 核心框架
- **Flutter** 3.19+ - 跨平台UI框架
- **Dart** 3.3+ - 开发语言

### 状态管理
- **flutter_bloc** 8.1+ - BLoC状态管理模式
- **provider** - 依赖注入

### 网络与数据
- **dio** 5.4+ - 网络请求库
- **retrofit** - RESTful API生成
- **json_serializable** - JSON序列化
- **cached_network_image** - 图片缓存
- **hive** - 本地数据库

### UI与动画
- **go_router** 12.0+ - 路由管理
- **lottie** 3.0+ - Lottie动画
- **flutter_animate** - 便捷动画API
- **animations** - 官方动画包
- **responsive_framework** - 响应式布局

### 工具库
- **get_it** + **injectable** - 依赖注入
- **dartz** - 函数式编程工具
- **equatable** - 值比较
- **logger** - 日志输出

## 🚀 快速开始

### 环境要求

- Flutter SDK >= 3.19.0
- Dart SDK >= 3.3.0
- Chrome浏览器(用于Web开发)

### 安装步骤

1. **安装依赖**
   ```bash
   flutter pub get
   ```

2. **运行项目**
   ```bash
   # 开发模式
   flutter run -d chrome

   # 指定端口
   flutter run -d chrome --web-port 8080
   ```

3. **构建生产版本**
   ```bash
   flutter build web --release
   ```

## 📖 文档

- [架构手册](../ARCHITECTURE.md) - 完整的技术架构说明
- [开发指南](../DEVELOPMENT.md) - 开发流程和最佳实践

---

**Happy Coding!** 🚀
