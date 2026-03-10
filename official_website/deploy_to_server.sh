#!/bin/bash

echo "==================================="
echo "   部署 Flutter Web 到服务器"
echo "==================================="
echo ""

# 进入项目目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# 服务器配置
SERVER_HOST="192.168.2.14"
SERVER_PORT="8080"
SERVER_USER="root"
SERVER_DIR="/var/www/html/official_website"  # 部署到服务器的目录

echo "📋 服务器信息："
echo "   主机：$SERVER_USER@$SERVER_HOST"
echo "   端口：$SERVER_PORT"
echo "   目录：$SERVER_DIR"
echo ""

# 1. 检查构建文件是否存在
echo "📦 步骤 1: 检查构建文件..."
if [ ! -d "build/web" ]; then
    echo "❌ 构建文件不存在！请先运行：flutter build web --release"
    exit 1
fi
echo "✅ 构建文件存在"
echo ""

# 2. 检查SSH连接
echo "🔌 步骤 2: 检查SSH连接..."
if ! ssh -o ConnectTimeout=5 ${SERVER_USER}@${SERVER_HOST} "echo 'SSH连接成功'" 2>/dev/null; then
    echo "❌ 无法连接到服务器 $SERVER_HOST"
    echo "请确保："
    echo "  1. 服务器IP地址正确"
    echo "  2. SSH服务已启动"
    echo "  3. 已配置SSH密钥或密码认证"
    exit 1
fi
echo "✅ SSH连接正常"
echo ""

# 3. 在服务器上创建目录
echo "📁 步骤 3: 创建服务器目录..."
ssh ${SERVER_USER}@${SERVER_HOST} "mkdir -p $SERVER_DIR"
echo "✅ 目录创建完成"
echo ""

# 4. 上传文件到服务器
echo "📤 步骤 4: 上传文件到服务器..."
echo "正在上传 build/web/* -> $SERVER_HOST:$SERVER_DIR"
rsync -avz --delete \
    -e "ssh -o StrictHostKeyChecking=no" \
    build/web/ \
    ${SERVER_USER}@${SERVER_HOST}:${SERVER_DIR}/

if [ $? -eq 0 ]; then
    echo "✅ 文件上传成功"
else
    echo "❌ 文件上传失败"
    exit 1
fi
echo ""

# 5. 停止服务器上旧的8080端口服务
echo "🛑 步骤 5: 停止旧的服务..."
ssh ${SERVER_USER}@${SERVER_HOST} "pkill -f 'python.*http.server.*8080' 2>/dev/null; lsof -ti :8080 | xargs kill -9 2>/dev/null; echo '旧服务已停止'"
echo ""

# 6. 在服务器上启动HTTP服务器
echo "🚀 步骤 6: 在服务器上启动HTTP服务器..."
ssh ${SERVER_USER}@${SERVER_HOST} << EOF
cd $SERVER_DIR
nohup python3 -m http.server 8080 > /dev/null 2>&1 &
echo "服务器PID: \$!"
sleep 2

# 检查服务是否启动成功
if lsof -i :8080 > /dev/null 2>&1; then
    echo "✅ 服务器启动成功"
else
    echo "❌ 服务器启动失败"
    exit 1
fi
EOF

if [ $? -eq 0 ]; then
    echo ""
    echo "==================================="
    echo "   🎉 部署完成！"
    echo "==================================="
    echo ""
    echo "📍 访问地址："
    echo "   http://$SERVER_HOST:$SERVER_PORT"
    echo "   http://localhost:$SERVER_PORT (在服务器本机)"
    echo ""
    echo "💡 管理命令："
    echo "   查看服务状态: lsof -i :8080"
    echo "   停止服务: pkill -f 'python.*http.server.*8080'"
    echo ""
    echo "==================================="
else
    echo "❌ 部署失败"
    exit 1
fi
