#!/bin/bash

# Flutter Web 项目部署脚本
# 部署到本地服务器 192.168.2.14:3000

echo "=========================================="
echo " Flutter Web 项目部署工具"
echo "=========================================="
echo ""

# 项目目录
PROJECT_DIR="/Volumes/DudaDate/微信小程序开发/flutter官网开发/official_website"

# 检查构建目录
if [ ! -d "$PROJECT_DIR/build/web" ]; then
  echo "❌ 错误: 构建目录不存在！"
  echo "请先运行: flutter build web --release"
  exit 1
fi

echo "✅ 找到构建目录: build/web"
echo ""

# 进入构建目录
cd "$PROJECT_DIR/build/web"

echo "🚀 启动Web服务器..."
echo "   访问地址: http://192.168.2.14:3000"
echo "   本地地址: http://localhost:3000"
echo ""
echo "按 Ctrl+C 停止服务器"
echo "=========================================="
echo ""

# 启动Python HTTP服务器
# 监听所有网络接口(0.0.0.0)的3000端口
python3 -m http.server 3000 --bind 0.0.0.0
