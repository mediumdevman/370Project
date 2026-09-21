# ERD — song logging & rating platform

```mermaid
erDiagram
  ARTIST ||--o{ ALBUM : releases
  ALBUM ||--o{ SONG : contains
  SONG ||--o{ SONG_GENRE : tagged_as
  GENRE ||--o{ SONG_GENRE : categorizes
  USER ||--o{ LOG : writes
  SONG ||--o{ LOG : logged_as
  USER ||--o{ LIST : creates
  LIST ||--o{ LIST_ITEM : contains
  SONG ||--o{ LIST_ITEM : included_in
  USER ||--o{ FOLLOW : follower
  USER ||--o{ FOLLOW : followee

  USER {
    int user_id PK
    string username
    string email
    string password_hash
    datetime joined_at
  }
  ARTIST {
    int artist_id PK
    string name
  }
  ALBUM {
    int album_id PK
    string title
    date release_date
    int artist_id FK
  }
  SONG {
    int song_id PK
    string title
    int duration_sec
    int album_id FK
  }
  GENRE {
    int genre_id PK
    string name
  }
  SONG_GENRE {
    int song_id PK
    int genre_id PK
  }
  LOG {
    int log_id PK
    int user_id FK
    int song_id FK
    int rating
    string review_text
    datetime logged_at
  }
  LIST {
    int list_id PK
    int user_id FK
    string title
    datetime created_at
  }
  LIST_ITEM {
    int list_id PK
    int song_id PK
    int position
  }
  FOLLOW {
    int follower_id PK
    int followee_id PK
  }
```

## Design notes

- **`LOG` is both a diary entry and a review.** A user can log the same
  song multiple times (`log_id` is its own surrogate key, not a composite
  of user+song), mirroring Letterboxd's "rewatch" diary entries. `rating`
  and `review_text` are both optional on top of the required listen event.
- **`SONG_GENRE` and `LIST_ITEM` are junction tables** resolving the two
  many-to-many relationships in the schema (song↔genre, list↔song).
  `LIST_ITEM.position` supports ranked lists (e.g. "top 10 songs of 2025").
- **`FOLLOW` is self-referencing on `USER`** (`follower_id`, `followee_id`)
  to model the social graph.
- Artist name and album title are *not* duplicated onto `SONG` — they're
  reached via `ALBUM.artist_id` and `SONG.album_id` respectively, which is
  what keeps the schema from having a transitive dependency (see
  `normalization.md`).

## Future work (next sprint — Advanced Relational Design)

- `LIKE` (user likes a `LOG`) and `COMMENT` (user comments on a `LOG`) —
  both straightforward junction/child tables on `LOG`.
- Indexing strategy for common queries (e.g. a user's diary feed, a song's
  average rating).
- Views for aggregate stats (e.g. average rating per song).
