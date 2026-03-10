#!/bin/bash

echo "🚀 Flutter Web 官网 - 推送到GitHub"
echo "================================"
echo ""

# 保存当前目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "当前仓库: $SCRIPT_DIR"
echo ""

# 检查当前状态
echo "📋 当前Git状态:"
git remote -v
echo ""
git branch
echo ""

echo "📝 最新提交:"
git log --oneline -1
echo ""

echo "================================"
echo "选择推送方式:"
echo ""
echo "1. 使用 GitHub Desktop (推荐新手)"
echo "2. 使用 GitHub CLI"
echo "3. 使用 SSH 密钥"
echo "4. 使用 Personal Access Token"
echo "5. 手动推送 (已有凭证)"
echo ""
read -p "请选择 (1-5): " choice

case $choice in
  1)
    echo ""
    echo "📱 使用 GitHub Desktop"
    echo "-------------------"
    echo "1. 下载 GitHub Desktop:"
    echo "   https://desktop.github.com/"
    echo ""
    echo "2. 安装并登录"
    echo ""
    echo "3. 添加本地仓库:"
    echo "   File → Add Local Repository"
    echo "   选择: $SCRIPT_DIR"
    echo ""
    echo "4. 点击 'Publish repository'"
    echo ""
    ;;

  2)
    echo ""
    echo "🔧 使用 GitHub CLI"
    echo "-------------------"
    echo ""

    # 检查是否安装gh
    if ! command -v gh &> /dev/null; then
      echo "⚠️  GitHub CLI 未安装"
      echo ""
      echo "安装命令:"
      echo "  brew install gh"
      echo ""
      echo "安装后运行:"
      echo "  gh auth login"
      echo "  git push -u origin main"
    else
      echo "✅ GitHub CLI 已安装"
      echo ""
      echo "执行以下命令:"
      echo ""
      echo "  1. 登录: gh auth login"
      echo "  2. 推送: git push -u origin main"
    fi
    echo ""
    ;;

  3)
    echo ""
    echo "🔑 使用 SSH 密钥"
    echo "-------------------"
    echo ""
    echo "1. 生成SSH密钥:"
    echo "   ssh-keygen -t ed25519 -C \"your_email@example.com\""
    echo ""
    echo "2. 复制公钥:"
    echo "   cat ~/.ssh/id_ed25519.pub"
    echo ""
    echo "3. 添加到GitHub:"
    echo "   https://github.com/settings/keys"
    echo ""
    echo "4. 修改远程仓库地址:"
    echo "   git remote set-url origin git@github.com:catforpy/Web_business_home.git"
    echo ""
    echo "5. 推送:"
    echo "   git push -u origin main"
    echo ""
    ;;

  4)
    echo ""
    echo "🎫 使用 Personal Access Token"
    echo "------------------------------"
    echo ""
    echo "1. 创建Token:"
    echo "   https://github.com/settings/tokens"
    echo "   点击 'Generate new token (classic)'"
    echo "   勾选 'repo' 权限"
    echo "   复制生成的token"
    echo ""
    echo "2. 推送时会提示输入:"
    echo "   Username: catforpy"
    echo "   Password: <粘贴token>"
    echo ""
    echo "3. 执行推送:"
    echo "   git push -u origin main"
    echo ""
    ;;

  5)
    echo ""
    echo "⚡ 手动推送"
    echo "----------"
    echo ""
    echo "如果已配置好凭证，直接执行:"
    echo ""
    echo "  git push -u origin main"
    echo ""
    echo "如果提示输入密码:"
    echo "  Username: catforpy"
    echo "  Password: <输入GitHub密码或Token>"
    echo ""
    ;;

  *)
    echo ""
    echo "❌ 无效选择"
    exit 1
    ;;
esac

echo ""
echo "================================"
echo "✅ 详细指南请查看:"
echo "   - 快速推送GitHub.md"
echo "   - GIT操作指南.md"
echo "================================"
