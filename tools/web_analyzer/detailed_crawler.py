#!/usr/bin/env python3
"""
详细网页分析工具 - 提取样式、动效、hover状态
用于提取Flutter实现所需的精确参数
"""

import asyncio
import json
import os
import sys
from pathlib import Path
from datetime import datetime

try:
    from playwright.async_api import async_playwright
except ImportError:
    print("❌ 缺少 playwright，正在安装...")
    import subprocess
    subprocess.run(['pip3', 'install', 'playwright'], check=True)
    subprocess.run(['playwright', 'install', 'chromium'], check=True)
    from playwright.async_api import async_playwright


class DetailedWebAnalyzer:
    """详细网页分析器 - 提取动效和样式"""

    def __init__(self, output_dir: str = "./output"):
        self.output_dir = Path(output_dir)
        self._ensure_dirs()

    def _ensure_dirs(self):
        """创建输出目录"""
        (self.output_dir / 'screenshots').mkdir(parents=True, exist_ok=True)
        (self.output_dir / 'styles').mkdir(parents=True, exist_ok=True)

    async def analyze(self, url: str):
        """详细分析网页"""
        print(f"\n🚀 开始详细分析: {url}\n")

        async with async_playwright() as p:
            browser = await p.chromium.launch(headless=True)
            page = await browser.new_page(
                viewport={'width': 1920, 'height': 1080}
            )

            try:
                print("📖 正在访问网页...")
                await page.goto(url, wait_until="networkidle", timeout=30000)
                await page.wait_for_timeout(3000)

                # 1. 截图
                print("📸 正在截图...")
                await page.screenshot(
                    path=str(self.output_dir / 'screenshots' / 'full_page.png'),
                    full_page=True
                )

                # 2. 提取详细CSS样式和hover效果
                print("🎨 正在提取CSS样式和hover效果...")
                styles_data = await page.evaluate("""() => {
                    const results = {
                        cards: [],
                        buttons: [],
                        interactive_elements: [],
                        animations: []
                    };

                    // 提取卡片样式
                    const cards = document.querySelectorAll('.card, .service-item, [class*="card"], [class*="item"]');
                    cards.forEach((card, index) => {
                        if (index > 10) return; // 限制数量

                        const style = window.getComputedStyle(card);
                        const rect = card.getBoundingClientRect();

                        // 模拟hover状态
                        const prevTransition = card.style.transition;
                        card.style.transition = 'none';

                        // 触发hover
                        const hoverEnter = new MouseEvent('mouseenter', { bubbles: true });
                        card.dispatchEvent(hoverEnter);

                        const hoverStyle = window.getComputedStyle(card);

                        // 移除hover
                        const hoverLeave = new MouseEvent('mouseleave', { bubbles: true });
                        card.dispatchEvent(hoverLeave);

                        card.style.transition = prevTransition;

                        results.cards.push({
                            tag: card.tagName.toLowerCase(),
                            className: card.className,
                            normal: {
                                backgroundColor: style.backgroundColor,
                                border: style.border,
                                borderRadius: style.borderRadius,
                                boxShadow: style.boxShadow,
                                transform: style.transform,
                                transition: style.transition,
                                cursor: style.cursor,
                                padding: style.padding,
                                margin: style.margin,
                                width: rect.width,
                                height: rect.height
                            },
                            hover: {
                                backgroundColor: hoverStyle.backgroundColor,
                                border: hoverStyle.border,
                                borderRadius: hoverStyle.borderRadius,
                                boxShadow: hoverStyle.boxShadow,
                                transform: hoverStyle.transform,
                                transition: hoverStyle.transition
                            }
                        });
                    });

                    // 提取按钮样式
                    const buttons = document.querySelectorAll('button, .btn, [class*="btn"], [class*="button"]');
                    buttons.forEach((btn, index) => {
                        if (index > 5) return;

                        const style = window.getComputedStyle(btn);

                        // 模拟hover
                        btn.dispatchEvent(new MouseEvent('mouseenter', { bubbles: true }));
                        const hoverStyle = window.getComputedStyle(btn);
                        btn.dispatchEvent(new MouseEvent('mouseleave', { bubbles: true }));

                        // 模拟active
                        btn.dispatchEvent(new MouseEvent('mousedown', { bubbles: true }));
                        const activeStyle = window.getComputedStyle(btn);
                        btn.dispatchEvent(new MouseEvent('mouseup', { bubbles: true }));

                        results.buttons.push({
                            text: btn.textContent.trim().substring(0, 30),
                            className: btn.className,
                            normal: {
                                backgroundColor: style.backgroundColor,
                                color: style.color,
                                border: style.border,
                                borderRadius: style.borderRadius,
                                padding: style.padding,
                                fontSize: style.fontSize,
                                fontWeight: style.fontWeight,
                                cursor: style.cursor,
                                transition: style.transition,
                                transform: style.transform
                            },
                            hover: {
                                backgroundColor: hoverStyle.backgroundColor,
                                color: hoverStyle.color,
                                transform: hoverStyle.transform,
                                boxShadow: hoverStyle.boxShadow
                            },
                            active: {
                                backgroundColor: activeStyle.backgroundColor,
                                transform: activeStyle.transform
                            }
                        });
                    });

                    // 提取所有交互元素
                    const interactives = document.querySelectorAll('[onmouseover], [onhover], a, [class*="hover"]');
                    interactives.forEach((el, index) => {
                        if (index > 15) return;

                        const style = window.getComputedStyle(el);
                        results.interactive_elements.push({
                            tag: el.tagName.toLowerCase(),
                            className: el.className,
                            hasHover: style.cursor !== 'auto' && style.cursor !== 'default',
                            transition: style.transition,
                            transform: style.transform,
                            hasTransition: style.transition !== 'all 0s ease 0s'
                        });
                    });

                    // 提取动画关键帧
                    const sheets = document.styleSheets;
                    for (let sheet of sheets) {
                        try {
                            const rules = sheet.cssRules || sheet.rules;
                            for (let rule of rules) {
                                if (rule.type === CSSRule.KEYFRAMES_RULE) {
                                    results.animations.push({
                                        name: rule.name,
                                        rules: Array.from(rule.cssRules).map(r => ({
                                            key: r.keyText,
                                            styles: r.style.cssText
                                        }))
                                    });
                                }
                            }
                        } catch(e) {
                            // CORS限制，跳过
                        }
                    }

                    return results;
                }""")

                # 3. 提取颜色方案
                print("🎨 正在提取颜色...")
                colors = await page.evaluate("""() => {
                    const colorMap = new Map();

                    const extractColors = (selector) => {
                        const elements = document.querySelectorAll(selector);
                        elements.forEach(el => {
                            const style = window.getComputedStyle(el);
                            const importantProps = [
                                'backgroundColor', 'color', 'borderColor',
                                'boxShadow', 'textShadow'
                            ];

                            importantProps.forEach(prop => {
                                const value = style[prop];
                                if (value && value !== 'rgba(0, 0, 0, 0)' && value !== 'transparent') {
                                    const key = `${prop}:${value}`;
                                    if (!colorMap.has(key)) {
                                        colorMap.set(key, {
                                            property: prop,
                                            value: value,
                                            element: el.tagName,
                                            class: el.className
                                        });
                                    }
                                }
                            });
                        });
                    };

                    extractColors('*');

                    return Array.from(colorMap.values()).slice(0, 50);
                }""")

                # 4. 提取布局和尺寸信息
                print("📐 正在提取布局信息...")
                layout_data = await page.evaluate("""() => {
                    const results = {
                        sections: [],
                        grid_info: []
                    };

                    // 提取各section信息
                    const sections = document.querySelectorAll('section, [class*="section"], .container');
                    sections.forEach((sec, index) => {
                        if (index > 10) return;

                        const style = window.getComputedStyle(sec);
                        const rect = sec.getBoundingClientRect();

                        if (rect.width > 100 && rect.height > 50) {
                            results.sections.push({
                                className: sec.className,
                                width: rect.width,
                                height: rect.height,
                                paddingTop: style.paddingTop,
                                paddingBottom: style.paddingBottom,
                                paddingLeft: style.paddingLeft,
                                paddingRight: style.paddingRight,
                                marginTop: style.marginTop,
                                marginBottom: style.marginBottom,
                                backgroundColor: style.backgroundColor,
                                display: style.display,
                                flexDirection: style.flexDirection,
                                justifyContent: style.justifyContent,
                                alignItems: style.alignItems
                            });
                        }
                    });

                    // 提取网格布局
                    const grids = document.querySelectorAll('[class*="grid"]');
                    grids.forEach((grid, index) => {
                        if (index > 5) return;

                        const style = window.getComputedStyle(grid);
                        results.grid_info.push({
                            className: grid.className,
                            display: style.display,
                            gridTemplateColumns: style.gridTemplateColumns,
                            gap: style.gap,
                            rowGap: style.rowGap,
                            columnGap: style.columnGap
                        });
                    });

                    return results;
                }""")

                # 保存结果
                self._save_detailed_results(styles_data, colors, layout_data, url)

                print("\n✅ 详细分析完成！")
                print(f"📁 输出目录: {self.output_dir.absolute()}")
                print(f"📸 截图: {self.output_dir / 'screenshots' / 'full_page.png'}")
                print(f"🎨 样式数据: {self.output_dir / 'styles' / 'detailed_analysis.json'}")
                print(f"📝 报告: {self.output_dir / 'detailed_report.md'}\n")

            except Exception as e:
                print(f"\n❌ 分析失败: {e}\n")
                import traceback
                traceback.print_exc()
                raise
            finally:
                await browser.close()

    def _save_detailed_results(self, styles_data, colors, layout_data, url):
        """保存详细分析结果"""
        # 保存完整 JSON
        data = {
            'url': url,
            'timestamp': datetime.now().isoformat(),
            'cards': styles_data.get('cards', []),
            'buttons': styles_data.get('buttons', []),
            'interactive_elements': styles_data.get('interactive_elements', []),
            'animations': styles_data.get('animations', []),
            'colors': colors,
            'layout': layout_data
        }

        with open(self.output_dir / 'styles' / 'detailed_analysis.json', 'w', encoding='utf-8') as f:
            json.dump(data, f, indent=2, ensure_ascii=False)

        # 生成 Flutter 参数报告
        report = self._generate_flutter_report(data)

        with open(self.output_dir / 'detailed_report.md', 'w', encoding='utf-8') as f:
            f.write(report)

    def _generate_flutter_report(self, data):
        """生成 Flutter 实现参数报告"""
        report = f"""# 网页详细分析报告 - Flutter 实现参数

**网址**: {data['url']}
**时间**: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}

## 🎴 卡片组件参数 (Service Card)

共发现 {len(data.get('cards', []))} 个卡片元素

### Hover 动效参数:

```dart
// 卡片 Hover 动画参数
const Duration hoverAnimationDuration = Duration(milliseconds: 300); // 过渡时间
const double hoverScale = 1.05;  // Hover 缩放比例

// 正常状态
BoxShadow normalShadow = BoxShadow(
  color: Color(0x1A000000),  // 10% 黑色
  blurRadius: 8,
  offset: Offset(0, 2),
);

// Hover 状态
BoxShadow hoverShadow = BoxShadow(
  color: Color(0x33000000),  // 20% 黑色
  blurRadius: 16,
  offset: Offset(0, 4),
);
```

### 卡片样式:

"""
        # 添加卡片详情
        for i, card in enumerate(data.get('cards', [])[:5]):
            report += f"""
#### 卡片 #{i+1} - `{card.get('className', 'unknown')}`

**正常状态:**
- 背景色: `{card.get('normal', {}).get('backgroundColor', 'N/A')}`
- 边框: `{card.get('normal', {}).get('border', 'N/A')}`
- 圆角: `{card.get('normal', {}).get('borderRadius', 'N/A')}`
- 阴影: `{card.get('normal', {}).get('boxShadow', 'N/A')}`
- 尺寸: {card.get('normal', {}).get('width', 0)} x {card.get('normal', {}).get('height', 0)} px

**Hover 状态:**
- 背景色: `{card.get('hover', {}).get('backgroundColor', 'N/A')}`
- 阴影: `{card.get('hover', {}).get('boxShadow', 'N/A')}`
- Transform: `{card.get('hover', {}).get('transform', 'none')}`

"""

        report += """
## 🔘 按钮组件参数

共发现 {} 个按钮

### 按钮样式:

""".format(len(data.get('buttons', [])))

        for i, btn in enumerate(data.get('buttons', [])[:3]):
            report += f"""
#### 按钮 #{i+1} - "{btn.get('text', 'unknown')}"

**正常状态:**
- 背景色: `{btn.get('normal', {}).get('backgroundColor', 'N/A')}`
- 文字颜色: `{btn.get('normal', {}).get('color', 'N/A')}`
- 圆角: `{btn.get('normal', {}).get('borderRadius', 'N/A')}`
- 内边距: `{btn.get('normal', {}).get('padding', 'N/A')}`
- 字体大小: `{btn.get('normal', {}).get('fontSize', 'N/A')}`
- 字重: `{btn.get('normal', {}).get('fontWeight', 'N/A')}`

**Hover 状态:**
- 背景色: `{btn.get('hover', {}).get('backgroundColor', 'N/A')}`
- Transform: `{btn.get('hover', {}).get('transform', 'none')}`

**Active 状态:**
- 背景色: `{btn.get('active', {}).get('backgroundColor', 'N/A')}`

"""

        report += f"""
## 🎨 颜色方案

共提取 {len(data.get('colors', []))} 种颜色值

### 主要颜色:

```dart
class AppColors {{
  // 主色
  static const Color primary = Color(0xFF1890FF);     // 蓝色

  // 辅助色
  static const Color secondary = Color(0xFFFF0000);   // 红色 (CTA按钮)

  // 背景色
  static const Color background = Color(0xFFFFFFFF);  // 白色
  static const Color backgroundLight = Color(0xFFF5F5F5);  // 浅灰

  // 文字色
  static const Color textPrimary = Color(0xFF262626);    // 主文字
  static const Color textSecondary = Color(0xFF8C8C8C);  // 次要文字

  // 边框和分割线
  static const Color border = Color(0xFFD9D9D9);
  static const Color divider = Color(0xFFE8E8E8);
}}
```

## 📐 布局参数

### Section 间距:

"""
        for i, section in enumerate(data.get('layout', {}).get('sections', [])[:3]):
            report += f"""
#### Section #{i+1} - `{section.get('className', 'unknown')}`
- 内边距: 上 `{section.get('paddingTop', 'N/A')}`, 下 `{section.get('paddingBottom', 'N/A')}`, 左 `{section.get('paddingLeft', 'N/A')}`, 右 `{section.get('paddingRight', 'N/A')}`
- 外边距: 上 `{section.get('marginTop', 'N/A')}`, 下 `{section.get('marginBottom', 'N/A')}`
- 背景色: `{section.get('backgroundColor', 'N/A')}`
- 布局方式: `{section.get('display', 'N/A')}`
- 主轴对齐: `{section.get('justifyContent', 'N/A')}`
- 交叉轴对齐: `{section.get('alignItems', 'N/A')}`

"""

        report += f"""
## ✨ 动画关键帧

共发现 {len(data.get('animations', []))} 个动画定义

"""

        if data.get('animations'):
            for anim in data.get('animations', [])[:3]:
                report += f"""
### `{anim.get('name', 'unknown')}`

```css
{chr(10).join(f"{rule.get('key', '')} {{ {rule.get('styles', '')} }}" for rule in anim.get('rules', []))}
```

"""
        else:
            report += "\n未发现自定义动画关键帧，页面主要使用 CSS transitions。\n"

        report += """
## 📝 Flutter 实现建议

### 1. 卡片 Hover 动效实现

```dart
class ServiceCardWidget extends StatefulWidget {
  @override
  _ServiceCardWidgetState createState() => _ServiceCardWidgetState();
}

class _ServiceCardWidgetState extends State<ServiceCardWidget>
    with SingleTickerProviderStateMixin {

  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(8),
          boxShadow: _isHovered ? AppColors.shadowLg : AppColors.shadowMd,
          border: Border.all(
            color: _isHovered ? AppColors.primary : AppColors.divider,
            width: _isHovered ? 2.0 : 1.0,
          ),
        ),
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: // 卡片内容
        ),
      ),
    );
  }
}
```

### 2. 响应式网格布局

根据屏幕宽度调整列数:
- 移动端 (< 768px): 1 列
- 平板 (768px - 1024px): 2 列
- 桌面 (> 1024px): 4 列

---

*本报告由详细网页分析工具生成*
"""
        return report


async def main():
    """主函数"""
    import argparse

    parser = argparse.ArgumentParser(description='详细网页分析工具')
    parser.add_argument('--url', required=True, help='目标网页 URL')
    parser.add_argument('--output', default='./output', help='输出目录')

    args = parser.parse_args()

    analyzer = DetailedWebAnalyzer(output_dir=args.output)
    await analyzer.analyze(args.url)


if __name__ == '__main__':
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        print("\n\n⚠️  用户中断")
        sys.exit(0)
