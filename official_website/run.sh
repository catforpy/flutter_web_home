#!/bin/bash

echo "🚀 启动 Flutter Web 官网..."
echo ""

# 进入项目目录
cd "$(dirname "$0")"

# 检查Flutter是否安装
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter未安装，请先安装Flutter SDK"
    exit 1
fi

echo "✅ Flutter已安装"
echo ""

# 显示Flutter版本
echo "📌 Flutter版本："
flutter --version | head -3
echo ""

# 启动应用
echo "🚀 正在启动应用..."
echo "📱 浏览器地址: http://localhost:8080"
echo ""
echo "💡 提示："
echo "   - 按 'r' 键进行热重载"
echo "   - 按 'R' 键进行热重启"
echo "   - 按 'q' 键退出"
echo ""
echo "⏳ 请稍候，应用正在启动..."
echo ""

flutter run -d chrome --web-port 8080
