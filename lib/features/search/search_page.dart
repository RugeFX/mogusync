import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/router/app_routes.dart';
import '../../core/theme/app_tokens.dart';
import '../auth/auth_controller.dart';
import '../queue/controllers/mock_queue_controller.dart';
import '../queue/widgets/queue_visuals.dart';
import 'controllers/mock_tracks_controller.dart';
import 'data/mock_track_dto.dart';

class SearchPage extends ConsumerWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final tracksState = ref.watch(mockTracksControllerProvider);
    final queueState = ref.watch(mockQueueControllerProvider);
    final authState = ref.watch(authControllerProvider);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colorScheme.surfaceContainerLowest, colorScheme.surface],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: colorScheme.primary,
          backgroundColor: colorScheme.surfaceContainerHigh,
          onRefresh: () async {
            await ref.read(mockTracksControllerProvider.notifier).refresh();
            await ref.read(mockQueueControllerProvider.notifier).refresh();
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppCoreTokens.marginMobile,
                  AppCoreTokens.md,
                  AppCoreTokens.marginMobile,
                  AppCoreTokens.sm,
                ),
                sliver: SliverToBoxAdapter(
                  child: _SearchHeader(authState: authState),
                ),
              ),
              tracksState.when(
                loading: () => const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, stackTrace) => SliverFillRemaining(
                  hasScrollBody: false,
                  child: _SearchErrorState(
                    onRetry: () => ref
                        .read(mockTracksControllerProvider.notifier)
                        .refresh(),
                  ),
                ),
                data: (tracks) {
                  if (tracks.isEmpty) {
                    return const SliverFillRemaining(
                      hasScrollBody: false,
                      child: _EmptyTracksState(),
                    );
                  }

                  return SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      AppCoreTokens.marginMobile,
                      0,
                      AppCoreTokens.marginMobile,
                      AppCoreTokens.md,
                    ),
                    sliver: SliverList.separated(
                      itemBuilder: (context, index) {
                        final track = tracks[index];
                        final queue = queueState.value;
                        final isQueued =
                            queue?.containsMockTrack(track.id) ?? false;
                        final isAdding =
                            queue?.addingTrackIds.contains(track.id) ?? false;

                        return _MockTrackCard(
                          track: track,
                          index: index,
                          isAuthenticated: authState.isAuthenticated,
                          isQueued: isQueued,
                          isAdding: isAdding,
                          onLogin: () => context.go(AppRoutes.login),
                          onAdd: () => ref
                              .read(mockQueueControllerProvider.notifier)
                              .addTrack(track.id),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: AppCoreTokens.sm),
                      itemCount: tracks.length,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchHeader extends StatelessWidget {
  const _SearchHeader({required this.authState});

  final AuthState authState;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(LucideIcons.search, color: colorScheme.primary, size: 36),
        const SizedBox(height: AppCoreTokens.sm),
        Text(
          'Search',
          style: AppTypography.headlineLg.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppCoreTokens.base),
        Text(
          authState.isAuthenticated
              ? 'Add backend mock tracks into your persisted queue.'
              : 'Login to add tracks into your persisted queue.',
          style: AppTypography.bodyMd.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _MockTrackCard extends StatelessWidget {
  const _MockTrackCard({
    required this.track,
    required this.index,
    required this.isAuthenticated,
    required this.isQueued,
    required this.isAdding,
    required this.onLogin,
    required this.onAdd,
  });

  final MockTrack track;
  final int index;
  final bool isAuthenticated;
  final bool isQueued;
  final bool isAdding;
  final VoidCallback onLogin;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return QueueCard(
      padding: const EdgeInsets.all(AppCoreTokens.sm),
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
                Text(
                  track.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.labelLg.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppCoreTokens.xs),
                Text(
                  track.artist,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodyMd.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppCoreTokens.base),
                Row(
                  children: [
                    SourceBadge(source: track.source),
                    const SizedBox(width: AppCoreTokens.base),
                    Text(
                      formatTrackDuration(track.duration),
                      style: AppTypography.labelSm.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
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
    );
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
    if (!isAuthenticated) {
      return IconButton.filledTonal(
        onPressed: onLogin,
        icon: const Icon(LucideIcons.logIn),
        tooltip: 'Login to add',
      );
    }

    if (isQueued) {
      return IconButton.filledTonal(
        onPressed: null,
        icon: const Icon(LucideIcons.check),
        tooltip: 'Already queued',
      );
    }

    return IconButton.filled(
      onPressed: isAdding ? null : onAdd,
      icon: isAdding
          ? const SizedBox.square(
              dimension: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(LucideIcons.plus),
      tooltip: 'Add song',
    );
  }
}

class _SearchErrorState extends StatelessWidget {
  const _SearchErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(AppCoreTokens.marginMobile),
      child: QueueCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(LucideIcons.circleAlert, color: colorScheme.error, size: 32),
            const SizedBox(height: AppCoreTokens.sm),
            Text(
              'Unable to load mock tracks.',
              style: AppTypography.bodyLg.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppCoreTokens.gutter),
            OutlinedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}

class _EmptyTracksState extends StatelessWidget {
  const _EmptyTracksState();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(AppCoreTokens.marginMobile),
      child: Text(
        'No mock tracks are available yet.',
        textAlign: TextAlign.center,
        style: AppTypography.bodyLg.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
