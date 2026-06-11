import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/app_tokens.dart';

class QueuePage extends StatelessWidget {
  const QueuePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _PlaceholderTabPage(
      title: 'Queue',
      subtitle: 'Listening queue placeholder',
      icon: LucideIcons.listMusic,
    );
  }
}

class _PlaceholderTabPage extends StatelessWidget {
  const _PlaceholderTabPage({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppCoreTokens.marginMobile),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: colorScheme.primary, size: AppCoreTokens.lg),
            const SizedBox(height: AppCoreTokens.gutter),
            Text(
              title,
              style: AppTypography.headlineLg.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppCoreTokens.base),
            Text(
              subtitle,
              style: AppTypography.bodyLg.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
