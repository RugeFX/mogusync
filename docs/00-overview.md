# MoguSync Overview

MoguSync is a mobile music controller app for Discord voice channels.

The mobile app acts as the controller, the backend is the source of truth, and the Discord bot is the audio playback agent inside Discord voice channels.

## Core Concept

User opens app → logs in with Discord → selects server and voice channel → bot joins → users control queue from app.

## Product Model

- App-first flow is primary.
- Discord slash commands are fallback.
- One active music session per Discord server.
- Multiple Discord servers can have active sessions at the same time.
- Queue, playback, voting, and DJ controls are synced in real time.

## Main Tabs

- Queue
- Search
- Servers
- Library
- Settings