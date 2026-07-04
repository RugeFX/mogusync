import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/router/app_routes.dart';
import '../../core/theme/app_tokens.dart';
import '../auth/auth_controller.dart';
import '../queue/controllers/mock_queue_controller.dart';
import '../queue/widgets/queue_visuals.dart';
import 'controllers/track_search_controller.dart';
import 'data/track_search_dto.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _queryController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _queryController.dispose();
    super.dispose();
  }

  void _handleQueryChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 450), () {
      ref.read(trackSearchControllerProvider.notifier).search(value);
    });
  }

  Future<void> _refresh() async {
    await ref.read(authControllerProvider.notifier).refreshCurrentUser();
    await ref.read(trackSearchControllerProvider.notifier).refresh();
    await ref.read(mockQueueControllerProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final searchState = ref.watch(trackSearchControllerProvider);
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
          onRefresh: _refresh,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  AppCoreTokens.marginMobile,
                  AppCoreTokens.md,
                  AppCoreTokens.marginMobile,
                  AppCoreTokens.md,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SearchInput(
                        controller: _queryController,
                        onChanged: _handleQueryChanged,
                        onSubmitted: (value) => ref
                            .read(trackSearchControllerProvider.notifier)
                            .search(value),
                      ),
                      const SizedBox(height: AppCoreTokens.gutter),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight - 116,
                        ),
                        child: _ResultsPanel(
                          searchState: searchState,
                          queueState: queueState,
                          authState: authState,
                          onRetry: _refresh,
                          onLogin: () => context.go(AppRoutes.login),
                          onAdd: (track) => ref
                              .read(mockQueueControllerProvider.notifier)
                              .addSearchResult(track),
                        ),
                      ),
                      if (queueState.value?.actionError != null) ...[
                        const SizedBox(height: AppCoreTokens.base),
                        Text(
                          queueState.value!.actionError!,
                          style: AppTypography.bodyMd.copyWith(
                            color: colorScheme.error,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SearchInput extends StatefulWidget {
  const _SearchInput({
    required this.controller,
    required this.onChanged,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;

  @override
  State<_SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<_SearchInput> {
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChanged);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChanged);
    _focusNode.dispose();
    super.dispose();
  }

  void _handleFocusChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isFocused = _focusNode.hasFocus;

    return AnimatedContainer(
      height: 54,
      duration: const Duration(milliseconds: 140),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(AppCoreTokens.full),
        border: Border.all(
          color: isFocused
              ? colorScheme.primary
              : colorScheme.outlineVariant.withValues(alpha: 0.92),
          width: isFocused ? 1.4 : 1,
        ),
      ),
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
              child: Center(
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  onChanged: widget.onChanged,
                  onSubmitted: widget.onSubmitted,
                  textInputAction: TextInputAction.search,
                  maxLines: 1,
                  style: AppTypography.labelLg.copyWith(
                    color: colorScheme.onSurface,
                    letterSpacing: 0.4,
                  ),
                  cursorColor: colorScheme.primary,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Search and add songs here...',
                    hintStyle: AppTypography.labelLg.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      letterSpacing: 0.4,
                    ),
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

class _ResultsPanel extends StatelessWidget {
  const _ResultsPanel({
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
    final colorScheme = Theme.of(context).colorScheme;

    return QueueCard(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(queueCardRadius),
        child: Column(
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
                style: AppTypography.titleLg.copyWith(
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
            searchState.when(
              loading: () => const _PanelMessage(
                icon: null,
                title: 'Searching...',
                body: 'Finding tracks you can add to the queue.',
                loading: true,
              ),
              error: (error, stackTrace) => _PanelMessage(
                icon: LucideIcons.circleAlert,
                title: 'Search is unavailable',
                body: 'Check the backend search service and try again.',
                actionLabel: 'Retry',
                onAction: onRetry,
              ),
              data: (state) {
                if (!state.hasQuery) {
                  return const _PanelMessage(
                    icon: LucideIcons.search,
                    title: 'Start with a song, artist, or link',
                    body: 'Results from the search API will show up here.',
                  );
                }

                if (state.tracks.isEmpty) {
                  return _PanelMessage(
                    icon: LucideIcons.listMusic,
                    title: 'No results for "${state.query}"',
                    body: 'Try a different title, artist, or YouTube link.',
                  );
                }

                return Column(
                  children: [
                    for (var index = 0; index < state.tracks.length; index += 1)
                      _TrackSearchRow(
                        track: state.tracks[index],
                        index: index,
                        isAuthenticated: authState.isAuthenticated,
                        isQueued:
                            queueState.value?.containsSourceUrl(
                              state.tracks[index].sourceUrl,
                            ) ??
                            false,
                        isAdding:
                            queueState.value?.addingTrackIds.contains(
                              state.tracks[index].id,
                            ) ??
                            false,
                        onLogin: onLogin,
                        onAdd: () => onAdd(state.tracks[index]),
                      ),
                    const SizedBox(height: AppCoreTokens.xl * 4),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _TrackSearchRow extends StatelessWidget {
  const _TrackSearchRow({
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
              size: 76,
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
                          style: AppTypography.titleLg.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppCoreTokens.base),
                      SourceBadge(source: track.source),
                    ],
                  ),
                  const SizedBox(height: AppCoreTokens.xs),
                  Text(
                    track.artist ?? 'Unknown artist',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodyMd.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: AppCoreTokens.xs),
                  Text(
                    _sourceDescription(track.source),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.labelSm.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
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

  String _sourceDescription(String source) {
    return switch (source) {
      'youtube' => 'YouTube result',
      'spotify_metadata' => 'Spotify metadata',
      _ => 'Search result',
    };
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
      dimension: 58,
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
      dimension: 58,
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
