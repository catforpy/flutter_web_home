#!/bin/bash

# Flutter Web 内网服务器部署脚本
# 部署到 192.168.2.14:3000

echo "🚀 开始构建 Flutter Web (内网环境)..."

# 清理之前的构建
echo "📦 清理旧的构建文件..."
rm -rf build/web

# 构建生产版本（使用 staging 环境）
echo "🔨 正在构建..."
flutter build web \
  --dart-define=ENV=staging \
  --dart-define=API_BASE_URL=http://192.168.2.14:8080/api \
  --release

if [ $? -eq 0 ]; then
  echo "✅ 构建成功！"
  echo "📂 构建文件位置: build/web/"
  echo ""
  echo "🌐 下一步操作："
  echo "   1. 将 build/web/ 目录的内容复制到服务器"
  echo "   2. 在服务器上运行启动脚本"
  echo ""
  echo "💡 或者使用以下命令直接启动本地测试服务器："
  echo "   ./start_server.sh"
else
  echo "❌ 构建失败！"
  exit 1
fi
