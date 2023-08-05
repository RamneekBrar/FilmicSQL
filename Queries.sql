-- 1. Display all the tables
SELECT * FROM movie_ids;
SELECT * FROM movie_details;
SELECT * FROM movie_ratings;
SELECT * FROM movie_text;


-- 2. Display all data about movies
SELECT m1.title, m2.runtime, m2.genres, m3.imdb_rating, m4.story, m4.actors, m4.awards, m4.date_of_release
FROM movie_ids m1, movie_details m2, movie_ratings m3, movie_text m4
WHERE m1.imdb_id = m2.imdb_id AND m1.imdb_id = m3.imdb_id AND m1.imdb_id = m4.imdb_id;


-- 3. Display information about movies in the decreasing order of imdb_rating
SELECT m1.title, m2.runtime, m2.genres, m3.imdb_rating, m4.story, m4.actors, m4.awards, m4.date_of_release
FROM movie_ids m1, movie_details m2, movie_ratings m3, movie_text m4
WHERE m1.imdb_id = m2.imdb_id AND m1.imdb_id = m3.imdb_id AND m1.imdb_id = m4.imdb_id
ORDER BY m3.imdb_rating DESC;


-- 4. Display movies having IMDB Rating of greater than or equal to 8
SELECT m1.title, m2.runtime, m2.genres, m3.imdb_rating, m4.story, m4.actors
FROM movie_ids m1, movie_details m2, movie_ratings m3, movie_text m4
WHERE m1.imdb_id = m2.imdb_id AND m1.imdb_id = m3.imdb_id AND m1.imdb_id = m4.imdb_id AND m3.imdb_rating >= 8
ORDER BY m3.imdb_rating DESC;


-- 5. Display all the information for a particular movie
SELECT m1.title, m2.runtime, m2.genres, m3.imdb_rating, m4.story, m4.summary, m4.actors, m4.awards, m4.nominations, m4.date_of_release
FROM movie_ids m1, movie_details m2, movie_ratings m3, movie_text m4
WHERE m1.imdb_id = m2.imdb_id AND m1.imdb_id = m3.imdb_id AND m1.imdb_id = m4.imdb_id AND title = "Sholay";


-- 6. Display all the movies of a particular genre
SELECT m1.title, m2.runtime, m2.genres, m3.imdb_rating, m4.story, m4.awards, m4.date_of_release
FROM movie_ids m1, movie_details m2, movie_ratings m3, movie_text m4
WHERE m1.imdb_id = m2.imdb_id AND m1.imdb_id = m3.imdb_id AND m1.imdb_id = m4.imdb_id AND genres LIKE "%Drama%"
ORDER BY m3.imdb_rating DESC;


-- 7. Display all the movies of a particular actor in the increasing order of release date
SELECT m1.title, m2.runtime, m2.genres, m3.imdb_rating, m4.story, m4.awards, m4.actors, m4.date_of_release
FROM movie_ids m1, movie_details m2, movie_ratings m3, movie_text m4
WHERE m1.imdb_id = m2.imdb_id AND m1.imdb_id = m3.imdb_id AND m1.imdb_id = m4.imdb_id AND actors LIKE "%Aamir Khan%"
ORDER BY m4.date_of_release; 


-- 8. Display the movie having highest rating of a particular actor
SELECT m1.title, m2.runtime, m2.genres, m3.imdb_rating, m4.story, m4.awards, m4.actors, m4.date_of_release
FROM movie_ids m1, movie_details m2, movie_ratings m3, movie_text m4
WHERE m1.imdb_id = m2.imdb_id AND m1.imdb_id = m3.imdb_id AND m1.imdb_id = m4.imdb_id AND actors LIKE "%Aamir Khan%"
ORDER BY m3.imdb_rating DESC LIMIT 1; 