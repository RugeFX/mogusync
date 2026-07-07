import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_routes.dart';
import '../../core/theme/app_tokens.dart';
import '../auth/auth_controller.dart';
import '../queue/controllers/mock_queue_controller.dart';
import 'controllers/track_search_controller.dart';
import 'widgets/search_input.dart';
import 'widgets/search_results_panel.dart';

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
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppCoreTokens.marginMobile,
                  AppCoreTokens.md,
                  AppCoreTokens.marginMobile,
                  0,
                ),
                sliver: SliverToBoxAdapter(
                  child: SearchInput(
                    controller: _queryController,
                    onChanged: _handleQueryChanged,
                    onSubmitted: (value) => ref
                        .read(trackSearchControllerProvider.notifier)
                        .search(value),
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: AppCoreTokens.gutter),
              ),
              SearchResultsPanelSliver(
                searchState: searchState,
                queueState: queueState,
                authState: authState,
                onRetry: _refresh,
                onLogin: () => context.go(AppRoutes.login),
                onAdd: (track) => ref
                    .read(mockQueueControllerProvider.notifier)
                    .addSearchResult(track),
              ),
              if (queueState.value?.actionError != null)
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    AppCoreTokens.marginMobile,
                    AppCoreTokens.base,
                    AppCoreTokens.marginMobile,
                    AppCoreTokens.md,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      queueState.value!.actionError!,
                      style: AppTypography.bodyMd.copyWith(
                        color: colorScheme.error,
                      ),
                    ),
                  ),
                )
              else
                const SliverToBoxAdapter(
                  child: SizedBox(height: AppCoreTokens.md),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
