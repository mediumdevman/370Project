# ERD — [project name TBD]

<img width="2640" height="1485" alt="image" src="https://github.com/user-attachments/assets/56f78484-f53b-4342-971e-1ae1d82157a6" />

## Entities

- **User:** Stores information about each user, including a unique user_id and username. Users can rate songs through the Rates relationship.
- **Song:** Represents individual songs and stores attributes such as song_id, song_name, and length. Each song is associated with a genre and an album.
- **Album:** Stores information about albums, including a unique album_id, album_name, release_date, and whether the album is a single (is_single). Albums are associated with an artist and can contain multiple songs.
- **Artist:** Stores information about artists using a unique artist_id and artist_name. An artist can be associated with multiple albums.
- **Genre:** Stores different music genres using a unique genre_id and genre_name. Each song is categorized under a genre.
- **Ratings:** The Rates relationship connects users and songs, allowing users to rate individual songs. The Rating attribute stores the rating given by the user. This creates a many-to-many relationship, since a user can rate many songs and a song can receive ratings from many users.
- **Primary Keys:** Each main entity has a unique identifier (user_id, song_id, album_id, artist_id, and genre_id) to uniquely identify its records.


## Relationships 

- **Genre-Song:** One to Many relationship to account for each song having only one main genre, while each genre will have multiple songs under it
- **Song-Album:** One to Many relationship represents each song belonging on only one album, while each album can have multiple songs (unless it is a sinlge)
- **Album-Artist:** One to Many relationship represents each album being made my one primary artist, while each artist can create multiple albums.
- **User-Song:** Many to Many relationship to represent that each user has the ability to leave multiple ratings on different songs while each song can have multiple ratings from different users.
