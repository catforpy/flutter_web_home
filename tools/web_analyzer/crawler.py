#!/usr/bin/env python3
"""
Web 网页分析工具 - 主爬虫脚本
用于提取网页的截图、样式、动效等信息

用法：
    python3 crawler.py --url "https://example.com"
    python3 crawler.py --url "https://example.com" --config config.yaml
"""

import asyncio
import json
import os
import sys
from pathlib import Path
from datetime import datetime
from typing import Dict, List, Any
import yaml

try:
    from playwright.async_api import async_playwright, Browser, Page
    from bs4 import BeautifulSoup
    from rich.console import Console
    from rich.progress import track
    from rich.panel import Panel
except ImportError as e:
    print(f"❌ 缺少依赖库: {e}")
    print("请运行: pip3 install -r requirements.txt")
    sys.exit(1)

console = Console()


class WebAnalyzer:
    """网页分析器主类"""

    def __init__(self, config_path: str = "config.yaml"):
        """初始化分析器"""
        self.config = self._load_config(config_path)
        self.output_dir = Path(self.config.get('output_dir', './output'))
        self._ensure_output_dirs()

    def _load_config(self, config_path: str) -> Dict:
        """加载配置文件"""
        if os.path.exists(config_path):
            with open(config_path, 'r', encoding='utf-8') as f:
                return yaml.safe_load(f)
        return {}

    def _ensure_output_dirs(self):
        """确保输出目录存在"""
        dirs = [
            self.output_dir / 'screenshots',
            self.output_dir / 'html',
            self.output_dir / 'styles',
            self.output_dir / 'animations',
            self.output_dir / 'components'
        ]
        for dir_path in dirs:
            dir_path.mkdir(parents=True, exist_ok=True)

    async def analyze(self, url: str):
        """分析网页"""
        console.print(Panel(f"🚀 开始分析网页: {url}", style="bold blue"))

        async with async_playwright() as p:
            # 启动浏览器
            browser = await p.chromium.launch(
                headless=self.config.get('advanced', {}).get('headless', True)
            )

            # 创建页面
            page = await browser.new_page(
                viewport={
                    'width': self.config.get('viewport', {}).get('width', 1920),
                    'height': self.config.get('viewport', {}).get('height', 1080)
                }
            )

            try:
                # 访问网页
                console.print(f"📖 正在访问: {url}")
                await page.goto(url, wait_until="networkidle")

                # 等待页面加载
                wait_config = self.config.get('wait_for', {})
                await page.wait_for_timeout(wait_config.get('timeout', 5000))

                # 截图
                if self.config.get('screenshot', {}).get('full_page', True):
                    await self._screenshot_full_page(page)

                # 组件截图
                if self.config.get('screenshot', {}).get('components', True):
                    await self._screenshot_components(page)

                # 提取HTML
                await self._extract_html(page)

                # 提取样式
                if self.config.get('extract_styles', {}).get('colors', True):
                    await self._extract_styles(page)

                # 提取动效
                if self.config.get('animation_analysis', {}).get('extract_transitions', True):
                    await self._extract_animations(page)

                # 生成报告
                await self._generate_report(url, page)

                console.print(Panel("✅ 分析完成!", style="bold green"))

            except Exception as e:
                console.print(f"❌ 分析失败: {e}", style="bold red")
                raise
            finally:
                await browser.close()

    async def _screenshot_full_page(self, page: Page):
        """截取完整页面"""
        console.print("📸 正在截取完整页面...")
        screenshot_path = self.output_dir / 'screenshots' / 'full_page.png'

        await page.screenshot(
            path=str(screenshot_path),
            full_page=True
        )

        console.print(f"✅ 已保存: {screenshot_path}")

    async def _screenshot_components(self, page: Page):
        """截取组件"""
        console.print("📦 正在截取组件...")

        components = self.config.get('component_selectors', [])

        for component in components:
            name = component.get('name', 'unknown')
            selector = component.get('selector')

            if not selector:
                continue

            try:
                # 查找元素
                elements = await page.query_selector_all(selector)

                if not elements:
                    console.print(f"⚠️  未找到组件: {name} ({selector})")
                    continue

                # 截取第一个匹配的元素
                element = elements[0]
                screenshot_path = self.output_dir / 'screenshots' / f'{name}.png'

                await element.screenshot(path=str(screenshot_path))
                console.print(f"✅ 已保存组件: {name}")

            except Exception as e:
                console.print(f"⚠️  组件截图失败 {name}: {e}")

    async def _extract_html(self, page: Page):
        """提取 HTML"""
        console.print("📄 正在提取 HTML...")

        # 完整 HTML
        html_content = await page.content()
        html_path = self.output_dir / 'html' / 'page.html'

        with open(html_path, 'w', encoding='utf-8') as f:
            f.write(html_content)

        console.print(f"✅ 已保存: {html_path}")

        # 组件 HTML
        components = self.config.get('component_selectors', [])

        for component in components:
            name = component.get('name', 'unknown')
            selector = component.get('selector')

            if not selector:
                continue

            try:
                elements = await page.query_selector_all(selector)

                if not elements:
                    continue

                # 获取第一个元素的 HTML
                element_html = await elements[0].inner_html()
                component_html_path = self.output_dir / 'html' / 'components' / f'{name}.html'

                # 确保目录存在
                component_html_path.parent.mkdir(exist_ok=True)

                with open(component_html_path, 'w', encoding='utf-8') as f:
                    f.write(element_html)

                console.print(f"✅ 已保存组件 HTML: {name}")

            except Exception as e:
                console.print(f"⚠️  提取组件 HTML失败 {name}: {e}")

    async def _extract_styles(self, page: Page):
        """提取样式"""
        console.print("🎨 正在提取样式...")

        # 提取颜色
        colors = await page.evaluate("""() => {
            const colors = new Set();
            const allElements = document.querySelectorAll('*');

            allElements.forEach(el => {
                const computed = window.getComputedStyle(el);
                colors.add(computed.color);
                colors.add(computed.backgroundColor);
                colors.add(computed.borderColor);
            });

            return Array.from(colors);
        }""")

        colors_path = self.output_dir / 'styles' / 'colors.json'
        with open(colors_path, 'w', encoding='utf-8') as f:
            json.dump({'colors': colors}, f, indent=2, ensure_ascii=False)

        console.print(f"✅ 已提取 {len(colors)} 种颜色")

        # 提取字体
        fonts = await page.evaluate("""() => {
            const fonts = new Set();
            const allElements = document.querySelectorAll('*');

            allElements.forEach(el => {
                const computed = window.getComputedStyle(el);
                fonts.add(computed.fontFamily);
            });

            return Array.from(fonts);
        }""")

        fonts_path = self.output_dir / 'styles' / 'fonts.json'
        with open(fonts_path, 'w', encoding='utf-8') as f:
            json.dump({'fonts': fonts}, f, indent=2, ensure_ascii=False)

        console.print(f"✅ 已提取 {len(fonts)} 种字体")

    async def _extract_animations(self, page: Page):
        """提取动效"""
        console.print("✨ 正在提取动效...")

        # 提取 CSS 动画
        animations = await page.evaluate("""() => {
            const animations = [];
            const allElements = document.querySelectorAll('*');

            allElements.forEach(el => {
                const computed = window.getComputedStyle(el);
                const transition = computed.transition;
                const animation = computed.animation;

                if (transition && transition !== 'all 0s ease 0s') {
                    animations.push({
                        type: 'transition',
                        selector: el.tagName.toLowerCase(),
                        value: transition
                    });
                }

                if (animation && animation !== 'none 0s ease 0s 1 normal') {
                    animations.push({
                        type: 'animation',
                        selector: el.tagName.toLowerCase(),
                        value: animation
                    });
                }
            });

            return animations;
        }""")

        animations_path = self.output_dir / 'animations' / 'css_animations.json'
        with open(animations_path, 'w', encoding='utf-8') as f:
            json.dump({'animations': animations}, f, indent=2, ensure_ascii=False)

        console.print(f"✅ 已提取 {len(animations)} 个动效")

    async def _generate_report(self, url: str, page: Page):
        """生成分析报告"""
        console.print("📝 正在生成报告...")

        # 获取页面标题
        title = await page.title()

        report_path = self.output_dir / 'report.md'

        with open(report_path, 'w', encoding='utf-8') as f:
            f.write(f"# 网页分析报告\n\n")
            f.write(f"**生成时间**: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n\n")
            f.write(f"**目标网址**: {url}\n\n")
            f.write(f"**页面标题**: {title}\n\n")

            f.write("## 📸 截图\n\n")
            f.write("- `full_page.png` - 完整页面截图\n")
            f.write("- 组件截图位于 `screenshots/` 目录\n\n")

            f.write("## 🎨 样式\n\n")
            f.write("- 颜色方案: `styles/colors.json`\n")
            f.write("- 字体信息: `styles/fonts.json`\n\n")

            f.write("## ✨ 动效\n\n")
            f.write("- CSS 动画和过渡: `animations/css_animations.json`\n\n")

            f.write("## 📄 HTML 结构\n\n")
            f.write("- 完整页面: `html/page.html`\n")
            f.write("- 组件 HTML: `html/components/`\n\n")

            f.write("## 🔧 下一步\n\n")
            f.write("1. 查看截图了解页面布局\n")
            f.write("2. 分析 HTML 结构理解组件层级\n")
            f.write("3. 根据样式文件提取颜色和字体\n")
            f.write("4. 参考动效文件实现 Flutter 动画\n\n")

        console.print(f"✅ 已生成报告: {report_path}")


async def main():
    """主函数"""
    import argparse

    parser = argparse.ArgumentParser(description='Web 网页分析工具')
    parser.add_argument('--url', required=True, help='目标网页 URL')
    parser.add_argument('--config', default='config.yaml', help='配置文件路径')
    parser.add_argument('--output', help='输出目录（覆盖配置文件）')

    args = parser.parse_args()

    # 创建分析器
    analyzer = WebAnalyzer(config_path=args.config)

    # 覆盖输出目录
    if args.output:
        analyzer.output_dir = Path(args.output)
        analyzer._ensure_output_dirs()

    # 开始分析
    await analyzer.analyze(args.url)


if __name__ == '__main__':
    asyncio.run(main())
