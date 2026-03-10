import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../widgets/common/footer_widget.dart';
import '../../widgets/common/floating_widget.dart';
import '../../widgets/common/unified_navigation_bar.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/gestures.dart';
import '../../routes/app_router.dart';

/// 合作流程页面
/// 展示合作流程、开发步骤等内容
class CooperationPage extends StatefulWidget {
  /// 初始选中的标签索引
  final int initialTabIndex;

  const CooperationPage({
    super.key,
    this.initialTabIndex = 0,
  });

  @override
  State<CooperationPage> createState() => _CooperationPageState();
}

class _CooperationPageState extends State<CooperationPage> {
  final ScrollController _scrollController = ScrollController();

  // 当前选中的合作方式索引
  int _selectedCooperationIndex = -1; // -1表示没有选中

  // 当前选中的步骤索引
  int _selectedStepIndex = 0;

  @override
  void initState() {
    super.initState();
    // 设置初始选中的标签
    _selectedCooperationIndex = widget.initialTabIndex;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingWidget(
      scrollController: _scrollController,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              // 1. 导航栏 + 合作流程标题区
              _buildHeroSection(),

              // 2. 导航栏（在 Hero 横幅下面）
              UnifiedNavigationBar(
                currentPath: AppRouter.cooperation,
              ),

              // 3. 合作方式按钮
              _buildCooperationButtons(),

              // 3. Footer 底部导航栏
              const FooterWidget(),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建合作方式按钮区域
  Widget _buildCooperationButtons() {
    final buttons = [
      {'label': '小程序购买', 'index': 0},
      {'label': '小程序租赁', 'index': 1},
      {'label': '小程序合作', 'index': 2},
    ];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: Column(
        children: [
          // 标题
          const Text(
            '选择合作方式',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 60),

          // 3个按钮
          Wrap(
            spacing: 20,
            children: buttons.map((btn) {
              return _CooperationButton(
                label: btn['label'] as String,
                isSelected: _selectedCooperationIndex == btn['index'] as int,
                onTap: () {
                  setState(() {
                    _selectedCooperationIndex = btn['index'] as int;
                    _selectedStepIndex = 0; // 重置步骤选择
                  });
                  debugPrint('点击${btn['label']}');
                  // TODO: 根据选中的按钮跳转到不同页面
                },
              );
            }).toList(),
          ),

          // 如果选择了小程序购买或小程序租赁，显示进度步骤
          // 如果选择了小程序合作，显示提示信息
          if (_selectedCooperationIndex == 0 || _selectedCooperationIndex == 1) ...[
            const SizedBox(height: 80),
            _buildProgressSteps(),
          ],

          // 如果选择了小程序合作，显示提示
          if (_selectedCooperationIndex == 2) ...[
            const SizedBox(height: 80),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 60),
              child: const Text(
                '详情咨询客服',
                style: TextStyle(
                  fontSize: 24,
                  color: Color(0xFF999999),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// 构建进度步骤
  Widget _buildProgressSteps() {
    // 根据合作方式获取不同的步骤
    List<Map<String, dynamic>> steps;

    if (_selectedCooperationIndex == 0) {
      // 小程序购买
      steps = [
        {'title': '深入沟通', 'percent': 20},
        {'title': '项目UI模板选型及设计', 'percent': 40},
        {'title': '后端开发', 'percent': 80},
        {'title': '系统测试', 'percent': 90},
        {'title': '部署上线', 'percent': 100},
      ];
    } else if (_selectedCooperationIndex == 1) {
      // 小程序租赁
      steps = [
        {'title': '选择小程序', 'percent': 25},
        {'title': '沟通洽谈', 'percent': 50},
        {'title': '上架产品/服务', 'percent': 75},
        {'title': '验收/维护', 'percent': 100},
      ];
    } else {
      // 小程序合作
      steps = [
        {'title': '选择小程序', 'percent': 25},
        {'title': '沟通洽谈', 'percent': 50},
        {'title': '签订合同', 'percent': 75},
        {'title': '启动项目', 'percent': 100},
      ];
    }

    return Column(
      children: [
        // 步骤标签行（可横向滚动）
        SizedBox(
          height: 80,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 120),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: steps.asMap().entries.map((entry) {
                final index = entry.key;
                final step = entry.value;
                return Padding(
                  padding: EdgeInsets.only(
                    right: index < steps.length - 1 ? 60 : 0,
                  ),
                  child: _ProgressStep(
                    title: step['title'] as String,
                    percent: step['percent'] as int,
                    isSelected: _selectedStepIndex == index,
                    onTap: () {
                      setState(() {
                        _selectedStepIndex = index;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ),

        // 步骤详细内容（左右分栏）
        if (_selectedStepIndex >= 0) _buildStepDetail(),
      ],
    );
  }

  /// 构建步骤详细内容
  Widget _buildStepDetail() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 80), // 增加边距
      child: SizedBox(
        width: 1400, // 固定最大宽度
        child: _StepDetailContent(
          stepIndex: _selectedStepIndex,
          cooperationType: _selectedCooperationIndex,
        ),
      ),
    );
  }

  /// 构建顶部区域（导航栏 + 合作流程标题）
  Widget _buildHeroSection() {
    return SizedBox(
      height: 600,
      child: Stack(
        children: [
          // 背景图
          Positioned.fill(
            child: Image.asset(
              'assets/cooperation-banner.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                debugPrint('CooperationBanner: 图片加载失败 - $error');
                // 图片加载失败时显示渐变背景
                return Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF1A2332),
                        Color(0xFF0D1B2A),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // 黑色半透明蒙版
          Container(
            color: Colors.black.withValues(alpha: 0.65),
          ),

          // 左侧文案区（距左40px，距顶180px）
          Positioned(
            top: 180,
            left: 40,
            child: _buildLeftContent(),
          ),
        ],
      ),
    );
  }

  /// 构建左侧内容
  Widget _buildLeftContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 主标题
        Text(
          '合作流程',
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 24),

        // 副标题
        Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Text(
            '项目制作的好坏，很多时候取决于是否拥有严谨、合理的高效流程',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white.withValues(alpha: 0.9),
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }

}

/// 合作方式按钮组件
class _CooperationButton extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CooperationButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_CooperationButton> createState() => _CooperationButtonState();
}

class _CooperationButtonState extends State<_CooperationButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final bool isActive = widget.isSelected || _isHovered;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? const Color(0xFFD93025) // 选中：红色背景
                : Colors.white, // 未选中：白色背景
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: widget.isSelected
                  ? const Color(0xFFD93025)
                  : const Color(0xFFE0E0E0),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: _isHovered ? 0.1 : 0.05,
                ),
                blurRadius: _isHovered ? 8 : 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              fontSize: 16,
              color: widget.isSelected
                  ? Colors.white // 选中：白色文字
                  : const Color(0xFF333333), // 未选中：黑色文字
              fontWeight: isActive
                  ? FontWeight.bold // 悬停或选中时加粗
                  : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

/// 进度步骤组件
class _ProgressStep extends StatefulWidget {
  final String title;
  final int percent;
  final bool isSelected;
  final VoidCallback onTap;

  const _ProgressStep({
    required this.title,
    required this.percent,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_ProgressStep> createState() => _ProgressStepState();
}

class _ProgressStepState extends State<_ProgressStep> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 圆形进度指示器
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.isSelected
                    ? const Color(0xFFD93025) // 选中：红色实心
                    : (_isHovered
                        ? const Color(0xFFD93025)
                        : const Color(0xFF333333)), // 未选中：黑色实心
              ),
              child: Center(
                child: Text(
                  '${widget.percent}%',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // 始终白色
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // 标题文字
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: widget.isSelected ? FontWeight.bold : FontWeight.normal,
                color: widget.isSelected
                    ? const Color(0xFFD93025) // 选中：红色
                    : (_isHovered
                        ? const Color(0xFFD93025)
                        : const Color(0xFF333333)), // 未选中：黑色
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 步骤详细内容组件
class _StepDetailContent extends StatelessWidget {
  final int stepIndex;
  final int cooperationType;

  const _StepDetailContent({
    required this.stepIndex,
    required this.cooperationType,
  });

  @override
  Widget build(BuildContext context) {
    // 根据合作方式和步骤索引返回不同内容
    if (cooperationType == 0) {
      // 小程序购买
      switch (stepIndex) {
        case 0:
          return _buildPurchaseStep1Content();
        case 1:
          return _buildPurchaseStep2Content();
        case 2:
          return _buildPurchaseStep3Content();
        case 3:
          return _buildPurchaseStep4Content();
        case 4:
          return _buildPurchaseStep5Content();
        default:
          return const SizedBox.shrink();
      }
    } else if (cooperationType == 1) {
      // 小程序租赁
      switch (stepIndex) {
        case 0:
          return _buildRentStep1Content();
        case 1:
          return _buildRentStep2Content();
        case 2:
          return _buildRentStep3Content();
        case 3:
          return _buildRentStep4Content();
        default:
          return const SizedBox.shrink();
      }
    } else {
      // 小程序合作
      switch (stepIndex) {
        case 0:
          return _buildCooperationStep1Content();
        case 1:
          return _buildCooperationStep2Content();
        case 2:
          return _buildCooperationStep3Content();
        case 3:
          return _buildCooperationStep4Content();
        default:
          return const SizedBox.shrink();
      }
    }
  }

  /// 小程序购买 - 第1步：深入沟通
  Widget _buildPurchaseStep1Content() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 左侧：文字内容（固定宽度）
        SizedBox(
          width: 500,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 标题
              Wrap(
                spacing: 4,
                children: [
                  Text(
                    '首次',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFD93025), // 红色加深
                    ),
                  ),
                  Text(
                    '沟通 洽谈需求',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF333333),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 副标题
              Text(
                '用户确定自身资质是否满足微信设立相应小程序的资质要求，确定网站建设方案，需求定位，沟通网站设计细节',
                style: TextStyle(
                  fontSize: 14,
                  color: const Color(0xFF999999), // 灰色
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),

              // 分割线（短）
              Container(
                width: 60,
                height: 2,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
              const SizedBox(height: 32),

              // 两个Column组成的Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 220,
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBullet('商务顾问深入沟通'),
                      _buildBullet('出具醒目报价单'),
                      _buildBullet('规划网站栏目'),
                      _buildBullet('确认设计风格'),
                    ],
                  ),
                  ),
                  const SizedBox(width: 40),
                  SizedBox(
                    width: 220,
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBullet('提供网站建设方案'),
                      _buildBullet('确定双方合作'),
                      _buildBullet('确定页面模型个数'),
                      _buildBullet('确定所需功能'),
                    ],
                  ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // 右侧：图片
        const SizedBox(width: 80),
        Flexible(
          child: Container(
            height: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: const DecorationImage(
                image: NetworkImage('https://picsum.photos/800/600?random=100'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 小程序购买 - 第2步：项目UI模板选型及设计
  Widget _buildPurchaseStep2Content() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 左侧：文字内容（固定宽度）
        SizedBox(
          width: 500,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 标题
              Wrap(
                spacing: 4,
                children: [
                  Text(
                    '用户',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFD93025), // 红色
                    ),
                  ),
                  Text(
                    '选模型，设计师根据需求，出具设计图',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF333333),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 分割线（短）
              Container(
                width: 60,
                height: 2,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
              const SizedBox(height: 24),

              // 副标题
              Text(
                '本阶段 网站设计图给到用户浏览 用户提出修改要求与最终签字确认',
                style: TextStyle(
                  fontSize: 14,
                  color: const Color(0xFF999999), // 灰色
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),

              // 两个Column组成的Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 220,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBullet('1-3天出具设计稿'),
                        _buildBullet('内业整体设计'),
                        _buildBullet('反馈修改意见'),
                        _buildBullet('定稿设计图'),
                      ],
                    ),
                  ),
                  const SizedBox(width: 40),
                  SizedBox(
                    width: 220,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBullet('甲方提供设计素材'),
                        _buildBullet('首页界面设计'),
                        _buildBullet('甲方审阅预览'),
                        _buildBullet('跟进修改调整'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // 右侧：图片
        const SizedBox(width: 80),
        Flexible(
          child: Container(
            height: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: const DecorationImage(
                image: NetworkImage('https://picsum.photos/800/600?random=200'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 小程序购买 - 第3步：后端开发
  Widget _buildPurchaseStep3Content() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 左侧：文字内容（固定宽度）
        SizedBox(
          width: 500,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 标题
              Wrap(
                spacing: 4,
                children: [
                  Text(
                    '后端',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFD93025), // 红色
                    ),
                  ),
                  Text(
                    '程序功能开发',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF333333),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 分割线（短）
              Container(
                width: 60,
                height: 2,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
              const SizedBox(height: 24),

              // 副标题
              Text(
                '本阶段程序员会根据前端代码开发系统功能和实现逻辑',
                style: TextStyle(
                  fontSize: 14,
                  color: const Color(0xFF999999), // 灰色
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),

              // 两个Column组成的Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 220,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBullet('功能逻辑梳理'),
                        _buildBullet('数据库规划设计'),
                        _buildBullet('打入测试数据'),
                      ],
                    ),
                  ),
                  const SizedBox(width: 40),
                  SizedBox(
                    width: 220,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBullet('PHP/JAVA语言开发'),
                        _buildBullet('调试DEMO功能'),
                        _buildBullet('转交测试员'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // 右侧：图片
        const SizedBox(width: 80),
        Flexible(
          child: Container(
            height: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: const DecorationImage(
                image: NetworkImage('https://picsum.photos/800/600?random=300'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 小程序购买 - 第4步：系统测试
  Widget _buildPurchaseStep4Content() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 左侧：文字内容（固定宽度）
        SizedBox(
          width: 500,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 标题
              Wrap(
                spacing: 4,
                children: [
                  Text(
                    '测试员',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFD93025), // 红色
                    ),
                  ),
                  Text(
                    '终端测试',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF333333),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 分割线（短）
              Container(
                width: 60,
                height: 2,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
              const SizedBox(height: 24),

              // 副标题
              Text(
                '本阶段测试各型号的移动端，确保每个项目的质量都趋于完美',
                style: TextStyle(
                  fontSize: 14,
                  color: const Color(0xFF999999), // 灰色
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),

              // 两个Column组成的Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 220,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBullet('严格的测试标准'),
                        _buildBullet('功能逻辑测试'),
                        _buildBullet('安全风险测试'),
                        _buildBullet('运行环境调试'),
                      ],
                    ),
                  ),
                  const SizedBox(width: 40),
                  SizedBox(
                    width: 220,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBullet('前端JS测试'),
                        _buildBullet('速度相应测试'),
                        _buildBullet('并发压力测试'),
                        _buildBullet('符合上线标准'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // 右侧：图片
        const SizedBox(width: 80),
        Flexible(
          child: Container(
            height: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: const DecorationImage(
                image: NetworkImage('https://picsum.photos/800/600?random=400'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 小程序购买 - 第5步：部署上线
  Widget _buildPurchaseStep5Content() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 左侧：文字内容（固定宽度）
        SizedBox(
          width: 500,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 标题
              Wrap(
                spacing: 4,
                children: [
                  Text(
                    '完成',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFD93025), // 红色
                    ),
                  ),
                  Text(
                    '符合标准进行维护',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF333333),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 分割线（短）
              Container(
                width: 60,
                height: 2,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
              const SizedBox(height: 24),

              // 副标题
              Text(
                '项目部署上线，开始正式运营和后期技术支持',
                style: TextStyle(
                  fontSize: 14,
                  color: const Color(0xFF999999), // 灰色
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),

              // 两个Column组成的Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 220,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBullet('域名解析与绑定'),
                        _buildBullet('数据库安装'),
                        _buildBullet('交付管理系统'),
                        _buildBullet('售后技术响应'),
                      ],
                    ),
                  ),
                  const SizedBox(width: 40),
                  SizedBox(
                    width: 220,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBullet('代码环境部署'),
                        _buildBullet('递交搜索抓取'),
                        _buildBullet('1对1指导使用'),
                        _buildBullet('永久技术维护'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // 右侧：图片
        const SizedBox(width: 80),
        Flexible(
          child: Container(
            height: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: const DecorationImage(
                image: NetworkImage('https://picsum.photos/800/600?random=500'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 小程序租赁 - 第1步：选择小程序
  Widget _buildRentStep1Content() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 左侧：文字内容（固定宽度）
        SizedBox(
          width: 500,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 标题
              Wrap(
                spacing: 4,
                children: [
                  Text(
                    '用户',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFD93025), // 红色
                    ),
                  ),
                  Text(
                    '筛选小程序',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF333333),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 分割线（短）
              Container(
                width: 60,
                height: 2,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
              const SizedBox(height: 24),

              // 副标题
              Text(
                '本阶段用户根据自身产品/服务性质特征，选择拥有对应资质的小程序',
                style: TextStyle(
                  fontSize: 14,
                  color: const Color(0xFF999999), // 灰色
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),

              // 列表
              SizedBox(
                width: 220,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBullet('产品/服务与小程序行业资质匹配'),
                  ],
                ),
              ),
            ],
          ),
        ),

        // 右侧：图片
        const SizedBox(width: 80),
        Flexible(
          child: Container(
            height: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: const DecorationImage(
                image: NetworkImage('https://picsum.photos/800/600?random=600'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 小程序租赁 - 第2步：沟通洽谈
  Widget _buildRentStep2Content() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 左侧：文字内容（固定宽度）
        SizedBox(
          width: 500,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 标题
              Wrap(
                spacing: 4,
                children: [
                  Text(
                    '用户',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFD93025), // 红色
                    ),
                  ),
                  Text(
                    '与小程序业主洽谈',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF333333),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 分割线（短）
              Container(
                width: 60,
                height: 2,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
              const SizedBox(height: 24),

              // 副标题
              Text(
                '本阶段，用户和小程序业主洽谈租金及租赁方式，沟通达成一致后由双方签订租赁合同',
                style: TextStyle(
                  fontSize: 14,
                  color: const Color(0xFF999999), // 灰色
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),

        // 右侧：图片
        const SizedBox(width: 80),
        Flexible(
          child: Container(
            height: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: const DecorationImage(
                image: NetworkImage('https://picsum.photos/800/600?random=700'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 小程序租赁 - 第3步：上架产品/服务
  Widget _buildRentStep3Content() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 左侧：文字内容（固定宽度）
        SizedBox(
          width: 500,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 标题
              Wrap(
                spacing: 4,
                children: [
                  Text(
                    '用户',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFD93025), // 红色
                    ),
                  ),
                  Text(
                    '将产品/服务上架资料发给小程序业主',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF333333),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 分割线（短）
              Container(
                width: 60,
                height: 2,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
              const SizedBox(height: 24),

              // 副标题
              Text(
                '本阶段，用户将产品/服务的介绍资料发给小程序业主，由小程序业主将相关资料发布在对应的小程序中，客户购买后，分成按照合同规则进行分配',
                style: TextStyle(
                  fontSize: 14,
                  color: const Color(0xFF999999), // 灰色
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),

        // 右侧：图片
        const SizedBox(width: 80),
        Flexible(
          child: Container(
            height: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: const DecorationImage(
                image: NetworkImage('https://picsum.photos/800/600?random=800'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 小程序租赁 - 第4步：验收/维护
  Widget _buildRentStep4Content() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 左侧：文字内容（固定宽度）
        SizedBox(
          width: 500,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 标题
              Wrap(
                spacing: 4,
                children: [
                  Text(
                    '用户',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFD93025), // 红色
                    ),
                  ),
                  Text(
                    '实时跟踪销售数据，参与客服维护工作',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF333333),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 分割线（短）
              Container(
                width: 60,
                height: 2,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
              const SizedBox(height: 24),

              // 副标题
              Text(
                '本阶段，用户可成为小程序的对应柜台的专属客服，实时维护/答疑，并且可以跟踪销售数据',
                style: TextStyle(
                  fontSize: 14,
                  color: const Color(0xFF999999), // 灰色
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),

        // 右侧：图片
        const SizedBox(width: 80),
        Flexible(
          child: Container(
            height: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: const DecorationImage(
                image: NetworkImage('https://picsum.photos/800/600?random=900'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 小程序合作 - 第1步：选择小程序
  Widget _buildCooperationStep1Content() {
    return const Center(
      child: Text(
        '选择小程序',
        style: TextStyle(fontSize: 24, color: Colors.grey),
      ),
    );
  }

  /// 小程序合作 - 第2步：沟通洽谈
  Widget _buildCooperationStep2Content() {
    return const Center(
      child: Text(
        '沟通洽谈',
        style: TextStyle(fontSize: 24, color: Colors.grey),
      ),
    );
  }

  /// 小程序合作 - 第3步：签订合同
  Widget _buildCooperationStep3Content() {
    return const Center(
      child: Text(
        '签订合同',
        style: TextStyle(fontSize: 24, color: Colors.grey),
      ),
    );
  }

  /// 小程序合作 - 第4步：启动项目
  Widget _buildCooperationStep4Content() {
    return const Center(
      child: Text(
        '启动项目',
        style: TextStyle(fontSize: 24, color: Colors.grey),
      ),
    );
  }

  /// 构建列表项
  Widget _buildBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '· ',
            style: TextStyle(
              fontSize: 18, // 从15放大到18
              color: const Color(0xFF333333),
              height: 1.6,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 15,
                color: const Color(0xFF333333),
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
