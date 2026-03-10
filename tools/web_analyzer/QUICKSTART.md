# Web 分析工具 - 快速启动指南

## 📦 项目隔离说明

本工具采用**独立目录结构**，与 Flutter Web 项目分离但距离相近：

```
/Volumes/DudaDate/微信小程序开发/flutter官网开发/
├── official_website/          # Flutter Web 项目（主项目）
│   ├── lib/
│   ├── assets/
│   └── pubspec.yaml
│
├── tools/                     # 工具目录（独立）
│   └── web_analyzer/         # 网页分析工具
│       ├── README.md         # 完整文档
│       ├── requirements.txt  # Python 依赖
│       ├── config.yaml       # 配置文件
│       ├── crawler.py        # 爬虫脚本
│       └── output/           # 输出目录
│
├── docs/                      # 项目文档
└── scripts/                   # 其他脚本
```

### 隔离原则

1. **完全独立** - 工具有独立的 Python 环境、依赖、配置
2. **不影响主项目** - 不修改 Flutter 项目代码
3. **方便使用** - 距离主项目近，便于参考和协作

---

## 🚀 使用步骤

### 1. 等待依赖安装完成

```bash
# 安装正在后台进行，请等待...
pip3 install -r requirements.txt
```

首次安装需要下载 Playwright 浏览器（约 41MB），请耐心等待。

### 2. 安装 Playwright 浏览器（安装完成后）

```bash
cd tools/web_analyzer
playwright install chromium
```

### 3. 分析目标网页

```bash
cd tools/web_analyzer

# 分析指定网页
python3 crawler.py --url "https://www.junhesoftware.online/xcx/serve"

# 或使用自定义输出目录
python3 crawler.py \
  --url "https://www.junhesoftware.online/xcx/serve" \
  --output "./output/junhe_serve"
```

### 4. 查看分析结果

```bash
cd output
ls -lh

# 查看报告
cat report.md

# 查看截图
open screenshots/full_page.png
```

---

## 📊 输出结果说明

### 目录结构

```
output/
├── screenshots/           # 📸 截图
│   ├── full_page.png     # 完整页面
│   ├── hero_banner.png   # 组件截图
│   └── services.png
│
├── html/                 # 📄 HTML 结构
│   ├── page.html        # 完整 HTML
│   └── components/      # 组件 HTML
│
├── styles/              # 🎨 样式
│   ├── colors.json      # 颜色方案
│   └── fonts.json       # 字体信息
│
├── animations/          # ✨ 动效
│   └── css_animations.json
│
└── report.md            # 📝 分析报告
```

### 如何使用结果

1. **查看截图** - 了解页面布局和组件样式
2. **分析 HTML** - 理解组件结构和层级关系
3. **提取样式** - 获取颜色、字体用于 Flutter 实现
4. **参考动效** - 根据动效参数实现 Flutter 动画

---

## 🎯 与 Flutter 项目集成

### 从网页到 Flutter 组件

分析完成后，在 Flutter 项目中创建对应的组件：

```dart
// lib/presentation/widgets/serve/hero_banner_widget.dart
class HeroBannerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // 参考 output/styles/colors.json 中的颜色
      color: Color(0xFF1890FF),

      child: Column(
        children: [
          Text(
            // 参考 output/html/components/hero_banner.html 中的文字
            '我们用心让客户更放心',
            style: TextStyle(
              // 参考 output/styles/fonts.json 中的字体
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
```

### 实现动效

```dart
// 参考 output/animations/css_animations.json
class AnimatedServiceCard extends StatefulWidget {
  @override
  _AnimatedServiceCardState createState() => _AnimatedServiceCardState();
}

class _AnimatedServiceCardState extends State<AnimatedServiceCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300), // 从 CSS 提取
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut, // 从 CSS 提取
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _controller.forward(),
      onExit: (_) => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 + (_animation.value * 0.05),
            child: child,
          );
        },
      ),
    );
  }
}
```

---

## ⚙️ 配置选项

编辑 `config.yaml` 来自定义分析行为：

```yaml
# 目标网页
target_url: "https://www.junhesoftware.online/xcx/serve"

# 视口设置（桌面端/移动端）
viewport:
  width: 1920
  height: 1080

# 组件选择器（指定要截图的组件）
component_selectors:
  - name: "hero_banner"
    selector: ".hero-banner, .banner, header"

  - name: "services"
    selector: ".services, .service-cards"
```

---

## 🔧 常见问题

### Q: 安装卡住了怎么办？

A: Playwright 下载较慢，可以：
1. 等待安装完成
2. 或使用国内镜像：`export PLAYWRIGHT_DOWNLOAD_HOST=https://npmmirror.com/mirrors/playwright/`

### Q: 截图是空白？

A: 增加等待时间：
```yaml
wait_for:
  timeout: 10000  # 增加到 10 秒
```

### Q: 如何提取特定组件？

A: 在 `config.yaml` 中添加组件选择器：
```yaml
component_selectors:
  - name: "my_component"
    selector: ".my-class"
    description: "我的组件"
```

---

## 📚 更多文档

- [完整文档](README.md)
- [项目架构手册](../../ARCHITECTURE.md)
- [开发指南](../../DEVELOPMENT.md)

---

**提示**：本工具专为 Flutter Web 官网项目设计，不会影响主项目代码，可以安全使用！
