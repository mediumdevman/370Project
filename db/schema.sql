
CREATE DATABASE IF NOT EXISTS TBD;
USE TBD;

CREATE TABLE USERS (
    user_id int auto_increment PRIMARY KEY, 
    username varchar(128) NOT NULL
);

CREATE TABLE GENRES (
	genre_id int PRIMARY KEY,
    name varchar(128) NOT NULL UNIQUE
);

CREATE TABLE ARTISTS (
   artist_id int PRIMARY KEY, 
   name varchar(128) NOT NULL UNIQUE
);

CREATE TABLE ALBUMS (
	album_id int auto_increment PRIMARY KEY, 
	name varchar(128) NOT NULL, 
    album_by INT NOT NULL, foreign key (album_by) REFERENCES ARTISTS(artist_id),
    release_date DATE,
    is_single BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE SONGS (
	song_id int auto_increment PRIMARY KEY, 
	name varchar(128) NOT NULL, 
    album INT NOT NULL, foreign key (album) REFERENCES ALBUMS(album_id),
    length INT, 
    genre int, foreign key (genre) REFERENCES GENRES(genre_id)
);


