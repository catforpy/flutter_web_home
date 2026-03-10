import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../domain/models/service_item.dart';
import '../../../domain/models/process_step.dart';
import '../../../domain/models/tech_advantage.dart';
import '../../../domain/models/development_step.dart';
import '../../widgets/serve/hero_banner_widget.dart';
import '../../widgets/serve/core_services_widget.dart';
import '../../widgets/serve/tech_advantage_widget.dart';
import '../../widgets/serve/service_flow_widget.dart';
import '../../widgets/serve/service_intro_widget.dart';
import '../../widgets/serve/success_cases_widget.dart';
import '../../widgets/serve/case_banner_widget.dart';
import '../../widgets/common/footer_widget.dart';
import '../../widgets/common/floating_widget.dart';
import '../../widgets/common/unified_navigation_bar.dart';
import '../../routes/app_router.dart';

/// 服务页面
/// 展示公司的服务内容、技术优势、服务流程等
class ServePage extends StatefulWidget {
  const ServePage({super.key});

  @override
  State<ServePage> createState() => _ServePageState();
}

class _ServePageState extends State<ServePage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<FloatingWidgetState> _floatingWidgetKey = GlobalKey<FloatingWidgetState>();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// 显示聊天窗口
  void _showChatWindow() {
    _floatingWidgetKey.currentState?.showChatWindow();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingWidget(
      key: _floatingWidgetKey,
      scrollController: _scrollController,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              // 1. Hero 横幅
              const HeroBannerWidget(
                title: '我们用心让客户更放心',
                subtitle: '源码交付 | 高质上线 | 售后无忧',
                backgroundImageUrl: 'assets/hero-banner.png',
                showDownloadButton: true,
              ),

              // 2. 导航栏（在 Hero 横幅下面）
              UnifiedNavigationBar(
                currentPath: AppRouter.serve,
              ),

              // 3. 核心服务
              CoreServicesWidget(
                services: services,
                backgroundColor: AppColors.background,
              ),

              // 3. 技术优势
              TechAdvantageWidget(
                advantages: advantages,
                backgroundColor: AppColors.backgroundDark,
              ),

              // 4. 服务流程
              ServiceFlowWidget(
                steps: steps,
                backgroundColor: AppColors.background,
              ),

              // // 5. 开发流程
              // DevelopmentFlowWidget(
              //   steps: developmentSteps,
              //   backgroundColor: AppColors.background,
              // ),

              // 6. 全行业小程序开发服务介绍
              ServiceIntroWidget(
                backgroundColor: AppColors.background,
                onConsult: _showChatWindow,
              ),

              // 7. 企业成功案例
              const SuccessCasesWidget(
                backgroundColor: AppColors.background,
              ),

              // 8. 案例横幅
              CaseBannerWidget(
                onConsult: _showChatWindow,
              ),

              // 9. Footer 底部导航栏
              const FooterWidget(),
            ],
          ),
        ),
      ),
    );
  }
  static const List<ServiceItem> services = [
    ServiceItem(
      title: '小程序商城',
      icon: Icons.shopping_cart,
      features: [
        '快速部署即刻开业',
        '个性化店铺自由搭建',
        '集成分销/拼团/砍价/优惠券',
        '助力实体门店转型社交新零售',
      ],
      description: '助力商家快速抢占社交电商市场先机',
      imageUrl: 'https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=800&h=600&fit=crop',
    ),
    ServiceItem(
      title: 'APP开发',
      icon: Icons.phone_android,
      features: [
        'IOS开发',
        'Android开发',
        '物联网应用开发',
        '一站式APP开发服务',
      ],
      description: '一站式APP开发服务',
      imageUrl: 'https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?w=800&h=600&fit=crop',
    ),
    ServiceItem(
      title: '网站建设',
      icon: Icons.language,
      features: [
        '专属企业品牌官网',
        '实效营销获客网站',
        '手机电脑完美适配',
        '立体呈现企业品牌优势',
      ],
      description: '助力企业全面展示品牌优势',
      imageUrl: 'https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=800&h=600&fit=crop',
    ),
    ServiceItem(
      title: '微信小程序开发',
      icon: Icons.wechat,
      features: [
        '专属小程序深度定制',
        '公众号功能精准开发',
        '爆款H5互动营销制作',
        '助您轻松激活微信私域客流',
      ],
      description: '助力获取微信流量红利',
      imageUrl: 'https://images.unsplash.com/photo-1551650975-87deedd944c3?w=800&h=600&fit=crop',
    ),
  ];

  /// 技术优势数据
  static const List<TechAdvantage> advantages = [
    TechAdvantage(
      title: '加速应用开发',
      subtitle: '极致性体验',
      description:
          '强大的Native渲染引擎提供丰富的API。出色的原生性和流畅的页面交互，为您的用户提供最佳的使用体验。',
      icon: Icons.explore,
    ),
    TechAdvantage(
      title: '可视化开发',
      subtitle: '生成专业级源代码',
      description:
          '通过可视化拖拉拽快速构建应用程序，一键生成专业级应用代码，开发者可直接二次开发使用。',
      icon: Icons.code,
    ),
    TechAdvantage(
      title: '一套代码',
      subtitle: '适配多端应用',
      description:
          '只需一次开发，使用UniApp跨平台技术可同时发布为Android、iOS、小程序、H5多端应用，使企业更专注于业务创新。',
      icon: Icons.devices,
    ),
  ];

  /// 服务流程数据
  static const List<ProcessStep> steps = [
    // 第一行：大卡片
    ProcessStep(
      title: '小程序开发',
      icon: Icons.phone_iphone,
      stepNumber: 1,
      isLarge: true,
      backgroundImage: 'https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?w=800&h=600&fit=crop', // 手机界面
      logoImage: 'https://junhe.oss-cn-beijing.aliyuncs.com/newgw/xcx/static/kaifalogo.png',
    ),
    ProcessStep(
      title: '可视化云开发',
      icon: Icons.cloud,
      stepNumber: 2,
      isLarge: true,
      backgroundImage: 'https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=800&h=600&fit=crop', // 代码编辑器
      logoImage: 'https://junhe.oss-cn-beijing.aliyuncs.com/newgw/xcx/static/yunkaifalogo.png',
    ),
    // 第二行：小卡片
    ProcessStep(
      title: '小程序测试',
      icon: Icons.bug_report,
      stepNumber: 3,
      isLarge: false,
      backgroundImage: 'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=600&h=600&fit=crop', // 数据图表
      logoImage: 'https://junhe.oss-cn-beijing.aliyuncs.com/newgw/xcx/static/cesilogo.png',
    ),
    ProcessStep(
      title: '小程序发布',
      icon: Icons.publish,
      stepNumber: 4,
      isLarge: false,
      backgroundImage: 'https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=600&h=600&fit=crop', // 键盘/屏幕
      logoImage: 'https://junhe.oss-cn-beijing.aliyuncs.com/newgw/xcx/static/fabulogo.png',
    ),
    ProcessStep(
      title: '应用运营',
      icon: Icons.trending_up,
      stepNumber: 5,
      isLarge: false,
      backgroundImage: 'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=600&h=600&fit=crop', // 数据面板
      logoImage: 'https://junhe.oss-cn-beijing.aliyuncs.com/newgw/xcx/static/yunkaifalogo.png',
    ),
  ];

  /// 开发流程数据
  static const List<DevelopmentStep> developmentSteps = [
    DevelopmentStep(
      title: '6 个人员角色/项目',
      descriptions: [
        '产品经理',
        'UI设计师',
        '前端工程师',
        '后端工程师',
        '测试工程师',
        '项目经理',
      ],
      stepNumber: '01',
      iconType: DevelopmentStepIconType.personnel,
    ),
    DevelopmentStep(
      title: '每周汇报进度',
      descriptions: [
        '每周五汇报',
        '展示成果',
        '问题同步',
        '下周计划',
      ],
      stepNumber: '02',
      iconType: DevelopmentStepIconType.weeklyReport,
    ),
    DevelopmentStep(
      title: '4 项测试，高质上线',
      descriptions: [
        '功能测试',
        '性能测试',
        '兼容性测试',
        '安全测试',
      ],
      stepNumber: '03',
      iconType: DevelopmentStepIconType.testing,
    ),
    DevelopmentStep(
      title: '12 项交付内容',
      descriptions: [
        '源代码',
        '设计稿',
        '数据库文档',
        'API文档',
        '部署文档',
        '操作手册',
      ],
      stepNumber: '04',
      iconType: DevelopmentStepIconType.deliverables,
    ),
    DevelopmentStep(
      title: '2 种维护模式',
      descriptions: [
        '免费维护3个月',
        '付费续维服务',
        '7x24小时响应',
        '定期版本更新',
      ],
      stepNumber: '05',
      iconType: DevelopmentStepIconType.maintenance,
    ),
    DevelopmentStep(
      title: '提供客户培训/咨询',
      descriptions: [
        '系统操作培训',
        '管理员培训',
        '技术咨询服务',
        '问题解答支持',
      ],
      stepNumber: '06',
      iconType: DevelopmentStepIconType.training,
    ),
  ];
}
