# 页面结构与路由分析

**目标网站**: https://www.junhesoftware.online
**分析时间**: 2026-03-04

---

## 📊 网站导航结构分析

### 主导航栏

```
首页 | 解决方案 | 服务 | 案例 | 关于 | 动态 | 联系
```

### 页面路由结构

#### 1. 首页 (`/`)
**特点**: 单页滚动模式，包含多个section
- Hero区域（Banner）
- 核心服务介绍（4个卡片）
- 技术优势展示
- 数据统计（58+、16+、1000+）
- 案例展示（部分）
- 联系方式

**交互方式**:
- 导航栏点击 → 滚动到对应section（锚点跳转）
- URL保持为 `/`

#### 2. 服务页 (`/xcx/serve`)
**特点**: 独立页面
**URL**: https://www.junhesoftware.online/xcx/serve

**包含内容**:
- Hero横幅："我们用心让客户更放心"
- 4个核心服务（小程序商城、APP开发、网站建设、微信小程序）
- 技术优势（3个优势）
- 服务流程（5步流程图）
- 行业服务说明
- 企业成功案例
- 联系咨询栏

**交互方式**:
- 导航栏点击 → 路由跳转到 `/xcx/serve`
- 页面内滚动查看完整内容

#### 3. 案例页 (推断 `/case`)
**特点**: 独立页面或首页section
**内容**: 展示所有成功案例

#### 4. 解决方案页 (推断 `/solution`)
**特点**: 独立页面
**包含**: 各行业解决方案（电商、教育、医疗、政务等）

#### 5. 关于页 (`/about`)
**特点**: 独立页面
**包含**: 公司简介、团队、合作伙伴等

#### 6. 动态/新闻页 (推断 `/news`)
**特点**: 独立页面
**包含**: 公司动态、行业资讯

#### 7. 联系页 (`/contact`)
**特点**: 独立页面或首页section
**包含**: 联系方式、地图、表单等

---

## 🎯 路由模式总结

### 混合路由策略

| 页面类型 | URL示例 | 跳转方式 | 适用场景 |
|---------|---------|---------|---------|
| **首页** | `/` | 滚动跳转 | 营销型首页 |
| **详情页** | `/xcx/serve` | 路由跳转 | 内容丰富的页面 |
| **独立页** | `/about` | 路由跳转 | 功能独立页面 |

### 实现方式

#### 1. 首页单页滚动
```javascript
// 导航栏点击"核心服务"
- URL不变: `/`
- 页面滚动到"核心服务"section
- 使用: ScrollController + animateTo()
```

#### 2. 独立页面路由
```javascript
// 导航栏点击"服务"
- URL变化: `/xcx/serve`
- 完整页面切换
- 使用: go_router
```

---

## 🚀 Flutter 实现方案

### 方案A：纯路由模式（推荐）

**优点**:
- ✅ 结构清晰，易于维护
- ✅ SEO友好
- ✅ 符合Flutter Web最佳实践

**路由结构**:
```
/                          → 首页
/serve                     → 服务页
/solution                  → 解决方案页
/case                      → 案例页
/about                     → 关于页
/news                      → 新闻动态页
/contact                   → 联系页
```

**实现**: 使用go_router管理所有路由

---

### 方案B：混合模式

**优点**:
- ✅ 更接近目标网站的体验
- ✅ 首页更流畅

**缺点**:
- ⚠️ 复杂度较高
- ⚠️ 需要处理滚动和路由的协调

**实现**:
- 首页使用 `SingleChildScrollView` + `ScrollController`
- 其他页面使用路由跳转
- 导航栏根据当前路由判断行为

---

## 📂 推荐的页面文件结构

```
lib/presentation/pages/
├── home/                          # 首页
│   ├── home_page.dart             # 首页入口
│   ├── sections/                  # 首页各个section
│   │   ├── hero_section.dart      # Hero横幅
│   │   ├── service_section.dart   # 服务介绍
│   │   ├── advantage_section.dart # 技术优势
│   │   ├── stats_section.dart     # 数据统计
│   │   └── contact_section.dart   # 联系方式
│   └── home_page_controller.dart  # 滚动控制器
│
├── serve/                         # 服务页
│   ├── serve_page.dart            # 服务页入口
│   └── widgets/                   # 服务页组件
│       ├── hero_banner_widget.dart
│       ├── core_services_widget.dart
│       ├── tech_advantage_widget.dart
│       └── service_flow_widget.dart
│
├── solution/                      # 解决方案页
│   ├── solution_page.dart
│   └── widgets/
│
├── case/                          # 案例页
│   ├── case_page.dart
│   └── widgets/
│
├── about/                         # 关于页
│   ├── about_page.dart
│   └── widgets/
│
├── news/                          # 新闻页
│   ├── news_page.dart
│   └── widgets/
│
└── contact/                       # 联系页
    ├── contact_page.dart
    └── widgets/
```

---

## 🎨 Flutter 路由配置（方案A）

```dart
// lib/presentation/routes/app_router.dart

class AppRouter {
  // 路由路径常量
  static const String home = '/';
  static const String serve = '/serve';
  static const String solution = '/solution';
  static const String case = '/case';
  static const String about = '/about';
  static const String news = '/news';
  static const String contact = '/contact';

  /// GoRouter 配置
  static final GoRouter router = GoRouter(
    initialLocation: home,

    routes: [
      // 首页
      GoRoute(
        path: home,
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),

      // 服务页
      GoRoute(
        path: serve,
        name: 'serve',
        builder: (context, state) => const ServePage(),
      ),

      // 解决方案页
      GoRoute(
        path: solution,
        name: 'solution',
        builder: (context, state) => const SolutionPage(),
      ),

      // 案例页
      GoRoute(
        path: case,
        name: 'case',
        builder: (context, state) => const CasePage(),
      ),

      // 关于页
      GoRoute(
        path: about,
        name: 'about',
        builder: (context, state) => const AboutPage(),
      ),

      // 新闻页
      GoRoute(
        path: news,
        name: 'news',
        builder: (context, state) => const NewsPage(),
      ),

      // 联系页
      GoRoute(
        path: contact,
        name: 'contact',
        builder: (context, state) => const ContactPage(),
      ),
    ],

    errorBuilder: (context, state) => const NotFoundPage(),
  );
}
```

---

## 🎯 Flutter 导航栏实现

```dart
// lib/presentation/widgets/common/app_nav_bar.dart

class AppNavBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context).uri.path;

    return AppBar(
      title: const Text('君和数字创意'),
      actions: [
        _buildNavItem(context, '首页', '/', currentRoute),
        _buildNavItem(context, '解决方案', '/solution', currentRoute),
        _buildNavItem(context, '服务', '/serve', currentRoute),
        _buildNavItem(context, '案例', '/case', currentRoute),
        _buildNavItem(context, '关于', '/about', currentRoute),
        _buildNavItem(context, '动态', '/news', currentRoute),
        _buildNavItem(context, '联系', '/contact', currentRoute),
      ],
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    String title,
    String route,
    String currentRoute,
  ) {
    final isSelected = currentRoute == route;

    return TextButton(
      onPressed: () => context.go(route),
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.blue : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
```

---

## 📱 响应式布局

### 断点设计

```dart
class Breakpoints {
  static const double mobile = 640;   // 手机
  static const double tablet = 768;   // 平板
  static const double desktop = 1024; // 桌面
}

// 使用示例
Widget build(BuildContext context) {
  final width = MediaQuery.of(context).size.width;

  if (width < Breakpoints.tablet) {
    return MobileLayout();  // 单列
  } else if (width < Breakpoints.desktop) {
    return TabletLayout();  // 2列
  } else {
    return DesktopLayout(); // 3-4列
  }
}
```

---

## ✅ 实施步骤

### 第1步：更新路由配置
```bash
cd /Volumes/DudaDate/微信小程序开发/flutter官网开发/official_website

# 编辑路由文件
lib/presentation/routes/app_router.dart
```

### 第2步：创建页面目录结构
```bash
# 创建各页面目录
mkdir -p lib/presentation/pages/serve/widgets
mkdir -p lib/presentation/pages/solution/widgets
mkdir -p lib/presentation/pages/case/widgets
mkdir -p lib/presentation/pages/news/widgets
```

### 第3步：创建页面文件
- 按优先级创建各个页面
- 从服务页开始（已有组件设计）

### 第4步：实现导航栏
- 创建响应式导航栏
- 根据屏幕大小调整布局（桌面横向，移动抽屉）

### 第5步：添加页面过渡动画
```dart
// 使用 go_router 的页面过渡
pageBuilder: (context, state) => CustomTransitionPage(
  key: state.pageKey,
  child: const ServePage(),
  transitionsBuilder: (context, animation, secondaryAnimation, child) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  },
),
```

---

## 🎯 总结

### 目标网站路由特点：
1. ✅ **首页**使用单页滚动（section跳转）
2. ✅ **详情页**使用独立路由（URL变化）
3. ✅ 导航栏根据页面类型切换行为

### Flutter推荐方案：
1. ✅ **方案A（推荐）**: 纯路由模式 - 所有页面独立路由
2. ⚠️ **方案B**: 混合模式 - 首页滚动 + 其他页面路由

### 优势：
- ✅ 完全可以实现目标网站的效果
- ✅ go_router提供强大的路由管理
- ✅ 支持深层链接和浏览器前进/后退
- ✅ SEO友好
- ✅ 代码结构清晰

---

**结论**: Flutter完全可以模仿目标网站的路由行为，推荐使用纯路由模式（方案A）实现。
