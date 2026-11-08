# Functional dependencies & BCNF argument


## Tables and BCNF Proofs

**Schema:** USER(<u>user_id</u>, username)

**FDs:**
- user_id → username

**Closure:** {user_id}<sup>+</sup> = {user_id, username} → *user_id* is a **superkey**.

**Results**: username → user_id does not hold, since usernames can repeat. This table is normalized under BCNF conditions. 

---

**Schema:** GENRE(<u>genre_id</u>, genre_name, parent_genre_id)

**FDs:**
- genre_id → genre_name, parent_genre_id
- genre_name → genre_id, parent_genre_id

**Closures:** 
- {genre_id}<sup>+</sup> = {genre_id, genre_name, parent_genre_id} → *genre_id* is a **superkey**.
- {genre_name}<sup>+</sup> = {genre_name, genre_id, parent_genre_id} → *genre_name* is a **superkey**.

**Notes**:
parent_genre_id → genre_id or parent_genre_id → genre_name do not hold as a parent_genre_id can be shared by more than 1 
genre. Soft Rock (8) and Punk Rock (9) both have parent 2, therefore parent_genre_id = 2 is paired with two different genres, Soft Rock and Punk Rock. 

**Results**: every FD’s left side is a key, so GENRE is still in BCNF

---

**Schema:** SONG(<u>song_id</u>, song_name, length, genre_id)

**FDs:**
- song_id → song_name, length, genre_id

**Closures:** 
- {song_id}<sup>+</sup> = {song_id, song_name, length, genre_id} → *song_id* is a **superkey**.

**Notes**: song_name → song_id does not hold, since more than one song can have the same name (e.g. two different songs called Creep). This is why we are using ID's to uniquely categorize them. 

**Result:** Since song_id is a **superkey** and the only non-trivial FD in the table, **SONG** is in BCNF

---

**Schema:** ALBUM(<u>album_id</u>, album_name, made_by, release_date, is_single)

**FDs:**
- album_id → album_name, made_by, release_date, is_single

**Closures:** 
- {album_id}<sup>+</sup> = {album_id, album_name, made_by, release_date, is_single} → *album_id* is a **superkey**.

**Notes**: 
- **album_name** → (*other attributes*) does not hold as more than one album can have the same name, hence unique album_ids. 

- **made_by** (which is an artist_id) → (*other attributes*) does not hold as artists may have multiple albums. 

- (**made_by**, **album_name**) → **album_id** does not hold. 
  - Ex:  **a1** = (0001, AlbumA, 0132, 2026-01-01, TRUE) could be as a single titled 'AlbumA', released ahead of an album. A month later **a2** = (0002, AlbumA, 0132, 2026-02-01, FALSE) is created. These are two separate releases and should be treated as such, even if they have the same name. 
 
Thus **album_id** → *album_name, made_by, release_date, is_single* is the only non-trivial FD.

**Result:** Since album_id is a **superkey** and the only non-trivial FD in the table, **ALBUM** is in BCNF

---

**Schema:** ARTIST(<u>artist_id</u>, artist_name)

**FDs:**
- artist_id → artist_name

**Closure:** {artist_id}<sup>+</sup> = {artist_id, artist_name} → *artist_id* is a **superkey**.

**Results**: artist_name → artist_id does not hold, since band/artists names can repeat. This table is in BCNF. 

---

**Schema:** SONG_ARTIST(<u>song_id, artist_id</u>, role)
 
**FDs:**
- song_id, artist_id → role

**Closure:** {song_id, artist_id}<sup>+</sup> = {song_id, artist_id, role} → *song_id & artist_id* are a **superkey**.
 
**Notes:**
- **song_id → role** does not hold. A song can have more than one credited artist with different roles. e.g. in tests.sql song 1 is credited to artist 1 as primary and to artist 2 as featured, so song_id 1 has two different roles.
- **artist_id → role** does not hold. One artist can be primary on one song and featured on another. e.g. in tests.sql artist 2 is featured on song 1 (1, 2, featured) and primary on song 2 (2, 2, primary).
- **song_id → artist_id** and **artist_id → song_id** do not hold. A song can have several artists and an artist can be credited on several songs, which is why this is a many to many relationship and why both ids are needed in the key.
- **role → (*any attribute*)** does not hold. Many songs and many artists share the same role value, so role cannot determine which song or which artist it belongs to.
- role is the only non-key attribute, and it depends on the whole key. It describes how that artist is involved in that song, so it can't be determined by either id alone.

**Results**: Since (song_id, artist_id) is a superkey and the only non-trivial FD in the table, SONG_ARTIST is in BCNF.
 
---

**Schema:** RATING(<u>user_id, song_id</u>, rating)

**FDs:**
- user_id, song_id→ rating

**Closure:** {user_id, song_id}<sup>+</sup> = {user_id, song_id, rating} → *user_id & song_id* are a **superkey**.

**Notes:** 
- **song_id → rating** does not hold. Two users can have two different ratings of the same song

- **user_id → rating** does not hold. One user can have different ratings for different songs.

- **rating → (*any attribute*)** does not hold. One rating can not determine which song was rated or which user rated it. 5 stars could belong to hundreds of songs. 

**Results**: Table is in BCNF

---

**Schema:** TRACK(<u>album_id, track_number</u>, song_id)

**FDs:**
- album_id, track_number → song_id
- album_id, song_id → track_number

**Closure:** 
1. {album_id, track_number}<sup>+</sup> = {album_id, track_number, song_id} 
2. {album_id, song_id}<sup>+</sup> = {album_id, track_number, song_id} 

- *(album_id, track_number)* and *(album_id, song_id)* are **keys** as they are both minimal and determine all attributes of TRACK. {album_id}⁺, {track_number}⁺, and {song_id}⁺ each contain only themselves, so no single attribute is a superkey.

**Notes:** 
- **song_id → track_number** does not hold. A song can be released as a single at one point and then as a track on an album at another point. e.g. song 4 appears as (2, 1, 4) and (3, 13, 4), so the same song_id has track numbers 1 and 13.

- **album_id → track_number or song_id** does not hold. One album has multiple tracks/songs, so a single album_id cannot yield an individual track/song from an album. e.g. album 3 has (3, 9, 5), (3, 11, 6), and (3, 13, 4), so one album_id has three different track numbers and three different songs.

- **song_id → album_id** does not hold. Song 4 is on album 2 (track 1) and album 3 (track 13), so a song_id will point you two places which is why it can't FD a single album_id.

- **track_number → (*any attribute*)** does not hold. Many albums have many songs therefore many albums have many track numbers. e.g. (2, 1, 4) and (7, 1, 12) are both track 1, but on different albums with different songs.

**Results**: Both {album_id, track_number} and {album_id, song_id} are keys, so TRACK is in BCNF.

---

**Schema:** FOLLOWS(<u>follower_id, followed_id</u>, followed_at)

**FDs:**
- follower_id, followed_id → followed_at

**Closure:** {follower_id, followed_id}<sup>+</sup> = {follower_id, followed_id, followed_at} → *follower_id & followed_id* are a **superkey**.

**Notes:**
- **follower_id → followed_at** does not hold, since a user can follow multiple users at different times.
- **followed_id → followed_at** does not hold, since a user can be followed by multiple users at different times.
- **followed_at → (follower_id, followed_id)** does not hold, since multiple follow relationships can be recorded at the same timestamp.
- Neither **follower_id → followed_id** nor **followed_id → follower_id** holds, since a user can follow multiple users and can also be followed by multiple users.

**Results:** Since (follower_id, followed_id) is a superkey and the only non-trivial FD in the table, FOLLOWS is in BCNF.

---

## Summary

The full schema is in BCNF because, for every relation, the determinant of each non-trivial functional dependency is a superkey of that relation.

- USER: user_id → username, and user_id is a superkey.

- GENRE: Both genre_id → genre_name, parent_genre_id and genre_name → genre_id, parent_genre_id are keys.

- SONG: song_id → song_name, length, genre_id and song_id is a superkey.

- ALBUM: album_id → album_name, made_by, release_date, is_single, and album_id is a superkey.

- ARTIST: artist_id → artist_name, and artist_id is a superkey.

- SONG_ARTIST: (song_id, artist_id) → role, and (song_id, artist_id) is a superkey.

- RATING: (user_id, song_id) → rating, and (user_id, song_id) is a superkey.

- TRACK: (album_id, track_number) → song_id and (album_id, song_id) → track_number. Both (album_id, track_number) and (album_id, song_id) are keys (and therefore superkeys).

- FOLLOWS: (follower_id, followed_id) -> followed_at and (follower_id, followed_id) is a superkey

Therefore, no table needs to be decomposed or split to achieve BCNF. The schema as presented is already in BCNF. 
Since every relation in BCNF is also in 3NF, all tables in the schema are also in 3NF.
