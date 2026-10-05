# Project Kickoff

Hello, 

This is a file to document the development of our CSC370 Database Porject. This is the entry for Project Kick-Off/Sprint 0. It contains the rational for our design choices and serves a supplementary document to our video. It is also a place for us to take notes

## Team | Group 8

- Zachary Zhao, Maren Dunn, Jackson MacNeil

## Repo structure

- `db/schemaV1.sql` — SQL DDL for the relational schema used in our project
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

**Status:** design in progress — see `docs/erd.md`, `docs/normalization.md`,
and `db/schemaV1.sql` (currently outlines/templates for the team to fill in).

### Next Sprint (2)

Planned scope/features for Sprint 1:

- Introduce a weak entity set 'Tracks' that enables us to determine the order of tracks on an album. This is a weak data set because the songID and albumID both have meaning, but track# is  nothing unless it is paired with an album. 
  - Update ERD to include this double boxed table and its relationship with the Album table (double diamond). In this case Track# is the partial key. 
  - Update the DDL to include the changes in the ERD
  - Decide if the Song Table needs to include album_ID or if we can just give it Track# and then use a new relationship to determine a songs album.
- If we learn of ways to enfoce data restrictions, update the SchemaV1.sql file to include these restrictions. 
- Design a 'Follows' table that could model different Roles and M:M relationships in our data base. We will use Roles, which connect conceptual logic (an ARD element). We will use a composite primary key that consists of two unique user_ids's. 
  - Update the ERD to include the new table and relationships (Between tables and the user themselves)
  - Update the DDL to reflect the ERD changes
  - Test sample data and edge cases  
  - Introduce/Code a check that makes sure a user cannot follow themselves or the same person multiple times.
- Check our ERD and DDL against the 'good design' princicples in the textbook/lecture. 
  - Check against faithfulness, avoiding redundancy, simplicity, correct relationships. 
  - If we find our ERD fails any of these conditions we will make changes so that moving forward it does not.
  - Also checking any new elements of our ERD/DDL against these qualities.
- Finally make sure that any an all new tables have clear FDs and are in BCNF.



## Setup

```bash
mysql -u root -p < db/schemaV1.sql
```

