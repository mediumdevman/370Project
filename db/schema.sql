-- Song logging & rating platform — schema DDL
-- See docs/erd.md and docs/normalization.md for design rationale.

CREATE DATABASE IF NOT EXISTS song_log;
USE song_log;

CREATE TABLE USER (
    user_id       INT AUTO_INCREMENT PRIMARY KEY,
    username      VARCHAR(50)  NOT NULL UNIQUE,
    email         VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    joined_at     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE ARTIST (
    artist_id INT AUTO_INCREMENT PRIMARY KEY,
    name      VARCHAR(200) NOT NULL
);

CREATE TABLE ALBUM (
    album_id     INT AUTO_INCREMENT PRIMARY KEY,
    title        VARCHAR(200) NOT NULL,
    release_date DATE,
    artist_id    INT NOT NULL,
    FOREIGN KEY (artist_id) REFERENCES ARTIST(artist_id)
);

CREATE TABLE SONG (
    song_id      INT AUTO_INCREMENT PRIMARY KEY,
    title        VARCHAR(200) NOT NULL,
    duration_sec INT NOT NULL,
    album_id     INT NOT NULL,
    FOREIGN KEY (album_id) REFERENCES ALBUM(album_id)
);

CREATE TABLE GENRE (
    genre_id INT AUTO_INCREMENT PRIMARY KEY,
    name     VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE SONG_GENRE (
    song_id  INT NOT NULL,
    genre_id INT NOT NULL,
    PRIMARY KEY (song_id, genre_id),
    FOREIGN KEY (song_id) REFERENCES SONG(song_id),
    FOREIGN KEY (genre_id) REFERENCES GENRE(genre_id)
);

CREATE TABLE LOG (
    log_id      INT AUTO_INCREMENT PRIMARY KEY,
    user_id     INT NOT NULL,
    song_id     INT NOT NULL,
    rating      TINYINT CHECK (rating BETWEEN 1 AND 5),
    review_text TEXT,
    logged_at   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES USER(user_id),
    FOREIGN KEY (song_id) REFERENCES SONG(song_id)
);

CREATE TABLE LIST (
    list_id    INT AUTO_INCREMENT PRIMARY KEY,
    user_id    INT NOT NULL,
    title      VARCHAR(200) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES USER(user_id)
);

CREATE TABLE LIST_ITEM (
    list_id  INT NOT NULL,
    song_id  INT NOT NULL,
    position INT NOT NULL,
    PRIMARY KEY (list_id, song_id),
    FOREIGN KEY (list_id) REFERENCES LIST(list_id),
    FOREIGN KEY (song_id) REFERENCES SONG(song_id)
);

CREATE TABLE FOLLOW (
    follower_id INT NOT NULL,
    followee_id INT NOT NULL,
    PRIMARY KEY (follower_id, followee_id),
    FOREIGN KEY (follower_id) REFERENCES USER(user_id),
    FOREIGN KEY (followee_id) REFERENCES USER(user_id),
    CHECK (follower_id <> followee_id)
);
