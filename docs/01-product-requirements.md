# Product Requirements

## App Name

MoguSync

## Format

Mobile app built with Flutter.

## Target User

Discord users who want to control a shared music bot through a polished mobile app instead of only slash commands.

## Core Features

### Authentication

Users log in with Discord OAuth.

### Server Selection

Users can see Discord servers where:
- MoguSync is installed
- MoguSync is not installed
- user lacks permission
- an active music session exists

### Voice Channel Connection

Users can select a Discord voice channel and connect the bot.

### Queue Control

Users can:
- view current track
- add songs
- vote skip
- view upcoming queue

### DJ Controls

Users with DJ role/admin permission can:
- reorder queue
- clear queue
- shuffle queue
- move bot channel
- disconnect bot
- configure server settings

### Music Sources

Supported source types:
- YouTube search/link
- Local Mogu object storage/library

## Library

The Library page provides reusable music references that users can quickly add back into a Discord music session.

The Library is not responsible for local file storage in the MVP.

### MVP Library Sections

#### Server Playlists

Server playlists are reusable track collections attached to a Discord server.

Users can:

- view server playlists
- open playlist details
- add a playlist to the current queue
- shuffle a playlist into the current queue

DJ/admin users can:

- create server playlists
- edit server playlists
- remove tracks from server playlists
- delete server playlists

#### Saved Tracks / Favorites

Saved tracks are user-specific music references.

Users can:

- save a track
- remove a saved track
- add a saved track to the active queue

#### Recently Played

Recently played shows tracks that were played in previous sessions.

Users can:

- add a recently played track back to the queue
- save a recently played track
- see which server/session the track was played in

### Out of Scope

The following are not part of the MVP Library:

- Local Mogu file browser
- Audio uploads
- Object storage folders
- Server-hosted audio management