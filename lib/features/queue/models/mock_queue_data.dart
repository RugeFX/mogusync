import 'active_session.dart';
import 'now_playing_track.dart';
import 'queue_track.dart';

abstract final class MockQueueData {
  static const activeSession = ActiveSession(
    guildName: 'Chill Squad',
    voiceChannelName: 'LoFi Room',
    listenerCount: 6,
    connected: true,
  );

  static const nowPlaying = NowPlayingTrack(
    title: 'Night Drive',
    artist: 'YOASOBI',
    source: 'YouTube',
    position: Duration(minutes: 2, seconds: 15),
    duration: Duration(minutes: 4, seconds: 21),
  );

  static const upcomingTracks = [
    QueueTrack(
      id: 'mock-starry-days',
      title: 'Starry Days',
      artist: 'Kano',
      source: 'YouTube',
      duration: Duration(minutes: 3, seconds: 18),
      requestedBy: 'Nyanters',
    ),
    QueueTrack(
      id: 'mock-coffee-shop',
      title: 'Coffee Shop',
      artist: 'BGM channel',
      source: 'YouTube',
      duration: Duration(minutes: 2, seconds: 45),
      requestedBy: 'Okiaya',
    ),
    QueueTrack(
      id: 'mock-marigold',
      title: 'Marigold',
      artist: 'Aimyon',
      source: 'YouTube',
      duration: Duration(minutes: 4, seconds: 2),
      requestedBy: 'Shion',
    ),
    QueueTrack(
      id: 'mock-anemone',
      title: 'Anemone',
      artist: 'Ryuusa',
      source: 'YouTube',
      duration: Duration(minutes: 3, seconds: 36),
      requestedBy: 'Koorne',
    ),
    QueueTrack(
      id: 'mock-rainy-day',
      title: 'Rainy Day',
      artist: 'Chillhop',
      source: 'YouTube',
      duration: Duration(minutes: 2, seconds: 58),
      requestedBy: 'Mio',
    ),
    QueueTrack(
      id: 'mock-twilight',
      title: 'Twilight',
      artist: 'Aimer',
      source: 'YouTube',
      duration: Duration(minutes: 4, seconds: 11),
      requestedBy: 'Fubuki',
    ),
  ];
}
