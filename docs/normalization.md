# Functional dependencies & BCNF argument


## Tables and BCNF Proofs

**Schema:** USER(<u>user_id</u>, username)

**FDs:**
- user_id → username

**Closure:** {user_id}<sup>+</sup> = {user_id, username} → *user_id* is a **superkey**.

**Results**: username → user_id does not hold, since usernames can repeat. This table is normalized under BCNF conditions. 

---

**Schema:** GENRE(<u>genre_id</u>, genre_name)

**FDs:**
- genre_id → genre_name
- genre_name → genre_id

**Closures:** 
- {genre_id}<sup>+</sup> = {genre_id, genre_name} → *genre_id* is a **superkey**.
- {genre_name}<sup>+</sup> = {genre_name, genre_id} → *genre_name* is a **superkey**.

**Results**: Both genre_id and genre_name are both **minimal superkeys** and thus **GENRE** is in BCNF

---

**Schema:** SONG(<u>song_id</u>, song_name, album_id, length, genre_id)

**FDs:**
- song_id → song_name, album_id, length, genre_id

**Closures:** 
- {song_id}<sup>+</sup> = {song_id, song_name, album_id, length, genre_id} → *song_id* is a **superkey**.

**Notes**: album_id → genre_id is not a FD because a song may have a genre that is different from the genre of the album. Same with song_name → song_id or song_name → album_id, as it is possible for more than one song to have the same name or have the same name, but belong to different albums. This is why we are using ID's to uniquely categorize them. 

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

**Schema:** RATING(<u>user_id, song_id</u>, rating)

**FDs:**
- user_id, song_id→ rating

**Closure:** {user_id, song_id}<sup>+</sup> = {user_id, song_id, rating} → *user_id & song_id* are a **superkey**.

**Notes:** 
- **song_id → rating** does not hold. Two users can have two different ratings of the same song

- **user_id → rating** does not hold. One user can have different ratings for different songs.

- **rating → (*any attribute*)** does not hold. One rating can not determine which song was rated or which user rated it. 5 stars could belong to hundreds of songs. 

**Results**: Table is in BCNF



## Summary

The full schema is in BCNF because, for every relation, the determinant of each non-trivial functional dependency is a superkey of that relation.

- USER: user_id → username, and user_id is a superkey.

- GENRE: Both genre_id → genre_name and genre_name → genre_id have superkey determinants.

- SONG: song_id → song_name, album_id, length, genre_id and song_id is a superkey.

- ALBUM: album_id → album_name, made_by, release_date, is_single, and album_id is a superkey.

- ARTIST: artist_id → artist_name, and artist_id is a superkey.

- RATING: (user_id, song_id) → rating, and (user_id, song_id) is a superkey.

Therefore, no table needs to be decomposed or split to achieve BCNF. The schema as presented is already in BCNF.
