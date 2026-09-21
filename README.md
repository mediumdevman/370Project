# [Project name TBD] — a song logging & rating platform

CSC 370 course project — an information system backed by a MySQL database,
inspired by Letterboxd but for songs: users log listens, rate and review
tracks, build ranked lists, and follow each other.

## Team

- Group 8
- Member names / GitHub usernames: TBD

## Repo structure

- `db/schema.sql` — SQL DDL for the relational schema
- `docs/erd.md` — entity-relationship diagram and design notes
- `docs/normalization.md` — functional dependency and BCNF reasoning
- `AI_USAGE.md` — disclosure of generative AI use on this project

## Sprint status

### Sprint 1 (this submission)

**Goals:**
- Demonstrate conceptual + relational schema design (Data Architecture
  competency, Level 2)
- Build a complete ERD and implement it as a normalized (BCNF) relational
  database with SQL DDL

**Evidence:** see `docs/erd.md`, `docs/normalization.md`, and `db/schema.sql`.

### Next sprint

Planned scope: Advanced Relational Design. See `docs/erd.md` for the
"future work" section outlining what's planned (likes/comments on logs,
indexing strategy, etc.).

## Setup

```bash
mysql -u root -p < db/schema.sql
```
