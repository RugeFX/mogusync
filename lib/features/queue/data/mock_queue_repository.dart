import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/mogusync_api_client.dart';
import '../../../core/state/app_providers.dart';
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
}
