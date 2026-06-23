import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_tokens.dart';

class QueueSearchShortcut extends StatelessWidget {
  const QueueSearchShortcut({super.key, required this.onSearch});

  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Semantics(
      button: true,
      label: 'Search and add songs',
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow.withValues(alpha: 0.78),
          borderRadius: BorderRadius.circular(AppCoreTokens.full),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.92),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: onSearch,
                borderRadius: BorderRadius.circular(AppCoreTokens.full),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: AppCoreTokens.gutter,
                    right: AppCoreTokens.base,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        LucideIcons.search,
                        size: 22,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: AppCoreTokens.sm),
                      Expanded(
                        child: Text(
                          'Search and add songs here...',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.labelLg.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
