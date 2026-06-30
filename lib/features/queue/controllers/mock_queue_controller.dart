import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_exception.dart';
import '../../auth/auth_controller.dart';
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
    this.addingTrackIds = const {},
    this.actionError,
  });

  const MockQueueState.empty()
    : sessionId = null,
      items = const [],
      addingTrackIds = const {},
      actionError = null;

  final String? sessionId;
  final List<QueueItem> items;
  final Set<String> addingTrackIds;
  final String? actionError;

  bool containsMockTrack(String trackId) {
    return items.any((item) => item.sourceUrl == 'mock://tracks/$trackId');
  }

  MockQueueState copyWith({
    String? sessionId,
    List<QueueItem>? items,
    Set<String>? addingTrackIds,
    String? actionError,
    bool clearActionError = false,
  }) {
    return MockQueueState(
      sessionId: sessionId ?? this.sessionId,
      items: items ?? this.items,
      addingTrackIds: addingTrackIds ?? this.addingTrackIds,
      actionError: clearActionError ? null : actionError ?? this.actionError,
    );
  }
}

class MockQueueController extends AsyncNotifier<MockQueueState> {
  @override
  Future<MockQueueState> build() async {
    final authState = ref.watch(authControllerProvider);
    final token = authState.accessToken;

    if (token == null) {
      return const MockQueueState.empty();
    }

    return _fetchQueue(token);
  }

  Future<void> refresh() async {
    final token = _accessTokenOrNull();
    if (token == null) {
      state = const AsyncData(MockQueueState.empty());
      return;
    }

    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchQueue(token));
  }

  Future<void> addTrack(String trackId) async {
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
      final nextState = await _fetchQueue(token);
      state = AsyncData(nextState);
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

  String? _accessTokenOrNull() {
    return ref.read(authControllerProvider).accessToken;
  }

  Future<MockQueueState> _fetchQueue(String token) async {
    try {
      final response = await ref
          .read(mockQueueRepositoryProvider)
          .fetchMockQueue(accessToken: token);
      return MockQueueState(
        sessionId: response.sessionId,
        items: response.items,
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
