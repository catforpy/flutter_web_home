# Web 网页分析工具

## 📋 工具说明

这是一个专为 **Flutter Web 官网项目** 设计的网页分析工具，用于提取目标网页的：
- 📸 **截图** - 完整页面和关键组件截图
- 🎨 **样式** - 颜色、字体、间距、布局
- ✨ **动效** - CSS 动画、过渡效果、交互动效
- 📄 **结构** - HTML 结构、组件层级
- 🖼️ **资源** - 图片、图标、字体等资源文件

## 🎯 适用场景

1. **竞品分析** - 分析竞争对手的网页设计
2. **设计还原** - 提取设计参数用于 Flutter 实现
3. **动效复刻** - 提取动效参数（时长、缓动函数等）
4. **组件设计** - 分析网页组件结构，设计 Flutter 组件方案

## 📁 目录结构

```
tools/web_analyzer/
├── README.md              # 本文件
├── requirements.txt       # Python 依赖
├── config.yaml           # 配置文件
├── crawler.py            # 主爬虫脚本
├── analyzer.py           # 分析脚本
└── output/               # 输出目录
    ├── screenshots/      # 截图
    ├── html/            # HTML 内容
    ├── styles/          # CSS 样式提取
    ├── animations/      # 动效参数
    └── report.md        # 分析报告
```

## 🚀 快速开始

### 1. 安装依赖

```bash
cd tools/web_analyzer
pip3 install -r requirements.txt
```

### 2. 配置目标网页

编辑 `config.yaml`：

```yaml
target_url: "https://www.junhesoftware.online/xcx/serve"
output_dir: "./output"
viewport:
  width: 1920
  height: 1080
screenshot:
  full_page: true
  components: true
```

### 3. 运行分析

```bash
# 完整分析
python3 crawler.py --url "https://www.junhesoftware.online/xcx/serve"

# 仅截图
python3 crawler.py --url "..." --screenshot-only

# 仅提取样式
python3 crawler.py --url "..." --styles-only
```

### 4. 查看报告

分析完成后，查看 `output/report.md` 获取完整分析报告。

## 📊 输出内容

### 1. 截图 (screenshots/)

- `full_page.png` - 完整页面截图
- `hero_banner.png` - 顶部横幅
- `services.png` - 服务卡片
- `tech_advantage.png` - 技术优势
- `process_flow.png` - 流程图
- ... 其他组件截图

### 2. HTML 结构 (html/)

- `page.html` - 完整 HTML
- `components/` - 各组件 HTML 结构

### 3. 样式提取 (styles/)

- `colors.json` - 颜色方案
- `typography.json` - 字体样式
- `spacing.json` - 间距规范
- `layout.json` - 布局参数

### 4. 动效参数 (animations/)

- `transitions.json` - 过渡效果
- `keyframes.json` - 关键帧动画
- `interactions.json` - 交互动效

### 5. 分析报告 (report.md)

包含：
- 页面结构分析
- 组件设计方案
- Flutter 实现建议
- 动效实现代码

## 🛠️ 技术栈

- **Python 3.9+**
- **Playwright** - 浏览器自动化
- **BeautifulSoup4** - HTML 解析
- **Crawl4AI** - AI 友好爬虫
- **Pillow** - 图片处理

## ⚙️ 配置选项

### 视口设置

```yaml
viewport:
  width: 1920        # 桌面端
  height: 1080
  # width: 375       # 移动端
  # height: 667
```

### 等待策略

```yaml
wait_for:
  selector: ".main-content"  # 等待特定元素
  timeout: 5000              # 超时时间（ms）
  idle: 1000                 # 空闲时间（ms）
```

### 截图选项

```yaml
screenshot:
  full_page: true      # 完整页面
  components: true     # 组件截图
  animations: false    # 动画帧截图
```

## 📝 使用示例

### 示例 1：分析服务页面

```bash
python3 crawler.py \
  --url "https://www.junhesoftware.online/xcx/serve" \
  --output "./output/serve_page" \
  --full-report
```

### 示例 2：仅提取动效

```bash
python3 analyzer.py \
  --url "https://www.junhesoftware.online/xcx/serve" \
  --extract animations
```

### 示例 3：对比分析

```bash
python3 crawler.py \
  --url "https://www.junhesoftware.online/xcx/serve" \
  --compare "./output/baseline.json"
```

## 🎨 Flutter 组件映射

工具会自动分析网页组件并生成对应的 Flutter 组件设计：

| 网页元素 | Flutter 组件 |
|---------|-------------|
| Hero Banner | `HeroBannerWidget` |
| Service Cards | `ServiceCardWidget` |
| Process Flow | `ProcessStepWidget` |
| Animations | `AnimatedContainer` / `AnimationController` |

## ⚠️ 注意事项

1. **项目隔离** - 本工具独立于 Flutter 项目，但不影响项目结构
2. **网络连接** - 需要稳定的网络连接访问目标网页
3. **浏览器驱动** - 首次运行会自动下载 Playwright 浏览器
4. **输出清理** - 每次运行会覆盖 `output/` 目录内容

## 🔧 故障排除

### Playwright 浏览器未安装

```bash
playwright install chromium
```

### 依赖冲突

```bash
pip3 install --upgrade -r requirements.txt
```

### 截图空白

增加等待时间：
```yaml
wait_for:
  timeout: 10000
```

## 📚 相关文档

- [项目架构手册](../../ARCHITECTURE.md)
- [开发指南](../../DEVELOPMENT.md)
- [组件设计方案](../official_website/lib/presentation/widgets/)

## 📧 反馈与支持

如有问题或建议，请在项目仓库提 Issue。

---

**最后更新**：2026-03-04
**版本**：v1.0.0
**维护者**：Flutter Web 官网项目组
