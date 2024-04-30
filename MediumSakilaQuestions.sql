-- Q.1- Which actors participated in the movie ‘Academy Dinosaur’? Print their first and last names.
SELECT a.first_name, a.last_name
FROM 
	actor a
JOIN
	film_actor fa
ON
	a.actor_id=fa.actor_id
JOIN
	film f
ON
	fa.film_id=f.film_id
WHERE
	f.title='Academy Dinosaur';
    
-- Q.2- What is the total amount paid by each customer for all their rentals? 
-- For each customer print their name and the total amount paid.
SELECT concat(c.first_name,' ',c.last_name) AS Cutomer_Name, sum(p.amount) AS 'Total Amount'
FROM 
	customer c
JOIN
	payment p
ON
	c.customer_id=p.customer_id
GROUP BY
	c.customer_id;
    
-- Q.3- How many films from each category each store has? Print the store id, category name and 
-- number of films. Order the results by store id and category name.
SELECT  c.name AS 'Category Name', count(f.film_id) AS 'No. Of Films'
FROM
	category c
JOIN
	film_category fc
ON
	c.category_id=fc.category_id
JOIN
	film f
ON
	fc.film_id=f.film_id
GROUP BY
	c.name;

-- Q.4- Calculate the total revenue of each store.
SELECT s.store_id, sum(p.amount) AS 'Total Revenue'
FROM 
	store s 
JOIN
	inventory i
ON
	s.store_id=i.store_id
JOIN
	rental r
ON
	i.inventory_id=r.inventory_id
JOIN
	payment p 
ON 
	r.rental_id=p.rental_id
GROUP BY
	s.store_id;

-- Q.5- Find pairs of actors that participated together in the same movie and print their full names.
-- Each such pair should appear only once in the result. (You should have 10,385 rows in the result)
SELECT DISTINCT concat(a1.first_name,' ',a1.last_name) AS Actor1,
 concat(a2.first_name,' ',a2.last_name) AS Actor2
FROM
	film_actor fa1
JOIN
	film_actor fa2
ON
	fa1.film_id=fa2.film_id
AND fa1.actor_id<fa2.actor_id
JOIN
	actor a1 
ON 
	fa1.actor_id=a1.actor_id
JOIN
	actor a2
ON
	fa2.actor_id=a2.actor_id;

-- Q.6- Display the top five most popular films, i.e., films that were rented the highest number of times.
-- For each film print its title and the number of times it was rented.
SELECT f.title AS Film, count(r.rental_id) As 'No. Of Times Rented'
FROM 
	film f
JOIN
	inventory i
ON
	f.film_id=i.film_id
JOIN
	rental r
ON	
	i.inventory_id=r.inventory_id
GROUP BY
	f.title
ORDER BY
	count(r.rental_id) DESC
LIMIT 5;

-- Q.7- Is the film ‘Academy Dinosaur’ available for rent from Store 1? You should check that the film
-- exists as one of the items in the inventory of Store 1, and that there is no outstanding rental of
-- that item with no return date.
SELECT f.title, s.store_id,count(i.inventory_id) AS 'Inventory Count', count(r.rental_id) As 'Rental Count' ,
(count(i.inventory_id)-count(r.rental_id)) AS 'Available Copies'
FROM
	film f
JOIN
	inventory i
ON
	f.film_id=i.film_id 
JOIN
	store s
ON 
	i.store_id=s.store_id
LEFT JOIN
	rental r
ON
	i.inventory_id=r.inventory_id
WHERE 
	f.title='Academy Dinosaur'
AND
    s.store_id=1
GROUP BY
	f.title;
    
-- WITH CTE 
WITH cte_actor AS(
	SELECT actor_id, first_name, last_name
    FROM actor
    )
SELECT actor_id, first_name, last_name FROM cte_actor;

-- Multiple WITH CTE
WITH cte_filmActor AS(
	SELECT actor_id,film_id
    FROM film_actor
    ),
cte_film AS(
	SELECT film_id, title 
    FROM film
    )
SELECT DISTINCT fa.film_id,fa.actor_id,f.title 
FROM cte_filmActor fa
JOIN
	cte_film f
ON
	fa.film_id=f.film_id
;
	

-- With Recursive CTE
WITH RECURSIVE cte_num AS(
	SELECT 2 AS n
	UNION ALL
    SELECT n+2 FROM cte_num WHERE n<6
    )
SELECT n FROM cte_num;

-- Write a query to find the film which grossed the highest revenue for the video renting organization.
SELECT f.title AS Film, SUM(p.amount) Revenue
FROM film f
JOIN inventory i USING (film_id)
JOIN rental r USING (inventory_id)
JOIN payment p USING (rental_id)
GROUP BY f.film_id
ORDER BY sum(p.amount) DESC
LIMIT 1;

-- Write a query to find the city which generated the maximum revenue for the organization.
SELECT ct.city AS City, SUM(p.amount) Revenue
FROM city ct
JOIN address a USING (city_id)
JOIN customer USING	(address_id)
JOIN payment p USING (customer_id)
GROUP BY ct.city_id
ORDER BY SUM(p.amount) DESC
LIMIT 1;

-- Write a query to find out how many times a particular movie category is rented. Arrange these categories in the 
-- decreasing order of the number of times they are rented.
SELECT c.name Movie_Category, COUNT(r.rental_id) Rented_Count
FROM category c 
JOIN film_category USING (category_id)
JOIN film USING (film_id)
JOIN inventory USING (film_id)
JOIN rental r USING (inventory_id)
GROUP BY Movie_Category
ORDER BY Rented_Count DESC;

-- Write a query to find the full names of customers who have rented sci-fi movies more than 2 times.
-- Arrange these names in alphabetical order.
SELECT concat(c.first_name,' ',c.last_name) Customer_Name
FROM category cy JOIN 
	film_category fc
ON 
	cy.category_id=fc.category_id AND cy.name='Sci-Fi'
JOIN film USING (film_id)
JOIN inventory USING (film_id)
JOIN rental r USING (inventory_id)
JOIN customer c USING (customer_id)
GROUP BY Customer_Name
HAVING count(r.rental_id)>2
ORDER BY Customer_Name DESC;

-- Write a query to find the full names of those customers who have rented at least one movie and belong to
-- the city Arlington.
SELECT concat(c.first_name," ",c.last_name) Customer_Name, COUNT(r.rental_id) Rented_Film
FROM  rental r
JOIN customer c USING (customer_id)
JOIN address a USING (address_id)
JOIN city ct USING (city_id) 
WHERE city='Arlington'
GROUP BY c.customer_id
HAVING count(r.rental_id)>=1
;

-- Write a query to find the number of movies rented across each country. Display only those countries where at 
-- least one movie was rented. Arrange these countries in alphabetical order.
SELECT country, COUNT(r.rental_id) Rented_Film
FROM rental r
JOIN customer c USING (customer_id)
JOIN address a USING (address_id)
JOIN city ct USING (city_id) 
JOIN country USING (country_id)
GROUP BY country_id
HAVING Rented_Film>=1
ORDER BY country
;


