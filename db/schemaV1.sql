CREATE DATABASE IF NOT EXISTS SONG_LOG;
USE SONG_LOG;

CREATE TABLE USER (
    user_id int PRIMARY KEY,
    username varchar(128)
);

CREATE TABLE GENRE (
	genre_id int PRIMARY KEY,
    name varchar(128) 
);

CREATE TABLE ARTIST (
    artist_id int PRIMARY KEY,
    artist_name varchar(120)
);

CREATE TABLE ALBUM (
	album_id int PRIMARY KEY, 
	name varchar(128), 
    made_by int,
    release_date date,
    is_single boolean,
    FOREIGN KEY (made_by) REFERENCES ARTIST(artist_id)
);

CREATE TABLE SONG (
    song_id int PRIMARY KEY,
    name varchar(128), 
    album_id int, 
    length int, 
    genre_id int,
    FOREIGN KEY (album_id) REFERENCES ALBUM (album_id),
    FOREIGN KEY (genre) REFERENCES GENRE (genre_id)
);

CREATE TABLE RATING (
    user_id int,
    song_id int,
    rating float,
    PRIMARY KEY (user_id, song_id),
    FOREIGN KEY (user_id) REFERENCES USER (user_id),
    FOREIGN KEY (song_id) REFERENCES SONG (song_id)
);

