import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/mock_track_dto.dart';
import '../data/mock_tracks_repository.dart';

final mockTracksControllerProvider =
    AsyncNotifierProvider<MockTracksController, List<MockTrack>>(
      MockTracksController.new,
    );

class MockTracksController extends AsyncNotifier<List<MockTrack>> {
  @override
  Future<List<MockTrack>> build() async {
    return ref.read(mockTracksRepositoryProvider).fetchMockTracks();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(mockTracksRepositoryProvider).fetchMockTracks(),
    );
  }
}
