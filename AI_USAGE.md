# Generative AI usage disclosure

Per course policy, this document tracks where and how generative AI was
used on this project, and how we ensured it did not substitute for our
own development of course competencies.

## Sprint 0

**Tool:** Claude (Anthropic), used through Claude Code in VS Code.

### Consistency review and fixes

After the team wrote the schema (`db/schemaV1.sql`) and the BCNF proofs
(`docs/normalization.md`), we used AI to check the repo for inconsistencies
between those files and to fix what it found:

- **Foreign key bug.** `SONG` declared `FOREIGN KEY (genre)` after the column
had been renamed to `genre_id`, so the script would fail. Fixed to
`genre_id`.
- **Missing constraints.** The schema had no `NOT NULL`, `UNIQUE` or `CHECK`
constraints, even though our requirements and BCNF proofs assume them.
Added `NOT NULL` on required fields, `UNIQUE` on `GENRE.name` (needed for
the `name → genre_id` dependency), and a `CHECK` limiting ratings to
0.5–5.0 in half steps.
- **Name mismatches.** `normalization.md` still used old table and column
names (`GENRES`, `SONGS`, `ALBUMS`, `album_by`, `ARTISTS.name`). Updated them
to match the schema (`GENRE`, `SONG`, `ALBUM`, `made_by`,
`ARTIST.artist_name`).
- Used to create test Data in seed.sql for the video Submission demonstrating the schema



### Other uses

- Explaining database concepts (DDL vs. DML, how a `.sql` file runs against a
MySQL server, what an ERD is).
- Drafting `docs/requirements.md` from our existing schema and BCNF proofs.
The "Open decisions" section lists design choices the team still has to
make itself.



### How this did not replace our own learning

The design work this sprint is graded on was done by the team: choosing the
entities, writing the table definitions, and writing the functional
dependency and BCNF argument for each table. The AI acted as a reviewer. It
pointed out where our files disagreed with each other, and we reviewed every
change before committing it. Decisions about what the system should model
(for example, whether a song can have more than one genre) are left to the
team.