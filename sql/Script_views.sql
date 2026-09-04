CREATE OR REPLACE VIEW view_top_genres_by_revenue AS
SELECT 
    g.genre_name,
    COUNT(f.movie_id) AS total_movies,
    ROUND(AVG(f.gross_revenue_usd), 2) AS avg_gross_usd,
    ROUND(AVG(f.rating), 2) AS avg_rating
FROM fact_movies f
JOIN map_movie_genres mmg ON f.movie_id = mmg.movie_id
JOIN dim_genres g ON mmg.genre_id = g.genre_id
GROUP BY g.genre_name
ORDER BY avg_gross_usd DESC;