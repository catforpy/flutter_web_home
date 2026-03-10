#!/bin/bash
# 快速测试脚本 - 安装完成后立即运行

echo "🚀 开始测试网页分析工具..."

cd "/Volumes/DudaDate/微信小程序开发/flutter官网开发/tools/web_analyzer"

# 1. 检查 Python 依赖
echo ""
echo "📦 检查 Python 依赖..."
python3 -c "
import sys
try:
    import playwright
    print(f'✅ playwright {playwright.__version__}')
except ImportError:
    print('❌ playwright 未安装')
    sys.exit(1)

try:
    import bs4
    print(f'✅ beautifulsoup4 已安装')
except ImportError:
    print('❌ beautifulsoup4 未安装')
    sys.exit(1)
"

if [ $? -ne 0 ]; then
    echo "❌ 依赖检查失败"
    exit 1
fi

# 2. 安装 Playwright 浏览器（如果还没安装）
echo ""
echo "🌐 检查 Playwright 浏览器..."
if ! playwright install chromium 2>/dev/null; then
    echo "⚠️  需要安装 Chromium 浏览器"
    echo "这可能需要几分钟时间..."
    playwright install chromium
fi

# 3. 运行快速测试
echo ""
echo "🧪 运行快速测试..."
python3 simple_crawler.py \
    --url "https://www.junhesoftware.online/xcx/serve" \
    --output "./output/test_run"

# 4. 检查输出
echo ""
echo "📊 检查输出文件..."
if [ -f "./output/test_run/screenshots/full_page.png" ]; then
    echo "✅ 截图生成成功"
    ls -lh "./output/test_run/screenshots/full_page.png"
else
    echo "❌ 截图未生成"
fi

if [ -f "./output/test_run/styles/analysis.json" ]; then
    echo "✅ 分析数据生成成功"
    echo "提取的颜色数量:"
    python3 -c "import json; data=json.load(open('./output/test_run/styles/analysis.json')); print(f'  {len(data[\"colors\"])} 种颜色')"
else
    echo "❌ 分析数据未生成"
fi

if [ -f "./output/test_run/report.md" ]; then
    echo "✅ 报告生成成功"
    echo ""
    echo "=== 报告预览 ==="
    head -30 "./output/test_run/report.md"
fi

echo ""
echo "🎉 测试完成！"
echo "📁 完整输出目录: $(pwd)/output/test_run"
