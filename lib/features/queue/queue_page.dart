import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/router/app_routes.dart';
import '../../core/theme/app_tokens.dart';
import '../auth/auth_controller.dart';
import 'controllers/mock_queue_controller.dart';
import 'data/queue_dto.dart';
import 'models/mock_queue_data.dart';
import 'models/now_playing_track.dart';
import 'models/queue_track.dart';
import 'widgets/active_connection_card.dart';
import 'widgets/now_playing_card.dart';
import 'widgets/queue_search_shortcut.dart';
import 'widgets/queue_track_tile.dart';
import 'widgets/queue_visuals.dart';
import 'widgets/vote_skip_row.dart';

class QueuePage extends ConsumerWidget {
  const QueuePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final authState = ref.watch(authControllerProvider);
    final queueState = ref.watch(mockQueueControllerProvider);

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
          child: _QueueBody(
            authState: authState,
            queueState: queueState,
            colorScheme: colorScheme,
          ),
        ),
      ),
    );
  }
}

class _QueueBody extends ConsumerWidget {
  const _QueueBody({
    required this.authState,
    required this.queueState,
    required this.colorScheme,
  });

  final AuthState authState;
  final AsyncValue<MockQueueState> queueState;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (authState.isLoading) {
      return const _QueueLoadingState();
    }

    if (!authState.isAuthenticated) {
      return _AuthRequiredState(
        message: authState.errorMessage,
        onLogin: () => context.go(AppRoutes.login),
      );
    }

    return queueState.when(
      loading: () => const _QueueLoadingState(),
      error: (error, stackTrace) => _QueueErrorState(
        message: 'Unable to load queue. Check the API server and try again.',
        onRetry: () => ref.read(mockQueueControllerProvider.notifier).refresh(),
      ),
      data: (state) {
        final tracks = state.items
            .map((item) => _queueTrackFromItem(item, authState.user?.id))
            .toList(growable: false);
        final nowPlaying = state.items.isEmpty
            ? null
            : _nowPlayingFromItem(state.items.first);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ActiveConnectionCard(
              session: MockQueueData.activeSession,
              onChange: _handleChangeChannel,
            ),
            const SizedBox(height: AppCoreTokens.sm),
            if (nowPlaying == null)
              _EmptyNowPlayingCard(onSearch: () => context.go(AppRoutes.search))
            else
              QueueCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    NowPlayingCard(
                      track: nowPlaying,
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
            QueueSearchShortcut(onSearch: () => context.go(AppRoutes.search)),
            if (state.actionError != null) ...[
              const SizedBox(height: AppCoreTokens.base),
              Text(
                state.actionError!,
                style: AppTypography.bodyMd.copyWith(color: colorScheme.error),
              ),
            ],
            const SizedBox(height: AppCoreTokens.sm),
            _UpcomingQueueList(
              tracks: tracks,
              onClearQueue: _handleClearQueue,
              onOpenTrackMenu: _handleOpenTrackMenu,
            ),
            const SizedBox(height: AppCoreTokens.sm),
            _FooterHint(colorScheme: colorScheme),
          ],
        );
      },
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

  QueueTrack _queueTrackFromItem(QueueItem item, String? currentUserId) {
    return QueueTrack(
      id: item.id,
      title: item.title,
      artist: item.artist ?? 'Unknown artist',
      source: _sourceLabel(item.source),
      sourceUrl: item.sourceUrl,
      duration: item.duration,
      requestedBy: item.requestedByUserId == currentUserId ? 'You' : 'Listener',
      thumbnailUrl: item.coverImageUrl,
    );
  }

  NowPlayingTrack _nowPlayingFromItem(QueueItem item) {
    final duration = item.duration.inMilliseconds == 0
        ? const Duration(minutes: 1)
        : item.duration;

    return NowPlayingTrack(
      title: item.title,
      artist: item.artist ?? 'Unknown artist',
      source: _sourceLabel(item.source),
      duration: duration,
      position: Duration(
        milliseconds: (duration.inMilliseconds * 0.52).round(),
      ),
      thumbnailUrl: item.coverImageUrl,
    );
  }

  String _sourceLabel(String source) {
    return switch (source) {
      'youtube' => 'YouTube',
      'spotify_metadata' => 'Spotify',
      _ => source,
    };
  }
}

class _QueueLoadingState extends StatelessWidget {
  const _QueueLoadingState();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: AppCoreTokens.xl),
      child: Center(
        child: CircularProgressIndicator(color: colorScheme.primary),
      ),
    );
  }
}

class _AuthRequiredState extends StatelessWidget {
  const _AuthRequiredState({required this.onLogin, this.message});

  final VoidCallback onLogin;
  final String? message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return QueueCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(LucideIcons.lockKeyhole, color: colorScheme.primary, size: 32),
          const SizedBox(height: AppCoreTokens.sm),
          Text(
            'Login to manage the queue',
            style: AppTypography.titleLg.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppCoreTokens.base),
          Text(
            message ??
                'Your saved queue and add-song controls need an account.',
            style: AppTypography.bodyMd.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppCoreTokens.gutter),
          FilledButton(onPressed: onLogin, child: const Text('Go to login')),
        ],
      ),
    );
  }
}

class _QueueErrorState extends StatelessWidget {
  const _QueueErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return QueueCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(LucideIcons.circleAlert, color: colorScheme.error, size: 32),
          const SizedBox(height: AppCoreTokens.sm),
          Text(
            message,
            style: AppTypography.bodyLg.copyWith(color: colorScheme.onSurface),
          ),
          const SizedBox(height: AppCoreTokens.gutter),
          OutlinedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}

class _EmptyNowPlayingCard extends StatelessWidget {
  const _EmptyNowPlayingCard({required this.onSearch});

  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return QueueCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(LucideIcons.music2, color: colorScheme.primary, size: 32),
          const SizedBox(height: AppCoreTokens.sm),
          Text(
            'Queue is empty',
            style: AppTypography.titleLg.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppCoreTokens.base),
          Text(
            'Add a mock track from Search to start this shared session.',
            style: AppTypography.bodyMd.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppCoreTokens.gutter),
          FilledButton.icon(
            onPressed: onSearch,
            icon: const Icon(LucideIcons.search),
            label: const Text('Find tracks'),
          ),
        ],
      ),
    );
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
          if (tracks.isEmpty)
            Padding(
              padding: const EdgeInsets.all(AppCoreTokens.gutter),
              child: Text(
                'No tracks queued yet.',
                style: AppTypography.bodyMd.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            )
          else
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
