import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/app_tokens.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppCoreTokens.marginMobile),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              LucideIcons.search,
              color: colorScheme.primary,
              size: AppCoreTokens.lg,
            ),
            const SizedBox(height: AppCoreTokens.gutter),
            Text(
              'Search',
              style: AppTypography.headlineLg.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppCoreTokens.base),
            Text(
              'Search placeholder',
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
