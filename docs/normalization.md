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

**Result:** Since song_id is a **superkey** and the only non-trivial FD in the table, **SONGS** is in BCNF

**Notes**: album_id → genre is not a FD because a song may have a genre that is different from the genre of the album. Same with name → song_id or name → album_id, as it is possible for more than one song to have the same name or have the same name, but belong to different albums. This is why we are using ID's to uniquely catagorize them. 


## Summary

Once every table is written up above, state the overall conclusion here:
is the full schema in BCNF? Did any table need to be split into two to
get there?
