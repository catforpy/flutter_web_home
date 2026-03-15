import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../routes/app_router.dart';
import 'store_settings_page.dart';

/// 工作台路由管理器
/// 统一管理所有子菜单的路由跳转
class WorkbenchRouteManager {
  /// 处理子菜单点击事件
  static void handleSubMenuItemClick(
    BuildContext context,
    String subMenuItem,
  ) {
    debugPrint('点击子菜单：$subMenuItem');

    switch (subMenuItem) {
      // 小程序管理 - 进入容器页面
      case '开发设置':
      case '审核管理':
      case '菜单导航':
      case '订阅消息':
      case '跳转小程序':
      case '开发者模式':
        MiniProgramManagementRoutes.navigate(context, initialTab: subMenuItem);
        break;

      // 配置管理
      case '支付配置':
        MiniProgramManagementRoutes.navigate(context, initialTab: subMenuItem);
        break;
      case '分享海报设置':
      case '客服设置':
      case '短信设置':
      case '广告位配置':
        _showComingSoonDialog(context, subMenuItem);
        break;

      case '音视频存储':
        // 跳转到音视频存储页面
        context.go(AppRouter.mediaStorage);
        break;

      // 模块管理
      case '文章管理':
        // 跳转到文章管理页面
        context.go(AppRouter.articleManagement);
        break;
      case '留言管理':
      case '启动图管理':
      case '活动页配置':
      case '经典语录管理':
        _showComingSoonDialog(context, subMenuItem);
        break;

      // 页面管理
      case '主页管理':
      case '个人中心管理':
        // 导航到小程序管理页面，并设置初始标签
        MiniProgramManagementRoutes.navigate(context, initialTab: subMenuItem);
        break;

      // 课程管理
      case '课程分类':
        debugPrint('=== 进入课程分类处理 ===');
        debugPrint('课程分类路由：${AppRouter.courseCategory}');
        context.go(AppRouter.courseCategory);
        debugPrint('=== 已执行导航 ===');
        break;
      case '课程问答管理':
        debugPrint('=== 进入课程问答管理处理 ===');
        debugPrint('课程问答管理路由：${AppRouter.courseQA}');
        context.go(AppRouter.courseQA);
        debugPrint('=== 已执行导航 ===');
        break;
      case '课程列表':
      case '作者列表':
      case '评论管理':
        _showComingSoonDialog(context, subMenuItem);
        break;

      // 订单管理
      case '课程订单':
        _showComingSoonDialog(context, subMenuItem);
        break;

      // 商城管理
      case '商品分类':
      case '商品列表':
      case '运费模板':
      case '商品评价':
      case '商城订单':
      case '维权订单':
      case '订单设置':
      case '留言模版':
        _showComingSoonDialog(context, subMenuItem);
        break;

      // 用户管理
      case '用户列表':
      case '用户分类':
      case '用户等级':
      case '签到记录':
      case '搜索历史管理':
        _showComingSoonDialog(context, subMenuItem);
        break;

      // 会员卡管理
      case '会员卡':
      case '储值卡':
      case '会员对话码':
        _showComingSoonDialog(context, subMenuItem);
        break;

      // 营销工具
      case '优惠券':
      case '拼团':
      case '秒杀':
        _showComingSoonDialog(context, subMenuItem);
        break;

      // 其他
      case '店铺设置':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const StoreSettingsPage(),
          ),
        );
        break;

      default:
        _showComingSoonDialog(context, subMenuItem);
        break;
    }
  }

  /// 显示"即将推出"对话框
  static void _showComingSoonDialog(BuildContext context, String featureName) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.info_outline,
                size: 48,
                color: Color(0xFF1890FF),
              ),
              const SizedBox(height: 16),
              const Text(
                '功能即将推出',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '"$featureName" 功能正在开发中',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 80,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1890FF),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      '知道了',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 判断是否应该返回平台初始化页面
  static bool shouldReturnToPlatform(String menuItem) {
    const platformItems = ['管理中心', '平台概览'];
    return platformItems.contains(menuItem);
  }
}

/// 小程序管理路由配置
class MiniProgramManagementRoutes {
  static const String routeName = '/mini-program-management';

  static void navigate(BuildContext context, {String initialTab = '开发设置'}) {
    // 使用 go_router 导航，并传递标签参数
    AppRouter.goToMiniProgramManagement(context, initialTab);
  }
}

