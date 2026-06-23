import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/app_tokens.dart';
import 'models/mock_queue_data.dart';
import 'models/queue_track.dart';
import 'widgets/active_connection_card.dart';
import 'widgets/now_playing_card.dart';
import 'widgets/queue_search_shortcut.dart';
import 'widgets/queue_track_tile.dart';
import 'widgets/queue_visuals.dart';
import 'widgets/vote_skip_row.dart';

class QueuePage extends StatelessWidget {
  const QueuePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tracks = MockQueueData.upcomingTracks;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colorScheme.surfaceContainerLowest, colorScheme.surface],
          stops: const [0, 1],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppCoreTokens.marginMobile,
            AppCoreTokens.md,
            AppCoreTokens.marginMobile,
            AppCoreTokens.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ActiveConnectionCard(
                session: MockQueueData.activeSession,
                onChange: _handleChangeChannel,
              ),
              const SizedBox(height: AppCoreTokens.sm),
              QueueCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    NowPlayingCard(
                      track: MockQueueData.nowPlaying,
                      embedded: true,
                      onSave: _handleSaveCurrentTrack,
                      onShuffle: _handleShuffle,
                      onPrevious: _handlePrevious,
                      onPlayPause: _handlePlayPause,
                      onNext: _handleNext,
                      onRepeat: _handleRepeat,
                    ),
                    VoteSkipRow(
                      votes: 3,
                      voteTarget: 5,
                      attached: true,
                      onVoteSkip: _handleVoteSkip,
                      onOpenDjTools: _handleOpenDjTools,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppCoreTokens.sm),
              QueueSearchShortcut(onSearch: _handleSearchShortcut),
              const SizedBox(height: AppCoreTokens.sm),
              _UpcomingQueueList(
                tracks: tracks,
                onClearQueue: _handleClearQueue,
                onOpenTrackMenu: _handleOpenTrackMenu,
              ),
              const SizedBox(height: AppCoreTokens.sm),
              _FooterHint(colorScheme: colorScheme),
            ],
          ),
        ),
      ),
    );
  }

  void _handleChangeChannel() {
    debugPrint('Change channel pressed');
    // TODO: Connect to server/channel selection flow.
  }

  void _handleVoteSkip() {
    debugPrint('Vote skip pressed');
    // TODO: Submit vote skip for the active session.
  }

  void _handleOpenDjTools() {
    debugPrint('Open DJ tools pressed');
    // TODO: Open DJ tools for permitted users.
  }

  void _handleSearchShortcut() {
    debugPrint('Search shortcut pressed');
    // TODO: Navigate to the Search tab when the real flow is wired.
  }

  void _handleClearQueue() {
    debugPrint('Clear queue pressed');
    // TODO: Confirm and clear queue for users with permission.
  }

  void _handleOpenTrackMenu(QueueTrack track) {
    debugPrint('Open track menu pressed for: ${track.title}');
    // TODO: Open track overflow actions for track.
  }

  void _handleSaveCurrentTrack() {
    debugPrint('Save current track pressed');
    // TODO: Save current track to favorites/library.
  }

  void _handleShuffle() {
    debugPrint('Shuffle toggled');
    // TODO: Toggle shuffle for current session.
  }

  void _handlePrevious() {
    debugPrint('Previous track pressed');
    // TODO: Request previous track.
  }

  void _handlePlayPause() {
    debugPrint('Play/pause toggled');
    // TODO: Toggle playback state.
  }

  void _handleNext() {
    debugPrint('Next track pressed');
    // TODO: Request next track.
  }

  void _handleRepeat() {
    debugPrint('Repeat mode toggled');
    // TODO: Toggle repeat mode.
  }
}

class _UpcomingQueueList extends StatelessWidget {
  const _UpcomingQueueList({
    required this.tracks,
    required this.onClearQueue,
    required this.onOpenTrackMenu,
  });

  final List<QueueTrack> tracks;
  final VoidCallback onClearQueue;
  final ValueChanged<QueueTrack> onOpenTrackMenu;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return QueueCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppCoreTokens.gutter,
              vertical: AppCoreTokens.sm,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Up Next (${tracks.length})',
                    style: AppTypography.bodyLg.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onClearQueue,
                  icon: Icon(LucideIcons.listX, size: 20),
                  color: colorScheme.primary,
                  visualDensity: VisualDensity.compact,
                  tooltip: 'Clear Queue',
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: colorScheme.outlineVariant.withValues(alpha: 0.64),
          ),
          for (var index = 0; index < tracks.length; index += 1) ...[
            QueueTrackTile(
              track: tracks[index],
              index: index,
              onOpenMenu: () => onOpenTrackMenu(tracks[index]),
            ),
            if (index != tracks.length - 1)
              Divider(
                height: 1,
                thickness: 1,
                indent: AppCoreTokens.sm,
                endIndent: AppCoreTokens.sm,
                color: colorScheme.outlineVariant.withValues(alpha: 0.52),
              ),
          ],
        ],
      ),
    );
  }
}

class _FooterHint extends StatelessWidget {
  const _FooterHint({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(LucideIcons.music, size: 16, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: AppCoreTokens.base),
        Flexible(
          child: Text(
            'Search, save, or add from Library to keep the vibes going.',
            textAlign: TextAlign.center,
            style: AppTypography.labelSm.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}
