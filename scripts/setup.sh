#!/bin/bash

# Flutter Web 官网 - 项目设置脚本
# 用于快速设置开发环境

set -e  # 遇到错误立即退出

echo "🚀 Flutter Web 官网 - 项目设置"
echo "================================"
echo ""

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 打印带颜色的消息
print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_info() {
    echo -e "ℹ️  $1"
}

# 检查Flutter是否安装
check_flutter() {
    print_info "检查Flutter安装..."

    if ! command -v flutter &> /dev/null; then
        print_error "Flutter未安装,请先安装Flutter SDK"
        echo "访问 https://flutter.dev/docs/get-started/install 获取安装指南"
        exit 1
    fi

    print_success "Flutter已安装"

    # 显示Flutter版本
    flutter --version
    echo ""
}

# 检查Flutter环境
check_flutter_environment() {
    print_info "检查Flutter环境..."
    flutter doctor

    if [ $? -ne 0 ]; then
        print_warning "Flutter环境存在一些问题,请查看上方详细信息"
    else
        print_success "Flutter环境检查通过"
    fi
    echo ""
}

# 清理项目
clean_project() {
    print_info "清理项目..."
    flutter clean
    print_success "项目清理完成"
    echo ""
}

# 获取依赖
install_dependencies() {
    print_info "获取依赖包..."
    flutter pub get

    if [ $? -eq 0 ]; then
        print_success "依赖安装完成"
    else
        print_error "依赖安装失败"
        exit 1
    fi
    echo ""
}

# 运行代码生成
run_code_generation() {
    print_info "运行代码生成..."
    print_warning "这可能需要几分钟时间..."

    # 检查是否需要代码生成
    if grep -q "build_runner" pubspec.yaml; then
        flutter pub run build_runner build --delete-conflicting-outputs

        if [ $? -eq 0 ]; then
            print_success "代码生成完成"
        else
            print_warning "代码生成失败或跳过(如果没有需要生成的代码)"
        fi
    else
        print_info "未配置代码生成,跳过此步骤"
    fi
    echo ""
}

# 创建必要的目录
create_directories() {
    print_info "创建项目目录结构..."

    directories=(
        "lib/core/config"
        "lib/core/constants"
        "lib/core/error"
        "lib/core/network"
        "lib/core/utils"
        "lib/domain/entities"
        "lib/domain/repositories"
        "lib/data/models"
        "lib/data/datasources/remote"
        "lib/data/datasources/local"
        "lib/data/repositories"
        "lib/application/blocs"
        "lib/presentation/pages"
        "lib/presentation/widgets"
        "lib/presentation/animations"
        "lib/presentation/theme"
        "lib/presentation/routes"
        "test/unit"
        "test/widget"
        "test/integration"
        "assets/images"
        "assets/animations"
        "assets/fonts"
    )

    for dir in "${directories[@]}"; do
        mkdir -p "$dir"
    done

    print_success "目录结构创建完成"
    echo ""
}

# 运行测试
run_tests() {
    print_info "运行测试..."
    flutter test

    if [ $? -eq 0 ]; then
        print_success "所有测试通过"
    else
        print_warning "部分测试失败,请检查"
    fi
    echo ""
}

# 分析代码
analyze_code() {
    print_info "分析代码..."
    flutter analyze

    if [ $? -eq 0 ]; then
        print_success "代码分析通过"
    else
        print_warning "代码分析发现问题,请查看上方详细信息"
    fi
    echo ""
}

# 格式化代码
format_code() {
    print_info "格式化代码..."
    flutter format .
    print_success "代码格式化完成"
    echo ""
}

# 主函数
main() {
    # 检查参数
    SKIP_TESTS=false
    SKIP_ANALYSIS=false

    while [[ "$#" -gt 0 ]]; do
        case $1 in
            --skip-tests) SKIP_TESTS=true ;;
            --skip-analysis) SKIP_ANALYSIS=true ;;
            *) echo "未知参数: $1"; exit 1 ;;
        esac
        shift
    done

    # 执行设置步骤
    check_flutter
    check_flutter_environment
    clean_project
    install_dependencies
    create_directories
    run_code_generation

    # 可选步骤
    if [ "$SKIP_TESTS" = false ]; then
        run_tests
    fi

    if [ "$SKIP_ANALYSIS" = false ]; then
        analyze_code
    fi

    format_code

    # 完成信息
    echo ""
    echo "================================"
    print_success "项目设置完成! 🎉"
    echo ""
    echo "下一步操作:"
    echo "  运行开发服务器: flutter run -d chrome"
    echo "  构建生产版本:   flutter build web --release"
    echo ""
    echo "文档:"
    echo "  架构手册: docs/ARCHITECTURE.md"
    echo "  开发指南: docs/DEVELOPMENT.md"
    echo "  项目路线图: docs/PROJECT_ROADMAP.md"
    echo "================================"
}

# 运行主函数
main "$@"
