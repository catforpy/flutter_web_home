#!/bin/bash

# 使用 Node.js http-server 启动服务器（推荐）
# 性能更好，支持 CORS

PORT=${1:-3000}

echo "🌐 启动 HTTP 服务器 (Node.js http-server)..."
echo "📍 地址: http://192.168.2.14:$PORT"
echo "📂 目录: build/web"
echo ""
echo "💡 按 Ctrl+C 停止服务器"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 检查是否安装了 Node.js
if command -v npx &> /dev/null; then
  echo "✅ 使用 Node.js http-server"
  cd build/web && npx http-server . -p $PORT --cors -a 192.168.2.14
else
  echo "❌ 未找到 Node.js 或 npx"
  echo ""
  echo "请先安装 Node.js:"
  echo "  brew install node    # macOS"
  echo "  sudo apt install nodejs npm  # Ubuntu/Debian"
  echo ""
  echo "或者使用 Python 服务器:"
  echo "  ./start_server.sh $PORT"
  echo ""
  exit 1
fi
