class ActiveSession {
  const ActiveSession({
    required this.guildName,
    required this.voiceChannelName,
    required this.listenerCount,
    required this.connected,
  });

  final String guildName;
  final String voiceChannelName;
  final int listenerCount;
  final bool connected;
}
