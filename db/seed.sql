-- Dummy data for SONG_LOG, for demoing the schema.
-- Artists, albums and songs are real, but song lengths and release dates
-- are approximate. Users and ratings are made up.
--
-- Run after the schema, on an empty database:
--   mysql -u root -p < db/schemaV1.sql
--   mysql -u root -p < db/seed.sql
--
-- To start over: DROP DATABASE SONG_LOG; then run both files again.

USE SONG_LOG;

INSERT INTO USER (user_id, username) VALUES
    (1, 'zach'),
    (2, 'maren'),
    (3, 'jackson'),
    (4, 'alex'),
    (5, 'alex');          -- R1: two users can share a username

INSERT INTO GENRE (genre_id, genre_name) VALUES
    (1, 'Pop'),
    (2, 'Rock'),
    (3, 'Hip-Hop'),
    (4, 'R&B'),
    (5, 'Grunge'),
    (6, 'Psychedelic Rock');

INSERT INTO ARTIST (artist_id, artist_name) VALUES
    (1, 'Taylor Swift'),
    (2, 'The Weeknd'),
    (3, 'Kendrick Lamar'),
    (4, 'Radiohead'),
    (5, 'TLC'),
    (6, 'Nirvana'),       -- the US grunge band
    (7, 'Nirvana');       -- R2: the 1960s UK band, same name

INSERT INTO ALBUM (album_id, album_name, made_by, release_date, is_single) VALUES
    (1, '1989',                         1, '2014-10-27', FALSE),
    (2, 'After Hours',                  2, '2020-02-19', TRUE),   -- R14: single...
    (3, 'After Hours',                  2, '2020-03-20', FALSE),  -- ...and album, same title
    (4, 'DAMN.',                        3, '2017-04-14', FALSE),
    (5, 'Pablo Honey',                  4, '1993-02-22', FALSE),
    (6, 'CrazySexyCool',                5, '1994-11-15', FALSE),
    (7, 'Nevermind',                    6, '1991-09-24', FALSE),
    (8, 'The Story of Simon Simopath',  7, NULL,         FALSE);  -- R3: release date is optional

INSERT INTO SONG (song_id, song_name, album_id, length, genre_id) VALUES
    (1,  'Blank Space',               1, 231, 1),
    (2,  'Style',                     1, 231, 1),
    (3,  'Shake It Off',              1, 219, 1),
    (4,  'After Hours',               2, 361, 4),
    (5,  'Blinding Lights',           3, 200, 1),
    (6,  'Save Your Tears',           3, 215, 1),
    (7,  'After Hours',               3, 361, 4),   -- R15: same title as song 4
    (8,  'HUMBLE.',                   4, 177, 3),
    (9,  'DNA.',                      4, 185, 3),
    (10, 'Creep',                     5, 238, 2),
    (11, 'Creep',                     6, 268, 4),   -- R15: same title, different artist
    (12, 'Smells Like Teen Spirit',   7, 301, 5),
    (13, 'Come as You Are',           7, 219, 5),
    (14, 'Pentecost Hotel',           8, 190, NULL);  -- R8: genre is optional

INSERT INTO RATING (user_id, song_id, rating) VALUES
    (1, 1, 4.0), (1, 5, 5.0), (1, 8, 4.5), (1, 10, 3.5), (1, 12, 5.0),
    (2, 1, 5.0), (2, 2, 4.5), (2, 3, 3.0), (2, 5, 4.5), (2, 11, 4.0),
    (3, 8, 5.0), (3, 9, 4.5), (3, 10, 4.0), (3, 12, 4.5), (3, 13, 4.0),
    (4, 5, 3.5), (4, 6, 4.0), (4, 7, 4.5), (4, 14, 2.5),
    (5, 1, 2.0), (5, 5, 4.0), (5, 10, 5.0), (5, 13, 3.5);
