#!/bin/bash

# 部署 Flutter Web 到局域网服务器
# 支持自定义端口（默认 3000）

PORT=${1:-3000}  # 默认端口 3000，可以通过参数修改

echo "==================================="
echo "   部署 Flutter Web 到局域网服务器"
echo "==================================="
echo ""

# 进入项目目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# 服务器配置
SERVER_HOST="192.168.2.14"
SERVER_USER="root"
SERVER_DIR="/var/www/html/official_website"  # 部署到服务器的目录
WEB_SERVER_PORT=$PORT

echo "📋 服务器信息："
echo "   主机：$SERVER_USER@$SERVER_HOST"
echo "   Web服务端口：$WEB_SERVER_PORT"
echo "   目录：$SERVER_DIR"
echo ""

# 1. 检查构建文件是否存在
echo "📦 步骤 1: 检查构建文件..."
if [ ! -d "build/web" ]; then
    echo "❌ 构建文件不存在！"
    echo "正在构建..."
    flutter build web \
      --dart-define=ENV=staging \
      --dart-define=API_BASE_URL=http://192.168.2.14:8080/api \
      --release
    
    if [ $? -ne 0 ]; then
      echo "❌ 构建失败！"
      exit 1
    fi
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
    echo ""
    echo "💡 如果是本机部署，可以跳过此步骤，直接运行："
    echo "   ./start_server_node.sh $WEB_SERVER_PORT"
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

# 5. 停止服务器上旧的服务
echo "🛑 步骤 5: 停止旧的Web服务..."
ssh ${SERVER_USER}@${SERVER_HOST} "pkill -f 'python.*http.server.*$WEB_SERVER_PORT' 2>/dev/null; lsof -ti :$WEB_SERVER_PORT | xargs kill -9 2>/dev/null; echo '旧服务已停止'"
echo ""

# 6. 在服务器上启动HTTP服务器
echo "🚀 步骤 6: 在服务器上启动HTTP服务器 (端口 $WEB_SERVER_PORT)..."
ssh ${SERVER_USER}@${SERVER_HOST} << EOF
cd $SERVER_DIR
nohup python3 -m http.server $WEB_SERVER_PORT > /tmp/web_server.log 2>&1 &
SERVER_PID=\$!
echo "服务器PID: \$SERVER_PID"
sleep 2

# 检查服务是否启动成功
if lsof -i :$WEB_SERVER_PORT > /dev/null 2>&1; then
    echo "✅ 服务器启动成功 (端口 $WEB_SERVER_PORT)"
    echo "📝 日志文件: /tmp/web_server.log"
else
    echo "❌ 服务器启动失败"
    echo "💡 请检查日志: tail -f /tmp/web_server.log"
    exit 1
fi
