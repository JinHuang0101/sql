--Data Camp

--Correlated subqueries 
--What is the average number of goals scored in each country?
SELECT
	c.name AS country,
	AVG(m.home_goal + m.away_goal) AS avg_goals 
FROM
	country AS c 
LEFT JOIN match AS m 
ON c.id = m.country_id  
GROUP BY
	country 
;

SELECT
	c.name AS country,
	(SELECT AVG(home_goal + away_goal) 
	 FROM match AS m
	 WHERE m.country_id = c.id) AS avg_goals 
FROM country AS c 
GROUP BY country 
;

--Nested subqueries
--How much did each country's average differ from the overall average?
SELECT
	c.name AS country,
	AVG(m.home_goal + m.away_goal) AS avg_goals,
	AVG(m.home_goal + m.away_goal) - 
		(SELECT AVG(home_goal + away_goal)
		 FROM match) AS avg_diff 
FROM country AS c
LEFT JOIN match AS m 
ON c.id = m.country_id  
GROUP BY country 
;

--Nested subqueries 
--How does each month's total goals differ from the average monthly total of goals scored?
SELECT
	EXTRACT(MONTH FROM date) AS month,
	SUM(m.home_goal + m.away_goal) AS total_goals,
	SUM(m.home_goal + m.away_goal) - 
	(SELECT AVG(goals) 
	FROM (
		SELECT
			EXTRACT(MONTH FROM date) AS month,
			SUM(home_goal + away_goal) AS goals 
		FROM match  
		GROUP BY month
		)
		) AS avg_diff 

FROM
	match AS m  
GROUP BY month  
;

--Nested subqueries 
--What is the each country's average goals scored in the 2011/2012 season?
SELECT
	c.name AS country,
	(SELECT AVG(home_goal+away_goal)  
	 FROM match AS m  
	 WHERE m.country_id = c.id 
	 	AND id IN (
	 		SELECT 
	 		FROM match 
	 		WHERE season = '2011/2012'
	 		)
		) AS avg_goals

FROM country AS c   
GROUP BY country
;

--Common Table Expressions

--subquery in FROM 
SELECT
	c.name AS country,
	COUNT(s.id) AS matches 
FROM country AS c  
INNER JOIN (
	SELECT country_id, id 
	FROM match 
	WHERE (home_goal + away_goal) >= 10) AS s 
ON c.id = s.country_id
GROUP BY 
country
;


--CTE
WITH s AS (
	SELECT country_id, id 
	FROM match   
	WHERE (home_goal + away_goal) >= 10
)
SELECT
	c.name AS country,
	COUNT(s.id) AS matches 
FROM
	country AS c   
INNER JOIN s  
ON c.id = s.country_id
GROUP BY country
;

--CTE
WITH s1 AS(
	SELECT country_id, id 
	FROM match   
	WHERE (home_goal + away_goal)>=10
),
s2 AS (
	SELECT country_id, id 
	FROM  match 
	WHERE (home_goal + away_goal) <= 1 
)
SELECT 
	c.name AS country,
	COUNT(s1.id) AS high_scores,
	COUNT(s2.id) AS low_scores
FROM country AS c  
INNER JOIN s1 ON c.id = s1.country_id
INNER JOIN s2 ON c.id = s2.country_id
GROUP BY country
;

























