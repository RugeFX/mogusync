```mermaid
flowchart TD
  User[Discord User] --> MoguSync[MoguSync System]
  Admin[Server Admin / DJ] --> MoguSync

  MoguSync --> DiscordOAuth[Discord OAuth]
  MoguSync --> DiscordAPI[Discord API]
  MoguSync --> DiscordVoice[Discord Voice Channels]
  MoguSync --> SearchProvider[YouTube / Search Provider]
  MoguSync --> ObjectStorage[Local Mogu Object Storage]
```