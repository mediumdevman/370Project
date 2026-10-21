CREATE DATABASE IF NOT EXISTS SONG_LOG;
USE SONG_LOG;

CREATE TABLE USER (
    user_id int PRIMARY KEY,
    username varchar(128) NOT NULL,
    CONSTRAINT chk_username_not_blank CHECK (CHAR_LENGTH(TRIM(username)) > 0)
);

CREATE TABLE GENRE (
	genre_id int PRIMARY KEY,
    genre_name varchar(128) NOT NULL UNIQUE,
    CONSTRAINT chk_genre_name_not_blank CHECK (CHAR_LENGTH(TRIM(genre_name)) > 0)
);

CREATE TABLE ARTIST (
    artist_id int PRIMARY KEY,
    artist_name varchar(120) NOT NULL,
    CONSTRAINT chk_artist_name_not_blank CHECK (CHAR_LENGTH(TRIM(artist_name)) > 0)
);

CREATE TABLE ALBUM (
	album_id int PRIMARY KEY,
	album_name varchar(128) NOT NULL,
    made_by int NOT NULL,
    release_date date,
    is_single boolean NOT NULL DEFAULT FALSE,
    FOREIGN KEY (made_by) REFERENCES ARTIST(artist_id) ON DELETE RESTRICT,
    CONSTRAINT chk_album_name_not_blank CHECK (CHAR_LENGTH(TRIM(album_name)) > 0)
);

CREATE TABLE SONG (
    song_id int PRIMARY KEY,
    song_name varchar(128) NOT NULL,
    length int NOT NULL,
    genre_id int,
    FOREIGN KEY (genre_id) REFERENCES GENRE (genre_id) ON DELETE SET NULL,
    CONSTRAINT chk_song_name_not_blank CHECK (CHAR_LENGTH(TRIM(song_name)) > 0),
    CONSTRAINT chk_song_length_positive CHECK (length > 0)
);

CREATE TABLE TRACK(
album_id INT, 
track_number INT, 
song_id INT NOT NULL, 
PRIMARY KEY (album_id, track_number),
UNIQUE (album_id, song_id), 
FOREIGN KEY (album_id) REFERENCES ALBUM (album_id) ON DELETE CASCADE,
FOREIGN KEY (song_id) REFERENCES SONG (song_id) ON DELETE RESTRICT,
CONSTRAINT chk_track_number_positive CHECK (track_number > 0)
);

CREATE TABLE RATING (
    user_id int,
    song_id int,
    rating float NOT NULL,
    PRIMARY KEY (user_id, song_id),
    FOREIGN KEY (user_id) REFERENCES USER (user_id) ON DELETE CASCADE,
    FOREIGN KEY (song_id) REFERENCES SONG (song_id) ON DELETE CASCADE,
    CONSTRAINT chk_rating_half_steps CHECK (rating BETWEEN 0.5 AND 5.0 AND rating * 2 = FLOOR(rating * 2))
);

CREATE TABLE FOLLOWS (
    follower_id int NOT NULL,
    followed_id int NOT NULL,
    followed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (follower_id, followed_id),
    FOREIGN KEY (follower_id) REFERENCES USER(user_id) ON DELETE CASCADE,
    FOREIGN KEY (followed_id) REFERENCES USER(user_id) ON DELETE CASCADE,
    CONSTRAINT chk_no_self_follow CHECK (follower_id <> followed_id)
);
