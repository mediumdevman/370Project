# Design Quality Review

Sprint 1 goal G7. We checked our ERD and schema against the Batini design criteria from lecture 10, Improving Conceptual Designs (completeness, correctness, minimality, expressiveness, readability, self-explanation, extensibility, normality). For each one we wrote down what we found and whether we changed anything.

## Multiplicity assumptions

The TA asked us to state the assumptions behind our multiplicities so the design can be checked against them.

| Relationship | Multiplicity | Assumption |
| --- | --- | --- |
| Rates (User - Song) | many to many | a user can rate many songs and a song can be rated by many users, but only once per user (R10) |
| Follows (User - User) | many to many | a user can follow many users and be followed by many users, but not themselves and not the same person twice |
| Categorizes (Song - Genre) | many to one | a song has at most one main genre (R8), a genre has many songs |
| Made by (Album - Artist) | many to one | an album has exactly one main artist (R6), an artist can have many albums |
| Contains (Track - Album) | many to one | a track belongs to exactly one album, an album has many tracks |
| Represents (Track - Song) | many to one | a track is exactly one song, a song can be a track on many albums |

## Findings

### 1. Minimality: the same song stored twice (changed)

In Sprint 0 every song had one album_id. The After Hours single and the After Hours album both have the song After Hours, so we had to store it as two SONG rows (ids 4 and 7) with the same name, length and genre. That is redundant. If the length was fixed in one row the other would be wrong, and ratings were split between the two copies.

Change: we removed album_id from SONG and added the TRACK weak entity set. Now After Hours is one song (id 4) with two tracks, track 1 on the single and track 13 on the album. Song 7 was removed from the seed data and its rating was moved to song 4.

### 2. Expressiveness: release hierarchy, dangling subs (rejected)

We thought about a Release entity with Album and Single as subclasses (inheritance). Album and Single have the exact same attributes and relationships, so the subclasses would add extra tables and joins without storing anything new. We kept one ALBUM table with an is_single flag instead.

### 3. Correctness: Artist and Genre as entities, not attributes (kept)

Artist has to be an entity and not just an attribute on Album because two different bands can have the same name (we have two bands called Nirvana, R2). Genre only has a name, so it could have been an attribute on Song, but making it an entity keeps one shared list of genres and stops typos like "Pop" and "pop" becoming different genres (genre_name is UNIQUE).

### 4. Correctness: Rates and Follows as relationships (kept)

A rating has no meaning on its own without a user and a song, so Rates is a relationship with a rating attribute and not its own entity. Follows is the same, it only connects two users, so it is a relationship with follower and followed roles and followed_at as a relationship attribute.

### 5. Completeness: one artist per album (kept, known limitation)

Every album has exactly one artist. This matches our requirements but it can't show collaborations or features. We kept it to stay simple for now and listed it as a known limitation in requirements.md.

## Second pass on the new parts

- TRACK: a weak entity makes sense here because a track number like "track 3" means nothing without its album. Its key is (album_id, track_number). We didn't give it its own track_id since that would hide that a track depends on its album.
- FOLLOWS: no redundancy, the only extra attribute is followed_at which depends on the whole key. Self follows and duplicate follows are blocked by a CHECK and the primary key.
