# Flutter 组件封装架构说明

**项目**: Flutter官网开发
**创建时间**: 2026-03-04
**状态**: 设计完成，待实现

---

## 📦 组件封装体系

### 一、组件分层架构

```
┌─────────────────────────────────────────┐
│           Pages Layer (页面层)           │
│    HomePage, ServePage, AboutPage...    │
└─────────────────────────────────────────┘
                    ↓ 使用
┌─────────────────────────────────────────┐
│      Business Widgets (业务组件)         │
│   HeroBannerWidget, CoreServicesWidget  │
└─────────────────────────────────────────┘
                    ↓ 组合
┌─────────────────────────────────────────┐
│      Common Widgets (通用组件)           │
│  SectionTitle, ServiceCard, CTAButton   │
└─────────────────────────────────────────┘
                    ↓ 基于
┌─────────────────────────────────────────┐
│         Flutter Material Widgets        │
│      Container, Text, Image, etc.       │
└─────────────────────────────────────────┘
```

---

## 🎨 已设计的组件清单

### 1️⃣ 通用组件层 (Common Widgets)

**位置**: `lib/presentation/widgets/common/`

#### ① SectionTitleWidget
```dart
/// 区块标题组件
/// 用途：各区块的标题展示
class SectionTitleWidget extends StatelessWidget {
  final String title;           // 主标题
  final String? subtitle;       // 副标题
  final TextAlign? textAlign;   // 对齐方式
}
```

**使用场景**:
- "高品质行业服务"
- "安全可靠，全程技术支持"
- "企业成功案例"

**可配置项**:
- ✅ 标题文字
- ✅ 副标题（可选）
- ✅ 对齐方式（左/中/右）
- ✅ 颜色、字体大小

---

#### ② ServiceCardWidget
```dart
/// 服务卡片组件
/// 用途：展示服务项目
class ServiceCardWidget extends StatefulWidget {
  final String title;           // 服务标题
  final IconData icon;          // 图标
  final List<String> features;  // 特性列表

  // 动效：鼠标悬停放大、阴影加深
}
```

**使用场景**:
- 小程序商城
- APP开发
- 网站建设
- 微信小程序开发

**可配置项**:
- ✅ 卡片标题
- ✅ 图标/图片
- ✅ 特性列表
- ✅ 悬停动画参数
- ✅ 点击事件

---

#### ③ CTAButtonWidget
```dart
/// 行动号召按钮 (Call to Action)
/// 用途：引导用户操作
class CTAButtonWidget extends StatelessWidget {
  final String text;           // 按钮文字
  final VoidCallback? onPressed;
  final CTAButtonType type;    // primary / secondary

  // 样式：渐变背景、描边样式、悬停变色
}
```

**使用场景**:
- "免费咨询"
- "了解更多"
- "立即评估"

**可配置项**:
- ✅ 按钮文字
- ✅ 按钮类型（主/次按钮）
- ✅ 颜色、渐变
- ✅ 尺寸（大/中/小）

---

#### ④ ProcessStepWidget
```dart
/// 流程步骤组件
/// 用途：展示流程步骤
class ProcessStepWidget extends StatelessWidget {
  final List<ProcessStep> steps;  // 步骤列表
  final Axis direction;           // horizontal / vertical

  // 布局：桌面横向、移动纵向
}
```

**使用场景**:
- 服务流程（5步）
- 开发流程

**可配置项**:
- ✅ 步骤数量
- ✅ 步骤图标
- ✅ 步骤文字
- ✅ 排列方向（横/竖）

---

### 2️⃣ 业务组件层 (Business Widgets)

**位置**: `lib/presentation/widgets/serve/`

#### ① HeroBannerWidget
```dart
/// 顶部横幅组件
/// 内容："我们用心让客户更放心"
class HeroBannerWidget extends StatelessWidget {
  final String title;
  final String subtitle;

  // 动效：淡入动画、从下向上滑入
}
```

**特点**:
- 全宽背景
- 渐变色或图片背景
- 居中对齐
- 响应式字体

---

#### ② CoreServicesWidget
```dart
/// 核心服务组件
/// 包含4个服务卡片
class CoreServicesWidget extends StatelessWidget {
  final List<ServiceItem> services;

  // 布局：桌面4列、平板2列、手机1列
}
```

**特点**:
- 响应式网格布局
- 使用 ServiceCardWidget

---

#### ③ TechAdvantageWidget
```dart
/// 技术优势组件
/// 展示3个技术优势
class TechAdvantageWidget extends StatelessWidget {
  final List<TechAdvantage> advantages;

  // 布局：横向3列
}
```

**特点**:
- 图标 + 标题 + 描述

---

#### ④ ServiceFlowWidget
```dart
/// 服务流程组件
/// 展示5步流程
class ServiceFlowWidget extends StatelessWidget {
  final List<ProcessStep> steps;

  // 使用 ProcessStepWidget
}
```

**特点**:
- 步骤间用箭头连接

---

#### ⑤ IndustryServiceWidget
```dart
/// 行业服务组件
/// 包含文字说明 + CTA按钮
class IndustryServiceWidget extends StatelessWidget {
  final String title;
  final String description;
  final List<String> features;
  final String ctaText;
}
```

**特点**:
- 使用 SectionTitleWidget
- 使用 CTAButtonWidget

---

#### ⑥ CaseStudyWidget
```dart
/// 案例展示组件
/// 卡片网格展示案例
class CaseStudyWidget extends StatelessWidget {
  final List<CaseStudy> cases;

  // 布局：响应式网格
}
```

**特点**:
- 案例图片 + 标题 + 描述

---

#### ⑦ ContactBarWidget
```dart
/// 联系咨询组件
/// 固定在底部或页面底部
class ContactBarWidget extends StatelessWidget {
  final String phone;
  final String hintText;
}
```

**特点**:
- 客服热线
- "免费咨询"按钮

---

### 3️⃣ 数据模型层 (Data Models)

**位置**: `lib/domain/models/`

```dart
// 服务项目模型
class ServiceItem {
  final String title;
  final IconData icon;
  final List<String> features;
}

// 流程步骤模型
class ProcessStep {
  final String title;
  final IconData icon;
}

// 案例模型
class CaseStudy {
  final String title;
  final String industry;
  final String image;
  final String description;
}

// 技术优势模型
class TechAdvantage {
  final String title;
  final String description;
  final IconData icon;
}
```

---

## 🎯 组件封装的优势

### 1. 高度可复用

一个组件，多处使用：

```dart
// 在服务页使用
SectionTitleWidget(
  title: "高品质行业服务",
  subtitle: "为企业提供一站式技术服务",
)

// 在首页也使用
SectionTitleWidget(
  title: "核心服务",
  subtitle: "专业从事互联网服务",
)

// 在解决方案页也使用
SectionTitleWidget(
  title: "解决方案",
  subtitle: "为企业提供全方位数字化服务",
)
```

### 2. 统一管理样式

```dart
// 想改所有标题的颜色？只改一个组件！
class SectionTitleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: AppColors.primary,  // 改这里，全站生效！
        fontSize: AppSizes.fs2xl,
      ),
    );
  }
}
```

### 3. 修改不影响其他组件

```dart
// 想改卡片的悬停效果？
// 只需要修改 ServiceCardWidget，其他组件不受影响
class ServiceCardWidget extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() {
        // 只在这里修改动效参数
        _scale = 1.1;  // 从1.05改成1.1
      }),
      child: AnimatedContainer(...),
    );
  }
}
```

---

## 📂 组件文件结构

```
lib/
├── domain/
│   └── models/                      # 数据模型
│       ├── service_item.dart        ✅ 已设计
│       ├── process_step.dart        ✅ 已设计
│       ├── case_study.dart          ✅ 已设计
│       └── tech_advantage.dart      ✅ 已设计
│
├── presentation/
│   ├── widgets/
│   │   ├── common/                  # 通用组件
│   │   │   ├── section_title_widget.dart       ✅ 已设计
│   │   │   ├── service_card_widget.dart        ✅ 已设计
│   │   │   ├── cta_button_widget.dart          ✅ 已设计
│   │   │   └── process_step_widget.dart        ✅ 已设计
│   │   │
│   │   ├── serve/                   # 服务页组件
│   │   │   ├── hero_banner_widget.dart         ✅ 已设计
│   │   │   ├── core_services_widget.dart       ✅ 已设计
│   │   │   ├── tech_advantage_widget.dart      ✅ 已设计
│   │   │   ├── service_flow_widget.dart        ✅ 已设计
│   │   │   ├── industry_service_widget.dart    ✅ 已设计
│   │   │   ├── case_study_widget.dart          ✅ 已设计
│   │   │   └── contact_bar_widget.dart         ✅ 已设计
│   │   │
│   │   └── layouts/                 # 布局组件
│   │       ├── page_container.dart
│   │       └── section_container.dart
│   │
│   └── pages/
│       ├── serve/
│       │   └── serve_page.dart     ⏳ 待实现
│       ├── solution/
│       ├── case/
│       ├── about/
│       └── home/
│
├── core/
│   ├── constants/
│   │   ├── app_colors.dart         ✅ 已设计
│   │   └── app_sizes.dart          ✅ 已设计
│   └── theme/
│       └── app_theme.dart
│
└── main.dart
```

---

## ✅ 当前状态总结

### 已完成：
- ✅ 完整的组件架构设计
- ✅ 每个组件的功能定义
- ✅ 数据模型设计
- ✅ 样式规范（颜色、尺寸）
- ✅ 动效设计方案

### 待完成：
- ⏳ 创建实际的 .dart 文件
- ⏳ 编写组件代码
- ⏳ 实现页面组装
- ⏳ 添加路由配置

---

## 🚀 下一步：开始编码

需要我开始创建实际的组件代码吗？

**我可以**：
1. 创建所有组件的 .dart 文件
2. 实现组件的完整功能
3. 添加响应式布局
4. 实现动效
5. 组装页面

**从哪个开始？**
- 选项A：从通用组件开始（SectionTitle、ServiceCard）
- 选项B：从服务页开始（HeroBanner、CoreServices）
- 选项C：按你的优先级来

---

## 💡 修改示例

### 场景1：改颜色

```dart
// 修改前
class AppColors {
  static const primary = Color(0xFF1890FF);  // 蓝色
}

// 修改后
class AppColors {
  static const primary = Color(0xFF52C41A);  // 绿色
}
// 全站所有使用 primary 的地方自动变成绿色！
```

### 场景2：改卡片间距

```dart
// 修改前
class CoreServicesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 16,  // 改这里
        mainAxisSpacing: 16,   // 改这里
      ),
    );
  }
}

// 修改后
class CoreServicesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 32,  // 改成32
        mainAxisSpacing: 32,   // 改成32
      ),
    );
  }
}
```

### 场景3：修改服务内容

```dart
// 只需要修改数据，不需要改组件！
class ServePage extends StatelessWidget {
  final List<ServiceItem> services = [
    ServiceItem(
      title: "小程序商城",
      icon: Icons.shopping_cart,
      features: [
        "3步开通一键发布",
        "自定义+可视化店铺装修",
      ],
    ),
    // 想增加服务？只在这里添加！
    ServiceItem(
      title: "新服务",
      icon: Icons.new_releases,
      features: [
        "新特性1",
        "新特性2",
      ],
    ),
  ];
}
```

---

**总结**：
- ✅ 组件封装已完成设计
- ✅ 后续可随时修改
- ✅ 改一处，多处生效
- ✅ 组件独立，互不影响
- ⏳ 待创建实际代码文件

准备开始实现组件了吗？从哪个开始？
