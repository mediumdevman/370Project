# SONG_LOG

Hello, 

This is a file to document the development of our CSC370 Database Project. It contains the rationale for our design choices, our sprint goals and our plan for the next sprint, and serves as a supplementary document to our videos. It is also a place for us to take notes.

## Team | Group 8

- Zachary Zhao, Maren Dunn, Jackson MacNeil

## Repo structure

- `db/schemaV1.sql` — SQL DDL for the relational schema used in our project
- `db/seed.sql` — sample data for demoing the schema
- `db/tests.sql` — tests for every constraint and ON DELETE rule
- `docs/erd.md` — entity-relationship diagram and design notes
- `docs/normalization.md` — functional dependency and BCNF reasoning
- `docs/requirements.md` — requirements and where each one shows up in the design
- `docs/design_quality.md` — design principles review and multiplicity assumptions
- `AI_USAGE.md` — disclosure of generative AI use on this project



## Sprint status



### Sprint 0 (done)

**Goals:**

- Demonstrate conceptual + relational schema design (Data Architecture
competency, Level 2)
- Build a complete ERD and implement it as a normalized (BCNF) relational
database with SQL DDL

### Sprint 1 (this submission)

**Goals:**

- Introduce a weak entity set 'Tracks' that enables us to determine the order of tracks on an album. This is a weak entity set because the songID and albumID both have meaning, but track# is nothing unless it is paired with an album. 
  - Update ERD to include this double boxed table and its relationship with the Album table (double diamond). In this case Track# is the partial key. 
  - Update the DDL to include the changes in the ERD
  - Decide if the Song Table needs to include album_ID or if we can just give it Track# and then use a new relationship to determine a songs album.
- If we learn of ways to enforce data restrictions, update the SchemaV1.sql file to include these restrictions. 
- Design a 'Follows' table that could model different Roles and M:M relationships in our data base. We will use Roles, which connect conceptual logic (an ARD element). We will use a composite primary key that consists of two unique user_ids's. 
  - Update the ERD to include the new table and relationships (Between tables and the user themselves)
  - Update the DDL to reflect the ERD changes
  - Test sample data and edge cases  
  - Introduce/Code a check that makes sure a user cannot follow themselves or the same person multiple times.
- Check our ERD and DDL against the 'good design' principles in the textbook/lecture. 
  - Check against faithfulness, avoiding redundancy, simplicity, correct relationships. 
  - If we find our ERD fails any of these conditions we will make changes so that moving forward it does not.
  - Also checking any new elements of our ERD/DDL against these qualities.
- Finally make sure that any and all new tables have clear FDs and are in BCNF.

**TA feedback from Sprint 0:**

- Have at least 8 tables
- State the assumptions behind our multiplicities
- Decide what happens on delete for every foreign key
- Write down our functional dependencies

**Status:** all goals met.

- TRACK weak entity added, SONG no longer stores album_id so a song can be on many albums (`db/schemaV1.sql`, `docs/erd.md`, `docs/ERDv2.png`)
- FOLLOWS added with follower and followed roles, self follows and duplicate follows are blocked
- New CHECK constraints (names can't be blank, length > 0, track number > 0) and ON DELETE rules on every foreign key, all tested in `db/tests.sql`
- Design review and multiplicity assumptions in `docs/design_quality.md`
- FDs and BCNF proofs for TRACK and FOLLOWS in `docs/normalization.md`
- 8 tables total

### Sprint 2 (next)

**Current limitation:** SONG_LOG can store and protect data, but it can't answer a single question a user would ask. After Sprint 1 there are 8 tables, constraints and tests, and zero queries. Genres are also flat, so there is no way to say that one genre is a sub-genre of another.

| # | Goal | Lecture | How we measure it |
| --- | --- | --- | --- |
| S1 | **Sub-genres.** Add a "subgenre of" relationship from GENRE to itself, with parent and child roles (e.g. Alternative Rock is a subgenre of Rock). Update the ERD, DDL and seed data. | 05 Multiplicity (roles, self-referencing relationship), 04 Conceptual Design | Seed has at least 3 sub-genres. Inserting a genre as its own parent fails, and inserting a parent that doesn't exist fails. |
| S2 | **FDs and normal forms for the new design.** FDs and a BCNF proof for the updated GENRE, plus a minimal basis and a 3NF check (prime attributes) for every table. | 06 FDs & Keys, 07 BCNF, 12 Projecting FDs, 23 3NF | `normalization.md` has a section per table with its minimal basis. GENRE, which has two keys, is shown to be in BCNF and 3NF. |
| S3 | **4NF check.** Show in writing why putting genres and artists for a song in one table, SONG_INFO(song, genre, artist), would have MVDs (song ↠ genre, song ↠ artist) and break 4NF, and why our separate tables don't. | 24 4NF & MVDs | A worked example in `normalization.md` using seed songs, showing the repeated rows and the 4NF decomposition |
| S4 | **Basic queries.** A `db/queries.sql` that answers 4 user questions with SELECT, WHERE and ORDER BY, e.g. "songs longer than 5 minutes, longest first". Each query also written in relational algebra (σ, π, ρ). | 03 SQL DQL, 08 Relational Algebra | Every query runs, and its output matches the expected rows written in a comment above it |
| S5 | **Join queries.** Use joins to answer: "every track with its song, album and artist", "every sub-genre with its parent genre" (a self-join with renaming), and "ratings by the people user 1 follows". | 03 SQL DQL (×, ⋈, theta join, ρ) | Track listing returns all 14 tracks; the feed for user 1 shows only ratings by users 2 and 3; the sub-genre query matches the seed |
| S6 | **Set queries.** Use union, intersection and difference, e.g. "songs rated by both user 1 and user 2" and "users who rated a Taylor Swift song but not a Radiohead song". | 03 SQL DQL (∪, ∩, −) | Each result matches the answer worked out by hand in relational algebra |

**Velocity:** we met all 8 Sprint 1 goals, so 6 goals is a reasonable size for Sprint 2.



## Setup

```bash
mysql -u root -p < db/schemaV1.sql
mysql -u root -p < db/seed.sql
mysql -u root -p --force -vvv SONG_LOG < db/tests.sql
```
