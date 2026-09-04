CREATE TABLE dim_directors (
    director_id SERIAL PRIMARY KEY,
    director_name VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE dim_genres (
    genre_id SERIAL PRIMARY KEY,
    genre_name VARCHAR(100) UNIQUE NOT NULL
);
CREATE TABLE fact_movies (
    movie_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    release_year INT,
    runtime_mins INT,
    rating NUMERIC(3, 1),
    votes_count INT,
    gross_revenue_usd NUMERIC(15, 2),
    star_main VARCHAR(255),
    star_co VARCHAR(255),
    director_id INT REFERENCES dim_directors(director_id) ON DELETE SET NULL
);
--мостовая таблица
CREATE TABLE map_movie_genres (
    movie_id INT REFERENCES fact_movies(movie_id) ON DELETE CASCADE,
    genre_id INT REFERENCES dim_genres(genre_id) ON DELETE CASCADE,
    PRIMARY KEY (movie_id, genre_id)
);
