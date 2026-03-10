#!/usr/bin/env python3
"""
精准提取网页CSS样式和hover效果
针对 junhesoftware.online 网站定制
"""

import asyncio
import json
from pathlib import Path
from datetime import datetime

try:
    from playwright.async_api import async_playwright
except ImportError:
    print("❌ 缺少 playwright")
    import subprocess
    subprocess.run(['pip3', 'install', 'playwright'], check=True)
    subprocess.run(['playwright', 'install', 'chromium'], check=True)
    from playwright.async_api import async_playwright


async def extract_detailed_styles(url: str, output_dir: str = "./output"):
    """提取详细的CSS样式和hover效果"""
    output_path = Path(output_dir)
    output_path.mkdir(parents=True, exist_ok=True)

    print(f"\n🚀 开始提取样式: {url}\n")

    async with async_playwright() as p:
        browser = await p.chromium.launch(headless=True)
        page = await browser.new_page(viewport={'width': 1920, 'height': 1080})

        try:
            print("📖 正在访问网页...")
            await page.goto(url, wait_until="networkidle", timeout=30000)
            await page.wait_for_timeout(3000)

            # 提取所有样式规则和hover效果
            print("🎨 正在提取CSS规则...")
            css_data = await page.evaluate("""() => {
                const results = {
                    hoverRules: [],
                    elementStyles: [],
                    colors: [],
                    fonts: []
                };

                // 1. 提取所有CSS规则（包括hover）
                const sheets = document.styleSheets;
                const rulesMap = new Map(); // 用于去重

                for (let sheet of sheets) {
                    try {
                        const rules = sheet.cssRules || sheet.rules;
                        for (let rule of rules) {
                            // 提取所有带:hover的规则
                            if (rule.selectorText && rule.selectorText.includes(':hover')) {
                                const key = rule.selectorText;
                                if (!rulesMap.has(key)) {
                                    rulesMap.set(key, []);
                                }
                                rulesMap.get(key).push(rule.style.cssText);
                            }
                        }
                    } catch(e) {
                        // CORS限制，跳过外部样式表
                    }
                }

                // 转换hover规则
                for (let [selector, styles] of rulesMap) {
                    results.hoverRules.push({
                        selector: selector,
                        styles: styles.join('; ')
                    });
                }

                // 2. 查找页面上的关键元素并提取样式
                const selectors = [
                    '.box',
                    '.heng',
                    '.liucheng',
                    '.buttom',
                    'h3',
                    'h4',
                    'p',
                    'a',
                    'button',
                    '[class*="card"]',
                    '[class*="item"]',
                    '[class*="service"]',
                    '[class*="btn"]'
                ];

                selectors.forEach(selector => {
                    try {
                        const elements = document.querySelectorAll(selector);
                        if (elements.length > 0) {
                            const el = elements[0];
                            const style = window.getComputedStyle(el);

                            // 模拟hover
                            el.dispatchEvent(new MouseEvent('mouseenter', { bubbles: true, cancelable: true }));
                            const hoverStyle = window.getComputedStyle(el);
                            el.dispatchEvent(new MouseEvent('mouseleave', { bubbles: true, cancelable: true }));

                            results.elementStyles.push({
                                selector: selector,
                                count: elements.length,
                                normal: {
                                    display: style.display,
                                    backgroundColor: style.backgroundColor,
                                    color: style.color,
                                    border: style.border,
                                    borderRadius: style.borderRadius,
                                    padding: style.padding,
                                    margin: style.margin,
                                    fontSize: style.fontSize,
                                    fontWeight: style.fontWeight,
                                    boxShadow: style.boxShadow,
                                    transform: style.transform,
                                    transition: style.transition,
                                    cursor: style.cursor
                                },
                                hover: {
                                    backgroundColor: hoverStyle.backgroundColor,
                                    color: hoverStyle.color,
                                    border: hoverStyle.border,
                                    boxShadow: hoverStyle.boxShadow,
                                    transform: hoverStyle.transform
                                },
                                className: el.className,
                                id: el.id
                            });
                        }
                    } catch(e) {
                        // 忽略错误
                    }
                });

                // 3. 提取颜色和字体信息
                const colorSet = new Set();
                const fontSet = new Set();

                document.querySelectorAll('*').forEach(el => {
                    const style = window.getComputedStyle(el);
                    if (style.color && style.color !== 'rgba(0, 0, 0, 0)') {
                        colorSet.add(style.color);
                    }
                    if (style.backgroundColor && style.backgroundColor !== 'rgba(0, 0, 0, 0)' && style.backgroundColor !== 'transparent') {
                        colorSet.add(style.backgroundColor);
                    }
                    if (style.borderColor && style.borderColor !== 'rgba(0, 0, 0, 0)') {
                        colorSet.add(style.borderColor);
                    }
                    if (style.fontSize) {
                        fontSet.add(style.fontSize);
                    }
                });

                results.colors = Array.from(colorSet).slice(0, 30);
                results.fonts = Array.from(fontSet).slice(0, 10);

                return results;
            }""")

            # 保存结果
            output_file = output_path / 'extracted_styles.json'
            with open(output_file, 'w', encoding='utf-8') as f:
                json.dump(css_data, f, indent=2, ensure_ascii=False)

            # 生成报告
            report = generate_report(css_data, url)

            report_file = output_path / 'styles_report.md'
            with open(report_file, 'w', encoding='utf-8') as f:
                f.write(report)

            print(f"\n✅ 提取完成！")
            print(f"📁 JSON数据: {output_file}")
            print(f"📝 报告: {report_file}\n")

            return css_data

        finally:
            await browser.close()


def generate_report(data, url):
    """生成样式报告"""
    report = f"""# 网页CSS样式提取报告

**网址**: {url}
**时间**: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}

## 🎯 发现的 Hover 规则 (共{len(data.get('hoverRules', []))}条)

"""
    # 添加hover规则
    for rule in data.get('hoverRules', []):
        report += f"""
### `{rule['selector']}`

```css
{rule['selector']} {{
    {rule['styles']};
}}
```

"""

    report += f"""
## 📦 关键元素样式 (共{len(data.get('elementStyles', []))}个)

"""
    # 添加元素样式
    for item in data.get('elementStyles', []):
        report += f"""
### {item['selector']} (发现 {item['count']} 个元素)

**类名**: `{item['className']}`

**正常状态**:
- 显示方式: `{item['normal']['display']}`
- 背景色: `{item['normal']['backgroundColor']}`
- 文字颜色: `{item['normal']['color']}`
- 边框: `{item['normal']['border']}`
- 圆角: `{item['normal']['borderRadius']}`
- 内边距: `{item['normal']['padding']}`
- 外边距: `{item['normal']['margin']}`
- 字体大小: `{item['normal']['fontSize']}`
- 字重: `{item['normal']['fontWeight']}`
- 阴影: `{item['normal']['boxShadow']}`
- Transform: `{item['normal']['transform']}`
- Transition: `{item['normal']['transition']}`
- 鼠标样式: `{item['normal']['cursor']}`

**Hover 状态**:
- 背景色: `{item['hover']['backgroundColor']}`
- 文字颜色: `{item['hover']['color']}`
- 边框: `{item['hover']['border']}`
- 阴影: `{item['hover']['boxShadow']}`
- Transform: `{item['hover']['transform']}`

---

"""

    report += f"""
## 🎨 颜色方案 (共{len(data.get('colors', []))}种)

"""
    for color in data.get('colors', []):
        report += f"- `{color}`\n"

    report += f"""
## 🔤 字体大小 (共{len(data.get('fonts', []))}种)

"""
    for font in data.get('fonts', []):
        report += f"- `{font}`\n"

    return report


async def main():
    url = "https://www.junhesoftware.online/xcx/serve"
    output = "/Volumes/DudaDate/微信小程序开发/flutter官网开发/tools/web_analyzer/output/extracted"
    await extract_detailed_styles(url, output)


if __name__ == '__main__':
    asyncio.run(main())
