-- Q.1- Which actors have the first name ‘Scarlett’
SELECT * FROM actor WHERE first_name = 'Scarlett';

-- Q.2- Which actors have the last name ‘Johansson’
SELECT * FROM actor WHERE last_name = 'Johansson';

-- Q.3- How many distinct actors last names are there?
SELECT count(distinct last_name) AS LastName_Count FROM actor; 

-- Q.4- Which last names are not repeated? 
SELECT last_name FROM actor GROUP BY last_name HAVING count(last_name)=1;

-- Q.5- Which last names appear more than once?
SELECT last_name FROM actor GROUP BY last_name HAVING count(last_name)>1;

-- Q.6- Which actor has appeared in the most films?
SELECT a.actor_id, a.first_name, a.last_name, COUNT(fa.film_id) AS film_count
FROM actor a
INNER JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id
ORDER BY film_count DESC
LIMIT 1;

-- 2nd approach
/* SELECT * FROM actor WHERE actor_id=(SELECT actor_id
FROM film_actor
GROUP BY actor_id
HAVING count(actor_id) = (
    SELECT MAX(actor_count)
    FROM (
        SELECT COUNT(actor_id) AS actor_count
        FROM film_actor
        GROUP BY actor_id
    ) AS actor_counts
)); */

-- Q.7- Is ‘Academy Dinosaur’ available for rent from Store 1?

-- Q.8- Insert a record to represent Mary Smith renting ‘Academy Dinosaur’ from Mike Hillyer at Store 1 today 
INSERT INTO rental (rental_date, inventory_id, customer_id, return_date, staff_id)
VALUES (NOW(), 
        (SELECT inventory_id
         FROM inventory i 
         INNER JOIN 
         film f ON i.film_id=f.film_id 
         WHERE 
         f.title='Academy Dinosaur'
         AND i.store_id=1
         LIMIT 1),
        (SELECT customer_id 
        FROM customer c 
        WHERE c.first_name='MARY' 
        AND c.last_name='SMITH' 
        AND c.store_id=1
        LIMIT 1),
        NULL,
        (SELECT staff_id
         FROM staff
         WHERE first_name = 'Mike' AND last_name = 'Hillyer'
         LIMIT 1));

-- Q.9- When is ‘Academy Dinosaur’ due?
SELECT 
    r.rental_date as Rental_Date,
    DATE_ADD(r.rental_date, INTERVAL f.rental_duration DAY) AS Due_Date 
FROM 
    rental r
JOIN 
    inventory i ON r.inventory_id = i.inventory_id 
JOIN 
    film f ON i.film_id = f.film_id
WHERE 
    f.title = 'Academy Dinosaur'
    AND r.return_date IS NULL;

-- Q.10- What is that average running time of all the films in the sakila DB?
SELECT avg(length) AS 'Average Running Time' FROM film;

-- Q.11- What is the average running time of films by category?
SELECT c.name AS Category, avg(f.length) AS 'Average Runnning Time'
FROM
	film f 
JOIN 
	film_category fc
ON
	f.film_id=fc.film_id
JOIN 
	category c 
ON 
	fc.category_id=c.category_id
GROUP BY
	c.category_id;
    
-- Q.13 Why does this query return the empty set?
SELECT * FROM film NATURAL JOIN inventory;



