# Functional dependencies & BCNF argument

For each table, we list its functional dependencies (FDs) and confirm
every determinant is a candidate key — the definition of BCNF.

## USER

FD: `user_id -> username, email, password_hash, joined_at`

`user_id` is the only determinant, and it is the primary key. BCNF holds.

## ARTIST

FD: `artist_id -> name`

BCNF holds trivially (single non-key attribute, one determinant).

## ALBUM

FD: `album_id -> title, release_date, artist_id`

`album_id` is the sole key and sole determinant. Note we do **not** store
`artist_name` here — pulling it would require going through `artist_id`,
which would be a transitive dependency (`album_id -> artist_id -> name`)
and violate 3NF, let alone BCNF.

## SONG

FD: `song_id -> title, duration_sec, album_id`

Same reasoning as `ALBUM`: no artist/album title duplicated here, avoiding
a transitive dependency through `album_id`.

## GENRE

FD: `genre_id -> name`

Trivial, BCNF holds.

## SONG_GENRE (junction table)

Composite PK: `(song_id, genre_id)`. There are no non-key attributes, so
there are no non-trivial FDs to check — BCNF holds vacuously.

## LOG

FD: `log_id -> user_id, song_id, rating, review_text, logged_at`

`log_id` is a surrogate key introduced specifically so that a
`(user_id, song_id)` pair is *not* forced to be unique — a user can log
the same song more than once (diary re-listens). Since `log_id` is the
only determinant and it's the key, BCNF holds.

If we had instead used `(user_id, song_id)` as the PK, we'd be unable to
represent repeat listens, and we'd risk `rating`/`review_text` depending
on the full composite (fine) but the design would silently forbid a valid
real-world case a user re-logging the same track. This is why the FD
analysis matters beyond just "is it normalized" — it also validates the
key choice against requirements.

## LIST

FD: `list_id -> user_id, title, created_at`

`list_id` sole key and determinant. BCNF holds.

## LIST_ITEM (junction table)

Composite PK: `(list_id, song_id)`. Non-key attribute: `position`.

FD: `(list_id, song_id) -> position`

The only determinant is the full composite key, which is the actual key
of the table — BCNF holds. (`position` cannot be determined by `list_id`
alone or `song_id` alone.)

## FOLLOW (junction table)

Composite PK: `(follower_id, followee_id)`. No non-key attributes — BCNF
holds vacuously, same as `SONG_GENRE`.

## Summary

Every table's only determinants are its own (candidate) key, so the
entire schema is in BCNF. No table stores a fact that depends on
anything less than its full primary key, and no non-key attribute
determines another non-key attribute.
