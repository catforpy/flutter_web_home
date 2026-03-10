import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../widgets/common/unified_navigation_bar.dart';
import '../../widgets/common/footer_widget.dart';
import '../../widgets/common/floating_widget.dart';
import '../../routes/app_router.dart';
import '../../../core/auth/auth_state.dart';

/// 个人中心页面 - 慕课网风格
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // 监听认证状态变化
    authState.addListener(_onAuthStateChanged);
  }

  @override
  void dispose() {
    authState.removeListener(_onAuthStateChanged);
    _scrollController.dispose();
    super.dispose();
  }

  /// 认证状态变化时的回调
  void _onAuthStateChanged() {
    // 当登录状态或用户类型变化时刷新UI
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingWidget(
      scrollController: _scrollController,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  // 顶部用户信息横幅
                  _buildUserBanner(),

                  // 导航栏
                  const UnifiedNavigationBar(
                    currentPath: AppRouter.profile,
                  ),

                  // 主内容区域
                  Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      children: [
                        // 课程学习进度
                        _buildLearningProgress(),
                        const SizedBox(height: 24),

                        // 我的课程卡片
                        _buildMyCoursesCard(),
                        const SizedBox(height: 24),

                        // 收藏的课程
                        _buildFavoriteCourses(),
                        const SizedBox(height: 24),

                        // 我的关注（客户）
                        _buildCustomerFollowCard(),
                        const SizedBox(height: 24),

                        // 我的租赁（客户）
                        _buildCustomerLeasingCard(),
                        const SizedBox(height: 24),

                        // 我的合作卡片（客户）
                        _buildCustomerCooperationCard(),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),

                  // Footer
                  const FooterWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建用户信息横幅（慕课网风格）
  Widget _buildUserBanner() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2C5F8D), // 深蓝色
            Color(0xFF1E3A5F), // 更深的蓝色
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
          child: Row(
            children: [
              // 左侧：用户头像和信息
              _buildUserInfo(),
              const SizedBox(width: 80),

              // 右侧：数据统计
              Expanded(
                child: _buildUserStats(),
              ),

              const SizedBox(width: 40),

              // 最右侧：个人设置按钮
              _buildSettingsButton(),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建用户头像和信息
  Widget _buildUserInfo() {
    return Row(
      children: [
        // 大头像
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 3,
            ),
          ),
          child: ClipOval(
            child: authState.avatarUrl != null && authState.avatarUrl!.isNotEmpty
                ? Image.network(
                    authState.avatarUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildDefaultAvatar();
                    },
                  )
                : _buildDefaultAvatar(),
          ),
        ),
        const SizedBox(width: 24),

        // 用户名和状态
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              authState.nickname,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFFD700), // 金色
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'VIP',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 构建默认头像
  Widget _buildDefaultAvatar() {
    return Container(
      color: const Color(0xFFF5F5F5),
      child: const Icon(
        Icons.person,
        size: 50,
        color: Color(0xFF999999),
      ),
    );
  }

  /// 构建用户数据统计
  Widget _buildUserStats() {
    // 根据用户身份显示不同的统计数据
    switch (authState.userType) {
      case UserType.customer:
        // 客户：客户 + 商户的统计数据
        return _buildCustomerStats();
      case UserType.merchant:
        // 商户：空白占位
        return _buildMerchantPlaceholderStats();
      case UserType.backend:
        return _buildBackendStats();
      case null:
        return const SizedBox.shrink();
    }
  }

  /// 客户数据统计（合并商户内容）
  Widget _buildCustomerStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const SizedBox(width: 40),
        _buildStatItem('15', '小程序'),  // 商户
        const SizedBox(width: 40),
        _buildStatItem('32', '收藏'),    // 客户
        const SizedBox(width: 40),
        _buildStatItem('2', '关注'),     // 客户
        const SizedBox(width: 40),
        _buildStatItem('238', '租赁'),   // 商户
        const SizedBox(width: 40),
        _buildStatItem('56', '合作'),    // 商户
      ],
    );
  }

  /// 服务商数据统计
  Widget _buildMerchantPlaceholderStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const SizedBox(width: 40),
        _buildStatItem('156', '完成订单'),
        const SizedBox(width: 40),
        _buildStatItem('4.8', '服务评分'),
        const SizedBox(width: 40),
        _buildStatItem('98%', '满意度'),
        const SizedBox(width: 40),
        _buildStatItem('32', '模板数'),
        const SizedBox(width: 40),
        _buildStatItem('89', '客户数'),
      ],
    );
  }

  /// 后台数据统计
  Widget _buildBackendStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const SizedBox(width: 40),
        _buildStatItem('128', '任务'),
        const SizedBox(width: 40),
        _buildStatItem('89', '完成'),
        const SizedBox(width: 40),
        _buildStatItem('3', '排名'),
        const SizedBox(width: 40),
        _buildStatItem('12', '站内信'),
      ],
    );
  }

  /// 构建单个统计项
  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFFB0C4DE),
          ),
        ),
      ],
    );
  }

  /// 构建个人设置按钮
  Widget _buildSettingsButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          // 跳转到账户管理页面
          AppRouter.goToAccountSettings(context);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            children: [
              Icon(
                Icons.settings,
                size: 18,
                color: Colors.white,
              ),
              SizedBox(width: 8),
              Text(
                '个人设置',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建课程学习进度
  Widget _buildLearningProgress() {
    // 根据用户身份显示不同的内容
    switch (authState.userType) {
      case UserType.customer:
        // 客户：显示客户的"最近关注"
        return _buildCustomerRecentFollow();
      case UserType.merchant:
        // 服务商：显示服务统计
        return _buildMerchantServiceStats();
      case UserType.backend:
        return _buildBackendRecentTask();
      case null:
        return const SizedBox.shrink();
    }
  }

  /// 客户：最近关注
  Widget _buildCustomerRecentFollow() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.play_circle_outline,
                size: 24,
                color: Color(0xFF00C853),
              ),
              const SizedBox(width: 12),
              const Text(
                '最近关注',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'AI智能助手小程序',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '大模型问答助手',
                        style: TextStyle(
                          fontSize: 14,
                          color: const Color(0xFF666666),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      // TODO: 继续学习
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00C853),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        '继续',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 服务商：服务统计卡片
  Widget _buildMerchantServiceStats() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.analytics_outlined,
                size: 24,
                color: Color(0xFF2196F3),
              ),
              const SizedBox(width: 12),
              const Text(
                '服务统计',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatBox('156', '完成订单', Icons.shopping_bag_outlined, const Color(0xFF4CAF50)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatBox('4.8', '服务评分', Icons.star, const Color(0xFFFFC107)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatBox('98%', '客户满意度', Icons.thumb_up, const Color(0xFF2196F3)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建统计框
  Widget _buildStatBox(String value, String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF666666),
            ),
          ),
        ],
      ),
    );
  }

  /// 后台：我的任务
  Widget _buildBackendRecentTask() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.assignment,
                size: 24,
                color: Color(0xFFFF9800),
              ),
              const SizedBox(width: 12),
              const Text(
                '我的任务',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '审核商户提交材料',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '待处理：5份申请',
                        style: TextStyle(
                          fontSize: 14,
                          color: const Color(0xFF666666),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      // TODO: 处理任务
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF9800),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        '处理',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建我的课程卡片
  Widget _buildMyCoursesCard() {
    // 根据用户身份显示不同的内容
    switch (authState.userType) {
      case UserType.customer:
        // 客户：显示客户的"我的点赞"
        return _buildCustomerLikesCard();
      case UserType.merchant:
        // 服务商：显示授权范围
        return _buildMerchantAuthorizationScope();
      case UserType.backend:
        return _buildBackendRankingCard();
      case null:
        return const SizedBox.shrink();
    }
  }

  /// 客户：我的点赞
  Widget _buildCustomerLikesCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '我的点赞',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 20),
          _buildCourseGrid(),
        ],
      ),
    );
  }

  /// 后台：我的排名
  Widget _buildBackendRankingCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '我的排名',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 20),
          _buildRankingList(),
        ],
      ),
    );
  }

  /// 构建后台排名列表
  Widget _buildRankingList() {
    return Column(
      children: List.generate(3, (index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: index == 0
                      ? const Color(0xFFFFD700)
                      : index == 1
                          ? const Color(0xFFC0C0C0)
                          : const Color(0xFFCD7F32),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ['本月任务完成', '响应速度', '审核准确率'][index],
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      ['Top 3', 'Top 5', 'Top 8'][index],
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  /// 构建课程网格
  Widget _buildCourseGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 1.5,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return _buildCourseCard(index);
      },
    );
  }

  /// 构建单个课程卡片
  Widget _buildCourseCard(int index) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          // TODO: 查看课程详情
        },
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFFE0E0E0),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 课程图片
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E0E0),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.play_circle_outline,
                      size: 40,
                      color: Color(0xFF999999),
                    ),
                  ),
                ),
              ),
              // 课程信息
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _getMiniProgramTitle(index),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF333333),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 获取小程序标题
  String _getMiniProgramTitle(int index) {
    final titles = [
      'AI大模型对话助手',
      '智能客服机器人',
      '数据分析工具',
      'OCR识别小程序',
    ];
    return titles[index];
  }

  /// 构建收藏的课程
  Widget _buildFavoriteCourses() {
    // 根据用户身份显示不同的内容
    switch (authState.userType) {
      case UserType.customer:
        // 客户：显示客户的"我的收藏"
        return _buildCustomerFavoritesCard();
      case UserType.merchant:
        // 服务商：显示我的模板
        return _buildMerchantMyTemplates();
      case UserType.backend:
        return _buildBackendMessagesCard();
      case null:
        return const SizedBox.shrink();
    }
  }

  /// 客户：我的收藏
  Widget _buildCustomerFavoritesCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '我的收藏',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 20),
          _buildCourseGrid(),
        ],
      ),
    );
  }

  /// 后台：站内信
  Widget _buildBackendMessagesCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '站内信',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 20),
          _buildMessageList(),
        ],
      ),
    );
  }

  /// 构建后台站内信列表
  Widget _buildMessageList() {
    final messages = [
      {'title': '新商户审核提醒', 'time': '10分钟前', 'unread': true},
      {'title': '系统维护通知', 'time': '1小时前', 'unread': true},
      {'title': '月度报表已生成', 'time': '昨天', 'unread': false},
    ];

    return Column(
      children: messages.map((msg) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: msg['unread'] == true
                ? const Color(0xFFE3F2FD)
                : const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      msg['title']! as String,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: msg['unread'] == true
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: const Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      msg['time']! as String,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ],
                ),
              ),
              if (msg['unread'] == true)
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2196F3),
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  /// 构建我的合作卡片（已废弃，现在隐藏）
  Widget _buildCooperationCard() {
    // 客户已经通过下拉菜单的"我的合作"访问，不再显示独立卡片
    return const SizedBox.shrink();
  }

  /// 客户：我的关注卡片
  Widget _buildCustomerFollowCard() {
    // 仅在客户身份下显示
    if (authState.userType != UserType.customer) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '我的关注',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 20),
          _buildFollowList(),
        ],
      ),
    );
  }

  /// 客户：我的租赁卡片
  Widget _buildCustomerLeasingCard() {
    // 仅在客户身份下显示
    if (authState.userType != UserType.customer) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '我租赁的',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 20),
          _buildCustomerLeasingList(),
        ],
      ),
    );
  }

  /// 构建客户租赁列表（我向他人租赁）
  Widget _buildCustomerLeasingList() {
    final leasingItems = [
      {
        'title': '电商小程序模板',
        'provider': '某科技公司',
        'period': '3个月',
        'price': '¥299',
        'status': '使用中',
        'statusColor': 0xFF00C853,
      },
      {
        'title': '餐饮系统小程序',
        'provider': '某服务商',
        'period': '6个月',
        'price': '¥599',
        'status': '使用中',
        'statusColor': 0xFF00C853,
      },
      {
        'title': '教育类小程序',
        'provider': '某平台商',
        'period': '1年',
        'price': '¥999',
        'status': '即将到期',
        'statusColor': 0xFFFF9800,
      },
    ];

    return Column(
      children: leasingItems.map((item) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title'] as String,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '提供商：${item['provider']} | ${item['period']} - ${item['price']}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: item['status'] == '使用中'
                      ? const Color(0xFF00C853)
                      : const Color(0xFFFF9800),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  item['status'] as String,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  /// 构建客户关注列表
  Widget _buildFollowList() {
    final followItems = [
      {
        'title': 'AI大模型技术',
        'type': '小程序技术',
        'time': '3天前关注',
        'status': '已关注',
        'statusColor': 0xFF2196F3,
      },
      {
        'title': '电商解决方案',
        'type': '业务合作',
        'time': '1周前关注',
        'status': '已关注',
        'statusColor': 0xFF2196F3,
      },
      {
        'title': '数据分析服务',
        'type': '技术服务',
        'time': '2周前关注',
        'status': '已关注',
        'statusColor': 0xFF2196F3,
      },
    ];

    return Column(
      children: followItems.map((item) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title'] as String,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '类型：${item['type']}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF666666),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['time'] as String,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF999999),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF2196F3),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  item['status'] as String,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  /// 客户：我的合作卡片
  Widget _buildCustomerCooperationCard() {
    // 仅在客户身份下显示
    if (authState.userType != UserType.customer) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '我合作的',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 20),
          _buildCustomerCooperationList(),
        ],
      ),
    );
  }

  /// 构建客户合作列表
  Widget _buildCustomerCooperationList() {
    final cooperationItems = [
      {
        'title': 'AI大模型小程序开发',
        'type': '小程序合作',
        'partner': '某科技公司',
        'status': '洽谈中',
        'statusColor': 0xFFFF9800,
        'time': '2025-03-10'
      },
      {
        'title': '数据分析平台定制',
        'type': '业务合作',
        'partner': '某电商平台',
        'status': '已达成',
        'statusColor': 0xFF00C853,
        'time': '2025-02-15'
      },
      {
        'title': '在线教育系统',
        'type': '小程序租赁',
        'partner': '某教育机构',
        'status': '进行中',
        'statusColor': 0xFF2196F3,
        'time': '2025-01-20'
      },
    ];

    return Column(
      children: cooperationItems.map((item) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title'] as String,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '合作类型：${item['type']} | 合作方：${item['partner']}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF666666),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '时间：${item['time']}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF999999),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Color(item['statusColor'] as int),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  item['status'] as String,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  /// 服务商：授权范围卡片
  Widget _buildMerchantAuthorizationScope() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '我的授权',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildAuthScopeCard('授权模块', Icons.apps, ['课程管理', '商城管理', '营销工具']),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildAuthScopeCard('授权地区', Icons.location_on, ['全国', '华东地区', '华南地区']),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildAuthScopeCard('授权行业', Icons.business, ['教育培训', '电商零售', '生活服务']),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建授权范围卡片
  Widget _buildAuthScopeCard(String title, IconData icon, List<String> items) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: const Color(0xFF2196F3)),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(left: 28, bottom: 6),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF2196F3),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      item,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  /// 服务商：我的模板卡片
  Widget _buildMerchantMyTemplates() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '我的模板',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 20),
          _buildTemplateGrid(),
        ],
      ),
    );
  }

  /// 构建模板网格
  Widget _buildTemplateGrid() {
    final templates = [
      {'name': '电商小程序模板', 'uses': 156, 'rating': 4.8},
      {'name': '餐饮系统模板', 'uses': 89, 'rating': 4.6},
      {'name': '教育机构模板', 'uses': 67, 'rating': 4.9},
      {'name': '健身场馆模板', 'uses': 45, 'rating': 4.7},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 2.5,
      ),
      itemCount: templates.length,
      itemBuilder: (context, index) {
        final template = templates[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFFE0E0E0),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  const Icon(Icons.dashboard, size: 20, color: Color(0xFF2196F3)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      template['name'] as String,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF333333),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    '使用 ${template['uses']}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF666666),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: Color(0xFFFFC107)),
                      const SizedBox(width: 4),
                      Text(
                        '${template['rating']}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
