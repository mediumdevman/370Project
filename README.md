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

**Current limitation:** SONG_LOG can store and protect data, but it can't answer a single question a user would ask. After Sprint 1 there are 8 tables, constraints and tests, and zero queries. A rule from Sprint 1 also can't be enforced with a CHECK (release date not in the future). Genres are flat, so there is no way to say one genre is a sub-genre of another.

**Plan:** one setup goal, plus one goal for each module competency in Complex SQL Queries and Advanced SQL. Queries go in `db/queries.sql` with the expected output in a comment, and trigger tests go in `db/tests.sql`.

| # | Competency | Goal | How we measure it |
| --- | --- | --- | --- |
| S1 | Setup (conceptual design, roles) | **Sub-genres.** Add a `parent_genre_id` column to GENRE that points to another genre (e.g. Alternative Rock under Rock). Add 3 sub-genres to the seed and update the ERD. | Seed loads with 3 sub-genres; a sub-genre with a parent that doesn't exist is rejected |
| S2 | **Uses aggregation:** Creates an aggregation query with FD attributes and both WHERE and HAVING | Average rating per album: GROUP BY album_id and also show album_name (album_id → album_name), WHERE not a single, HAVING at least 3 ratings | Returns 5 albums: DAMN. 4.67, After Hours 4.25, Nevermind 4.25, Pablo Honey 4.17, 1989 3.70 |
| S3 | **Uses sub-queries:** Creates a sub-query to aggregate aggregations with existential condition | Average of the album averages, counting only albums where EXISTS a 5.0 rating | Returns 4.21 over 5 albums |
| S4 | **Uses SQL DML:** Inserts and deletes data based on complex query predicates | INSERT ... SELECT: user 5 follows every user they don't already follow. DELETE: remove ratings of songs that have no genre. | FOLLOWS goes from 8 to 10 rows, RATING from 23 to 22 |
| S5 | **Accelerates queries with indexes:** Accelerates a query or a uniqueness check with EXPLAIN and a non-primary index | Index on SONG(song_name) for searching by title | EXPLAIN goes from type ALL (13 rows) to type ref |
| S6 | **Simplifies queries:** Simplifies a complex query by converting a sub-query into a (outer?) join | "Songs nobody has rated" with NOT IN, then rewritten as a LEFT JOIN ... IS NULL (add 1 unrated song to the seed) | Both return the same song |
| S7 | **Uses triggers:** Enforces consistency by adding triggers to queries | One trigger that stops an album's release date being in the future (a CHECK couldn't do this in Sprint 1) | Inserting a future date fails, today's date works |
| S8 | **Embraces ternary logic:** Incorporate NULL's into queries with ternary predicate logic | Show how the NULL genre on song 14 changes results | `genre_id <> 1` returns 7 songs, adding `OR genre_id IS NULL` returns 8; COUNT(*) 13 vs COUNT(genre_id) 12 |

**Velocity:** we met all 8 Sprint 1 goals, and these 8 are smaller: most are a single query, so this is a realistic size.



## Setup

```bash
mysql -u root -p < db/schemaV1.sql
mysql -u root -p < db/seed.sql
mysql -u root -p --force -vvv SONG_LOG < db/tests.sql
```
