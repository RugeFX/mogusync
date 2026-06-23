class NowPlayingTrack {
  const NowPlayingTrack({
    required this.title,
    required this.artist,
    required this.source,
    required this.duration,
    required this.position,
    this.thumbnailUrl,
  });

  final String title;
  final String artist;
  final String source;
  final Duration duration;
  final Duration position;
  final String? thumbnailUrl;
}
