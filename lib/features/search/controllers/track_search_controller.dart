import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/track_search_dto.dart';
import '../data/track_search_repository.dart';

final trackSearchControllerProvider =
    AsyncNotifierProvider<TrackSearchController, TrackSearchState>(
      TrackSearchController.new,
    );

class TrackSearchState {
  const TrackSearchState({required this.query, required this.tracks});

  const TrackSearchState.empty() : query = '', tracks = const [];

  final String query;
  final List<TrackSearchResult> tracks;

  bool get hasQuery => query.trim().isNotEmpty;
}

class TrackSearchController extends AsyncNotifier<TrackSearchState> {
  int _searchGeneration = 0;

  @override
  Future<TrackSearchState> build() async {
    return const TrackSearchState.empty();
  }

  Future<void> search(String query) async {
    final normalizedQuery = query.trim();
    final generation = ++_searchGeneration;

    if (normalizedQuery.isEmpty) {
      state = const AsyncData(TrackSearchState.empty());
      return;
    }

    if (normalizedQuery.length > 200) {
      state = AsyncError(
        ArgumentError('Search query must be 200 characters or fewer.'),
        StackTrace.current,
      );
      return;
    }

    state = const AsyncLoading();
    final result = await AsyncValue.guard(() async {
      final tracks = await ref
          .read(trackSearchRepositoryProvider)
          .searchTracks(query: normalizedQuery);
      return TrackSearchState(query: normalizedQuery, tracks: tracks);
    });

    if (generation == _searchGeneration) {
      state = result;
    }
  }

  Future<void> refresh() async {
    final currentQuery = state.value?.query;
    if (currentQuery == null || currentQuery.trim().isEmpty) {
      return;
    }

    await search(currentQuery);
  }
}
