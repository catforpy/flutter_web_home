# 服务页面组件设计方案

**目标网址**: https://www.junhesoftware.online/xcx/serve
**分析时间**: 2026-03-04
**设计工具**: 基于网页内容提取

---

## 📋 页面内容分析

### 页面结构

#### 1. 顶部标题区
```
标题: "我们用心让客户更放心"
副标题: "源码交付 | 高质上线 | 售后无忧"
```

#### 2. 核心服务区
```
标题: "高品质行业服务"
副标题: "为企业提供一站式技术服务，以高品质铸造商业价值"

4个服务卡片：
1. 小程序商城
   - 3步开通一键发布
   - 自定义+可视化店铺装修
   - 分销+拼团+砍价+秒杀+优惠券
   - 助力商家快速抢占社交电商市场先机

2. APP开发
   - IOS开发
   - Android开发
   - 物联网应用开发
   - 等一站式APP开发服务

3. 网站建设
   - 企业官网
   - 营销型网站
   - 响应式网站
   - 助力企业在全面展示品牌优势

4. 微信小程序开发
   - 小程序定制开发
   - 公众号定制开发
   - H5营销活动开发
   - 助力获取微信流量红利
```

#### 3. 技术优势区
```
标题: "安全可靠，全程技术支持"
副标题: "为全行业提供高效便捷得的小程序开发服务"

3个技术优势：
1. 加速应用开发
   - 极致性体验
   - 强大的Native渲染引擎提供丰富的API
   - 出色的原生性和流畅的页面交互

2. 可视化开发
   - 生成专业级源代码
   - 通过可视化拖拉拽快递构建应用程序

3. 一套代码
   - 适配多端应用
   - 只需一次作业，使用UniApp跨平台技术
   - 同时发布为Android、IOS、小程序、HTML5多端应用
```

#### 4. 服务流程区
```
标题: "移动互联网创业-企业数字化转型"
副标题: "众多知名企业的放心之选"

流程步骤：
小程序开发 → 可视化云开发 → 小程序测试 → 小程序发布 → 应用运营
```

#### 5. 全行业服务区
```
标题: "全行业小程序开发服务"
副标题: "众多知名企业的放心之选，以专业的技术、成熟的行业经验为企业提供高效可靠的移动化服务"

内容：
- 16年移动开发经验
- 自有平台技术支持App/小程序同时开发
- 支持移动应用定制、小程序开发、业务系统开发、行业解决方案等

CTA按钮: "免费小程序开发评估"
```

#### 6. 企业案例区
```
标题: "企业成功案例"
副标题: "君和数字创意帮助用户在移动场景中快速落地，涵盖电商、新能源、教育、社交、金融、资讯、医疗等众多领域"

链接: "更多行业案例 >"
```

#### 7. 联系咨询区
```
提示: "现在就与君和客服在线沟通"
客服热线: "13043973920"
按钮: "免费咨询"
```

---

## 🎨 Flutter 组件设计方案

### 一、通用组件层 (`lib/presentation/widgets/common/`)

#### 1. SectionTitleWidget
```dart
/// 区块标题组件
class SectionTitleWidget extends StatelessWidget {
  final String title;           // 主标题
  final String? subtitle;       // 副标题
  final TextAlign? textAlign;   // 对齐方式

  // 用途：各区块的标题展示
  // 场景：高品质行业服务、安全可靠全程技术支持等
}
```

#### 2. ServiceCardWidget
```dart
/// 服务卡片组件
class ServiceCardWidget extends StatefulWidget {
  final String title;           // 服务标题
  final String icon;            // 图标（IconData 或图片路径）
  final List<String> features;  // 特性列表

  // 动效：
  // - 鼠标悬停时卡片放大（scale: 1.05）
  // - 阴影加深
  // - Y轴向上偏移 4px

  // 场景：4个核心服务卡片
}
```

#### 3. CTAButtonWidget
```dart
/// 行动号召按钮
class CTAButtonWidget extends StatelessWidget {
  final String text;           // 按钮文字
  final VoidCallback? onPressed;
  final CTAButtonType type;    // primary / secondary

  // 样式：
  // - Primary: 渐变背景
  // - Secondary: 描边样式
  // - 悬停时颜色变化
}
```

#### 4. ProcessStepWidget
```dart
/// 流程步骤组件
class ProcessStepWidget extends StatelessWidget {
  final List<ProcessStep> steps;  // 步骤列表
  final Axis direction;           // horizontal / vertical

  // 布局：
  // - 桌面：横向排列
  // - 移动：纵向排列
  // - 步骤之间用箭头连接
}
```

---

### 二、业务组件层 (`lib/presentation/widgets/serve/`)

#### 1. HeroBannerWidget
```dart
/// 顶部横幅组件
class HeroBannerWidget extends StatelessWidget {
  // 内容：
  final String title = "我们用心让客户更放心";
  final String subtitle = "源码交付 | 高质上线 | 售后无忧";

  // 设计：
  // - 全宽背景
  // - 渐变色或图片背景
  // - 居中对齐
  // - 大标题（32-48px）
  // - 副标题较小（16-18px）
  // - 可能包含 CTA 按钮

  // 动效：
  // - 淡入动画（fade in）
  // - 标题从下向上滑入
}
```

#### 2. CoreServicesWidget
```dart
/// 核心服务组件
class CoreServicesWidget extends StatelessWidget {
  // 4个服务卡片
  final List<ServiceItem> services = [
    ServiceItem(
      title: "小程序商城",
      icon: Icons.shopping_cart,
      features: [
        "3步开通一键发布",
        "自定义+可视化店铺装修",
        "分销+拼团+砍价+秒杀+优惠券",
      ],
    ),
    // ... 其他3个服务
  ];

  // 布局：
  // - 桌面：4列网格（GridView.count(crossAxisCount: 4)）
  // - 平板：2列
  // - 手机：1列

  // 间距：
  // - 卡片间距：16-24px
  // - 区块上下内边距：60-80px
}
```

#### 3. TechAdvantageWidget
```dart
/// 技术优势组件
class TechAdvantageWidget extends StatelessWidget {
  // 3个技术优势
  // 布局：横向3列
  // 每个优势包含：
  //   - 图标/图片
  //   - 标题
  //   - 描述文字
}
```

#### 4. ServiceFlowWidget
```dart
/// 服务流程组件
class ServiceFlowWidget extends StatelessWidget {
  // 5个流程步骤
  final List<ProcessStep> steps = [
    ProcessStep(title: "小程序开发", icon: Icons.code),
    ProcessStep(title: "可视化云开发", icon: Icons.cloud),
    ProcessStep(title: "小程序测试", icon: Icons.testing),
    ProcessStep(title: "小程序发布", icon: Icons.publish),
    ProcessStep(title: "应用运营", icon: Icons.trending_up),
  ];

  // 连接：步骤之间用箭头图标（Icons.arrow_forward）
}
```

#### 5. IndustryServiceWidget
```dart
/// 行业服务组件
class IndustryServiceWidget extends StatelessWidget {
  // 包含：
  // - 标题和副标题
  // - 3个要点文字
  // - CTA按钮："免费小程序开发评估"

  // 布局：Column
}
```

#### 6. CaseStudyWidget
```dart
/// 案例展示组件
class CaseStudyWidget extends StatelessWidget {
  // 案例卡片网格
  // "更多行业案例" 链接
}
```

#### 7. ContactBarWidget
```dart
/// 联系咨询组件
class ContactBarWidget extends StatelessWidget {
  // 固定在底部或页面底部
  // 包含：
  // - 提示文字
  // - 客服热线：13043973920
  // - "免费咨询" 按钮
}
```

---

### 三、数据模型层 (`lib/domain/models/`)

```dart
/// 服务项目模型
class ServiceItem {
  final String title;
  final IconData icon;
  final List<String> features;

  ServiceItem({
    required this.title,
    required this.icon,
    required this.features,
  });
}

/// 流程步骤模型
class ProcessStep {
  final String title;
  final IconData icon;

  ProcessStep({
    required this.title,
    required this.icon,
  });
}

/// 案例模型
class CaseStudy {
  final String title;
  final String industry;
  final String image;
  final String description;
}
```

---

### 四、页面组装 (`lib/presentation/pages/serve/`)

```dart
class ServePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeroBannerWidget(),              // 1. 顶部横幅
            SizedBox(height: 60),            // 间距
            CoreServicesWidget(),            // 2. 核心服务
            SizedBox(height: 60),
            TechAdvantageWidget(),           // 3. 技术优势
            SizedBox(height: 60),
            ServiceFlowWidget(),             // 4. 服务流程
            SizedBox(height: 60),
            IndustryServiceWidget(),         // 5. 行业服务
            SizedBox(height: 60),
            CaseStudyWidget(),               // 6. 案例展示
            SizedBox(height: 60),
            ContactBarWidget(),              // 7. 联系咨询
          ],
        ),
      ),
    );
  }
}
```

---

## ✨ 动效设计

### 1. 滚动显现动效
```dart
// 元素随滚动淡入
AnimatedOpacity(
  opacity: _isVisible ? 1.0 : 0.0,
  duration: Duration(milliseconds: 600),
  child: Widget,
)
```

### 2. 卡片悬停动效
```dart
// 鼠标悬停时卡片放大
MouseRegion(
  onEnter: (_) => setState(() => _isHovered = true),
  onExit: (_) => setState(() => _isHovered = false),
  child: AnimatedContainer(
    duration: Duration(milliseconds: 300),
    curve: Curves.easeInOut,
    transform: Matrix4.identity()..scale(_isHovered ? 1.05 : 1.0),
    decoration: BoxDecoration(
      boxShadow: _isHovered
        ? [BoxShadow(blurRadius: 20, spreadRadius: 2)]
        : [BoxShadow(blurRadius: 10)],
    ),
  ),
)
```

### 3. 按钮动效
```dart
// 按钮悬停效果
InkWell(
  onHover: (isHovered) {
    // 颜色变化
  },
  child: Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xFF1890FF), Color(0xFF096DD9)],
      ),
    ),
  ),
)
```

---

## 🎨 颜色方案建议

```dart
class AppColors {
  // 主色
  static const primary = Color(0xFF1890FF);      // 蓝色
  static const primaryDark = Color(0xFF096DD9);
  static const primaryLight = Color(0xFF40A9FF);

  // 辅助色
  static const secondary = Color(0xFF52C41A);    // 绿色
  static const warning = Color(0xFFFAAD14);      // 橙色
  static const error = Color(0xFFF5222D);        // 红色

  // 中性色
  static const textPrimary = Color(0xFF262626);
  static const textSecondary = Color(0xFF8C8C8C);
  static const background = Color(0xFFFFFFFF);
  static const backgroundDark = Color(0xFFF5F5F5);
}
```

---

## 📐 尺寸规范

```dart
class AppSizes {
  // 间距
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  // 字体大小
  static const double fsSm = 12.0;
  static const double fsMd = 14.0;
  static const double fsLg = 16.0;
  static const double fsXl = 18.0;
  static const double fs2xl = 24.0;
  static const double fs3xl = 32.0;
}
```

---

## 📂 文件结构

```
lib/presentation/
├── widgets/
│   ├── common/
│   │   ├── section_title_widget.dart
│   │   ├── service_card_widget.dart
│   │   ├── cta_button_widget.dart
│   │   └── process_step_widget.dart
│   ├── serve/
│   │   ├── hero_banner_widget.dart
│   │   ├── core_services_widget.dart
│   │   ├── tech_advantage_widget.dart
│   │   ├── service_flow_widget.dart
│   │   ├── industry_service_widget.dart
│   │   ├── case_study_widget.dart
│   │   └── contact_bar_widget.dart
│   └── layouts/
│       ├── page_container_widget.dart
│       └── section_container_widget.dart
├── pages/
│   └── serve/
│       └── serve_page.dart
└── assets/
    ├── images/services/
    ├── images/cases/
    └── icons/
```

---

## 🚀 开发优先级

### 阶段1：基础组件（优先）
1. SectionTitleWidget
2. ServiceCardWidget
3. CTAButtonWidget

### 阶段2：业务组件
1. HeroBannerWidget
2. CoreServicesWidget
3. TechAdvantageWidget

### 阶段3：完善功能
1. ServiceFlowWidget
2. IndustryServiceWidget
3. CaseStudyWidget
4. ContactBarWidget

### 阶段4：动效优化
1. 滚动显现
2. 卡片悬停
3. 按钮交互

---

**总结**：本设计方案基于实际网页内容分析，提供了完整的组件架构、数据模型、动效设计和实现建议。可以直接用于 Flutter Web 开发。
