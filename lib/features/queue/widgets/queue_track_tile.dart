import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_tokens.dart';
import '../models/queue_track.dart';
import 'queue_visuals.dart';

class QueueTrackTile extends StatelessWidget {
  const QueueTrackTile({
    super.key,
    required this.track,
    required this.index,
    required this.onOpenMenu,
  });

  final QueueTrack track;
  final int index;
  final VoidCallback onOpenMenu;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppCoreTokens.gutter,
        vertical: AppCoreTokens.base,
      ),
      child: Row(
        children: [
          Icon(
            LucideIcons.grip,
            size: 20,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.74),
          ),
          const SizedBox(width: AppCoreTokens.base),
          TrackCoverImage(
            imageUrl: track.thumbnailUrl,
            seed: index,
            size: 56,
            borderRadius: AppCoreTokens.sm,
          ),
          const SizedBox(width: AppCoreTokens.gutter),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        track.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.labelLg.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SourceBadge(source: track.source),
                  ],
                ),
                const SizedBox(height: AppCoreTokens.xs),
                Text(
                  track.artist,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.labelSm.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppCoreTokens.sm),
          SizedBox(
            width: 42,
            child: Text(
              formatTrackDuration(track.duration),
              textAlign: TextAlign.right,
              style: AppTypography.bodyMd.copyWith(color: colorScheme.tertiary),
            ),
          ),
          const SizedBox(width: AppCoreTokens.sm),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.surfaceContainerLowest,
            ),
            child: IconButton(
              onPressed: onOpenMenu,
              icon: const Icon(LucideIcons.userRound),
              color: colorScheme.onSurfaceVariant,
              iconSize: 24,
              tooltip: 'Track options',
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}
