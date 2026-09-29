# Project Kickoff 

Hello, 

This is a file to document the development of our CSC370 Database Porject. This is the entry for Project Kick-Off/Sprint 0. It contains the rational for our design choices and serves a supplementary document to our video. It is also a place for us to take notes

## Team | Group 8 

- Zach Zhao, Maren Dunn, Jackson MacNeil

## Repo structure

- `db/schemaV1.sql` — SQL DDL for the relational schema used in our project
- `docs/erd.md` — entity-relationship diagram and design notes
- `docs/normalization.md` — functional dependency and BCNF reasoning
- `AI_USAGE.md` — disclosure of generative AI use on this project

## Sprint status

### Sprint 0 (this submission)

**Goals:**
- Demonstrate conceptual + relational schema design (Data Architecture
  competency, Level 2)
- Build a complete ERD and implement it as a normalized (BCNF) relational
  database with SQL DDL

**Status:** design in progress — see `docs/erd.md`, `docs/normalization.md`,
and `db/schemaV1.sql` (currently outlines/templates for the team to fill in).

### Next Sprint (1)

Planned scope/features for Sprint 1:
- TBD

## Setup

```bash
mysql -u root -p < db/schemaV1.sql
```
