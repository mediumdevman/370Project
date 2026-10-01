# ERD — [project name TBD]

<img width="2640" height="1485" alt="image" src="https://github.com/user-attachments/assets/56f78484-f53b-4342-971e-1ae1d82157a6" />

## Design notes

Explain key decisions here — e.g.:

- Genre-Song: One to Many relationship to account for each song having only one main genre, while each genre will have multiple songs under it
- Song-Album: One to Many relationship represents each song belonging on only one album, while each album can have multiple songs (unless it is a sinlge)
- Album-Artist: One to Many relationship represents each album being made my one primary artist, while each artist can create multiple albums.
- User-Song: Many to Many relationship to represent that each user has the ability to leave multiple ratings on different songs while each song can have multiple ratings from different users.
-
- Why a relationship is one-to-many vs. many-to-many
- Any surrogate keys used instead of natural keys, and why
- Anything non-obvious about the model that isn't clear from the diagram
alone

## Future work (next sprint)

What's planned for the next sprint (Advanced Relational Design) — new
tables, relationships not yet modeled, indexing strategy, etc.
