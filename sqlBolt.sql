/*
SQL tutorial from SQLBolt.com 

*/


Select query with unique results
SELECT DISTINCT column, another_column, …
FROM mytable
WHERE condition(s);

Select query with ordered results
SELECT column, another_column, …
FROM mytable
WHERE condition(s)
ORDER BY column ASC/DESC;


# EXAMPLE: List the two largest cities in Mexico (by population)  
SELECT * 
FROM North_american_cities
WHERE COUNTRY = "Mexico"
ORDER BY POPULATION DESC
LIMIT 2;




/*
Limiting results to a subset
The LIMIT will reduce the number of rows to return, 
and the optional OFFSET will specify where to begin counting the number rows from.
*/
Select query with limited rows
SELECT column, another_column, …
FROM mytable
WHERE condition(s)
ORDER BY column ASC/DESC
LIMIT num_limit OFFSET num_offset;

# example: List the first five Pixar movies sorted alphabetically
SELECT TITLE, YEAR FROM MOVIES 
ORDER BY YEAR DESC 
LIMIT 4;

# example: List the first five Pixar movies sorted alphabetically 
SELECT title, year FROM movies
ORDER BY TITLE
LIMIT 5;

# example continued: List the next five Pixar movies sorted alphabetically
SELECT TITLE FROM MOVIES 
ORDER BY TITLE ASC 
LIMIT 5 OFFSET 5;

# EXAMPLE: List the third and fourth largest cities (by population) in the United States 
#and their population 

SELECT * 
FROM North_american_cities
WHERE COUNTRY = "United States"
ORDER BY POPULATION DESC
LIMIT 2 OFFSET 2;


/*
Multi-table queries with JOINs
Using the JOIN clause in a query, 
we can combine row data across two separate tables using this unique key. 

The INNER JOIN is a process that matches rows from the first table 
and the second table which have the same key (as defined by the ON constraint) 
to create a result row with the combined columns from both tables. 

*/

Select query with INNER JOIN on multiple tables
SELECT column, another_table_column, …
FROM mytable
INNER JOIN another_table 
    ON mytable.id = another_table.id
WHERE condition(s)
ORDER BY column, … ASC/DESC
LIMIT num_limit OFFSET num_offset;


/*
Example:
Exercise 6 — Tasks
1. Find the domestic and international sales for each movie ✓
2. Show the sales numbers for each movie that did better internationally rather than domestically
3. List all the movies by their ratings in descending order
*/
SELECT * FROM movies
INNER JOIN BOXOFFICE ON MOVIES.ID = BOXOFFICE.MOVIE_ID;

SELECT * FROM movies
INNER JOIN BOXOFFICE ON MOVIES.ID = BOXOFFICE.MOVIE_ID
WHERE International_sales > Domestic_sales;

SELECT * FROM movies
INNER JOIN BOXOFFICE ON MOVIES.ID = BOXOFFICE.MOVIE_ID
ORDER BY RATING DESC;

/*
Depending on how you want to analyze the data, 
the INNER JOIN we used last lesson might not be sufficient 
because the resulting table only contains data that belongs in both of the tables.

If the two tables have asymmetric data, 
which can easily happen when data is entered in different stages, 
then we would have to use a LEFT JOIN, RIGHT JOIN or FULL JOIN 
instead to ensure that the data you need is not left out of the results.

Like the INNER JOIN these three new joins have to specify which column to join the data on.
When joining table A to table B, a LEFT JOIN simply includes rows from A
 regardless of whether a matching row is found in B. 
 The RIGHT JOIN is the same, but reversed, keeping rows in B 
 regardless of whether a match is found in A. 

 Finally, a FULL JOIN simply means that rows from both tables are kept, 
 regardless of whether a matching row exists in the other table.
*/

Select query with LEFT/RIGHT/FULL JOINs on multiple tables
SELECT column, another_column, …
FROM mytable
INNER/LEFT/RIGHT/FULL JOIN another_table 
    ON mytable.id = another_table.matching_id
WHERE condition(s)
ORDER BY column, … ASC/DESC
LIMIT num_limit OFFSET num_offset;

/*
List all buildings and the distinct employee roles 
in each building (including empty buildings) 
*/
SELECT DISTINCT building_name, role 
FROM buildings 
  LEFT JOIN employees
    ON building_name = building;

# NULL 
Select query with constraints on NULL values
SELECT column, another_column, …
FROM mytable
WHERE column IS/IS NOT NULL
AND/OR another_condition
AND/OR …;

# EXAMPLE, Find the names of the buildings that hold no employees 
SELECT * 
FROM BUILDINGS
    LEFT JOIN EMPLOYEES
        ON BUILDINGS.BUILDING_NAME = EMPLOYEES.BUILDING
WHERE ROLE IS NULL;


#Example query with expressions
SELECT particle_speed / 2.0 AS half_particle_speed
FROM physics_data
WHERE ABS(particle_position) * 10.0 > 500;



Select query with expression aliases
SELECT col_expression AS expr_description, …
FROM mytable;


#Example query with both column and table name aliases
SELECT column AS better_column_name, …
FROM a_long_widgets_table_name AS mywidgets
INNER JOIN widget_sales
  ON mywidgets.id = widget_sales.widget_id;

/*
List all movies and their combined sales in millions of dollars 
*/
SELECT *, (Domestic_sales + International_sales)/1000000 AS COMBINED_SALES 
FROM movies
    LEFT JOIN BOXOFFICE 
        WHERE MOVIES.ID = BOXOFFICE.MOVIE_ID;

# List all movies and their ratings in percent

SELECT title, rating * 10 AS rating_percent
FROM movies
  JOIN boxoffice
    ON movies.id = boxoffice.movie_id;

#List all movies that were released on even number years ✓
SELECT * FROM MOVIES
WHERE YEAR % 2 = 0;


Select query with aggregate functions over all rows
SELECT AGG_FUNC(column_or_expression) AS aggregate_description, …
FROM mytable
WHERE constraint_expression;


/*
Common aggregate functions:
*/

COUNT(*)
COUNT(column)
MIN(column)
MAX(column)
AVG(column)
SUM(column)

/*
In addition to aggregating across all the rows, you can instead apply the aggregate functions to individual groups of data within that group (ie. box office sales for Comedies vs Action movies).
This would then create as many results as there are unique groups defined as by the GROUP BY clause.
*/

Select query with aggregate functions over groups
SELECT AGG_FUNC(column_or_expression) AS aggregate_description, …
FROM mytable
WHERE constraint_expression
GROUP BY column;


# example: For each role, find the average number of years employed by employees in that role
SELECT ROLE, AVG(YEARS_EMPLOYED) FROM employees
GROUP BY ROLE;

# EXAMPLE: Find the total number of employee years worked in each building 
SELECT BUILDING,  SUM(YEARS_EMPLOYED) FROM employees
GROUP BY BUILDING;

/*
if the GROUP BY clause is executed after the WHERE clause 
(which filters the rows which are to be grouped), 
then how exactly do we filter the grouped rows?

Luckily, SQL allows us to do this by adding an additional HAVING clause 
which is used specifically with the GROUP BY clause 
to allow us to filter grouped rows from the result set.

The HAVING clause constraints are written the same way as 
the WHERE clause constraints, and are applied to the grouped rows.
*/

Select query with HAVING constraint
SELECT group_by_column, AGG_FUNC(column_expression) AS aggregate_result_alias, …
FROM mytable
WHERE condition
GROUP BY column
HAVING group_condition;


# Find the total number of years employed by all Engineers 
SELECT *, SUM(YEARS_EMPLOYED) 
FROM employees
WHERE ROLE = "Engineer";


Complete SELECT query
SELECT DISTINCT column, AGG_FUNC(column_or_expression), …
FROM mytable
    JOIN another_table
      ON mytable.column = another_table.column
    WHERE constraint_expression
    GROUP BY column
    HAVING constraint_expression
    ORDER BY column ASC/DESC
    LIMIT count OFFSET COUNT;


# Find the number of movies each director has directed 
SELECT DIRECTOR, COUNT(*) 
FROM movies
GROUP BY DIRECTOR;

# Find the total domestic and international sales that can be attributed to each director
# or inner join
SELECT DIRECTOR, SUM(Domestic_sales+International_sales) AS TOTAL_SALES
FROM movies
JOIN BOXOFFICE 
    WHERE MOVIES.ID = BOXOFFICE.MOVIE_ID
GROUP BY DIRECTOR;

# insert new data
Insert statement with values for all columns
INSERT INTO mytable
VALUES (value_or_expr, another_value_or_expr, …),
       (value_or_expr_2, another_value_or_expr_2, …),
       …;

/*
if you have incomplete data and the table contains columns that support default values, 
you can insert rows with only the columns of data you have by specifying them explicitly.
*/

Insert statement with specific columns
INSERT INTO mytable
(column, another_column, …)
VALUES (value_or_expr, another_value_or_expr, …),
      (value_or_expr_2, another_value_or_expr_2, …),
      …;

/*
use mathematical and string expressions with the values that you are inserting.
This can be useful to ensure that all data inserted is formatted a certain way.
*/
Example Insert statement with expressions
INSERT INTO boxoffice
(movie_id, rating, sales_in_millions)
VALUES (1, 9.9, 283742034 / 1000000);


/*
Exercise 13 — Tasks
Add the studio's new production, Toy Story 4 to the list of movies (you can use any director) 

Toy Story 4 has been released to critical acclaim! It had a rating of 8.7, and made 340 million domestically and 270 million internationally. Add the record to the BoxOffice table.
*/
INSERT INTO Movies 
(Title, Director, Year, Length_minutes)
VALUES("Toy Story 4", "John Lasseter", "2010", "100");


INSERT INTO Boxoffice
(Movie_id, Rating, Domestic_sales, International_sales)
VALUES("15", "8.7", "340000000", "270000000");




