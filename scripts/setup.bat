@echo off
REM Flutter Web 官网 - 项目设置脚本 (Windows)
REM 用于快速设置开发环境

echo ================================================
echo   Flutter Web 官网 - 项目设置
echo ================================================
echo.

REM 检查Flutter是否安装
echo [1/7] 检查Flutter安装...
where flutter >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo [错误] Flutter未安装,请先安装Flutter SDK
    echo 访问 https://flutter.dev/docs/get-started/install 获取安装指南
    pause
    exit /b 1
)
echo [完成] Flutter已安装
flutter --version
echo.

REM 检查Flutter环境
echo [2/7] 检查Flutter环境...
flutter doctor
echo.

REM 清理项目
echo [3/7] 清理项目...
flutter clean
echo [完成] 项目清理完成
echo.

REM 获取依赖
echo [4/7] 获取依赖包...
flutter pub get
if %ERRORLEVEL% neq 0 (
    echo [错误] 依赖安装失败
    pause
    exit /b 1
)
echo [完成] 依赖安装完成
echo.

REM 创建必要的目录
echo [5/7] 创建项目目录结构...

if not exist "lib\core\config" mkdir "lib\core\config"
if not exist "lib\core\constants" mkdir "lib\core\constants"
if not exist "lib\core\error" mkdir "lib\core\error"
if not exist "lib\core\network" mkdir "lib\core\network"
if not exist "lib\core\utils" mkdir "lib\core\utils"

if not exist "lib\domain\entities" mkdir "lib\domain\entities"
if not exist "lib\domain\repositories" mkdir "lib\domain\repositories"

if not exist "lib\data\models" mkdir "lib\data\models"
if not exist "lib\data\datasources\remote" mkdir "lib\data\datasources\remote"
if not exist "lib\data\datasources\local" mkdir "lib\data\datasources\local"
if not exist "lib\data\repositories" mkdir "lib\data\repositories"

if not exist "lib\application\blocs" mkdir "lib\application\blocs"

if not exist "lib\presentation\pages" mkdir "lib\presentation\pages"
if not exist "lib\presentation\widgets" mkdir "lib\presentation\widgets"
if not exist "lib\presentation\animations" mkdir "lib\presentation\animations"
if not exist "lib\presentation\theme" mkdir "lib\presentation\theme"
if not exist "lib\presentation\routes" mkdir "lib\presentation\routes"

if not exist "test\unit" mkdir "test\unit"
if not exist "test\widget" mkdir "test\widget"
if not exist "test\integration" mkdir "test\integration"

if not exist "assets\images" mkdir "assets\images"
if not exist "assets\animations" mkdir "assets\animations"
if not exist "assets\fonts" mkdir "assets\fonts"

echo [完成] 目录结构创建完成
echo.

REM 运行代码生成
echo [6/7] 运行代码生成...
echo [提示] 这可能需要几分钟时间...

findstr /C:"build_runner" pubspec.yaml >nul
if %ERRORLEVEL% equ 0 (
    flutter pub run build_runner build --delete-conflicting-outputs
    echo [完成] 代码生成完成
) else (
    echo [提示] 未配置代码生成,跳过此步骤
)
echo.

REM 格式化代码
echo [7/7] 格式化代码...
flutter format .
echo [完成] 代码格式化完成
echo.

REM 完成信息
echo ================================================
echo   项目设置完成!
echo ================================================
echo.
echo 下一步操作:
echo   运行开发服务器: flutter run -d chrome
echo   构建生产版本:   flutter build web --release
echo.
echo 文档:
echo   架构手册:      docs\ARCHITECTURE.md
echo   开发指南:      docs\DEVELOPMENT.md
echo   项目路线图:    docs\PROJECT_ROADMAP.md
echo ================================================
echo.
pause
