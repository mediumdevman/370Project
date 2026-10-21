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

-- deleting an album removes its tracks (cascade since a track is a weak entity)
DELETE FROM ALBUM WHERE album_id = 8;
SELECT COUNT(*) FROM TRACK WHERE album_id = 8;

-- deleting an artist who still has albums fails (restrict)
DELETE FROM ARTIST WHERE artist_id = 1;

-- deleting a genre keeps its songs but sets their genre to null (set null)
DELETE FROM GENRE WHERE genre_id = 2;
SELECT song_id, genre_id FROM SONG WHERE song_id = 10;

ROLLBACK;
