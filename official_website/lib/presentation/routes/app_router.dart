import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../pages/about/about_page.dart';
import '../pages/contact/contact_page.dart';
import '../pages/serve/serve_page.dart';
import '../pages/solutions/solutions_page.dart';
import '../pages/cases/cases_page.dart';
import '../pages/cases/case_detail_page.dart';
import '../pages/cooperation/cooperation_page.dart';
import '../pages/not_found/not_found_page.dart';
import '../pages/im_demo/im_demo_page.dart';
import '../pages/profile/profile_page.dart';
import '../pages/profile/account_settings_page.dart';
import '../pages/cart/cart_page.dart';
import '../pages/orders/orders_page.dart';
import '../pages/purchase/purchase_page.dart';
import '../pages/lease/lease_page.dart';
import '../pages/partnership/partnership_page.dart';
import '../pages/custom_dev/custom_dev_page.dart';
import '../pages/workbench/workbench_page.dart';
import '../pages/workbench/merchant_dashboard.dart';
import '../pages/workbench/mini_program_management_page.dart';
import '../pages/workbench/media_storage/media_storage_page.dart';
import '../pages/workbench/article_management/article_management_page.dart';
import '../pages/workbench/article_management/article_list_page.dart';
import '../pages/workbench/article_management/article_edit_page.dart';
import '../pages/workbench/course_category/course_category_management_page.dart';
import '../pages/workbench/course_qa_management/course_qa_management_page.dart';
import '../pages/home/home_page.dart';

/// 应用路由配置
/// 使用 go_router 进行声明式路由管理
class AppRouter {
  // 路由路径常量
  static const String home = '/';
  static const String purchase = '/purchase'; // 购买
  static const String lease = '/lease'; // 租赁
  static const String partnership = '/partnership'; // 合作
  static const String customDev = '/custom-dev'; // 定制开发
  static const String serve = '/serve';
  static const String solutions = '/solutions';
  static const String cases = '/cases';
  static const String caseDetail = '/cases/:caseId';
  static const String about = '/about';
  static const String contact = '/contact';
  static const String cooperation = '/cooperation';
  static const String imDemo = '/im-demo';
  static const String profile = '/profile';
  static const String accountSettings = '/account-settings';
  static const String cart = '/cart';
  static const String orders = '/orders';
  static const String workbench = '/workbench';
  static const String merchantDashboard = '/workbench/dashboard';
  static const String miniProgramManagement = '/workbench/dashboard/mini-program';
  static const String mediaStorage = '/workbench/dashboard/media-storage';
  static const String articleManagement = '/workbench/dashboard/article-management';
  static const String articleList = '/workbench/dashboard/article-list';
  static const String articleEdit = '/workbench/dashboard/article-edit';
  static const String courseCategory = '/workbench/dashboard/course-category';
  static const String courseQA = '/workbench/dashboard/course-qa';
  static const String rewardRecords = '/workbench/dashboard/reward-records';

  /// GoRouter 配置
  static final GoRouter router = GoRouter(
    // 初始路由
    initialLocation: home,

    // 路由配置
    routes: [
      // 首页路由 - 显示首页
      GoRoute(
        path: home,
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),

      // 购买页面路由
      GoRoute(
        path: purchase,
        name: 'purchase',
        builder: (context, state) => const PurchasePage(),
      ),

      // 租赁页面路由
      GoRoute(
        path: lease,
        name: 'lease',
        builder: (context, state) => const LeasePage(),
      ),

      // 合作页面路由
      GoRoute(
        path: partnership,
        name: 'partnership',
        builder: (context, state) => const PartnershipPage(),
      ),

      // 定制开发页面路由
      GoRoute(
        path: customDev,
        name: 'customDev',
        builder: (context, state) => const CustomDevPage(),
      ),

      // 服务页面路由
      GoRoute(
        path: serve,
        name: 'serve',
        builder: (context, state) => const ServePage(),
      ),

      // 解决方案页面路由
      GoRoute(
        path: solutions,
        name: 'solutions',
        builder: (context, state) => const SolutionsPage(),
      ),

      // 案例页面路由
      GoRoute(
        path: cases,
        name: 'cases',
        builder: (context, state) => const CasesPage(),
      ),

      // 案例详情页路由
      GoRoute(
        path: caseDetail,
        name: 'caseDetail',
        builder: (context, state) {
          final caseId = state.pathParameters['caseId'];
          return CaseDetailPage(caseId: caseId);
        },
      ),

      // 关于页面路由
      GoRoute(
        path: about,
        name: 'about',
        builder: (context, state) => const AboutPage(),
      ),

      // 合作流程页面路由
      GoRoute(
        path: cooperation,
        name: 'cooperation',
        builder: (context, state) {
          // 从URL参数获取选中的标签索引，默认为0（小程序购买）
          final tabIndex = int.tryParse(state.uri.queryParameters['tab'] ?? '0') ?? 0;
          return CooperationPage(initialTabIndex: tabIndex);
        },
      ),

      // 联系页面路由
      GoRoute(
        path: contact,
        name: 'contact',
        builder: (context, state) => const ContactPage(),
      ),

      // IM 演示页面路由
      GoRoute(
        path: imDemo,
        name: 'im-demo',
        builder: (context, state) => const IMDemoPage(),
      ),

      // 个人中心页面路由
      GoRoute(
        path: profile,
        name: 'profile',
        builder: (context, state) => const ProfilePage(),
      ),

      // 账户管理页面路由
      GoRoute(
        path: accountSettings,
        name: 'account-settings',
        builder: (context, state) => const AccountSettingsPage(),
      ),

      // 购物车页面路由
      GoRoute(
        path: cart,
        name: 'cart',
        builder: (context, state) => const CartPage(),
      ),

      // 订单页面路由
      GoRoute(
        path: orders,
        name: 'orders',
        builder: (context, state) => const OrdersPage(),
      ),

      // 工作台路由组
      GoRoute(
        path: workbench,
        name: 'workbench',
        builder: (context, state) => const WorkbenchPage(),
        routes: [
          // 商户管理后台（带子路由）
          GoRoute(
            path: 'dashboard',
            name: 'merchantDashboard',
            builder: (context, state) => const MerchantDashboard(),
            routes: [
              // 小程序管理 - 各个子标签
              GoRoute(
                path: 'mini-program',
                name: 'miniProgramManagement',
                builder: (context, state) {
                  final tab = state.uri.queryParameters['tab'] ?? '开发设置';
                  return MiniProgramManagementPage(initialTab: tab);
                },
              ),
              GoRoute(
                path: 'mini-program/:tab',
                name: 'miniProgramTab',
                builder: (context, state) {
                  final tab = state.pathParameters['tab'] ?? '开发设置';
                  return MiniProgramManagementPage(initialTab: tab);
                },
              ),
              GoRoute(
                path: 'media-storage',
                name: 'mediaStorage',
                builder: (context, state) => const MediaStoragePage(),
              ),
              GoRoute(
                path: 'article-management',
                name: 'articleManagement',
                builder: (context, state) => const ArticleManagementPage(),
              ),
              GoRoute(
                path: 'article-list',
                name: 'articleList',
                builder: (context, state) => const ArticleListPage(),
              ),
              GoRoute(
                path: 'article-edit',
                name: 'articleEdit',
                builder: (context, state) => const ArticleEditPage(showFullNavigation: false),
              ),
              GoRoute(
                path: 'course-category',
                name: 'courseCategory',
                builder: (context, state) => const CourseCategoryManagementPage(),
              ),
              GoRoute(
                path: 'course-qa',
                name: 'courseQA',
                builder: (context, state) => const CourseQAManagementPage(),
              ),
            ],
          ),
        ],
      ),
    ],

    // 404错误页面
    errorBuilder: (context, state) => const NotFoundPage(),
  );

  /// 导航到首页（服务页面）
  static void goToHome(BuildContext context) {
    context.go(home);
  }

  /// 导航到购买页面
  static void goToPurchase(BuildContext context) {
    context.go(purchase);
  }

  /// 导航到租赁页面
  static void goToLease(BuildContext context) {
    context.go(lease);
  }

  /// 导航到合作页面
  static void goToPartnership(BuildContext context) {
    context.go(partnership);
  }

  /// 导航到定制开发页面
  static void goToCustomDev(BuildContext context) {
    context.go(customDev);
  }

  /// 导航到服务页面
  static void goToServe(BuildContext context) {
    context.go(serve);
  }

  /// 导航到解决方案页面
  static void goToSolutions(BuildContext context) {
    context.go(solutions);
  }

  /// 导航到案例页面
  static void goToCases(BuildContext context) {
    context.go(cases);
  }

  /// 导航到案例详情页
  static void goToCaseDetail(BuildContext context, String caseId) {
    context.go('/cases/$caseId');
  }

  /// 导航到关于页面
  static void goToAbout(BuildContext context) {
    context.go(about);
  }

  /// 导航到合作流程页面
  static void goToCooperation(BuildContext context) {
    context.go(cooperation);
  }

  /// 导航到合作流程页面并选中指定标签
  /// tabIndex: 0=小程序购买, 1=小程序租赁, 2=小程序合作
  static void goToCooperationWithTab(BuildContext context, int tabIndex) {
    context.go('$cooperation?tab=$tabIndex');
  }

  /// 导航到联系页面
  static void goToContact(BuildContext context) {
    context.go(contact);
  }

  /// 导航到 IM 演示页面
  static void goToIMDemo(BuildContext context) {
    context.go(imDemo);
  }

  /// 导航到个人中心页面
  static void goToProfile(BuildContext context) {
    context.go(profile);
  }

  /// 导航到账户管理页面
  static void goToAccountSettings(BuildContext context) {
    context.go(accountSettings);
  }

  /// 导航到购物车页面
  static void goToCart(BuildContext context) {
    context.go(cart);
  }

  /// 导航到订单页面
  static void goToOrders(BuildContext context) {
    context.go(orders);
  }

  /// 导航到工作台页面
  static void goToWorkbench(BuildContext context) {
    context.go(workbench);
  }

  /// 导航到商户管理后台
  /// [from] 来源页面路径（用于返回逻辑）
  static void goToMerchantDashboard(BuildContext context, {String? from}) {
    if (from != null) {
      // 移除开头的斜杠（如果有）
      final fromPath = from.startsWith('/') ? from.substring(1) : from;
      context.go('$merchantDashboard?from=$fromPath');
    } else {
      context.go(merchantDashboard);
    }
  }

  /// 导航到小程序管理页面（带标签参数）
  /// tab: 开发设置、审核管理、菜单导航等
  static void goToMiniProgramManagement(BuildContext context, String tab) {
    context.go('$miniProgramManagement?tab=$tab');
  }

  /// 导航到小程序管理的特定子标签
  static void goToMiniProgramTab(BuildContext context, String tab) {
    context.go('$miniProgramManagement?tab=$tab');
  }

  /// 导航到课程问答管理页面
  static void goToCourseQA(BuildContext context) {
    context.go(courseQA);
  }

  /// 导航到打赏记录页面
  static void goToRewardRecords(BuildContext context) {
    context.go(rewardRecords);
  }

  /// 返回上一页
  static void pop(BuildContext context) {
    context.pop();
  }

  /// 打开外部URL
  static Future<void> openUrl(String urlString) async {
    final uri = Uri.parse(urlString);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint('无法打开URL: $urlString');
    }
  }
}
