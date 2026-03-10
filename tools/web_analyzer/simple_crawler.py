#!/usr/bin/env python3
"""
简化版网页分析工具 - 快速截图和样式提取
只需 playwright 和 beautifulsoup4（轻量级）

用法：
    python3 simple_crawler.py --url "https://example.com"
"""

import asyncio
import json
import os
import sys
from pathlib import Path
from datetime import datetime

# 只依赖基础库
try:
    from playwright.async_api import async_playwright
except ImportError:
    print("❌ 缺少 playwright，正在安装...")
    import subprocess
    subprocess.run(['pip3', 'install', 'playwright'], check=True)
    subprocess.run(['playwright', 'install', 'chromium'], check=True)
    from playwright.async_api import async_playwright


class SimpleWebAnalyzer:
    """简化版网页分析器"""

    def __init__(self, output_dir: str = "./output"):
        self.output_dir = Path(output_dir)
        self._ensure_dirs()

    def _ensure_dirs(self):
        """创建输出目录"""
        (self.output_dir / 'screenshots').mkdir(parents=True, exist_ok=True)
        (self.output_dir / 'styles').mkdir(parents=True, exist_ok=True)

    async def analyze(self, url: str):
        """分析网页"""
        print(f"\n🚀 开始分析: {url}\n")

        async with async_playwright() as p:
            # 启动浏览器（无头模式）
            browser = await p.chromium.launch(headless=True)

            # 创建页面（桌面视口）
            page = await browser.new_page(
                viewport={'width': 1920, 'height': 1080}
            )

            try:
                # 访问网页
                print("📖 正在访问网页...")
                await page.goto(url, wait_until="networkidle", timeout=30000)

                # 等待页面稳定
                await page.wait_for_timeout(3000)

                # 1. 截取完整页面
                print("📸 正在截图...")
                await page.screenshot(
                    path=str(self.output_dir / 'screenshots' / 'full_page.png'),
                    full_page=True
                )

                # 2. 提取颜色
                print("🎨 正在提取样式...")
                colors = await page.evaluate("""() => {
                    const colors = new Set();
                    const elements = document.querySelectorAll('*');
                    elements.forEach(el => {
                        const style = window.getComputedStyle(el);
                        colors.add(style.color);
                        colors.add(style.backgroundColor);
                    });
                    return Array.from(colors).filter(c => c && c !== 'rgba(0, 0, 0, 0)');
                }""")

                # 3. 提取文本内容
                print("📝 正在提取内容...")
                text_content = await page.evaluate("""() => {
                    return {
                        title: document.title,
                        headings: Array.from(document.querySelectorAll('h1, h2, h3, h4'))
                            .map(h => ({ tag: h.tagName, text: h.textContent.trim() })),
                        buttons: Array.from(document.querySelectorAll('button, .btn'))
                            .map(b => b.textContent.trim())
                    };
                }""")

                # 4. 提取组件信息
                print("🔍 正在分析组件...")
                components = await page.evaluate("""() => {
                    return {
                        hero: document.querySelector('header, .hero, .banner') !== null,
                        services: document.querySelectorAll('.service, .card').length,
                        forms: document.querySelectorAll('form').length,
                        images: document.querySelectorAll('img').length,
                        links: document.querySelectorAll('a').length
                    };
                }""")

                # 保存结果
                self._save_results(colors, text_content, components, url)

                print("\n✅ 分析完成！")
                print(f"📁 输出目录: {self.output_dir.absolute()}")
                print(f"📸 截图: {self.output_dir / 'screenshots' / 'full_page.png'}")
                print(f"🎨 样式: {self.output_dir / 'styles' / 'analysis.json'}")
                print(f"📝 报告: {self.output_dir / 'report.md'}\n")

            except Exception as e:
                print(f"\n❌ 分析失败: {e}\n")
                raise
            finally:
                await browser.close()

    def _save_results(self, colors, content, components, url):
        """保存分析结果"""
        # 保存 JSON 数据
        data = {
            'url': url,
            'timestamp': datetime.now().isoformat(),
            'colors': colors,
            'content': content,
            'components': components
        }

        with open(self.output_dir / 'styles' / 'analysis.json', 'w', encoding='utf-8') as f:
            json.dump(data, f, indent=2, ensure_ascii=False)

        # 生成 Markdown 报告
        report = f"""# 网页分析报告

**网址**: {url}
**时间**: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}

## 📊 页面概览

- **标题**: {content.get('title', 'N/A')}
- **图片数量**: {components.get('images', 0)}
- **链接数量**: {components.get('links', 0)}
- **表单数量**: {components.get('forms', 0)}
- **服务卡片**: {components.get('services', 0)}

## 📋 内容结构

### 标题和副标题
{chr(10).join(f"- {h.get('tag')}: {h.get('text', '')}" for h in content.get('headings', [])[:10])}

### 按钮文本
{chr(10).join(f"- {btn}" for btn in content.get('buttons', []) if btn)[:10]}

## 🎨 颜色方案

检测到 **{len(colors)}** 种颜色（主要颜色）：

```json
{json.dumps(colors[:20], indent=2, ensure_ascii=False)}
```

## 📸 截图

完整页面截图已保存至：`screenshots/full_page.png`

## 💡 下一步

1. 查看截图了解页面布局
2. 根据标题和按钮文本设计组件
3. 使用颜色方案配置 Flutter 主题
4. 参考 `analysis.json` 获取完整数据

---

*本报告由简化版网页分析工具生成*
"""

        with open(self.output_dir / 'report.md', 'w', encoding='utf-8') as f:
            f.write(report)


async def main():
    """主函数"""
    import argparse

    parser = argparse.ArgumentParser(description='简化版网页分析工具')
    parser.add_argument('--url', required=True, help='目标网页 URL')
    parser.add_argument('--output', default='./output', help='输出目录')

    args = parser.parse_args()

    analyzer = SimpleWebAnalyzer(output_dir=args.output)
    await analyzer.analyze(args.url)


if __name__ == '__main__':
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        print("\n\n⚠️  用户中断")
        sys.exit(0)
