import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/mogusync_api_client.dart';
import '../../../core/state/app_providers.dart';
import 'track_search_dto.dart';

final trackSearchRepositoryProvider = Provider<TrackSearchRepository>((ref) {
  return TrackSearchRepository(ref.watch(mogusyncApiClientProvider));
});

class TrackSearchRepository {
  const TrackSearchRepository(this._apiClient);

  final MogusyncApiClient _apiClient;

  Future<List<TrackSearchResult>> searchTracks({
    required String query,
    int limit = 10,
  }) async {
    final safeLimit = limit.clamp(1, 10);
    final path = Uri(
      path: '/api/v1/tracks/search',
      queryParameters: {'query': query, 'limit': '$safeLimit'},
    ).toString();
    final json = await _apiClient.getJson(path);
    final tracks = json['tracks']! as List<Object?>;

    return tracks
        .map(
          (track) => TrackSearchResult.fromJson(track! as Map<String, Object?>),
        )
        .toList(growable: false);
  }
}
