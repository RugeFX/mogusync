import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_tokens.dart';
import '../models/now_playing_track.dart';
import 'queue_visuals.dart';

class NowPlayingCard extends StatelessWidget {
  const NowPlayingCard({
    super.key,
    required this.track,
    required this.onSave,
    required this.onShuffle,
    required this.onPrevious,
    required this.onPlayPause,
    required this.onNext,
    required this.onRepeat,
    this.embedded = false,
    this.isPlaying = false,
  });

  final NowPlayingTrack track;
  final VoidCallback onSave;
  final VoidCallback onShuffle;
  final VoidCallback onPrevious;
  final VoidCallback onPlayPause;
  final VoidCallback onNext;
  final VoidCallback onRepeat;
  final bool embedded;
  final bool isPlaying;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final progress =
        track.position.inMilliseconds / track.duration.inMilliseconds;

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(AppCoreTokens.sm),
          decoration: BoxDecoration(
            color: colorScheme.surfaceBright.withValues(alpha: 0.42),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(
                embedded ? queueCardRadius - 1 : queueCardRadius,
              ),
              topRight: Radius.circular(
                embedded ? queueCardRadius - 1 : queueCardRadius,
              ),
              bottomLeft: const Radius.circular(AppCoreTokens.md),
              bottomRight: const Radius.circular(AppCoreTokens.md),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TrackCoverImage(
                imageUrl: track.thumbnailUrl,
                seed: 5,
                size: 112,
                borderRadius: AppCoreTokens.sm,
              ),
              const SizedBox(width: AppCoreTokens.gutter),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      track.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.titleLg.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppCoreTokens.base),
                    Text(
                      track.artist,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodyLg.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: AppCoreTokens.sm),
                    SourceBadge(source: track.source),
                  ],
                ),
              ),
              const SizedBox(width: AppCoreTokens.base),
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.surfaceContainerHighest,
                ),
                child: IconButton(
                  onPressed: onSave,
                  icon: const Icon(LucideIcons.heart),
                  color: colorScheme.onSurface,
                  tooltip: 'Save track',
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppCoreTokens.sm),
          child: Column(
            children: [
              CatEarProgressBar(
                progress: progress,
                leadingLabel: formatTrackDuration(track.position),
                trailingLabel: formatTrackDuration(track.duration),
              ),
              const SizedBox(height: AppCoreTokens.base),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _TransportButton(
                    icon: LucideIcons.repeat,
                    onPressed: onRepeat,
                    tooltip: 'Repeat',
                  ),
                  _TransportButton(
                    icon: LucideIcons.skipBack,
                    onPressed: onPrevious,
                    tooltip: 'Previous',
                    emphasized: true,
                  ),
                  _PlayPauseButton(
                    isPlaying: isPlaying,
                    onPressed: onPlayPause,
                  ),
                  _TransportButton(
                    icon: LucideIcons.skipForward,
                    onPressed: onNext,
                    tooltip: 'Next',
                    emphasized: true,
                  ),
                  _TransportButton(
                    icon: LucideIcons.shuffle,
                    onPressed: onShuffle,
                    tooltip: 'Shuffle',
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );

    if (embedded) {
      return content;
    }

    return QueueCard(padding: EdgeInsets.zero, child: content);
  }
}

class _TransportButton extends StatelessWidget {
  const _TransportButton({
    required this.icon,
    required this.onPressed,
    required this.tooltip,
    this.emphasized = false,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String tooltip;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: emphasized ? 56 : 44,
      height: emphasized ? 48 : 36,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(AppCoreTokens.md),
        color: emphasized
            ? colorScheme.surfaceBright.withValues(alpha: 0.62)
            : colorScheme.surfaceContainerLowest.withValues(alpha: 0.72),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
        color: colorScheme.primaryFixed,
        iconSize: emphasized ? 24 : 16,
        tooltip: tooltip,
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}

class _PlayPauseButton extends StatelessWidget {
  const _PlayPauseButton({required this.isPlaying, required this.onPressed});

  final bool isPlaying;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          // begin: Alignment.topLeft,
          // end: Alignment.bottomRight,
          colors: [colorScheme.primary, colorScheme.secondary],
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.secondary.withValues(alpha: 0.24),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          isPlaying ? LucideIcons.pause : LucideIcons.play,
          fill: 1,
          color: colorScheme.surface,
        ),
        iconSize: 38,
        tooltip: isPlaying ? 'Pause' : 'Play',
        style: IconButton.styleFrom(
          minimumSize: const Size(72, 72),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
    );
  }
}
