#!/usr/bin/env python3
"""
HTTP 网页分析工具 - 无需浏览器，立即可用
基于 requests + beautifulsoup4

用法：
    python3 http_analyzer.py --url "https://www.junhesoftware.online/xcx/serve"
"""

import argparse
import json
import sys
from pathlib import Path
from datetime import datetime
from urllib.parse import urljoin

try:
    import requests
    from bs4 import BeautifulSoup
except ImportError as e:
    print(f"❌ 缺少依赖: {e}")
    print("请运行: pip3 install requests beautifulsoup4")
    sys.exit(1)


class HTTPWebAnalyzer:
    """基于 HTTP 的网页分析器"""

    def __init__(self, output_dir: str = "./output"):
        self.output_dir = Path(output_dir)
        self._ensure_dirs()

    def _ensure_dirs(self):
        """创建输出目录"""
        (self.output_dir / 'html').mkdir(parents=True, exist_ok=True)
        (self.output_dir / 'styles').mkdir(parents=True, exist_ok=True)
        (self.output_dir / 'components').mkdir(parents=True, exist_ok=True)

    def analyze(self, url: str):
        """分析网页"""
        print(f"\n🚀 开始分析: {url}\n")

        try:
            # 1. 获取网页
            print("📖 正在获取网页...")
            headers = {
                'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36'
            }
            response = requests.get(url, headers=headers, timeout=15)
            response.raise_for_status()
            response.encoding = response.apparent_encoding

            print(f"✅ 状态码: {response.status_code}")
            print(f"✅ 内容大小: {len(response.text)} 字节\n")

            # 2. 解析 HTML
            print("🔍 正在解析 HTML...")
            soup = BeautifulSoup(response.text, 'html.parser')

            # 3. 提取信息
            print("📊 正在分析页面结构...")
            data = self._extract_data(url, soup, response)

            # 4. 保存结果
            print("💾 正在保存结果...")
            self._save_results(data, url, soup)

            print(f"\n✅ 分析完成！")
            print(f"📁 输出目录: {self.output_dir.absolute()}\n")

            # 5. 显示摘要
            self._show_summary(data)

        except requests.RequestException as e:
            print(f"\n❌ 网络请求失败: {e}\n")
            sys.exit(1)
        except Exception as e:
            print(f"\n❌ 分析失败: {e}\n")
            raise

    def _extract_data(self, url, soup, response):
        """提取页面数据"""
        data = {
            'url': url,
            'timestamp': datetime.now().isoformat(),
            'status_code': response.status_code,
            'meta': self._extract_meta(soup),
            'structure': self._extract_structure(soup),
            'content': self._extract_content(soup),
            'styles': self._extract_styles(soup),
            'components': self._identify_components(soup),
            'images': self._extract_images(soup, url),
            'links': self._extract_links(soup, url)
        }
        return data

    def _extract_meta(self, soup):
        """提取元数据"""
        return {
            'title': soup.title.string if soup.title else '',
            'description': soup.find('meta', attrs={'name': 'description'}) or {},
            'keywords': soup.find('meta', attrs={'name': 'keywords'}) or {},
        }

    def _extract_structure(self, soup):
        """提取页面结构"""
        return {
            'headings': {
                'h1': [h.get_text(strip=True) for h in soup.find_all('h1')],
                'h2': [h.get_text(strip=True) for h in soup.find_all('h2')],
                'h3': [h.get_text(strip=True) for h in soup.find_all('h3')][:10],
            },
            'sections': len(soup.find_all('section')),
            'divs': len(soup.find_all('div')),
            'forms': len(soup.find_all('form')),
        }

    def _extract_content(self, soup):
        """提取内容"""
        return {
            'buttons': [btn.get_text(strip=True) for btn in soup.find_all(['button', 'a'], class_=lambda x: x and ('btn' in str(x).lower() or 'button' in str(x).lower()))],
            'paragraphs': [p.get_text(strip=True) for p in soup.find_all('p')[:5]],
            'lists': len(soup.find_all(['ul', 'ol'])),
        }

    def _extract_styles(self, soup):
        """提取样式信息"""
        # 提取内联样式中的颜色
        colors = set()
        for elem in soup.find_all(style=True):
            style = elem.get('style', '')
            if 'color' in style.lower():
                colors.add(style)

        return {
            'inline_styles_count': len(soup.find_all(style=True)),
            'color_samples': list(colors)[:10],
        }

    def _identify_components(self, soup):
        """识别页面组件"""
        components = {
            'navbar': soup.find('nav') is not None or soup.find(class_=lambda x: x and 'nav' in str(x).lower()) is not None,
            'hero': soup.find(class_=lambda x: x and any(k in str(x).lower() for k in ['hero', 'banner', 'header'])) is not None,
            'cards': soup.find_all(class_=lambda x: x and 'card' in str(x).lower()),
            'footer': soup.find('footer') is not None,
        }
        components['card_count'] = len(components['cards'])
        return components

    def _extract_images(self, soup, base_url):
        """提取图片"""
        images = []
        for img in soup.find_all('img')[:20]:
            src = img.get('src', '') or img.get('data-src', '')
            if src:
                images.append({
                    'src': urljoin(base_url, src),
                    'alt': img.get('alt', ''),
                })
        return images

    def _extract_links(self, soup, base_url):
        """提取链接"""
        links = []
        for a in soup.find_all('a', href=True)[:20]:
            href = a['href']
            text = a.get_text(strip=True)
            if text:
                links.append({
                    'url': urljoin(base_url, href),
                    'text': text[:50],
                })
        return links

    def _save_results(self, data, url, soup):
        """保存结果"""
        # 保存 JSON
        with open(self.output_dir / 'styles' / 'analysis.json', 'w', encoding='utf-8') as f:
            json.dump(data, f, indent=2, ensure_ascii=False)

        # 保存 HTML
        with open(self.output_dir / 'html' / 'page.html', 'w', encoding='utf-8') as f:
            f.write(soup.prettify())

        # 生成组件方案
        self._generate_component_design(data)

        # 生成报告
        self._generate_report(data, url)

    def _generate_component_design(self, data):
        """生成组件设计方案"""
        design = """# Flutter 组件设计方案

## 页面组件识别

根据网页分析，建议实现以下组件：

### 1. 核心组件

"""

        # 导航栏
        if data['components'].get('navbar'):
            design += """
#### AppNavBar
- 位置：页面顶部
- 功能：导航链接
- 实现建议：`PreferredSizeWidget` + `AppBar`
"""

        # Hero区域
        if data['components'].get('hero'):
            design += """
#### HeroBannerWidget
- 位置：页面顶部主横幅
- 内容：主标题 + 副标题
- 实现建议：`Container` + `Column`
"""

        # 卡片
        if data['components']['card_count'] > 0:
            design += f"""
#### ServiceCardWidget
- 数量：{data['components']['card_count']} 个
- 位置：内容区域
- 实现建议：`Card` + `Column` + `Icon`
"""

        # 页脚
        if data['components'].get('footer'):
            design += """
#### FooterWidget
- 位置：页面底部
- 内容：版权信息、链接
- 实现建议：`Container` + `Wrap`
"""

        with open(self.output_dir / 'components' / 'design.md', 'w', encoding='utf-8') as f:
            f.write(design)

    def _generate_report(self, data, url):
        """生成分析报告"""
        report = f"""# 网页分析报告

**网址**: {url}
**时间**: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}
**状态码**: {data['status_code']}

## 📊 页面概览

### 元信息
- **标题**: {data['meta']['title']}
- **描述**: {data['meta'].get('description', {}).get('content', 'N/A')}

### 页面结构
- **H1 标题**: {len(data['structure']['headings']['h1'])} 个
  {chr(10).join(f"  - {h}" for h in data['structure']['headings']['h1'][:3])}
- **H2 标题**: {len(data['structure']['headings']['h2'])} 个
  {chr(10).join(f"  - {h}" for h in data['structure']['headings']['h2'][:5])}
- **H3 标题**: {len(data['structure']['headings']['h3'])} 个
- **Section 数量**: {data['structure']['sections']}
- **表单数量**: {data['structure']['forms']}

### 组件识别
- **导航栏**: {'✅' if data['components']['navbar'] else '❌'}
- **Hero 区域**: {'✅' if data['components']['hero'] else '❌'}
- **卡片数量**: {data['components']['card_count']}
- **页脚**: {'✅' if data['components']['footer'] else '❌'}

### 内容元素
- **按钮数量**: {len(data['content']['buttons'])}
  {chr(10).join(f"  - {btn}" for btn in data['content']['buttons'][:5])}
- **段落数量**: {len(data['content']['paragraphs'])}
- **列表数量**: {data['content']['lists']}

### 资源
- **图片数量**: {len(data['images'])}
- **链接数量**: {len(data['links'])}

## 💡 下一步建议

1. **查看 HTML 结构**: `html/page.html`
2. **组件设计方案**: `components/design.md`
3. **完整分析数据**: `styles/analysis.json`

## 🎨 Flutter 实现建议

基于分析结果，建议创建以下组件结构：

```
lib/presentation/widgets/
├── common/
│   ├── app_nav_bar.dart
│   └── footer_widget.dart
├── home/
│   ├── hero_banner_widget.dart
│   └── service_card_widget.dart
└── layouts/
    └── page_container.dart
```

---

*本报告由 HTTP 网页分析工具生成*
"""

        with open(self.output_dir / 'report.md', 'w', encoding='utf-8') as f:
            f.write(report)

    def _show_summary(self, data):
        """显示分析摘要"""
        print("📋 分析摘要:")
        print(f"  标题: {data['meta']['title'][:60]}...")
        print(f"  H1: {len(data['structure']['headings']['h1'])} | H2: {len(data['structure']['headings']['h2'])} | H3: {len(data['structure']['headings']['h3'])}")
        print(f"  组件: 导航栏{'✅' if data['components']['navbar'] else '❌'} | Hero{'✅' if data['components']['hero'] else '❌'} | 卡片{data['components']['card_count']}个")
        print(f"  资源: 图片{len(data['images'])} | 链接{len(data['links'])}")
        print()


def main():
    """主函数"""
    parser = argparse.ArgumentParser(description='HTTP 网页分析工具')
    parser.add_argument('--url', required=True, help='目标网页 URL')
    parser.add_argument('--output', default='./output', help='输出目录')

    args = parser.parse_args()

    analyzer = HTTPWebAnalyzer(output_dir=args.output)
    analyzer.analyze(args.url)


if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        print("\n\n⚠️  用户中断")
        sys.exit(0)
