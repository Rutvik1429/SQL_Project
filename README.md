# SQL_Project
This repository contains some SQL project for data analyst.


# 1.Netflix_Analysis
![netflix_images](https://github.com/Rutvik1429/SQL_Project/blob/main/Netflix_Analysis/Netflix_logo.png)

**Project Objective:**

The objective of this project is to analyze the Netflix dataset using advanced SQL techniques to extract meaningful insights about content trends, user preferences, and platform distribution. The project leverages SQL subqueries, Common Table Expressions (CTEs), and window functions to perform in-depth data analysis. This includes identifying the most frequent genres, understanding the release trends over the years, examining country-wise content distribution, and ranking shows based on duration and popularity.

To solve these problems efficiently, I used a combination of:

Subqueries for filtering and conditional analysis,

Common Table Expressions (CTEs) for improving query modularity and readability,

Window Functions to rank, group, and aggregate data dynamically across partitions.

This project aims to simulate data-driven decision-making tasks that a data analyst at Netflix might face, enhancing my SQL proficiency and business insight.


Each problem is explained with:
- **Problem Statement** 📝  
- **SQL Query** 💻  
- **Expected Output/Insight** 📈  

## 1️⃣ Count the Number of Movies vs TV Shows
```sql
SELECT type, COUNT(*) 
FROM netflix 
GROUP BY type;
```
![Netflix Q1](https://github.com/Rutvik1429/SQL_Project/blob/main/Netflix_Analysis/Output%20Images/Netflix%20Q1.png)

## 2️⃣ Find the Most Common Rating for Movies and TV Shows
```sql
WITH totalcount AS (
    SELECT type, rating, COUNT(*) AS total_num
    FROM netflix
    GROUP BY 1,2
    ORDER BY total_num DESC
),
rank_count AS (
    SELECT type, rating, total_num,
           RANK() OVER(PARTITION BY type ORDER BY total_num DESC) AS rank_num
    FROM totalcount
)
SELECT type, rating 
FROM rank_count
WHERE rank_num < 2;
```
![Netflix Q2](https://github.com/Rutvik1429/SQL_Project/blob/main/Netflix_Analysis/Output%20Images/Netflix%20Q2.png)

## 3️⃣ List All Movies Released in 2020
```sql
SELECT * 
FROM netflix 
WHERE type = 'Movie' 
  AND release_year = 2020;
```
![Netflix Q3](https://github.com/Rutvik1429/SQL_Project/blob/main/Netflix_Analysis/Output%20Images/Netflix%20Q3.png)

## 4️⃣ Find the Top 5 Countries with the Most Content
```sql
SELECT * 
FROM (
  SELECT UNNEST(STRING_TO_ARRAY(country,',')) AS country,
         COUNT(*) AS count_country 
  FROM netflix 
  GROUP BY country
) AS t1
WHERE country IS NOT NULL
ORDER BY count_country DESC
LIMIT 5;
```
![Netflix Q4](https://github.com/Rutvik1429/SQL_Project/blob/main/Netflix_Analysis/Output%20Images/Netflix%20Q4.png)

## 5️⃣ Identify the Longest Movie
```sql
SELECT * 
FROM netflix 
WHERE type = 'Movie' 
  AND duration IS NOT NULL 
ORDER BY SPLIT_PART(duration,' ',1)::int DESC;
```
![Netflix Q5](https://github.com/Rutvik1429/SQL_Project/blob/main/Netflix_Analysis/Output%20Images/Netflix%20Q5.png)

## 6️⃣ Find Content Added in the Last 5 Years
```sql
SELECT * 
FROM netflix 
WHERE TO_DATE(date_added,'Month DD,YYYY') >= CURRENT_DATE - INTERVAL '5 year';
```
![Netflix Q6](https://github.com/Rutvik1429/SQL_Project/blob/main/Netflix_Analysis/Output%20Images/Netflix%20Q6.png)

## 7️⃣ Find All Movies/TV Shows by Director 'Rajiv Chilaka'
```sql
SELECT * 
FROM netflix 
WHERE director LIKE '%Rajiv Chilaka%';
```
![Netflix Q7](https://github.com/Rutvik1429/SQL_Project/blob/main/Netflix_Analysis/Output%20Images/Netflix%20Q7.png)

## 8️⃣ List All TV Shows with More Than 5 Seasons
```sql
SELECT * 
FROM netflix 
WHERE type = 'TV Show' 
  AND SPLIT_PART(duration,' ',1)::int > 5;
```
![Netflix Q8](https://github.com/Rutvik1429/SQL_Project/blob/main/Netflix_Analysis/Output%20Images/Netflix%20Q8.png)

## 9️⃣ Count the Number of Content Items in Each Genre
```sql
SELECT 
    UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
    COUNT(*) AS total_content
FROM netflix
GROUP BY 1
ORDER BY 2 DESC;
```
![Netflix Q9](https://github.com/Rutvik1429/SQL_Project/blob/main/Netflix_Analysis/Output%20Images/Netflix%20Q9.png)

## 🔟 Average Content Released Per Year in India
```sql
SELECT 
    country,
    release_year,
    COUNT(show_id) AS total_release,
    ROUND(
        COUNT(show_id)::numeric /
        (SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::numeric * 100, 2
    ) AS avg_release
FROM netflix
WHERE country = 'India'
GROUP BY country, release_year
ORDER BY avg_release DESC
LIMIT 5;
```
![Netflix Q10](https://github.com/Rutvik1429/SQL_Project/blob/main/Netflix_Analysis/Output%20Images/Netflix%20Q10.png)

## 1️⃣1️⃣ List All Documentaries
```sql
SELECT * 
FROM netflix 
WHERE listed_in ILIKE '%documentaries%';
```
![Netflix Q11](https://github.com/Rutvik1429/SQL_Project/blob/main/Netflix_Analysis/Output%20Images/Netflix%20Q11.png)

## 1️⃣2️⃣ Find Content Without a Director
```sql
SELECT * 
FROM netflix 
WHERE director IS NULL;
```
![Netflix Q12](https://github.com/Rutvik1429/SQL_Project/blob/main/Netflix_Analysis/Output%20Images/Netflix%20Q12.png)

## 1️⃣3️⃣ Movies with Actor 'Salman Khan' in the Last 10 Years
```sql
SELECT * 
FROM netflix
WHERE casts LIKE '%Salman Khan%'
  AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;
```
![Netflix Q13](https://github.com/Rutvik1429/SQL_Project/blob/main/Netflix_Analysis/Output%20Images/Netflix%20Q13.png)

## 1️⃣4️⃣ Top 10 Actors in Indian Movies
```sql
SELECT 
    UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor,
    COUNT(*)
FROM netflix
WHERE country = 'India'
GROUP BY actor
ORDER BY COUNT(*) DESC
LIMIT 10;
```
![Netflix Q14](https://github.com/Rutvik1429/SQL_Project/blob/main/Netflix_Analysis/Output%20Images/Netflix%20Q14.png)

## 1️⃣5️⃣ Categorize Content Based on 'Kill' and 'Violence'
```sql
SELECT 
    category,
    COUNT(*) AS content_count
FROM (
    SELECT 
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY category;
```
![Netflix Q15](https://github.com/Rutvik1429/SQL_Project/blob/main/Netflix_Analysis/Output%20Images/Netflix%20Q15.png)

**Project Conclusion:**

Through this SQL-based Netflix data analysis project, I achieved the following:

1. Identified content distribution trends by type, genre, country, and release year.

2. Used window functions to find the longest movie and rank actors by appearances.

3. Applied subqueries and filters to analyze content with specific keywords like "Kill" and "Violence".

4. Employed CTEs for reusable logic in complex queries, such as calculating average yearly content for India or counting movies by specific actors and directors.

5. Extracted actionable insights like the most common rating, top-producing countries, and multi-season TV shows.

---
---
