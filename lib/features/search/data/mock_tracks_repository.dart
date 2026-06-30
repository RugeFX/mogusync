import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/mogusync_api_client.dart';
import '../../../core/state/app_providers.dart';
import 'mock_track_dto.dart';

final mockTracksRepositoryProvider = Provider<MockTracksRepository>((ref) {
  return MockTracksRepository(ref.watch(mogusyncApiClientProvider));
});

class MockTracksRepository {
  const MockTracksRepository(this._apiClient);

  final MogusyncApiClient _apiClient;

  Future<List<MockTrack>> fetchMockTracks() async {
    final json = await _apiClient.getJson('/api/v1/tracks/mock');
    final tracks = json['tracks']! as List<Object?>;

    return tracks
        .map((track) => MockTrack.fromJson(track! as Map<String, Object?>))
        .toList(growable: false);
  }
}
