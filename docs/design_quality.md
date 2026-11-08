# Design Quality Review

Sprint 1 goal G7, updated in Sprint 2. We checked our ERD and schema against the Batini design criteria from lecture 10, Improving Conceptual Designs (completeness, correctness, minimality, expressiveness, readability, self-explanation, extensibility, normality). For each one we wrote down what we found and whether we changed anything.

## Multiplicity assumptions

The TA asked us to state the assumptions behind our multiplicities so the design can be checked against them.

| Relationship | Multiplicity | Assumption |
| --- | --- | --- |
| Rates (User - Song) | many to many | a user can rate many songs and a song can be rated by many users, but only once per user (R10) |
| Follows (User - User) | many to many | a user can follow many users and be followed by many users, but not themselves and not the same person twice |
| Categorizes (Song - Genre) | many to one | a song has at most one main genre (R8), a genre has many songs |
| Made by (Album - Artist) | many to one | an album has exactly one album artist (R6), the credit for the release as a whole, which is "Various Artists" for a compilation. An artist can have many albums |
| Performed by (Song - Artist) | many to many | a song has one or more credited artists (primary or featured) and an artist can be credited on many songs, but only once per song. "At least one artist per song" is not enforced by the schema (see finding 8) |
| Contains (Track - Album) | many to one | a track belongs to exactly one album, an album has many tracks |
| Represents (Track - Song) | many to one | a track is exactly one song, a song can be a track on many albums |

## Findings

### 1. Minimality: the same song stored twice (changed, Sprint 1)

In Sprint 0 every song had one album_id. The After Hours single and the After Hours album both have the song After Hours, so we had to store it as two SONG rows (ids 4 and 7) with the same name, length and genre. That is redundant. If the length was fixed in one row the other would be wrong, and ratings were split between the two copies.

Change: we removed album_id from SONG and added the TRACK weak entity set. Now After Hours is one song (id 4) with two tracks, track 1 on the single and track 13 on the album. Song 7 was removed from the seed data and its rating was moved to song 4.

### 2. Expressiveness: release hierarchy, dangling subs (rejected, Sprint 1)

We thought about a Release entity with Album and Single as subclasses (inheritance). Album and Single have the exact same attributes and relationships, so the subclasses would add extra tables and joins without storing anything new. We kept one ALBUM table with an is_single flag instead.

### 3. Correctness: Artist and Genre as entities, not attributes (kept)

Artist has to be an entity and not just an attribute on Album because two different bands can have the same name (we have two bands called Nirvana, R2). Genre only has a name, so it could have been an attribute on Song, but making it an entity keeps one shared list of genres and stops typos like "Pop" and "pop" becoming different genres (genre_name is UNIQUE).

### 4. Correctness: Rates and Follows as relationships (kept)

A rating has no meaning on its own without a user and a song, so Rates is a relationship with a rating attribute and not its own entity. Follows is the same, it only connects two users, so it is a relationship with follower and followed roles and followed_at as a relationship attribute.

### 5. Completeness: one artist per album (kept, partly resolved in Sprint 2)

Every album has exactly one album artist. This matches our requirements. In Sprint 1 this was also the only way to get an artist for a song, so we could not show collaborations or features, and we listed it as a known limitation in requirements.md.

Sprint 2 update: the song-level part of this limitation is fixed by finding 6. The album-level part is still true and intended, an album has one album artist, and a compilation uses "Various Artists" rather than a list of artists on the album.

### 6. Correctness: a song's artist was only reachable through its album (changed, Sprint 2)

In Sprint 1 the only path from a song to an artist was Song, Track, Album, Made by, Artist. That says a song's artist is whoever made the album it appears on. This is wrong for a compilation: if Blinding Lights (The Weeknd) is on a compilation made by Various Artists, our design would say the song is by Various Artists. It is also wrong for songs with featured artists, and for a song that appears on several albums by different artists.

Change: we added the relationship Performed by between Song and Artist. It is many to many, and it has one attribute, role (primary or featured). In the schema it is the SONG_ARTIST table with primary key (song_id, artist_id). Made by is unchanged in the schema, but it now means the album artist.

The seed data shows the case: album 9 "Greatest Pop Hits" is made by Various Artists, and it has Blinding Lights (The Weeknd) and Blank Space (Taylor Swift) as tracks. These are existing songs, so no song is duplicated. A query can now give both answers separately, who made the album and who the song is by.

We rejected putting artist_id directly on SONG. It would be simpler, but it allows only one artist per song, so features and collaborations would be impossible again.

### 7. Minimality: album artist and song artist can overlap (kept, Sprint 2)

For a normal album, the album artist and the song's primary artist are the same person, so the same fact is stored twice (once in ALBUM.made_by and once in SONG_ARTIST). We checked whether one could be derived from the other. It can't: they are different facts. The album artist is the credit for the release, and the song artist is the credit for the song, and they differ on compilations. Because of that we kept both. The cost is that the two can disagree on a normal album (for example, if someone enters the wrong artist on one of them), and the schema does not check this.

### 8. Expressiveness: what we kept off Performed by, and what it can't say (rejected / known limitation, Sprint 2)

- artist_order (rejected). It would let us show multiple artists in a fixed order. We only needed it for display, it needed an extra UNIQUE (song_id, artist_order) constraint, and nothing in our requirements asks for credit order. Without it, the display order of two featured artists on the same song is undefined.
- role as a separate lookup table (rejected). Role has two values, so we used an ENUM('primary', 'featured') with a default of 'primary'. The trade-off is that adding a role later such as producer needs an ALTER TABLE, and ENUM is MySQL-specific.
- Total participation of Song in Performed by (known limitation). Every song should have at least one artist, but a plain constraint can't enforce it because the song row has to exist before its SONG_ARTIST row. This would have to be checked by the application, so the schema allows a song with no artist.

## Second pass on the new parts

- TRACK: a weak entity makes sense here because a track number like "track 3" means nothing without its album. Its key is (album_id, track_number). We didn't give it its own track_id since that would hide that a track depends on its album.
- FOLLOWS: no redundancy, the only extra attribute is followed_at which depends on the whole key. Self follows and duplicate follows are blocked by a CHECK and the primary key.
- SONG_ARTIST (normality): the only non-key attribute is role, and it depends on the whole key (song_id, artist_id), since it describes how that artist is involved in that song. There is no partial dependency, so it is in 3NF and BCNF. The primary key stops the same artist being credited twice on one song, so an artist can't be both primary and featured on the same song.
- SONG_ARTIST (delete behavior): deleting a song deletes its credits (CASCADE), because a credit means nothing without the song. Deleting an artist who is credited on a song is blocked (RESTRICT), the same as for artists with albums, so a credit can't point at a missing artist.