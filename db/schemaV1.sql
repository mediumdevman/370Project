CREATE DATABASE IF NOT EXISTS SONG_LOG;
USE SONG_LOG;

CREATE TABLE USER (
    user_id int PRIMARY KEY,
    username varchar(128) NOT NULL
);

CREATE TABLE GENRE (
	genre_id int PRIMARY KEY,
    genre_name varchar(128) NOT NULL UNIQUE
);

CREATE TABLE ARTIST (
    artist_id int PRIMARY KEY,
    artist_name varchar(120) NOT NULL
);

CREATE TABLE ALBUM (
	album_id int PRIMARY KEY,
	album_name varchar(128) NOT NULL,
    made_by int NOT NULL,
    release_date date,
    is_single boolean NOT NULL DEFAULT FALSE,
    FOREIGN KEY (made_by) REFERENCES ARTIST(artist_id)
);

CREATE TABLE SONG (
    song_id int PRIMARY KEY,
    song_name varchar(128) NOT NULL,
    album_id int NOT NULL,
    length int NOT NULL,
    genre_id int,
    FOREIGN KEY (album_id) REFERENCES ALBUM (album_id),
    FOREIGN KEY (genre_id) REFERENCES GENRE (genre_id)
);

CREATE TABLE RATING (
    user_id int,
    song_id int,
    rating float NOT NULL,
    PRIMARY KEY (user_id, song_id),
    FOREIGN KEY (user_id) REFERENCES USER (user_id),
    FOREIGN KEY (song_id) REFERENCES SONG (song_id),
    CHECK (rating BETWEEN 0.5 AND 5.0 AND rating * 2 = FLOOR(rating * 2))
);

