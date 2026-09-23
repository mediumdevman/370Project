CREATE DATABASE IF NOT EXISTS SONG_LOG;
USE SONG_LOG;

CREATE TABLE USER (
    user_id int PRIMARY KEY,
    display_name VARCHAR(120)
);

CREATE TABLE SONG(
    song_id int PRIMARY KEY,
    song_name VARCHAR(120),
    genre VARCHAR(120)
);

CREATE TABLE ARTIST(
    artist_id int PRIMARY KEY,
    artist_name VARCHAR(120)
);

CREATE TABLE RATING(
    user_id int,
    song_id int,
    rating float,
    PRIMARY KEY (user_id, song_id)
);

