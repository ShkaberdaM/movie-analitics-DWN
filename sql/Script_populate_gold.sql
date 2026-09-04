INSERT INTO dim_directors (director_name)
SELECT DISTINCT director
FROM stg_movies
WHERE director IS NOT NULL 
  AND director != '';

INSERT INTO dim_genres (genre_name)
SELECT DISTINCT TRIM(genre_item)
FROM (
    SELECT 
        unnest(string_to_array(genres, ',')) AS genre_item
    FROM stg_movies
    WHERE genres IS NOT NULL AND genres != ''
) AS raw_genres
WHERE TRIM(genre_item) != '';

INSERT INTO fact_movies (
    title, 
    release_year, 
    runtime_mins, 
    rating, 
    votes_count, 
    gross_revenue_usd, 
    star_main, 
    star_co, 
    director_id
)
SELECT 
    s.title,
    s.release_year,
    s.runtime_mins,
    s.rating,
    s.votes_count,
    s.gross_revenue_usd,
    s.star_main,
    s.star_co,
    d.director_id
FROM stg_movies s
LEFT JOIN dim_directors d ON s.director = d.director_name
WHERE s.director IS NOT NULL AND s.director != '';

INSERT INTO map_movie_genres (movie_id, genre_id)
SELECT 
    f.movie_id,
    g.genre_id
FROM fact_movies f
JOIN stg_movies s ON f.title = s.title AND f.release_year = s.release_year
CROSS JOIN LATERAL unnest(string_to_array(s.genres, ',')) AS raw_genre
JOIN dim_genres g ON TRIM(raw_genre) = g.genre_name
WHERE s.genres IS NOT NULL;