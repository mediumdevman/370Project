USE SONG_LOG;

-- average rating per album
SELECT a.album_name,
       ROUND(AVG(r.rating), 2) AS avg_rating
FROM ALBUM a
JOIN TRACK t  ON t.album_id = a.album_id
JOIN RATING r ON r.song_id  = t.song_id
GROUP BY a.album_id, a.album_name
ORDER BY avg_rating DESC, a.album_name;

-- average of the album averages, only for albums that have at least one 5.0 rating
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

-- make user 5 follow other users
INSERT INTO FOLLOWS (follower_id, followed_id)
SELECT 5, u.user_id
FROM USER u
WHERE u.user_id <> 5
  AND NOT EXISTS (
      SELECT 1 FROM FOLLOWS f
      WHERE f.follower_id = 5 AND f.followed_id = u.user_id
  );

-- DELETE ratings of songs that have no genre
DELETE FROM RATING
WHERE song_id IN (
    SELECT song_id FROM SONG WHERE genre_id IS NULL
);