# Flutter Web 官网 - 开发指南

> 快速开始开发您的Flutter Web官网项目

## 📚 目录

1. [环境搭建](#环境搭建)
2. [项目初始化](#项目初始化)
3. [开发工作流](#开发工作流)
4. [代码规范](#代码规范)
5. [测试指南](#测试指南)
6. [调试技巧](#调试技巧)
7. [常见问题](#常见问题)

---

## 环境搭建

### 1. 安装Flutter SDK

```bash
# macOS
brew install flutter

# 验证安装
flutter doctor

# 安装Web构建工具
flutter precache --web
```

### 2. 配置IDE

**推荐使用VS Code**:

1. 安装VS Code
2. 安装Flutter扩展
3. 安装Dart扩展
4. (可选) 安装Awesome Flutter Snippets

### 3. 配置开发环境

```bash
# 进入项目目录
cd /Volumes/DudaDate/微信小程序开发/flutter官网开发/official_website

# 获取依赖
flutter pub get

# 运行项目(开发模式)
flutter run -d chrome

# 运行项目(指定端口)
flutter run -d chrome --web-port 8080
```

---

## 项目初始化

### 步骤1: 创建目录结构

```bash
# 在official_website目录下执行
mkdir -p lib/core/{config,constants,error,network,utils,widget}
mkdir -p lib/domain/{entities,repositories,usecases}
mkdir -p lib/data/{models,datasources/{remote,local},repositories,mappers}
mkdir -p lib/application/{blocs,providers}
mkdir -p lib/presentation/{pages,widgets/{common,content_widgets,animated_widgets},animations,theme,routes}
mkdir -p assets/{images/{logo,banners,icons},animations/lottie,fonts}
mkdir -p test/{unit,widget,integration}
mkdir -p docs scripts
```

### 步骤2: 配置pubspec.yaml

```yaml
name: official_website
description: Official website built with Flutter Web
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.3.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter

  # UI & Animation
  flutter_bloc: ^8.1.3
  go_router: ^12.0.0
  lottie: ^3.0.0
  animations: ^2.0.11
  flutter_animate: ^4.3.0
  responsive_framework: ^1.1.1

  # Network & Data
  dio: ^5.4.0
  retrofit: ^4.0.0
  json_serializable: ^6.7.1
  freezed: ^2.4.6
  cached_network_image: ^3.3.0

  # Storage
  shared_preferences: ^2.2.2
  hive_flutter: ^1.1.0

  # Dependency Injection
  get_it: ^7.6.4
  injectable: ^2.3.2

  # Utilities
  dartz: ^0.10.1
  equatable: ^2.0.5
  logger: ^2.0.2
  intl: ^0.19.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
  injectable_generator: ^2.4.1
  build_runner: ^2.4.7
  mocktail: ^1.0.1

flutter:
  uses-material-design: true
  assets:
    - assets/images/
    - assets/images/logo/
    - assets/images/banners/
    - assets/images/icons/
    - assets/animations/
    - assets/animations/lottie/
  fonts:
    - family: CustomFont
      fonts:
        - asset: assets/fonts/custom_font_1.ttf
```

### 步骤3: 运行代码生成

```bash
# 生成代码
flutter pub run build_runner build --delete-conflicting-outputs

# 监听模式(开发时使用)
flutter pub run build_runner watch --delete-conflicting-outputs
```

---

## 开发工作流

### Git工作流

```bash
# 创建功能分支
git checkout -b feature/hero-section

# 开发并提交
git add .
git commit -m "feat: add hero section widget"

# 推送到远程
git push origin feature/hero-section

# 创建Pull Request
# 等待审核通过后合并到main分支
```

### 分支命名规范

- `feature/xxx` - 新功能
- `fix/xxx` - Bug修复
- `refactor/xxx` - 代码重构
- `docs/xxx` - 文档更新
- `style/xxx` - 代码格式调整
- `test/xxx` - 测试相关
- `chore/xxx` - 构建/工具相关

### Commit规范

使用[Conventional Commits](https://www.conventionalcommits.org/)规范:

```
<type>(<scope>): <subject>

<body>

<footer>
```

**类型(type)**:
- `feat`: 新功能
- `fix`: Bug修复
- `docs`: 文档更新
- `style`: 代码格式
- `refactor`: 代码重构
- `test`: 测试相关
- `chore`: 构建/工具

**示例**:
```
feat(home): add hero section with animation

- Implement hero module widget
- Add fade-in animation
- Support background image customization

Closes #123
```

---

## 代码规范

### Dart代码规范

遵循[Effective Dart](https://dart.dev/guides/language/effective-dart)指南:

#### 1. 命名规范

```dart
// 类名: PascalCase
class HeroSectionWidget extends StatelessWidget {}

// 变量/方法: camelCase
final heroTitle = 'Welcome';
void scrollToTop() {}

// 常量: lowerCamelCase 或 UPPER_SNAKE_CASE
const maxImageWidth = 600.0;
const API_BASE_URL = 'https://api.example.com';

// 私有成员: 前缀下划线
void _privateMethod() {}
final _privateVariable = 0;
```

#### 2. 文件组织

```dart
// 1. 导入语句(分组并排序)
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:official_website/core/constants/app_constants.dart';

// 2. 文档注释
/// Hero section widget.
///
/// Displays the main hero section with title and CTA buttons.
class HeroSectionWidget extends StatelessWidget {
  // 3. 静态常量
  static const double defaultHeight = 600.0;

  // 4. 成员变量
  final String title;

  // 5. 构造函数
  const HeroSectionWidget({
    Key? key,
    required this.title,
  }) : super(key: key);

  // 6. 工厂构造函数
  factory HeroSectionWidget.fromConfig(Config config) {
    return HeroSectionWidget(title: config.title);
  }

  // 7. Public方法
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  // 8. Private方法
  void _handleClick() {}

  // 9. 子类(如果有)
  // 10. Enums
}
```

#### 3. Widget规范

```dart
// ✅ Good: 使用const构造函数
const Text('Hello');

// ❌ Bad
Text('Hello');

// ✅ Good: 拆分大型Widget
class HeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTitle(),
        _buildSubtitle(),
        _buildCTA(),
      ],
    );
  }

  Widget _buildTitle() => const Text('Title');
  Widget _buildSubtitle() => const Text('Subtitle');
  Widget _buildCTA() => ElevatedButton(...);
}
```

#### 4. 状态管理规范

```dart
// ✅ Good: 使用Equatable优化状态比较
class ContentState extends Equatable {
  final List<Content> contents;
  final Status status;

  const ContentState({
    this.contents = const [],
    this.status = Status.initial,
  });

  @override
  List<Object?> get props => [contents, status];

  ContentState copyWith({
    List<Content>? contents,
    Status? status,
  }) {
    return ContentState(
      contents: contents ?? this.contents,
      status: status ?? this.status,
    );
  }
}
```

### 注释规范

```dart
/// 文档注释(用于公开API)
///
/// 详细说明...
///
/// Example:
/// ```dart
/// final widget = MyWidget();
/// ```
class MyWidget {}

// 单行注释(用于解释代码)
// 这里的代码用于处理特殊情况

/*
 * 多行注释
 * 用于详细说明
 * 复杂逻辑
 */
```

---

## 测试指南

### 单元测试

```dart
// test/unit/usecases/get_contents_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:official_website/domain/usecases/get_contents.dart';

class MockContentRepository extends Mock implements ContentRepository {}

void main() {
  late GetContents usecase;
  late MockContentRepository mockRepository;

  setUp(() {
    mockRepository = MockContentRepository();
    usecase = GetContents(mockRepository);
  });

  test('should get contents from repository', () async {
    // arrange
    final testContents = [Content(id: '1', title: 'Test')];
    when(() => mockRepository.getContents())
        .thenAnswer((_) async => Right(testContents));

    // act
    final result = await usecase(const Params());

    // assert
    expect(result, Right(testContents));
    verify(() => mockRepository.getContents());
    verifyNoMoreInteractions(mockRepository);
  });
}
```

### Widget测试

```dart
// test/widget/hero_section_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:official_website/presentation/widgets/hero_section.dart';

void main() {
  testWidgets('should display title', (WidgetTester tester) async {
    // arrange
    const widget = HeroSection(title: 'Test Title');

    // act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: widget,
        ),
      ),
    );

    // assert
    expect(find.text('Test Title'), findsOneWidget);
  });

  testWidgets('should call callback when button tapped', (WidgetTester tester) async {
    var callbackCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HeroSection(
            title: 'Test',
            onCTAPressed: () => callbackCalled = true,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(ElevatedButton));
    expect(callbackCalled, true);
  });
}
```

### 运行测试

```bash
# 运行所有测试
flutter test

# 运行特定测试文件
flutter test test/unit/usecases/get_contents_test.dart

# 运行测试并生成覆盖率
flutter test --coverage

# 查看覆盖率报告
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

---

## 调试技巧

### 1. 使用Flutter DevTools

```bash
# 启动DevTools
flutter pub global activate devtools
flutter pub global run devtools

# 在应用运行时连接
# DevTools会显示可用的调试会话
```

### 2. 日志输出

```dart
import 'package:logger/logger.dart';

final logger = Logger();

void main() {
  // 普通日志
  logger.i('Info message');

  // 调试日志
  logger.d('Debug message');

  // 警告
  logger.w('Warning message');

  // 错误
  logger.e('Error message');

  // 异常
  try {
    // ...
  } catch (e, stackTrace) {
    logger.e('Error occurred', e, stackTrace);
  }
}
```

### 3. 性能分析

```dart
// 使用Flutter Performance Overlay
MaterialApp(
  showPerformanceOverlay: true, // 显示性能覆盖层
  debugShowMaterialGrid: true, // 显示调试网格
  home: MyHomePage(),
);
```

### 4. 断点调试

在VS Code中:
1. 在代码行号左侧点击设置断点
2. 按F5启动调试
3. 使用调试工具栏控制执行

### 5. 热重载

```bash
# 开发时使用热重载
flutter run -d chrome

# 修改代码后按:
# r - 热重载
# R - 热重启
# q - 退出
```

---

## 常见问题

### Q1: Web构建失败

```bash
# 清理并重新构建
flutter clean
flutter pub get
flutter build web --release
```

### Q2: 字体不显示

确保在`pubspec.yaml`中正确配置:

```yaml
flutter:
  fonts:
    - family: CustomFont
      fonts:
        - asset: assets/fonts/custom_font.ttf
```

### Q3: 图片加载失败

使用`cached_network_image`处理错误:

```dart
CachedNetworkImage(
  imageUrl: url,
  errorWidget: (context, url, error) => Icon(Icons.error),
)
```

### Q4: 状态管理混乱

遵循BLoC模式最佳实践:
- 一个BLoC管理一个功能域
- State使用`Equatable`优化比较
- 事件命名清晰,使用过去式
- 使用`buildWhen`优化重建

### Q5: 性能问题

使用Flutter DevTools分析:
- 检查Widget重建次数
- 分析帧渲染时间
- 查看内存使用情况
- 优化热加载性能

### Q6: 路由跳转问题

使用`go_router`的最佳实践:

```dart
// 定义路由
GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomePage(),
    ),
    GoRoute(
      path: '/about',
      builder: (context, state) => AboutPage(),
    ),
  ],
  errorBuilder: (context, state) => NotFoundPage(),
);

// 跳转
context.go('/about');
context.push('/detail/1');
```

---

## 开发工具推荐

### VS Code扩展

- Flutter - 官方Flutter扩展
- Dart - Dart语言支持
- Awesome Flutter Snippets - 代码片段
- Flutter Widget Snippets - Widget代码片段

### Chrome扩展

- Flutter DevTools - 浏览器调试工具
- Lighthouse - 性能分析

### 命令行工具

```bash
# 格式化代码
flutter format .

# 分析代码
flutter analyze

# 修复代码问题
dart fix --apply

# 升级依赖
flutter pub upgrade
```

---

## 学习资源

- [Flutter官方文档](https://flutter.dev/docs)
- [Flutter Widget目录](https://api.flutter.dev/flutter/widgets/widgets-library.html)
- [flutter_bloc文档](https://bloclibrary.dev)
- [Effective Dart](https://dart.dev/guides/language/effective-dart)
- [Flutter Awesome](https://flutterawesome.com)

---

**祝您开发顺利!** 🚀
