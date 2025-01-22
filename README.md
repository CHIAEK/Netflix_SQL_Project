# Netflix Movies and TV Shows Data Analysis using SQL

![Netflix Logo](https://github.com/CHIAEK/Netflix_SQL_Project/blob/main/logo.png)

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives

- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Dataset

The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Schema

```sql
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(10),
    type         VARCHAR(20),
    title        VARCHAR(250),
    director     VARCHAR(600),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(60),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(300),
    description  VARCHAR(600)
);
```

## Business Problems and Solutions

### 1. Count the Number of Movies vs TV Shows

```sql
SELECT 
    type,
    COUNT(*)
FROM netflix
GROUP BY 1;
```

**Objective:** Determine the distribution of content types on Netflix.

### 2. Find the Most Common Rating for Movies and TV Shows

```sql
WITH RatingCounts AS (
    SELECT 
        type,
        rating,
        COUNT(*) AS rating_count
    FROM netflix
    GROUP BY type, rating
),
RankedRatings AS (
    SELECT 
        type,
        rating,
        rating_count,
        RANK() OVER (PARTITION BY type ORDER BY rating_count DESC) AS rank
    FROM RatingCounts
)
SELECT 
    type,
    rating AS most_frequent_rating
FROM RankedRatings
WHERE rank = 1;
```

**Objective:** Identify the most frequently occurring rating for each type of content.

### 3. List All Movies Released in a Specific Year (e.g., 2020)

```sql
SELECT * 
FROM netflix
WHERE (release_year = 2020 AND type = 'Movie');
```

**Objective:** Retrieve all movies released in a specific year.

### 4. Find the Top 3 Countries with the Most Content on Netflix

```sql
SELECT UNNEST(STRING_TO_ARRAY(country,',')) AS Country,
COUNT(show_id) AS Total_Content 
FROM Netflix 
GROUP BY 1 
ORDER BY 2 DESC LIMIT 3;
```

**Objective:** Identify the top 3 countries with the highest number of content items.

### 5. Identify the Longest Movie

```sql
SELECT type, title, duration 
FROM Netflix 
WHERE
	type = 'Movie' AND 
	duration = (SELECT MAX(duration) FROM Netflix );
```

**Objective:** Find the movie with the longest duration.

### 6. Find Content Added in the Last 5 Years

```sql
SELECT *
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';
```

**Objective:** Retrieve content added to Netflix in the last 5 years.

### 7. Find All Movies/TV Shows by Director 'Wim Wenders'

```sql
SELECT * 
FROM Netflix 
WHERE director ILIKE '%Wim Wenders%';
```

**Objective:** List all content directed by 'Wim Wenders'.

### 8. List All TV Shows with More Than 5 Seasons

```sql
SELECT * 
FROM Netflix 
WHERE
	type = 'TV Show'  AND 
	SPLIT_PART(duration, ' ',1)::numeric > 5 ;
```

**Objective:** Identify TV shows with more than 5 seasons.

### 9. Count the Number of Content Items in Each Genre

```sql
SELECT 
    UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
    COUNT(*) AS total_content
FROM netflix
GROUP BY 1;
```

**Objective:** Count the number of content items in each genre.

### 10.Find each year and the average numbers of content release in Germany on netflix. 
return top 5 year with highest avg content release!

```sql
SELECT EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS year,
	COUNT(*),
	ROUND(COUNT(*)::numeric/(SELECT COUNT(*) FROM Netflix WHERE country = 'Germany')::numeric*100,2) AS avg_content_per_year
FROM Netflix 
WHERE country = 'Germany' 
GROUP BY 1
ORDER BY 3 DESC
LIMIT 5;
```

**Objective:** Calculate and rank years by the average number of content releases by Germany.

### 11. List All Movies that are Documentaries

```sql
SELECT *
FROM Netflix
WHERE 
	type = 'Movie' 
	AND
	listed_in ILIKE '%documentaries%';
```

**Objective:** Retrieve all movies classified as documentaries.

### 12. Find All Content Without a Director

```sql
SELECT * 
FROM netflix
WHERE director IS NULL;
```

**Objective:** List content that does not have a director.

### 13. Find How Many Movies Actor 'Christoph Waltz' Appeared in the Last 10 Years

```sql
SELECT * 
FROM Netflix 
WHERE 
	casts ILIKE '%Christoph Waltz%' 
	AND 
	TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '10 Years');
```

**Objective:** Count the number of movies featuring 'Christoph Waltz' in the last 10 years.

### 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in Germany

```sql
SELECT UNNEST(STRING_TO_ARRAY(casts,',')) AS Actors,
	COUNT(*) AS Total_Content 
FROM Netflix 
WHERE 
	country ILIKE '%Germany%' 
GROUP BY 1 
ORDER BY 2 DESC
LIMIT 10;
```

**Objective:** Identify the top 10 actors with the most appearances in German-produced movies.

### 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

```sql
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
GROUP BY 1;
```

**Objective:** Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

## Findings and Conclusion

- **Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- **Common Ratings:** Insights into the most common ratings provide an understanding of the content's target audience.
- **Content Categorization:** Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.



## Author - CHIBANI Abdelkader

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!

- **EMAIL**: [abdelkader.chibani.1211@gmail.com].

I look forward to connecting with you!
