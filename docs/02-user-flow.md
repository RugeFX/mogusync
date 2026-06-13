# User Flow

## First-Time User Flow

1. User opens MoguSync.
2. User taps Login with Discord.
3. App redirects to Discord OAuth.
4. User authorizes app.
5. App opens Servers tab.
6. User selects a Discord server.
7. If bot is not installed, user taps Add Bot.
8. User installs bot through Discord.
9. User returns to app.
10. User selects a voice channel.
11. App requests backend to connect the bot.
12. Bot joins the voice channel.
13. App opens Queue tab.

## Returning User With Active Session

1. User opens app.
2. Backend checks active sessions.
3. If active session exists, app opens Queue tab.
4. User controls playback or queue.

## Returning User Without Active Session

1. User opens app.
2. No active session found.
3. App opens Servers tab.
4. User chooses server/channel.

## Add Saved Track to Queue

1. User opens Library.
2. User selects Saved Tracks.
3. User taps a saved track.
4. User taps Add to Queue.
5. App sends request to Backend API.
6. Backend validates active session and queue rules.
7. Backend adds the track to the session queue.
8. Realtime queue update is sent to all users.

## Add Server Playlist to Queue

1. User opens Library.
2. User selects Server Playlists.
3. User selects a playlist for the current Discord server.
4. User taps Add All to Queue or Shuffle into Queue.
5. Backend validates that the user can add tracks to the session.
6. Backend expands playlist items into queue items.
7. Queue is updated in realtime.

## Save Track

1. User sees a track in Search, Queue, or Recently Played.
2. User taps Save.
3. Backend stores the track reference under the user account.
4. Track appears in Saved Tracks.

## Recently Played Flow

1. Bot finishes or skips a track.
2. Backend records the track into play history.
3. User opens Library.
4. User sees the track in Recently Played.
5. User can save or add it again.