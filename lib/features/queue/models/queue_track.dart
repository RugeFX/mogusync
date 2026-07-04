class QueueTrack {
  const QueueTrack({
    required this.id,
    required this.title,
    required this.artist,
    required this.source,
    required this.duration,
    required this.requestedBy,
    this.position = 0,
    this.sourceUrl,
    this.thumbnailUrl,
    this.requesterAvatarUrl,
  });

  final String id;
  final String title;
  final String artist;
  final String source;
  final Duration duration;
  final String requestedBy;
  final int position;
  final String? sourceUrl;
  final String? thumbnailUrl;
  final String? requesterAvatarUrl;
}
