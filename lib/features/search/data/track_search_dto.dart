class TrackSearchResult {
  const TrackSearchResult({
    required this.id,
    required this.source,
    required this.sourceUrl,
    required this.title,
    this.artist,
    this.coverImageUrl,
    this.durationMs,
  });

  factory TrackSearchResult.fromJson(Map<String, Object?> json) {
    return TrackSearchResult(
      id: json['id'] as String,
      source: json['source'] as String,
      sourceUrl: json['sourceUrl'] as String,
      title: json['title'] as String,
      artist: json['artist'] as String?,
      coverImageUrl: json['coverImageUrl'] as String?,
      durationMs: json['durationMs'] as int?,
    );
  }

  final String id;
  final String source;
  final String sourceUrl;
  final String title;
  final String? artist;
  final String? coverImageUrl;
  final int? durationMs;

  Duration? get duration {
    final durationMs = this.durationMs;
    if (durationMs == null) {
      return null;
    }

    return Duration(milliseconds: durationMs);
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'source': source,
      'sourceUrl': sourceUrl,
      'title': title,
      'artist': artist,
      'coverImageUrl': coverImageUrl,
      'durationMs': durationMs,
    };
  }
}
