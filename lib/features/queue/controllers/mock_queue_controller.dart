import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/notifications/notification_providers.dart';
import '../../auth/auth_controller.dart';
import '../../search/data/track_search_dto.dart';
import '../data/mock_queue_repository.dart';
import '../data/queue_dto.dart';

final mockQueueControllerProvider =
    AsyncNotifierProvider<MockQueueController, MockQueueState>(
      MockQueueController.new,
    );

class MockQueueState {
  const MockQueueState({
    required this.sessionId,
    required this.items,
    this.nowPlaying,
    this.upcoming = const [],
    this.isPlaying = false,
    this.addingTrackIds = const {},
    this.actionError,
  });

  const MockQueueState.empty()
    : sessionId = null,
      items = const [],
      nowPlaying = null,
      upcoming = const [],
      isPlaying = false,
      addingTrackIds = const {},
      actionError = null;

  final String? sessionId;
  final List<QueueItem> items;
  final QueueItem? nowPlaying;
  final List<QueueItem> upcoming;
  final bool isPlaying;
  final Set<String> addingTrackIds;
  final String? actionError;

  bool containsMockTrack(String trackId) {
    return items.any((item) => item.sourceUrl == 'mock://tracks/$trackId');
  }

  bool containsSourceUrl(String sourceUrl) {
    return items.any((item) => item.sourceUrl == sourceUrl);
  }

  MockQueueState copyWith({
    String? sessionId,
    List<QueueItem>? items,
    Object? nowPlaying = _unset,
    List<QueueItem>? upcoming,
    bool? isPlaying,
    Set<String>? addingTrackIds,
    String? actionError,
    bool clearActionError = false,
  }) {
    return MockQueueState(
      sessionId: sessionId ?? this.sessionId,
      items: items ?? this.items,
      nowPlaying: identical(nowPlaying, _unset)
          ? this.nowPlaying
          : nowPlaying as QueueItem?,
      upcoming: upcoming ?? this.upcoming,
      isPlaying: isPlaying ?? this.isPlaying,
      addingTrackIds: addingTrackIds ?? this.addingTrackIds,
      actionError: clearActionError ? null : actionError ?? this.actionError,
    );
  }
}

const _unset = Object();

class MockQueueController extends AsyncNotifier<MockQueueState> {
  @override
  Future<MockQueueState> build() async {
    final authState = ref.watch(authControllerProvider);
    final token = authState.accessToken;

    if (token == null) {
      return const MockQueueState.empty();
    }

    return _fetchQueueAndPlayback(token);
  }

  Future<void> refresh() async {
    final token = _accessTokenOrNull();
    if (token == null) {
      state = const AsyncData(MockQueueState.empty());
      return;
    }

    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchQueueAndPlayback(token));
  }

  Future<void> addTrack({
    required String trackId,
    required String trackTitle,
  }) async {
    final token = _accessTokenOrNull();
    if (token == null) {
      await ref.read(authControllerProvider.notifier).handleUnauthorized();
      return;
    }

    final currentState = state.value ?? const MockQueueState.empty();
    state = AsyncData(
      currentState.copyWith(
        addingTrackIds: {...currentState.addingTrackIds, trackId},
        clearActionError: true,
      ),
    );

    try {
      await ref
          .read(mockQueueRepositoryProvider)
          .addMockTrackToQueue(trackId: trackId, accessToken: token);
      final nextState = await _fetchQueueAndPlayback(token);
      state = AsyncData(nextState);
      await ref
          .read(localNotificationServiceProvider)
          .showTrackAdded(trackTitle: trackTitle);
    } on ApiException catch (error) {
      if (error.isUnauthorized) {
        await ref.read(authControllerProvider.notifier).handleUnauthorized();
        state = const AsyncData(MockQueueState.empty());
        return;
      }

      state = AsyncData(
        currentState.copyWith(
          addingTrackIds: currentState.addingTrackIds.difference({trackId}),
          actionError: error.message,
        ),
      );
    } catch (_) {
      state = AsyncData(
        currentState.copyWith(
          addingTrackIds: currentState.addingTrackIds.difference({trackId}),
          actionError: 'Unable to add track. Please try again.',
        ),
      );
    }
  }

  Future<void> addSearchResult(TrackSearchResult track) async {
    final token = _accessTokenOrNull();
    if (token == null) {
      await ref.read(authControllerProvider.notifier).handleUnauthorized();
      return;
    }

    final currentState = state.value ?? const MockQueueState.empty();
    state = AsyncData(
      currentState.copyWith(
        addingTrackIds: {...currentState.addingTrackIds, track.id},
        clearActionError: true,
      ),
    );

    try {
      await ref
          .read(mockQueueRepositoryProvider)
          .addSearchTrackToQueue(track: track, accessToken: token);
      final nextState = await _fetchQueueAndPlayback(token);
      state = AsyncData(nextState);
      await ref
          .read(localNotificationServiceProvider)
          .showTrackAdded(trackTitle: track.title);
    } on ApiException catch (error) {
      if (error.isUnauthorized) {
        await ref.read(authControllerProvider.notifier).handleUnauthorized();
        state = const AsyncData(MockQueueState.empty());
        return;
      }

      state = AsyncData(
        currentState.copyWith(
          addingTrackIds: currentState.addingTrackIds.difference({track.id}),
          actionError: error.message,
        ),
      );
    } catch (_) {
      state = AsyncData(
        currentState.copyWith(
          addingTrackIds: currentState.addingTrackIds.difference({track.id}),
          actionError: 'Unable to add track. Please try again.',
        ),
      );
    }
  }

  Future<void> clearQueue() async {
    await _runQueueMutation(
      fallbackMessage: 'Unable to clear queue. Please try again.',
      mutation: (repository, token) {
        return repository.clearMockQueue(accessToken: token);
      },
    );
  }

  Future<void> removeTrack({required String queueItemId}) async {
    await _runQueueMutation(
      fallbackMessage: 'Unable to remove track. Please try again.',
      mutation: (repository, token) {
        return repository.removeMockQueueItem(
          queueItemId: queueItemId,
          accessToken: token,
        );
      },
    );
  }

  Future<void> moveTrack({
    required String queueItemId,
    required int position,
  }) async {
    await _runQueueMutation(
      fallbackMessage: 'Unable to reorder queue. Please try again.',
      mutation: (repository, token) {
        return repository.reorderMockQueueItem(
          queueItemId: queueItemId,
          position: position,
          accessToken: token,
        );
      },
    );
  }

  Future<void> skipPlayback() async {
    final token = _accessTokenOrNull();
    if (token == null) {
      await ref.read(authControllerProvider.notifier).handleUnauthorized();
      return;
    }

    final currentState = state.value ?? const MockQueueState.empty();
    state = AsyncData(currentState.copyWith(clearActionError: true));

    try {
      await ref
          .read(mockQueueRepositoryProvider)
          .skipMockPlayback(accessToken: token);
      final nextState = await _fetchQueueAndPlayback(token);
      state = AsyncData(nextState);
    } on ApiException catch (error) {
      if (error.isUnauthorized) {
        await ref.read(authControllerProvider.notifier).handleUnauthorized();
        state = const AsyncData(MockQueueState.empty());
        return;
      }

      state = AsyncData(currentState.copyWith(actionError: error.message));
    } catch (_) {
      state = AsyncData(
        currentState.copyWith(
          actionError: 'Unable to skip track. Please try again.',
        ),
      );
    }
  }

  String? _accessTokenOrNull() {
    return ref.read(authControllerProvider).accessToken;
  }

  Future<void> _runQueueMutation({
    required Future<QueueResponse> Function(
      MockQueueRepository repository,
      String token,
    )
    mutation,
    required String fallbackMessage,
  }) async {
    final token = _accessTokenOrNull();
    if (token == null) {
      await ref.read(authControllerProvider.notifier).handleUnauthorized();
      return;
    }

    final currentState = state.value ?? const MockQueueState.empty();
    state = AsyncData(currentState.copyWith(clearActionError: true));

    try {
      await mutation(ref.read(mockQueueRepositoryProvider), token);
      final nextState = await _fetchQueueAndPlayback(token);
      state = AsyncData(nextState);
    } on ApiException catch (error) {
      if (error.isUnauthorized) {
        await ref.read(authControllerProvider.notifier).handleUnauthorized();
        state = const AsyncData(MockQueueState.empty());
        return;
      }

      state = AsyncData(currentState.copyWith(actionError: error.message));
    } catch (_) {
      state = AsyncData(currentState.copyWith(actionError: fallbackMessage));
    }
  }

  Future<MockQueueState> _fetchQueueAndPlayback(String token) async {
    try {
      final repository = ref.read(mockQueueRepositoryProvider);
      final queueResponse = await repository.fetchMockQueue(accessToken: token);
      final playbackResponse = await repository.fetchMockPlayback(
        accessToken: token,
      );

      return MockQueueState(
        sessionId: playbackResponse.sessionId,
        items: queueResponse.items,
        nowPlaying: playbackResponse.nowPlaying,
        upcoming: playbackResponse.upcoming,
        isPlaying: playbackResponse.isPlaying,
      );
    } on ApiException catch (error) {
      if (error.isUnauthorized) {
        await ref.read(authControllerProvider.notifier).handleUnauthorized();
        return const MockQueueState.empty();
      }

      rethrow;
    }
  }
}
