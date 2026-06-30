class QueueItem {
  const QueueItem({
    required this.id,
    required this.sessionId,
    required this.requestedByUserId,
    required this.source,
    required this.sourceUrl,
    required this.title,
    required this.position,
    required this.status,
    this.artist,
    this.coverImageUrl,
    this.durationMs,
  });

  factory QueueItem.fromJson(Map<String, Object?> json) {
    return QueueItem(
      id: json['id'] as String,
      sessionId: json['sessionId'] as String,
      requestedByUserId: json['requestedByUserId'] as String,
      source: json['source'] as String,
      sourceUrl: json['sourceUrl'] as String,
      title: json['title'] as String,
      artist: json['artist'] as String?,
      coverImageUrl: json['coverImageUrl'] as String?,
      durationMs: json['durationMs'] as int?,
      position: json['position'] as int,
      status: json['status'] as String,
    );
  }

  final String id;
  final String sessionId;
  final String requestedByUserId;
  final String source;
  final String sourceUrl;
  final String title;
  final String? artist;
  final String? coverImageUrl;
  final int? durationMs;
  final int position;
  final String status;

  Duration get duration => Duration(milliseconds: durationMs ?? 0);
}

class QueueResponse {
  const QueueResponse({required this.sessionId, required this.items});

  factory QueueResponse.fromJson(Map<String, Object?> json) {
    final rawItems = json['items']! as List<Object?>;

    return QueueResponse(
      sessionId: json['sessionId'] as String,
      items: rawItems
          .map((item) => QueueItem.fromJson(item! as Map<String, Object?>))
          .toList(growable: false),
    );
  }

  final String sessionId;
  final List<QueueItem> items;
}
