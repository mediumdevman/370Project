# Functional dependencies & BCNF argument

For each table in `db/schemaV1.sql`, list its functional dependencies (FDs)
and confirm every determinant is a candidate key — that's the definition
of BCNF (Boyce-Codd Normal Form).

### Delete b4 Submit
**bold**, *italic*, `inline code` 

## Tables and BCNF Proofs

**Schema:** USER(<u>user_id</u>, username)

**FDs:**
- user_id → username

**Closure:** {user_id}<sup>+</sup> = {user_id, username} → *user_id* is a **superkey**.

**Results**: username → user_id does not hold, since usernames can repeat. This table is normalized under BCNF conditions. 

---

**Schema:** GENRES(<u>genre_id</u>, genre)

**FDs:**
- genre_id → name
- name → genre_id

**Closures:** 
- {genre_id}<sup>+</sup> = {genre_id, name} → *genre_id* is a **superkey**.
- {name}<sup>+</sup> = {name, genre_id} → *name* is a **superkey**.

**Results**: Both genre_id and name are both **minimal superkeys** and thus **GENRES** is in BCNF

---

**Schema:** SONGS(<u>song_id</u>, name, album_id, length, genre)

**FDs:**
- song_id → name, album_id, length, genre

**Closures:** 
- {song_id}<sup>+</sup> = {song_id, name, album_id, length, genre} → *song_id* is a **superkey**.

**Notes**: album_id → genre is not a FD because a song may have a genre that is different from the genre of the album. Same with name → song_id or name → album_id, as it is possible for more than one song to have the same name or have the same name, but belong to different albums. This is why we are using ID's to uniquely catagorize them. 

**Result:** Since song_id is a **superkey** and the only non-trivial FD in the table, **SONGS** is in BCNF

---

**Schema:** ALBUMS(<u>album_id</u>, name, album_by, release_date, is_single)

**FDs:**
- album_id → name, album_by, release_date, is_single

**Closures:** 
- {album_id}<sup>+</sup> = {album_id, name, album_by, release_date, is_single} → *album_id* is a **superkey**.

**Notes**: 
- **name** → (*other attributes*) does not hold as more than one album can have the same name, hence unique album_ids. 

- **album_by** (which is an artist_id) → (*other attributes*) does not hold as artists may have multiple albums. 

- (**album_by**, **name**) → **album_id** does not hold. 
  - Ex:  **a1** = (0001, AlbumA, 0132, 2026-01-01, TRUE) could be as a single titled 'AlbumA', released ahead of an album. A month later **a2** = (0002, AlbumA, 0132, 2026-02-01, FALSE) is created. These are two sepearte releases and should be treated as such, even if they have the same name. 
 
Thus **album_id** → *name, album_by, release_date, is_single* is the only non-trivial FD.

**Result:** Since album_id is a **superkey** and the only non-trivial FD in the table, **ALBUMS** is in BCNF

---

**Schema:** ARTISTS(<u>artist_id</u>, name)

**FDs:**
- artist_id → name

**Closure:** {artist_id}<sup>+</sup> = {artist_id, name} → *artist_id* is a **superkey**.

**Results**: name → artist_id does not hold, since band/artists names can repeat. This table is in BCNF. 

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

Once every table is written up above, state the overall conclusion here:
is the full schema in BCNF? Did any table need to be split into two to
get there?
