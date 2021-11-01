USE sakila;
-- Task 1 How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT COUNT(*) AS 'Number of Copies' FROM inventory
WHERE inventory.film_id = (
SELECT film.film_id FROM film
WHERE film.title = 'HUNCHBACK IMPOSSIBLE');

-- Task 2 List all films whose length is longer than the average of all the films.
SELECT film_id, title, length FROM film
WHERE (
SELECT AVG(length) FROM film)
 ORDER BY length DESC;
 
 -- Task 3 Use subqueries to display all actors who appear in the film Alone Trip.
 SELECT first_name, last_name FROM actor
 WHERE actor_id IN (
 SELECT actor_id FROM film_actor WHERE film_id IN (
 SELECT film_id FROM film WHERE title = 'ALONE TRIP')) 
 ORDER BY last_name ASC;
 
 
 -- Task 4  Identify all movies categorized as family films.
 SELECT name FROM category;
 
 SELECT title FROM film WHERE film_id IN
 (SELECT film_id FROM film_category WHERE category_id IN
 (SELECT category_id FROM category WHERE name = 'Family'));
 
 -- Task 5 Get name and email from customers from Canada using subqueries. Do the same with joins. 
 -- Subqueries
 SELECT first_name, last_name, email FROM customer WHERE address_id IN
 (SELECT address_id FROM address WHERE city_id IN
 (SELECT city_id FROM city WHERE country_id IN
 (SELECT country_id FROM country WHERE country = 'Canada')));
 
 -- Joins
 select c.first_name, c.last_name, c.email from sakila.customer c
inner join address a
on (c.address_id = a.address_id)
inner join city b
on (b.city_id = a.city_id)
inner join country e
on (e.country_id = b.country_id)
where e.country= 'Canada'
order by last_name;
 
 
 -- Task 6 Actor with most number of films and the names of those films

SELECT a.actor_id, actor.first_name, actor.last_name, a.film_count FROM actor
LEFT JOIN(SELECT COUNT(film_id) AS film_count, actor_id FROM film_actor
GROUP BY actor_id)AS a
ON (actor.actor_id=a.actor_id)
ORDER BY film_count DESC
limit 1;
 
 SELECT title FROM film WHERE film_id IN
(SELECT film_id FROM film WHERE film_id IN
(SELECT film_id FROM film_actor WHERE actor_id = 107));

-- Task 7 Films rented by most profitable customer.
-- You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
 
SELECT c.customer_id, c.first_name, c.last_name, sum(p.amount) as total FROM sakila.customer c
JOIN payment p
ON c.customer_id = p.customer_id
GROUP BY c.customer_id
ORDER BY sum(p.amount) DESC
limit 3;

SELECT sum(amount) AS total FROM payment WHERE customer_id in
(SELECT customer_id FROM payment WHERE customer_id in
(SELECT customer_id FROM customer WHERE customer_id = 526));

-- Task 8

SELECT SUM(amount), CONCAT(first_name,' ',last_name) FROM sakila.customer
JOIN sakila.payment USING (customer_id)
GROUP BY customer_id
HAVING sum(amount) > (SELECT avg(total_payment) FROM (
SELECT customer_id, SUM(amount) as total_payment FROM sakila.payment
GROUP BY customer_id) sub1)
ORDER BY SUM(amount) DESC;
