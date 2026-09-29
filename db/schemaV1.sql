CREATE DATABASE IF NOT EXISTS SONG_LOG;
USE SONG_LOG;

CREATE TABLE USER (
    user_id int PRIMARY KEY,
    username varchar(128)
);

CREATE TABLE GENRES (
	genre_id int PRIMARY KEY,
    name varchar(128) 
);

CREATE TABLE SONG(
    song_id int PRIMARY KEY,
    name varchar(128), 
    album_id int, 
    length int, 
    genre int
);

CREATE TABLE ALBUMS (
	album_id int PRIMARY KEY, 
	name varchar(128), 
    album_by int,
    release_date date,
    is_single boolean 
);

CREATE TABLE ARTIST(
    artist_id int PRIMARY KEY,
    artist_name varchar(120)
);

CREATE TABLE RATING(
    user_id int,
    song_id int,
    rating float,
    PRIMARY KEY (user_id, song_id)
);

