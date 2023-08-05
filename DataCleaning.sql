SELECT * FROM movie_ids;

SELECT * FROM movie_details;

SELECT * FROM movie_ratings;

SELECT * FROM movie_text;

SET SQL_SAFE_UPDATES = 0;
SET SQL_SAFE_UPDATES = 1;


-- Deleting Rows not having imdb_ids
DELETE
FROM movie_ids
WHERE length(imdb_id)=0;
-- --------------------------------------------------------


-- Deleting duplicate Rows
DELETE
FROM movie_ids m1
WHERE m1.imdb_id IN (
	SELECT imdb_id FROM (
		SELECT m2.imdb_id FROM movie_ids m2
		GROUP BY m2.imdb_id
		HAVING count(*) > 1
	)m
);

DELETE
FROM movie_details
WHERE imdb_id IN (
	SELECT imdb_id FROM (
		SELECT imdb_id FROM movie_details
		GROUP BY imdb_id
		HAVING count(*) > 1
	)m
);

DELETE
FROM movie_ratings
WHERE imdb_id IN (
	SELECT imdb_id FROM (
		SELECT imdb_id FROM movie_ratings
		GROUP BY imdb_id
		HAVING count(*) > 1
	)m
);
-- --------------------------------------------------------


-- Modying the data type of imdb_id
ALTER TABLE movie_ids
MODIFY COLUMN imdb_id varchar(10);

ALTER TABLE movie_details
MODIFY COLUMN imdb_id varchar(10);

ALTER TABLE movie_ratings
MODIFY COLUMN imdb_id varchar(10);

ALTER TABLE movie_text
MODIFY COLUMN imdb_id varchar(10);
-- --------------------------------------------------------


-- Creating Primary Key
ALTER TABLE movie_ids
ADD PRIMARY KEY (imdb_id);
-- --------------------------------------------------------


-- Creating Foreign Key
ALTER TABLE movie_details
ADD FOREIGN KEY (imdb_id) REFERENCES movie_ids(imdb_id);

ALTER TABLE movie_ratings
ADD FOREIGN KEY (imdb_id) REFERENCES movie_ids(imdb_id);

ALTER TABLE movie_text
ADD FOREIGN KEY (imdb_id) REFERENCES movie_ids(imdb_id);
-- --------------------------------------------------------


-- Deleting Rows so that data is consistent in all the tables
DELETE
FROM movie_text
WHERE imdb_id NOT IN (
	SELECT m.imdb_id FROM (
		SELECT m1.imdb_id
		FROM movie_text m1
		INNER JOIN movie_ids
		ON m1.imdb_id = movie_ids.imdb_id
    )m
);

DELETE
FROM movie_text
WHERE imdb_id NOT IN (
	SELECT m.imdb_id FROM (
		SELECT m1.imdb_id
		FROM movie_text m1
		INNER JOIN movie_ratings m2
		ON m1.imdb_id = m2.imdb_id
    )m
);

DELETE
FROM movie_text
WHERE imdb_id NOT IN (
	SELECT m.imdb_id FROM (
		SELECT m1.imdb_id
		FROM movie_text m1
		INNER JOIN movie_details m2
		ON m1.imdb_id = m2.imdb_id
    )m
);

DELETE
FROM movie_ratings
WHERE imdb_id NOT IN (
	SELECT m.imdb_id FROM (
		SELECT m1.imdb_id
		FROM movie_ratings m1
		INNER JOIN movie_text m2
		ON m1.imdb_id = m2.imdb_id
    )m
);

DELETE
FROM movie_ratings
WHERE imdb_id NOT IN (
	SELECT m.imdb_id FROM (
		SELECT m1.imdb_id
		FROM movie_ratings m1
		INNER JOIN movie_details m2
		ON m1.imdb_id = m2.imdb_id
    )m
);

DELETE
FROM movie_details
WHERE imdb_id NOT IN (
	SELECT m.imdb_id FROM (
		SELECT m1.imdb_id
		FROM movie_details m1
		INNER JOIN movie_text m2
		ON m1.imdb_id = m2.imdb_id
    )m
);

DELETE
FROM movie_details
WHERE imdb_id NOT IN (
	SELECT m.imdb_id FROM (
		SELECT m1.imdb_id
		FROM movie_details m1
		INNER JOIN movie_ratings m2
		ON m1.imdb_id = m2.imdb_id
    )m
);

DELETE
FROM movie_ids
WHERE imdb_id NOT IN (
	SELECT m.imdb_id FROM (
		SELECT m1.imdb_id
		FROM movie_ids m1
		INNER JOIN movie_details m2
		ON m1.imdb_id = m2.imdb_id
    )m
);

DELETE
FROM movie_ids
WHERE imdb_id NOT IN (
	SELECT m.imdb_id FROM (
		SELECT m1.imdb_id
		FROM movie_ids m1
		INNER JOIN movie_ratings m2
		ON m1.imdb_id = m2.imdb_id
    )m
);

DELETE
FROM movie_ids
WHERE imdb_id NOT IN (
	SELECT m.imdb_id FROM (
		SELECT m1.imdb_id
		FROM movie_ids m1
		INNER JOIN movie_text m2
		ON m1.imdb_id = m2.imdb_id
    )m
);
-- --------------------------------------------------------


-- Altering movie_details Table :
-- Deleting columns which are not required
ALTER TABLE movie_details
DROP COLUMN title;

ALTER TABLE movie_details
DROP COLUMN original_title;



-- Changing DataType of runtime field from INT to TIME
UPDATE movie_details
SET runtime = SEC_TO_TIME(runtime*60);

ALTER TABLE movie_details
MODIFY COLUMN runtime TIME;



-- Changing DataType of year_of_release from INT to YEAR
ALTER TABLE movie_details
MODIFY COLUMN year_of_release YEAR;



-- Changing DataType of genres from TEXT to VARCHAR
ALTER TABLE movie_details
MODIFY COLUMN genres VARCHAR(50);
-- --------------------------------------------------------


-- Altering movie_ids Table :
-- Changing DataType of title from TEXT to VARCHAR
ALTER TABLE movie_ids
MODIFY COLUMN title VARCHAR(100);
-- --------------------------------------------------------


-- Altering movie_text Table :
-- Adding Column for Awards
ALTER TABLE movie_text
ADD COLUMN awards VARCHAR(5) DEFAULT 0;

-- Updating Awards column using wins_nominations column
UPDATE movie_text
SET awards = SUBSTR(wins_nominations, 1, POSITION(" " IN wins_nominations))
WHERE wins_nominations LIKE "%win%";


-- Adding Column for Nominations
ALTER TABLE movie_text
ADD COLUMN nominations VARCHAR(5) DEFAULT 0;

-- Updating Nominations column using wins_nominations column
UPDATE movie_text
SET nominations = SUBSTR(wins_nominations, POSITION("&" IN wins_nominations)+1, POSITION("nom" IN wins_nominations) - POSITION("&" IN wins_nominations) - 1)
WHERE wins_nominations LIKE "%&%";

-- Updating Nominations column using wins_nominations column
UPDATE movie_text
SET nominations = SUBSTR(wins_nominations, 1, POSITION("n" IN wins_nominations)-1)
WHERE wins_nominations NOT LIKE "%&%" AND wins_nominations LIKE "%nom%";


-- Modifying DataType of Awards and Nominations to TINYINT
ALTER TABLE movie_text
MODIFY COLUMN awards TINYINT;

ALTER TABLE movie_text
MODIFY COLUMN nominations TINYINT;


-- Deleting wins_nominations column
ALTER TABLE movie_text
DROP COLUMN wins_nominations;


-- Adding Column for date_of_release
ALTER TABLE movie_text
ADD COLUMN date_of_release DATE;

-- If release_date only contains year of release the set month of release to January
UPDATE movie_text
SET release_date = CONCAT("January ", release_date)
WHERE SUBSTR(release_date, POSITION(" " IN release_date) + 1, 1) = "(";

-- If release_date only contains month and year of release the set date of release to 1
UPDATE movie_text
SET release_date = CONCAT("1 ", release_date)
WHERE POSITION(" " IN release_date) > 3;

-- Updating the date_of_release column using release_date
UPDATE movie_text
SET date_of_release = STR_TO_DATE(SUBSTR(release_date, 1, POSITION("(" IN release_date) - 1), '%d %M %Y');


-- Adding Column for place_of_release
ALTER TABLE movie_text
ADD COLUMN place_of_release VARCHAR(50);

-- Updating the place_of_release column using release_date
UPDATE movie_text
SET place_of_release = SUBSTR(release_date, POSITION("(" IN release_date) + 1, POSITION(")" IN release_date) - POSITION("(" IN release_date) - 1);


-- Deleting the column of release_date
ALTER TABLE movie_text
DROP COLUMN release_date;