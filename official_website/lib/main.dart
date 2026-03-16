import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'presentation/theme/app_theme.dart';
import 'presentation/routes/app_router.dart';
import 'application/blocs/counter/counter_bloc.dart';
import 'application/blocs/theme/theme_bloc.dart';
import 'core/auth/auth_state.dart';
import 'core/services/storage_service.dart';

void main() async {
  // 初始化 StorageService
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService().init();
  runApp(const OfficialWebsiteApp());
}

/// 官网应用主入口
///
/// 特性：
/// - 使用 MultiBlocProvider 提供多个 BLoC
/// - 使用 go_router 进行路由管理
/// - 支持亮色/暗色主题
class OfficialWebsiteApp extends StatelessWidget {
  const OfficialWebsiteApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 使用 MultiBlocProvider 提供多个 BLoC 实例
    return MultiBlocProvider(
      providers: [
        // 计数器 BLoC - 状态管理示例
        BlocProvider(
          create: (context) => CounterBloc(),
        ),
        // 主题 BLoC - 主题切换状态管理
        BlocProvider(
          create: (context) => ThemeBloc(),
        ),
      ],
      child: MultiProvider(
        providers: [
          // 认证状态管理
          ChangeNotifierProvider(
            create: (_) => AuthState()..initialize(),
          ),
        ],
        child: MaterialApp.router(
          title: 'Flutter 官网',
          debugShowCheckedModeBanner: false,

          // 主题配置
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,

          // 本地化配置 - 支持中文
          locale: const Locale('zh', 'CN'),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('zh', 'CN'), // 简体中文
            Locale('en', 'US'), // 英文
          ],

          // 路由配置
          routerConfig: AppRouter.router,
        ),
      ),
    );
  }
}
