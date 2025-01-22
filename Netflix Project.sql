-- Netflix Project
SELECT * FROM Netflix;

-- 15 Business Problems
-- 1. Count The Number Of Series And Movies
SELECT type,
	COUNT(*) AS Total_Content 
FROM Netflix 
GROUP BY type

-- 2. Find The Most Common Rating For Movies And TV-Shows
SELECT type, rating,Number_Of_Ratings 
FROM (
SELECT type, rating, COUNT(*) AS Number_Of_Ratings, RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) as Ranking
FROM Netflix GROUP BY 1, 2
) AS t1
WHERE Ranking = 1

-- 3. List all movies released in a specific year (e.g., 2020)
SELECT * 
FROM Netflix 
WHERE (release_year = 2020 AND type = 'Movie')

-- 4. Find The Top 3 Countries With The Most Content On Netflix
SELECT UNNEST(STRING_TO_ARRAY(country,',')) AS Country,
COUNT(show_id) AS Total_Content 
FROM Netflix 
GROUP BY 1 
ORDER BY 2 DESC LIMIT 3

-- 5. Identify The Longest Movie
SELECT type, title, duration 
FROM Netflix 
WHERE
	type = 'Movie' AND 
	duration = (SELECT MAX(duration) FROM Netflix )

-- 6. Find content added in the last 5 years
SELECT * 
FROM Netflix 
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 Years'

-- 7. Find all the movies/TV shows by director 'Wim Wenders'
SELECT * 
FROM Netflix 
WHERE director LIKE '%Wim Wenders%'

-- 8. List all TV Shows with more than 5 seasons
SELECT * 
FROM Netflix 
WHERE
	type = 'TV Show'  AND 
	SPLIT_PART(duration, ' ',1)::numeric > 5 

-- 9. Count The Number Of Content Items in Each Genre
SELECT UNNEST(STRING_TO_ARRAY(listed_in,',')), COUNT(show_id)
FROM Netflix 
GROUP BY 1

-- 10. Find Each Year And The Average Numbers Of Content Release By Germany on Netflix.
-- return top 5 years with highest avg content release
SELECT EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS year,
	COUNT(*),
	ROUND(COUNT(*)::numeric/(SELECT COUNT(*) FROM Netflix WHERE country = 'Germany')::numeric*100,2) AS avg_content_per_year
FROM Netflix 
WHERE country = 'Germany' 
GROUP BY 1

-- 11. List all Movies That Are Documentaries
SELECT *
FROM Netflix
WHERE 
	type = 'Movie' 
	AND
	listed_in ILIKE '%documentaries%'

-- 12. Find all Content Without a Director
SELECT * 
FROM Netflix
WHERE director IS NULL

-- 13. Find how many movies actor 'Christoph Waltz' appeared in last 10 years
SELECT * 
FROM Netflix 
WHERE 
	casts ILIKE '%Christoph Waltz%' 
	AND 
	TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '10 Years')

-- 14. Find the top 10 actors who have appeared in the highest number of movies peoduced in Germany.
SELECT UNNEST(STRING_TO_ARRAY(casts,',')) AS Actors,
	COUNT(*) AS Total_Content 
FROM Netflix 
WHERE 
	country ILIKE '%Germany%' 
GROUP BY 1 
ORDER BY 2 DESC LIMIT 10

-- 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords in the Description Field. Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

SELECT 
	Category, 
	COUNT(*) AS Total_Content 
	FROM(
		SELECT *, 
			CASE 
			WHEN
				description ILIKE '%kill%' OR
				description ILIKE '%violence%' THEN 'Bad_Content'
				ELSE 'Good_Content'
			END Category
		FROM Netflix
) AS Categorized_Content
GROUP BY 1
