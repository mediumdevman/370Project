-- [Project name TBD] — schema DDL
-- See docs/erd.md and docs/normalization.md for design rationale.
--
-- Fill in the blanks below once the team has drawn the ERD and worked
-- out the normalization argument. The structure/pattern is sketched out;
-- the actual entities, columns, and relationships are TBD.

CREATE DATABASE IF NOT EXISTS TBD;
USE TBD;

-- ── Core entity tables ──────────────────────────────────────────────
-- One CREATE TABLE per "thing" the system tracks (an entity from the ERD).
-- Every table needs a primary key (PK) — usually a surrogate
-- AUTO_INCREMENT id, unless there's a natural key.

CREATE TABLE ENTITY_ONE (
    entity_one_id INT AUTO_INCREMENT PRIMARY KEY
    -- TODO: columns
);

CREATE TABLE ENTITY_TWO (
    entity_two_id INT AUTO_INCREMENT PRIMARY KEY
    -- TODO: columns
);

-- ── One-to-many relationship (FK on the "many" side) ────────────────
-- e.g. if many ENTITY_TWO rows each belong to exactly one ENTITY_ONE:

CREATE TABLE ENTITY_THREE (
    entity_three_id INT AUTO_INCREMENT PRIMARY KEY,
    -- TODO: columns
    entity_one_id INT NOT NULL,
    FOREIGN KEY (entity_one_id) REFERENCES ENTITY_ONE(entity_one_id)
);

-- ── Many-to-many relationship (junction/bridge table) ───────────────
-- Composite PK of both foreign keys; no surrogate key needed unless the
-- relationship itself has attributes worth tracking with its own identity.

CREATE TABLE ENTITY_ONE_ENTITY_TWO (
    entity_one_id INT NOT NULL,
    entity_two_id INT NOT NULL,
    -- TODO: any attributes of the relationship itself (e.g. position, role)
    PRIMARY KEY (entity_one_id, entity_two_id),
    FOREIGN KEY (entity_one_id) REFERENCES ENTITY_ONE(entity_one_id),
    FOREIGN KEY (entity_two_id) REFERENCES ENTITY_TWO(entity_two_id)
);

-- ── Self-referencing relationship (e.g. users following users) ──────
-- Only needed if an entity relates to another row of its own table.

-- CREATE TABLE ENTITY_ONE_RELATION (
--     from_id INT NOT NULL,
--     to_id   INT NOT NULL,
--     PRIMARY KEY (from_id, to_id),
--     FOREIGN KEY (from_id) REFERENCES ENTITY_ONE(entity_one_id),
--     FOREIGN KEY (to_id)   REFERENCES ENTITY_ONE(entity_one_id),
--     CHECK (from_id <> to_id)
-- );
