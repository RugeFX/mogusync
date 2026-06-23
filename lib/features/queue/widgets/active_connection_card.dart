import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_tokens.dart';
import '../models/active_session.dart';
import 'queue_visuals.dart';

class ActiveConnectionCard extends StatelessWidget {
  const ActiveConnectionCard({
    super.key,
    required this.session,
    required this.onChange,
  });

  final ActiveSession session;
  final VoidCallback onChange;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return QueueCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppCoreTokens.sm,
        vertical: AppCoreTokens.base,
      ),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              const MockTrackThumbnail(seed: 0, size: 56),
              Positioned(
                right: -5,
                top: -5,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: session.connected
                        ? const Color(0xFF65EA76)
                        : colorScheme.outline,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colorScheme.surfaceContainerLow,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: AppCoreTokens.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Connected to ${session.guildName}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.labelLg.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: AppCoreTokens.xs),
                Row(
                  children: [
                    Icon(
                      LucideIcons.slidersHorizontal,
                      size: 14,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: AppCoreTokens.xs),
                    Flexible(
                      child: Text(
                        '${session.voiceChannelName}  \u2022  '
                        '${session.listenerCount} listeners',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.bodyMd.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppCoreTokens.xs),
                Text(
                  'Shared session for this server',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodyMd.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppCoreTokens.base),
          OutlinedButton(
            onPressed: onChange,
            style: OutlinedButton.styleFrom(
              foregroundColor: colorScheme.primary,
              side: BorderSide(
                color: colorScheme.primary.withValues(alpha: 0.45),
              ),
              minimumSize: const Size(82, 40),
              padding: const EdgeInsets.symmetric(horizontal: AppCoreTokens.sm),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppCoreTokens.base),
              ),
              textStyle: AppTypography.labelLg,
            ),
            child: const Text('Change'),
          ),
        ],
      ),
    );
  }
}
