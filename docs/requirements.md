# Requirements

This is what our song logging and rating system must store, and the rules
its data must follow. The ERD (`erd.md`), the schema (`../db/schemaV1.sql`),
and the BCNF proofs (`normalization.md`) are all derived from these. Each
requirement has an ID (R1, R2, ...) so design decisions can point back to it.

## Overview

Our system is a music catalogue that users can rate songs in, combining a
Spotify-style catalogue (artists, albums, songs, genres) with
Letterboxd-style personal ratings.

## Data requirements

What the system stores.

- **R1.** The system stores **users**. Each user has a unique ID and a
  username. Two users may have the same username.
- **R2.** The system stores **artists**. Each artist has a unique ID and a
  name. Two artists may have the same name (e.g. two bands called the same
  thing).
- **R3.** The system stores **albums**. Each album has a unique ID, a title,
  an optional release date, and a flag saying whether it is a single.
- **R4.** The system stores **songs**. Each song has a unique ID, a title, and
  a length in seconds.
- **R5.** The system stores **genres**. Each genre has a unique ID and a
  unique name (no two genres share a name).

## Relationship requirements

How the stored things connect, and how many of each can be involved.

- **R6.** Every album is released by **exactly one** artist. An artist can
  release **many** albums.
- **R7.** Every song belongs to **exactly one** album. An album can contain
  **many** songs.
- **R8.** Every song has **at most one** genre. A genre can apply to **many**
  songs.
- **R9.** A user can rate **many** songs, and a song can be rated by **many**
  users.

## Business rules

Constraints on the values themselves.

- **R10.** A user can rate a given song **at most once**. Changing a rating
  replaces the old one; it does not add a second rating.
- **R11.** A rating is a number from **0.5 to 5.0** in half-star steps.
- **R12.** A rating cannot exist for a user or a song that does not exist.
- **R13.** A song cannot reference an album that does not exist, and an album
  cannot reference an artist that does not exist.
- **R14.** Two albums by the same artist may have the same title (e.g. a
  single released ahead of a full album with the same name). They are
  separate releases.
- **R15.** Two songs may have the same title, including on different albums.

## Traceability

Where each requirement shows up in the design.

| Req | ERD | Schema (`schemaV1.sql`) | Normalization |
|---|---|---|---|
| R1 | `USER` entity | `USER`, `username` not `UNIQUE` | no `username → user_id` FD |
| R2 | `ARTIST` entity | `ARTIST`, `artist_name` not `UNIQUE` | no `artist_name → artist_id` FD |
| R3 | `ALBUM` entity | `ALBUM` | `album_id →` all attributes |
| R4 | `SONG` entity | `SONG` | `song_id →` all attributes |
| R5 | `GENRE` entity | `GENRE.genre_name UNIQUE` | `genre_name → genre_id` holds |
| R6 | one-to-many ARTIST–ALBUM | FK `ALBUM.made_by → ARTIST` | |
| R7 | one-to-many ALBUM–SONG | FK `SONG.album_id → ALBUM` | |
| R8 | one-to-many GENRE–SONG | FK `SONG.genre_id → GENRE` | |
| R9 | many-to-many USER–SONG | `RATING` table | |
| R10 | | `PRIMARY KEY (user_id, song_id)` on `RATING` | `(user_id, song_id) → rating` |
| R11 | | `CHECK` on `RATING.rating` | |
| R12 | | FKs on `RATING.user_id` and `RATING.song_id` | |
| R13 | | FKs on `SONG` and `ALBUM` | |
| R14 | | no `UNIQUE (made_by, album_name)` | `(made_by, album_name) → album_id` does not hold |
| R15 | | `SONG.song_name` not `UNIQUE` | `song_name → song_id` does not hold |

## Known limitations

Deliberate simplifications in the current design:

- **One genre per song (R8).** A song can't belong to several genres. Supporting
  that would replace `SONG.genre_id` with a `SONG_GENRE` junction table.
- **One artist per album (R6).** Collaborations and features can't be
  represented; each album has a single primary artist.
- **Track order isn't stored.** A song knows its album but not its position on
  it. A `TRACK` weak entity for this is planned for next sprint (see README).
- **No social features yet.** Users can rate songs but can't follow each other.
  A `FOLLOWS` relationship is planned for next sprint (see README).
