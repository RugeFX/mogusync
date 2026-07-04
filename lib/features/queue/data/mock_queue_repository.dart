import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/mogusync_api_client.dart';
import '../../../core/state/app_providers.dart';
import '../../search/data/track_search_dto.dart';
import 'queue_dto.dart';

final mockQueueRepositoryProvider = Provider<MockQueueRepository>((ref) {
  return MockQueueRepository(ref.watch(mogusyncApiClientProvider));
});

class MockQueueRepository {
  const MockQueueRepository(this._apiClient);

  final MogusyncApiClient _apiClient;

  Future<QueueResponse> fetchMockQueue({required String accessToken}) async {
    final json = await _apiClient.getJson(
      '/api/v1/sessions/mock/queue',
      accessToken: accessToken,
    );
    return QueueResponse.fromJson(json);
  }

  Future<QueueItem> addMockTrackToQueue({
    required String trackId,
    required String accessToken,
  }) async {
    final json = await _apiClient.postJson(
      '/api/v1/sessions/mock/queue',
      accessToken: accessToken,
      body: {'trackId': trackId},
    );

    return QueueItem.fromJson(json);
  }

  Future<QueueItem> addSearchTrackToQueue({
    required TrackSearchResult track,
    required String accessToken,
  }) async {
    final json = await _apiClient.postJson(
      '/api/v1/sessions/mock/queue',
      accessToken: accessToken,
      body: {'track': track.toJson()},
    );

    return QueueItem.fromJson(json);
  }

  Future<QueueResponse> clearMockQueue({required String accessToken}) async {
    final json = await _apiClient.deleteJson(
      '/api/v1/sessions/mock/queue',
      accessToken: accessToken,
    );

    return QueueResponse.fromJson(json);
  }

  Future<QueueResponse> removeMockQueueItem({
    required String queueItemId,
    required String accessToken,
  }) async {
    final json = await _apiClient.deleteJson(
      '/api/v1/sessions/mock/queue/$queueItemId',
      accessToken: accessToken,
    );

    return QueueResponse.fromJson(json);
  }

  Future<QueueResponse> reorderMockQueueItem({
    required String queueItemId,
    required int position,
    required String accessToken,
  }) async {
    final json = await _apiClient.patchJson(
      '/api/v1/sessions/mock/queue/$queueItemId',
      accessToken: accessToken,
      body: {'position': position},
    );

    return QueueResponse.fromJson(json);
  }

  Future<PlaybackResponse> fetchMockPlayback({
    required String accessToken,
  }) async {
    final json = await _apiClient.getJson(
      '/api/v1/sessions/mock/playback',
      accessToken: accessToken,
    );

    return PlaybackResponse.fromJson(json);
  }

  Future<PlaybackResponse> skipMockPlayback({
    required String accessToken,
  }) async {
    final json = await _apiClient.postJson(
      '/api/v1/sessions/mock/playback/skip',
      accessToken: accessToken,
    );

    return PlaybackResponse.fromJson(json);
  }
}
