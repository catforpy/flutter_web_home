# 🚀 快速启动指南

欢迎使用Flutter Web官网项目!本指南将帮助您在5分钟内启动项目。

## 📋 前置要求

在开始之前,请确保您已经安装:

- ✅ Flutter SDK (>= 3.19.0)
- ✅ Dart SDK (>= 3.3.0)
- ✅ Chrome 浏览器
- ✅ VS Code 或 IntelliJ IDEA (推荐)

### 检查Flutter安装

```bash
flutter --version
flutter doctor
```

---

## ⚡ 快速开始 (3步启动)

### 步骤 1: 项目设置

#### macOS/Linux

```bash
cd /Volumes/DudaDate/微信小程序开发/flutter官网开发

# 运行设置脚本
./scripts/setup.sh
```

#### Windows

```cmd
cd "路径\到\flutter官网开发"

# 运行设置脚本
scripts\setup.bat
```

设置脚本会自动完成:
- ✅ 检查Flutter环境
- ✅ 安装依赖
- ✅ 创建目录结构
- ✅ 运行代码生成
- ✅ 格式化代码

### 步骤 2: 运行项目

```bash
# 进入项目目录
cd official_website

# 启动开发服务器
flutter run -d chrome
```

项目会自动在Chrome浏览器中打开,默认地址为 `http://localhost:8080`

### 步骤 3: 开始开发

现在您可以开始开发了!

- 修改代码后,浏览器会自动热重载
- 按 `r` 键触发热重载
- 按 `R` 键触发热重启
- 按 `q` 键退出

---

## 📂 项目结构概览

```
official_website/
├── lib/                        # 源代码
│   ├── main.dart              # 应用入口
│   ├── core/                  # 核心层(配置、工具、错误处理)
│   ├── domain/                # 领域层(业务实体、仓储接口)
│   ├── data/                  # 数据层(数据模型、数据源)
│   ├── application/           # 应用层(状态管理)
│   └── presentation/          # 表现层(UI、主题、路由)
│
├── assets/                     # 资源文件
│   ├── images/               # 图片
│   ├── animations/           # 动画
│   └── fonts/                # 字体
│
├── test/                       # 测试代码
├── docs/                       # 文档
└── scripts/                    # 脚本工具
```

---

## 🛠️ 常用命令

### 开发

```bash
# 启动开发服务器
flutter run -d chrome

# 指定端口
flutter run -d chrome --web-port 3000

# Release模式运行
flutter run -d chrome --release
```

### 构建

```bash
# 构建生产版本
flutter build web --release

# 构建输出目录
# build/web/
```

### 代码质量

```bash
# 格式化代码
flutter format .

# 分析代码
flutter analyze

# 运行测试
flutter test

# 测试覆盖率
flutter test --coverage
```

### 代码生成

```bash
# 生成代码(使用freezed、json_serializable等)
flutter pub run build_runner build

# 监听模式(开发时使用)
flutter pub run build_runner watch
```

### 依赖管理

```bash
# 添加依赖
flutter pub add package_name

# 添加开发依赖
flutter pub add --dev package_name

# 升级依赖
flutter pub upgrade

# 获取依赖
flutter pub get
```

---

## 🎯 下一步做什么?

### 1. 了解架构

阅读详细的技术文档:

- 📖 [架构手册](ARCHITECTURE.md) - 了解完整的系统架构
- 📖 [开发指南](DEVELOPMENT.md) - 学习开发最佳实践
- 📖 [项目路线图](PROJECT_ROADMAP.md) - 查看开发计划

### 2. 开发第一个页面

参考以下顺序开发:

1. **首页** (最简单,熟悉流程)
   - Hero区域
   - 特性展示
   - CTA按钮

2. **关于页面**
   - 公司介绍
   - 团队成员

3. **联系页面**
   - 联系表单
   - 联系信息

### 3. 添加新功能

```dart
// 1. 在 domain 层定义实体
// lib/domain/entities/content.dart

class Content extends Equatable {
  final String id;
  final String title;

  const Content({
    required this.id,
    required this.title,
  });

  @override
  List<Object?> get props => [id, title];
}
```

```dart
// 2. 在 data 层实现数据源
// lib/data/datasources/remote/content_api_service.dart

@RestApi(baseUrl: "https://api.example.com")
abstract class ContentApiService {
  factory ContentApiService(Dio dio) = _ContentApiService;

  @GET("/contents")
  Future<List<ContentModel>> getContents();
}
```

```dart
// 3. 在 application 层实现状态管理
// lib/application/blocs/content/content_bloc.dart

class ContentBloc extends Bloc<ContentEvent, ContentState> {
  final GetContentsUseCase getContents;

  ContentBloc({required this.getContents}) : super(ContentInitial()) {
    on<LoadContents>(_onLoadContents);
  }

  Future<void> _onLoadContents(
    LoadContents event,
    Emitter<ContentState> emit,
  ) async {
    emit(ContentLoading());
    final result = await getContents(Params());
    result.fold(
      (failure) => emit(ContentError(failure.message)),
      (contents) => emit(ContentLoaded(contents)),
    );
  }
}
```

```dart
// 4. 在 presentation 层创建UI
// lib/presentation/pages/home/home_page.dart

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ContentBloc, ContentState>(
        builder: (context, state) {
          if (state is ContentLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ContentLoaded) {
            return ListView.builder(
              itemCount: state.contents.length,
              itemBuilder: (context, index) {
                return ContentCard(content: state.contents[index]);
              },
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}
```

---

## 🔧 开发工具推荐

### VS Code扩展

安装以下扩展提升开发效率:

- **Flutter** - 官方Flutter扩展
- **Dart** - Dart语言支持
- **Awesome Flutter Snippets** - 代码片段
- **Flutter Widget Snippets** - Widget代码片段

### Chrome扩展

- **Flutter DevTools** - 调试工具
- **Lighthouse** - 性能分析

---

## ❓ 遇到问题?

### 常见问题

**Q: 运行 `flutter run` 时提示 "No connected devices"?**

A: 确保Chrome已安装,然后运行:
```bash
flutter devices
flutter run -d chrome
```

**Q: 依赖安装失败?**

A: 尝试:
```bash
flutter clean
flutter pub cache repair
flutter pub get
```

**Q: 热重载不工作?**

A: 尝试热重启:
```
按 R 键(大写)
```

**Q: 构建失败?**

A: 检查Flutter版本:
```bash
flutter upgrade
flutter clean
flutter pub get
flutter build web --release
```

### 获取帮助

- 📖 [Flutter官方文档](https://flutter.dev/docs)
- 💬 [Flutter社区](https://flutter.dev/community)
- 🐛 [报告问题](https://github.com/your-org/official_website/issues)

---

## 📚 学习资源

### 官方资源

- [Flutter官方文档](https://flutter.dev/docs)
- [Dart语言指南](https://dart.dev/guides)
- [Flutter Widget目录](https://api.flutter.dev/flutter/widgets/widgets-library.html)

### 状态管理

- [flutter_bloc文档](https://bloclibrary.dev)
- [Provider文档](https://pub.dev/documentation/provider)

### UI设计

- [Material Design 3](https://m3.material.io)
- [Flutter动画指南](https://flutter.dev/docs/development/ui/animations)

---

## 🎉 开始编码!

现在您已经准备好开始了!祝您开发顺利!

**记住**: 遇到问题时先查看文档,大部分问题都有解决方案。

---

**最后更新**: 2026-03-04
**版本**: v1.0.0
