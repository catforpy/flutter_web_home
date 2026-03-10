import 'package:flutter/material.dart';
import '../../widgets/common/app_header.dart';
import '../../widgets/common/app_footer.dart';
import '../../routes/app_router.dart';

/// 404页面 - 页面未找到
class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Column(
        children: [
          const AppHeader(),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 404图标
                    Icon(
                      Icons.error_outline,
                      size: 120,
                      color: theme.colorScheme.error,
                    ),
                    const SizedBox(height: 32),

                    // 404文本
                    Text(
                      '404',
                      style: theme.textTheme.displayLarge?.copyWith(
                        color: theme.colorScheme.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 提示文本
                    Text(
                      '页面未找到',
                      style: theme.textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 16),

                    Text(
                      '抱歉，您访问的页面不存在。',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // 返回首页按钮
                    ElevatedButton.icon(
                      onPressed: () => AppRouter.goToHome(context),
                      icon: const Icon(Icons.home),
                      label: const Text('返回首页'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const AppFooter(),
        ],
      ),
    );
  }
}
