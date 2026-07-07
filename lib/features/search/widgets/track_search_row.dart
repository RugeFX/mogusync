import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_tokens.dart';
import '../../queue/widgets/queue_visuals.dart';
import '../data/track_search_dto.dart';

class TrackSearchRow extends StatelessWidget {
  const TrackSearchRow({
    super.key,
    required this.track,
    required this.index,
    required this.isAuthenticated,
    required this.isQueued,
    required this.isAdding,
    required this.onLogin,
    required this.onAdd,
  });

  final TrackSearchResult track;
  final int index;
  final bool isAuthenticated;
  final bool isQueued;
  final bool isAdding;
  final VoidCallback onLogin;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: index.isEven
            ? colorScheme.surfaceContainerHigh.withValues(alpha: 0.44)
            : colorScheme.surfaceContainer.withValues(alpha: 0.36),
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.36),
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppCoreTokens.sm,
          vertical: AppCoreTokens.sm,
        ),
        child: Row(
          children: [
            TrackCoverImage(
              seed: index,
              imageUrl: track.coverImageUrl,
              size: 64,
              borderRadius: AppCoreTokens.sm,
            ),
            const SizedBox(width: AppCoreTokens.sm),
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
                          style: AppTypography.bodyLg.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppCoreTokens.base),
                      SourceBadge(source: track.source),
                    ],
                  ),
                  Text(
                    track.artist ?? 'Unknown artist',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodyMd.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppCoreTokens.sm),
            SizedBox(
              width: 48,
              child: Text(
                _formatNullableDuration(track.duration),
                textAlign: TextAlign.right,
                style: AppTypography.bodyMd.copyWith(
                  color: colorScheme.tertiary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: AppCoreTokens.base),
            _AddTrackButton(
              isAuthenticated: isAuthenticated,
              isQueued: isQueued,
              isAdding: isAdding,
              onLogin: onLogin,
              onAdd: onAdd,
            ),
          ],
        ),
      ),
    );
  }

  String _formatNullableDuration(Duration? duration) {
    if (duration == null || duration.inMilliseconds == 0) {
      return '--:--';
    }

    return formatTrackDuration(duration);
  }
}

class _AddTrackButton extends StatelessWidget {
  const _AddTrackButton({
    required this.isAuthenticated,
    required this.isQueued,
    required this.isAdding,
    required this.onLogin,
    required this.onAdd,
  });

  final bool isAuthenticated;
  final bool isQueued;
  final bool isAdding;
  final VoidCallback onLogin;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (!isAuthenticated) {
      return _RoundActionButton(
        icon: LucideIcons.logIn,
        tooltip: 'Login to add',
        onPressed: onLogin,
      );
    }

    if (isQueued) {
      return _RoundActionButton(
        icon: LucideIcons.check,
        tooltip: 'Already queued',
        onPressed: null,
      );
    }

    return SizedBox.square(
      dimension: 42,
      child: IconButton(
        onPressed: isAdding ? null : onAdd,
        icon: isAdding
            ? SizedBox.square(
                dimension: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colorScheme.primary,
                ),
              )
            : const Icon(LucideIcons.plus),
        color: colorScheme.onSurfaceVariant,
        tooltip: 'Add song',
        style: IconButton.styleFrom(
          backgroundColor: colorScheme.surfaceBright.withValues(alpha: 0.46),
          disabledBackgroundColor: colorScheme.surfaceBright.withValues(
            alpha: 0.28,
          ),
          shape: const CircleBorder(),
        ),
      ),
    );
  }
}

class _RoundActionButton extends StatelessWidget {
  const _RoundActionButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox.square(
      dimension: 42,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
        color: onPressed == null
            ? colorScheme.primary
            : colorScheme.onSurfaceVariant,
        tooltip: tooltip,
        style: IconButton.styleFrom(
          backgroundColor: colorScheme.surfaceBright.withValues(alpha: 0.46),
          disabledBackgroundColor: colorScheme.primary.withValues(alpha: 0.14),
          shape: const CircleBorder(),
        ),
      ),
    );
  }
}
