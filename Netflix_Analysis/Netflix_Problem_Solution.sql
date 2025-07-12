
-- 1. Count the Number of Movies vs TV Shows

select type,count(*) from netflix group by type;


-- 2. Find the Most Common Rating for Movies and TV Shows

with totalcount as(select type,rating,count(*) AS total_num
from netflix
group by 1,2
order by total_num desc),
rank_count as(select type , rating , total_num,
rank() over(partition by type order by total_num desc) as rank_num
from totalcount)
select type,rating 
from rank_count
where rank_num < 2;


-- 3. List All Movies Released in a Specific Year (e.g., 2020)

select * from netflix where
type = 'Movie' and
release_year = 2020;


-- 4. Find the Top 5 Countries with the Most Content on Netflix

select * from (select unnest(string_to_array(country,',')) as country,
count(*) as count_country 
from netflix 
group by country) as t1
where country is not null
order by count_country desc
limit 5;


-- 5. Identify the Longest Movie.

select * from netflix;

select split_part(duration,' ',1)::int as Num from netflix;

select * from (select split_part(duration,' ',1) as Num from netflix )

select * from netflix where type = 'Movie' and duration is not null order by split_part(duration,' ',1)::int desc;

-- 6. Find Content Added in the Last 5 Years

select * from netflix;

select * from netflix where to_date(date_added,'Month DD,YYYY') >= current_date - interval '5 year';

-- 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

select * from netflix;

select * from netflix where director like '%Rajiv Chilaka%';

select unnest(string_to_array(director,',')) as director_name from netflix;

select * from (select *,unnest(string_to_array(director,',')) as director_name from netflix) as t1 where director_name = 'Rajiv Chilaka';

-- 8. List All TV Shows with More Than 5 Seasons

select * from netflix;

select type,split_part(duration,' ',1) as Num from netflix where type = 'TV Show';

select * from netflix where type = 'TV Show' and split_part(duration,' ',1)::int > 5;

-- 9. Count the Number of Content Items in Each Genre

select * from netflix;

SELECT 
    UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
    COUNT(*) AS total_content
FROM netflix
GROUP BY 1
order by 2 desc;

select * from (select unnest(string_to_array(listed_in,',')) as Each_genre,count(*) as Num from netflix group by Each_genre) as t1 order by Num desc; 

-- 10. Find each year and the average numbers of content release in India on netflix.

select year(date_added) from netflix;

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

-- 11. List All Movies that are Documentaries

select * from netflix;

select * from netflix where listed_in ilike '%documentaries%';


-- 12. Find All Content Without a Director

select * from netflix where director is null


-- 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

SELECT * 
FROM netflix
WHERE casts LIKE '%Salman Khan%'
  AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;


-- 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

SELECT 
    UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor,
    COUNT(*)
FROM netflix
WHERE country = 'India'
GROUP BY actor
ORDER BY COUNT(*) DESC
LIMIT 10;


-- 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

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