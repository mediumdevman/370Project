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
- AI updated seed.sql to match the new TRACK design



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
## Sprint 1

**Tool:** Claude (Anthropic)

### What we used it for

- Reviewing our schema and writing the named CHECK constraints and ON DELETE rules. The team picked the rules (what cascades and what is blocked).
- Writing `db/tests.sql` to test each constraint and delete rule. We ran it ourselves and checked every result.
- Drafting `docs/design_quality.md`, `docs/requirements.md` updates and README fixes from our existing design.
- Drafting the Sprint 2 plan from the Brightspace competencies. The team chose the goals, including sub-genres.
- Explaining MySQL and git errors.
- Updating `seed.sql` to match the new TRACK design.

### How this did not replace our own learning

The design decisions this sprint were made by the team: adding TRACK as a weak entity, removing album_id from SONG, designing FOLLOWS with roles, and choosing the ON DELETE rules. We reviewed every AI change before committing it and can explain each constraint and test.

## Sprint 2

**Tool:** Claude (Anthropic)

### What we used it for

- Explaining SQL concepts and helping troubleshoot MySQL errors, particularly with aggregation, subqueries, `INSERT ... SELECT`, `DELETE`, indexes, triggers, and NULL handling.
- Reviewing our implementation of the sub-genre functionality, including the self-referencing `parent_genre_id` foreign key, `ON DELETE RESTRICT` rule, and CHECK constraint preventing a genre from being its own parent.
- Reviewing the queries for each Sprint 2 competency, including album rating averages, existential subqueries, conditional inserts and deletes, query optimization, and NULL handling.
- Helping test triggers that prevent albums from having future release dates, including triggers for both INSERT and UPDATE operations.
- Reviewing our proposed response to TA feedback about song artists and compilation albums. We used AI to check our implementation of the `SONG_ARTIST` relationship, allowing songs to have their own primary and featured artists independently of the album artist.
- Helping update supporting documentation, including the ERD, BCNF proofs, requirements, design quality report, and test cases to reflect the Sprint 2 changes.

### How this did not replace our own learning

The team made the design decisions and determined how each competency would be demonstrated. In particular, the decision to introduce `SONG_ARTIST` came from our own evaluation of the TA's feedback and our existing database design. The team chose the relationship structure, primary and featured artist roles, and the associated foreign key and deletion rules.

AI was used to explain SQL concepts, check our implementation, review queries and constraints, and troubleshoot errors. We reviewed the suggested changes, ran the SQL scripts and tests ourselves, and checked the results against our expected outputs. The team remains responsible for understanding the queries, database design, and implementation decisions demonstrated in this submission.