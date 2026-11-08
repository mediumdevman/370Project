-- run after schemaV1.sql and seed.sql
-- mysql -u root -p --force -vvv SONG_LOG < db/tests.sql
-- everything is rolled back at the end so the seed data stays the same

-- check constraints need mysql 8.0.16 or newer
SELECT VERSION();

START TRANSACTION;

-- names test
-- names cant be empty or only spaces so the first six fail and the last one works
INSERT INTO USER (user_id, username) VALUES (100, '');
INSERT INTO USER (user_id, username) VALUES (101, '   ');
INSERT INTO GENRE (genre_id, genre_name) VALUES (100, '');
INSERT INTO ARTIST (artist_id, artist_name) VALUES (100, ' ');
INSERT INTO ALBUM (album_id, album_name, made_by) VALUES (100, '', 1);
INSERT INTO SONG (song_id, song_name, length) VALUES (100, '', 200);
INSERT INTO USER (user_id, username) VALUES (102, 'x');

-- song length test
-- length has to be above 0 so 0 and -30 fail and 1 works
INSERT INTO SONG (song_id, song_name, length) VALUES (101, 'Silence', 0);
INSERT INTO SONG (song_id, song_name, length) VALUES (102, 'Backwards', -30);
INSERT INTO SONG (song_id, song_name, length) VALUES (103, 'Very Short', 1);

-- track test
-- track numbers start at 1 and an album cant have the same track number twice
-- track 0 fails and track 2 fails since album 1 already has it and track 1 works
INSERT INTO TRACK (album_id, track_number, song_id) VALUES (1, 0, 103);
INSERT INTO TRACK (album_id, track_number, song_id) VALUES (1, 2, 103);
INSERT INTO TRACK (album_id, track_number, song_id) VALUES (1, 1, 103);

-- rating test
-- ratings are 0.5 to 5 in half steps so 0 and 5.5 and 3.7 fail and 0.5 and 5 work
INSERT INTO RATING (user_id, song_id, rating) VALUES (1, 2, 0.0);
INSERT INTO RATING (user_id, song_id, rating) VALUES (1, 2, 5.5);
INSERT INTO RATING (user_id, song_id, rating) VALUES (1, 2, 3.7);
INSERT INTO RATING (user_id, song_id, rating) VALUES (1, 2, 0.5);
INSERT INTO RATING (user_id, song_id, rating) VALUES (1, 3, 5.0);

-- follows test
-- a user cant follow themselves or follow the same person twice so both fail
INSERT INTO FOLLOWS (follower_id, followed_id) VALUES (1, 1);
INSERT INTO FOLLOWS (follower_id, followed_id) VALUES (1, 2);

-- song_artist test
-- role is an ENUM, so only 'primary' and 'featured' are allowed
-- (1,2,'featured') works; the next three fail:
-- duplicate pair (1062), bad role (1265 in strict mode), artist that doesn't exist (1452)
INSERT INTO SONG_ARTIST (song_id, artist_id, role) VALUES (1, 2, 'featured');
INSERT INTO SONG_ARTIST (song_id, artist_id, role) VALUES (1, 2, 'primary');
INSERT INTO SONG_ARTIST (song_id, artist_id, role) VALUES (1, 3, 'guest');
INSERT INTO SONG_ARTIST (song_id, artist_id, role) VALUES (1, 999, 'featured');
-- leaving role out uses the default, so this works and the SELECT should show 'primary'
INSERT INTO SONG_ARTIST (song_id, artist_id) VALUES (2, 2);
SELECT role FROM SONG_ARTIST WHERE song_id = 2 AND artist_id = 2;

-- sub-genre test
-- adding a genre with a parent that does not exists (FK Error, 1452) 
INSERT INTO GENRE (genre_id, genre_name, parent_genre_id) VALUES (101, 'Yacht Rock', 999); 
-- adding a genre whose parent is itself (Check Error -> 3819) 
INSERT INTO GENRE (genre_id, genre_name, parent_genre_id) VALUES (102, 'Glitch Pop', 102);
-- adding a valid sub genre that doesn't reference itself and references another genre as its parent
INSERT INTO GENRE (genre_id, genre_name, parent_genre_id) VALUES (103, 'Yacht Rock', 2);   

-- on delete test
-- deleting user 4 works and removes their ratings and follows (cascade)
SELECT COUNT(*) FROM RATING WHERE user_id = 4;
SELECT COUNT(*) FROM FOLLOWS WHERE follower_id = 4 OR followed_id = 4;
DELETE FROM USER WHERE user_id = 4;
SELECT COUNT(*) FROM RATING WHERE user_id = 4;
SELECT COUNT(*) FROM FOLLOWS WHERE follower_id = 4 OR followed_id = 4;

-- deleting a song removes its ratings (cascade) but a song still on an album cant be deleted (restrict)
INSERT INTO SONG (song_id, song_name, length) VALUES (104, 'Unreleased', 120);
INSERT INTO RATING (user_id, song_id, rating) VALUES (1, 104, 4.0);
DELETE FROM SONG WHERE song_id = 104;
SELECT COUNT(*) FROM RATING WHERE song_id = 104;
DELETE FROM SONG WHERE song_id = 1;

-- deleting a song removes its artist credits (cascade)
INSERT INTO SONG (song_id, song_name, length) VALUES (105, 'Demo', 120);
INSERT INTO SONG_ARTIST (song_id, artist_id) VALUES (105, 1);
DELETE FROM SONG WHERE song_id = 105;
SELECT COUNT(*) FROM SONG_ARTIST WHERE song_id = 105;   -- expect 0
 

-- deleting an album removes its tracks (cascade since a track is a weak entity)
DELETE FROM ALBUM WHERE album_id = 8;
SELECT COUNT(*) FROM TRACK WHERE album_id = 8;

-- deleting an artist who still has albums fails (restrict)
DELETE FROM ARTIST WHERE artist_id = 1;

-- deleting an artist who is credited on a song fails (restrict)
-- this artist has no albums, so the only thing blocking the delete is the credit
INSERT INTO ARTIST (artist_id, artist_name) VALUES (101, 'Session Player');
INSERT INTO SONG_ARTIST (song_id, artist_id, role) VALUES (3, 101, 'featured');
DELETE FROM ARTIST WHERE artist_id = 101;                -- fails, error 1451
 
-- deleting a genre that has sub-genres pointing to it (restrict, error 1451)
DELETE FROM GENRE WHERE genre_id = 2; 

-- deleting a genre keeps its songs but sets their genre to null (set null)
-- hip-hop has no sub genres pointing to it, so the songs can continue 
-- to exist with genre set to NULL
DELETE FROM GENRE WHERE genre_id = 3;
SELECT song_id, genre_id FROM SONG WHERE song_id = 8;

-- S7 trigger: future date fails, today and null work, update to future fails
INSERT INTO ALBUM (album_id, album_name, made_by, release_date) VALUES (100, 'Future', 1, '2030-01-01');
INSERT INTO ALBUM (album_id, album_name, made_by, release_date) VALUES (101, 'Today', 1, CURDATE());
INSERT INTO ALBUM (album_id, album_name, made_by, release_date) VALUES (102, 'No date', 1, NULL);
UPDATE ALBUM SET release_date = '2030-01-01' WHERE album_id = 1;

ROLLBACK;
