import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/app_tokens.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

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
              LucideIcons.library,
              color: colorScheme.primary,
              size: AppCoreTokens.lg,
            ),
            const SizedBox(height: AppCoreTokens.gutter),
            Text(
              'Library',
              style: AppTypography.headlineLg.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppCoreTokens.base),
            Text(
              'Server playlists, saved tracks, and recently played placeholder',
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
