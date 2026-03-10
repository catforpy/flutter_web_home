import 'package:flutter/material.dart';

/// 应用底部
class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(32),
      color: theme.colorScheme.surface,
      child: Column(
        children: [
          const Divider(),
          const SizedBox(height: 24),
          Text(
            '© 2026 Flutter Web 官网. All rights reserved.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Built with Flutter | Clean Architecture | BLoC',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}
