USE SONG_LOG;

-- S2 average rating per album, not singles, at least 3 ratings
-- expect: DAMN. 4.67 | After Hours 4.25 | Nevermind 4.25 | Pablo Honey 4.17 | 1989 3.70
SELECT a.album_name,
       ROUND(AVG(r.rating), 2) AS avg_rating
FROM ALBUM a
JOIN TRACK t  ON t.album_id = a.album_id
JOIN RATING r ON r.song_id  = t.song_id
WHERE a.is_single = FALSE
GROUP BY a.album_id, a.album_name
HAVING COUNT(r.rating) >= 3
ORDER BY avg_rating DESC, a.album_name;

-- S3 average of the album averages, only for albums that have at least one 5.0 rating
-- expect: 4.21 | 5
SELECT ROUND(AVG(album_avg), 2) AS avg_of_album_avgs,
       COUNT(*)                 AS album_count
FROM (
    SELECT a.album_id,
           AVG(r.rating) AS album_avg
    FROM ALBUM a
    JOIN TRACK t  ON t.album_id = a.album_id
    JOIN RATING r ON r.song_id  = t.song_id
    WHERE EXISTS (
        SELECT 1
        FROM TRACK t2
        JOIN RATING r2 ON r2.song_id = t2.song_id
        WHERE t2.album_id = a.album_id
          AND r2.rating = 5.0
    )
    GROUP BY a.album_id
) AS album_avgs;

-- S6 songs nobody has rated, sub-query version
-- expect: Anyone Can Play Guitar
SELECT song_name
FROM SONG
WHERE song_id NOT IN (SELECT song_id FROM RATING);

-- S6 same query as a left join
-- expect: Anyone Can Play Guitar
SELECT s.song_name
FROM SONG s
LEFT JOIN RATING r ON r.song_id = s.song_id
WHERE r.song_id IS NULL;

-- S8 the null genre song is not counted either way
-- expect 8
SELECT COUNT(*) FROM SONG WHERE genre_id <> 1;

-- expect 9
SELECT COUNT(*) FROM SONG WHERE genre_id <> 1 OR genre_id IS NULL;

-- expect 14, 13
SELECT COUNT(*), COUNT(genre_id) FROM SONG;

-- expect NULL
SELECT 2 NOT IN (1, NULL);

-- S4 make user 5 follow other users
-- expect: FOLLOWS goes from 8 to 10 rows (user 5 already follows 4 and 1, so 2 and 3 are added)
INSERT INTO FOLLOWS (follower_id, followed_id)
SELECT 5, u.user_id
FROM USER u
WHERE u.user_id <> 5
  AND NOT EXISTS (
      SELECT 1 FROM FOLLOWS f
      WHERE f.follower_id = 5 AND f.followed_id = u.user_id
  );

-- S4 DELETE ratings of songs that have no genre
-- expect: RATING goes from 23 to 22 rows (song 14 has the only one)
DELETE FROM RATING
WHERE song_id IN (
    SELECT song_id FROM SONG WHERE genre_id IS NULL
);

-- S1 sub-genres: each sub-genre with its parent (self-join on GENRE)
-- expect: Hyperpop | Pop, Soft Rock | Rock, Punk Rock | Rock
SELECT sub.genre_name AS sub_genre, parent.genre_name AS parent_genre
FROM GENRE sub
JOIN GENRE parent ON parent.genre_id = sub.parent_genre_id; 

-- S5 index on song_name to speed up searching by title
-- before index: type ALL, key NULL, 14 rows 
EXPLAIN FORMAT=TRADITIONAL SELECT * FROM SONG WHERE song_name = 'Creep';

-- After creating index: type ref, key index_song_name, 2 rows return
CREATE INDEX index_song_name ON SONG(song_name);
EXPLAIN FORMAT=TRADITIONAL SELECT * FROM SONG WHERE song_name = 'Creep';

DROP INDEX index_song_name ON SONG;


