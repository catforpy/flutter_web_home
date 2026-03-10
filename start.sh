#!/bin/bash

# 进入项目目录
cd "/Volumes/DudaDate/微信小程序开发/flutter官网开发/official_website"

echo "==================================="
echo "   Flutter Web 本地部署启动脚本"
echo "==================================="
echo ""

# 1. 清理旧的构建
echo "📦 步骤 1: 清理旧的构建文件..."
flutter clean

# 2. 构建 Web 生产版本
echo ""
echo "🔨 步骤 2: 构建 Web 生产版本..."
flutter build web --release

# 3. 检查构建是否成功
if [ ! -d "build/web" ]; then
    echo "❌ 构建失败！请检查错误信息。"
    exit 1
fi

echo "✅ 构建成功！"

# 4. 停止旧的 Python 服务器（如果有）
echo ""
echo "🛑 步骤 3: 停止旧的服务器..."
pkill -f "python.*http.server.*8080" 2>/dev/null
sleep 2

# 5. 启动 Python HTTP 服务器
echo ""
echo "🚀 步骤 4: 启动 HTTP 服务器..."
cd build/web
python3 -m http.server 8080 &
SERVER_PID=$!

# 等待服务器启动
sleep 3

# 6. 检查服务器是否启动成功
if lsof -i :8080 > /dev/null 2>&1; then
    echo "✅ 服务器启动成功！"
    echo ""
    echo "==================================="
    echo "   🎉 部署完成！"
    echo "==================================="
    echo ""
    echo "📍 本地访问地址："
    echo "   http://localhost:8080"
    echo "   http://127.0.0.1:8080"
    echo ""
    echo "📍 局域网访问地址："
    echo "   http://192.168.2.14:8080"
    echo "   （请将 192.168.2.14 替换为你的实际 IP 地址）"
    echo ""
    echo "💡 提示：按 Ctrl+C 停止服务器"
    echo ""
    echo "==================================="
    
    # 自动打开浏览器
    open http://localhost:8080
    
    # 等待用户输入
    echo "按任意键停止服务器..."
    read -n 1
    
    # 停止服务器
    echo ""
    echo "🛑 正在停止服务器..."
    kill $SERVER_PID 2>/dev/null
    pkill -f "python.*http.server.*8080" 2>/dev/null
    echo "✅ 服务器已停止"
else
    echo "❌ 服务器启动失败！"
    exit 1
fi
