#!/bin/bash

# 启动本地 HTTP 服务器
# 用于在部署前测试或作为简单部署方案

PORT=${1:-3000}

echo "🌐 启动 HTTP 服务器..."
echo "📍 地址: http://192.168.2.14:$PORT"
echo "📂 目录: build/web"
echo ""
echo "💡 按 Ctrl+C 停止服务器"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 检查是否安装了 Python
if command -v python3 &> /dev/null; then
  echo "✅ 使用 Python3 HTTP 服务器"
  cd build/web && python3 -m http.server $PORT --bind 192.168.2.14
elif command -v python &> /dev/null; then
  echo "✅ 使用 Python HTTP 服务器"
  cd build/web && python -m SimpleHTTPServer $PORT
else
  echo "❌ 未找到 Python"
  echo ""
  echo "请安装 Python 或使用以下方法之一："
  echo ""
  echo "方法 1: 使用 Node.js http-server"
  echo "  npx http-server build/web -p $PORT --cors"
  echo ""
  echo "方法 2: 使用 Node.js serve"
  echo "  npx serve build/web -p $PORT"
  echo ""
  echo "方法 3: 使用 Nginx"
  echo "  sudo apt install nginx"
  echo "  sudo cp -r build/web/* /var/www/html/"
  echo ""
  exit 1
fi
