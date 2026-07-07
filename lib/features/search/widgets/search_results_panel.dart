import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_tokens.dart';
import '../../auth/auth_controller.dart';
import '../../queue/controllers/mock_queue_controller.dart';
import '../../queue/widgets/queue_visuals.dart';
import '../controllers/track_search_controller.dart';
import '../data/track_search_dto.dart';
import 'track_search_row.dart';

class SearchResultsPanelSliver extends StatelessWidget {
  const SearchResultsPanelSliver({
    super.key,
    required this.searchState,
    required this.queueState,
    required this.authState,
    required this.onRetry,
    required this.onLogin,
    required this.onAdd,
  });

  final AsyncValue<TrackSearchState> searchState;
  final AsyncValue<MockQueueState> queueState;
  final AuthState authState;
  final VoidCallback onRetry;
  final VoidCallback onLogin;
  final ValueChanged<TrackSearchResult> onAdd;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppCoreTokens.marginMobile,
      ),
      sliver: _ResultsPanelSliver(
        slivers: [
          const SliverToBoxAdapter(child: _ResultsHeader()),
          ...searchState.when(
            loading: () => const [
              SliverFillRemaining(
                hasScrollBody: false,
                child: _ResultsPanelFill(
                  child: _PanelMessage(
                    icon: null,
                    title: 'Searching...',
                    body: 'Finding tracks you can add to the queue.',
                    loading: true,
                  ),
                ),
              ),
            ],
            error: (error, stackTrace) => [
              SliverFillRemaining(
                hasScrollBody: false,
                child: _ResultsPanelFill(
                  child: _PanelMessage(
                    icon: LucideIcons.circleAlert,
                    title: 'Search is unavailable',
                    body: 'Check the backend search service and try again.',
                    actionLabel: 'Retry',
                    onAction: onRetry,
                  ),
                ),
              ),
            ],
            data: (state) {
              if (!state.hasQuery) {
                return const [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _ResultsPanelFill(
                      child: _PanelMessage(
                        icon: LucideIcons.search,
                        title: 'Start with a song, artist, or link',
                        body: 'Results from the search API will show up here.',
                      ),
                    ),
                  ),
                ];
              }

              if (state.tracks.isEmpty) {
                return [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _ResultsPanelFill(
                      child: _PanelMessage(
                        icon: LucideIcons.listMusic,
                        title: 'No results for "${state.query}"',
                        body: 'Try a different title, artist, or YouTube link.',
                      ),
                    ),
                  ),
                ];
              }

              return [
                SliverList.builder(
                  itemCount: state.tracks.length,
                  itemBuilder: (context, index) {
                    final track = state.tracks[index];

                    return TrackSearchRow(
                      track: track,
                      index: index,
                      isAuthenticated: authState.isAuthenticated,
                      isQueued:
                          queueState.value?.containsSourceUrl(
                            track.sourceUrl,
                          ) ??
                          false,
                      isAdding:
                          queueState.value?.addingTrackIds.contains(track.id) ??
                          false,
                      onLogin: onLogin,
                      onAdd: () => onAdd(track),
                    );
                  },
                ),
                const SliverToBoxAdapter(child: _ResultsPanelFooter()),
              ];
            },
          ),
        ],
      ),
    );
  }
}

class _ResultsPanelSliver extends StatelessWidget {
  const _ResultsPanelSliver({required this.slivers});

  final List<Widget> slivers;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedSliver(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(queueCardRadius),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.82),
        ),
      ),
      sliver: SliverMainAxisGroup(slivers: slivers),
    );
  }
}

class _ResultsHeader extends StatelessWidget {
  const _ResultsHeader();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppCoreTokens.gutter,
            AppCoreTokens.gutter,
            AppCoreTokens.gutter,
            AppCoreTokens.sm,
          ),
          child: Text(
            'Results',
            style: AppTypography.bodyLg.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Divider(
          height: 1,
          thickness: 1,
          color: colorScheme.outlineVariant.withValues(alpha: 0.58),
        ),
      ],
    );
  }
}

class _ResultsPanelFill extends StatelessWidget {
  const _ResultsPanelFill({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class _ResultsPanelFooter extends StatelessWidget {
  const _ResultsPanelFooter();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: AppCoreTokens.xl * 2);
  }
}

class _PanelMessage extends StatelessWidget {
  const _PanelMessage({
    required this.title,
    required this.body,
    this.icon,
    this.loading = false,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String body;
  final IconData? icon;
  final bool loading;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(AppCoreTokens.gutter),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (loading)
            SizedBox.square(
              dimension: 26,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: colorScheme.primary,
              ),
            )
          else if (icon != null)
            Icon(icon, color: colorScheme.primary, size: 30),
          const SizedBox(height: AppCoreTokens.sm),
          Text(
            title,
            style: AppTypography.bodyLg.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppCoreTokens.xs),
          Text(
            body,
            style: AppTypography.bodyMd.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: AppCoreTokens.gutter),
            OutlinedButton(onPressed: onAction, child: Text(actionLabel!)),
          ],
        ],
      ),
    );
  }
}
