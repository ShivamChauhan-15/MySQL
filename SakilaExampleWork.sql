-- 1a. Display the first and last names of all actors from the table actor.
SELECT first_name, last_name FROM actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
SELECT UPPER(CONCAT_WS(' ',first_name,last_name)) AS 'Actor Name'  FROM actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only
-- the first name, “Joe.” What is one query would you use to obtain this information?

-- 2b. Find all actors whose last name contain the letters GEN:
SELECT actor_id, first_name, last_name FROM actor WHERE last_name LIKE '%GEN%';

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by 
-- last name and first name, in that order:
SELECT  actor_id, first_name, last_name FROM actor WHERE last_name LIKE '%LI%' ORDER BY last_name, first_name;

-- 2d. Using IN, display the country_id and country columns of the following countries:
-- Afghanistan, Bangladesh, and China:
SELECT country_id, country FROM country WHERE country IN('Afghanistan','Bangladesh','China');

-- 3a. Add a middle_name column to the table actor. Position it between first_name and last_name.
ALTER TABLE actor ADD middle_name VARCHAR(45) AFTER first_name;

-- 3b. You realize that some of these actors have tremendously long last names.
-- Change the data type of the middle_name column to blobs
ALTER TABLE actor MODIFY middle_name blob;
desc actor;

-- 3c. Now delete the middle_name column.
ALTER TABLE actor DROP middle_name;

-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, count(last_name) AS last_name_count FROM actor GROUP BY last_name;

-- 4b. List last names of actors and the number of actors who have that last name, 
-- but only for names that are shared by at least two actors
SELECT last_name, COUNT(last_name) AS last_name_count FROM actor
 GROUP BY last_name HAVING COUNT(last_name)>1;
 
-- 4c. Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS,
-- the name of Harpo’s second cousin’s husband’s yoga teacher. Write a query to fix the record.
UPDATE actor SET first_name='HARPO' WHERE first_name='GROUCHO' AND last_name='WILLIAMS';

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name 
-- after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO. 
-- Otherwise, change the first name to MUCHO GROUCHO, as that is exactly what the actor will be with the 
-- grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO MUCHO GROUCHO, HOWEVER!
UPDATE actor SET first_name=
CASE
	WHEN first_name='HARPO' THEN 'GROUCHO'
    WHEN first_name='GROUCHO' THEN 'MUCHO GROUCHO'
    ELSE first_name
    END 
    WHERE last_name='WILLIAMS';
    
-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member.
-- Use the tables staff and address:
SELECT s.first_name, s.last_name, a.address 
FROM 
	staff s
INNER JOIN
	address a
ON
	s.address_id=a.address_id;
	
-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. 
-- Use tables staff and payment.    
SELECT s.staff_id, s.first_name, s.last_name, SUM(p.amount) AS TotalAmount 
FROM
	staff s
INNER JOIN
	payment p
ON 
	s.staff_id = p.staff_id
WHERE 
	p.payment_date LIKE '2005-08%'
GROUP BY
	p.staff_id;
    
-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. 
-- Use inner join    
SELECT f.title AS Film, count(fa.actor_id) AS NumberOfActors 
FROM
	film_actor fa
INNER JOIN
	film f
ON
	fa.film_id=f.film_id
GROUP BY
	f.title;
    
-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT f.title AS Film, count(i.inventory_id)
FROM
	film f
INNER JOIN 
	inventory i
ON 
	f.film_id=i.film_id
WHERE
	f.title='Hunchback Impossible';

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. 
-- List the customers alphabetically by last name:    
SELECT c.customer_id, c.first_name, c.last_name, sum(p.amount) AS TotalPaid
FROM
	payment p
INNER JOIN
	customer c
ON
	p.customer_id=c.customer_id
GROUP BY
	c.customer_id
ORDER BY
	last_name;
    
-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended 
-- consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to 
-- display the titles of movies starting with the letters K and Q whose language is English.    
SELECT f.title AS Film_Title
FROM 
	film f
INNER JOIN
	language l
ON
	f.language_id=l.language_id
WHERE l.name='English'
AND f.title LIKE  'K%' OR f.title LIKE 'Q%';

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT actor_id, first_name, last_name 
FROM actor WHERE actor_id IN 
(SELECT actor_id FROM film_actor WHERE film_id=
(SELECT film_id FROM film WHERE title='Alone Trip'));
 
-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and 
-- email addresses of all Canadian customers. Use joins to retrieve this information. 
SELECT concat_ws(' ',c.first_name,c.last_name) as 'Name', c.email as 'E-mail'
FROM customer c
INNER JOIN 
	address a
ON 
	c.address_id = a.address_id
INNER JOIN 
	city cy 
ON 
	a.city_id = cy.city_id
INNER JOIN 
	country ct
ON 
	ct.country_id = cy.country_id
WHERE ct.country = 'Canada';    

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion.
-- Identify all movies categorized as famiy films.
SELECT f.title AS Movies FROM 
	film f
INNER JOIN
	film_category fc
ON 
	f.film_id=fc.film_id
INNER JOIN
	category c
ON
	fc.category_id = c.category_id
WHERE 
	c.name='Family';
    
-- 7e. Display the most frequently rented movies in descending order.
SELECT f.title as 'Movie', count(r.rental_date) AS ' NO. OF Times Rented'
FROM 
	film f
INNER JOIN
	inventory i 
ON 
	i.film_id = f.film_id
INNER JOIN
	rental r 
ON 
	r.inventory_id = i.inventory_id
GROUP BY
	f.title
ORDER BY 
	count(r.rental_date) desc;
    
-- 7f. Write a query to display how much business, in dollars, each store brought instore.
SELECT s.store_id, sum(p.amount) AS 'Total Amount'
FROM 
	payment p
JOIN 
	staff s
ON 
	p.staff_id=s.staff_id
GROUP BY
	s.store_id;

-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT  s.store_id, cy.city, ct.country
FROM
	store s
JOIN 
	address a
ON	
	s.address_id=a.address_id
JOIN
	city cy
ON 
	a.city_id=cy.city_id
JOIN
	country ct
ON 
	cy.country_id=ct.country_id;
    
-- 7h. List the top five genres in gross revenue in descending order.
SELECT c.name, sum(p.amount) AS 'Gross Revenue'
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
JOIN
	inventory i
ON
	f.film_id=i.film_id
JOIN
	rental r
ON 
	i.inventory_id=r.inventory_id
JOIN
	payment p
ON
	r.rental_id=p.rental_id
GROUP BY
	c.name
ORDER BY
	sum(p.amount) DESC
LIMIT 5;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres
-- by gross revenue. Use the solution from the problem above to create a view. If you haven’t solved 7h,
-- you can substitute another query to create a view.
CREATE VIEW top_5_genre_revenue AS
SELECT c.name, sum(p.amount) AS 'Gross Revenue'
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
JOIN
	inventory i
ON
	f.film_id=i.film_id
JOIN
	rental r
ON 
	i.inventory_id=r.inventory_id
JOIN
	payment p
ON
	r.rental_id=p.rental_id
GROUP BY
	c.name
ORDER BY
	sum(p.amount) DESC
LIMIT 5;

-- 8b. How would you display the view that you created in 8a?
SELECT * FROM top_5_genre_revenue;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW top_5_genre_revenue;

USE sakila;
SHOW CREATE TABLE address;	

-- Q. Select all columns from the payment table for payments made between midnight 05/25/2005 and 1 second before
-- midnight 05/26/2005.
SELECT * FROM 
payment
WHERE payment_date BETWEEN '2005-05-25 23:59:59' AND '2005-05-26 23:59:59';

-- Q. Find country name whose customer has maximum payment amount
SELECT cy.country, sum(p.amount)
FROM
	payment p
JOIN
	customer cu
ON 
	p.customer_id=cu.customer_id
JOIN
	address a
ON
	cu.address_id=a.address_id 
JOIN
	city ct
ON
	a.city_id=ct.city_id
JOIN
	country cy
ON
	ct.country_id=cy.country_id
GROUP BY 
	cu.customer_id
ORDER BY
	sum(p.amount) DESC
LIMIT 1;

    