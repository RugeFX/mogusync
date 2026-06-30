class MockTrack {
  const MockTrack({
    required this.id,
    required this.source,
    required this.sourceUrl,
    required this.title,
    required this.artist,
    required this.coverImageUrl,
    required this.durationMs,
  });

  factory MockTrack.fromJson(Map<String, Object?> json) {
    return MockTrack(
      id: json['id'] as String,
      source: json['source'] as String,
      sourceUrl: json['sourceUrl'] as String,
      title: json['title'] as String,
      artist: json['artist'] as String,
      coverImageUrl: json['coverImageUrl'] as String,
      durationMs: json['durationMs'] as int,
    );
  }

  final String id;
  final String source;
  final String sourceUrl;
  final String title;
  final String artist;
  final String coverImageUrl;
  final int durationMs;

  Duration get duration => Duration(milliseconds: durationMs);
}
