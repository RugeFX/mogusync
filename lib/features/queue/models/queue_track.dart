class QueueTrack {
  const QueueTrack({
    required this.title,
    required this.artist,
    required this.source,
    required this.duration,
    required this.requestedBy,
    this.thumbnailUrl,
    this.requesterAvatarUrl,
  });

  final String title;
  final String artist;
  final String source;
  final Duration duration;
  final String requestedBy;
  final String? thumbnailUrl;
  final String? requesterAvatarUrl;
}
