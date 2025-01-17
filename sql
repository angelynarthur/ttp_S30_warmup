-- You're wandering through the wilderness of someone else's code, and you stumble across
-- the following queries that use subqueries. You think they'd be better as CTE's
-- Go ahead and re-write the queries to use CTE's

-- -- EXAMPLE CTE:
--Returns the customer ID’s of ALL customers who have spent more money than $100 in their life.

WITH customer_totals AS (
  SELECT customer_id, 
         SUM(amount) as total
  FROM payment
  GROUP BY customer_id
)

SELECT customer_id, total 
FROM customer_totals 
WHERE total > 100;


--YOUR TURN:
-- Returns the average of the amount of stock each store has in their inventory. 
SELECT AVG(stock)
FROM (SELECT COUNT(inventory_id) as stock
	  FROM inventory
	  GROUP BY store_id) as store_stock;
	  
      
WITH avg_amount AS (
SELECT COUNT(inventory_id) as total
FROM inventory
GROUP BY store_id
)

SELECT AVG(total)
FROM avg_amount;


-- Returns the average customer lifetime spending, for each staff member.
-- HINT: you can work off the example
SELECT staff_id, AVG(total)
FROM (SELECT staff_id, SUM(amount) as total
	  FROM payment 
	  GROUP BY customer_id, staff_id) as customer_totals
GROUP BY staff_id;



WITH lifetime_spending AS (SELECT staff_id, SUM(amount) as total
FROM payment
GROUP BY staff_id, customer_id)

SELECT staff_id, AVG(total)
FROM lifetime_spending
GROUP BY staff_id
;


-- Returns the average rental rate for each genre of film.
SELECT AVG(rental_rate)
FROM film JOIN film_category ON film.film_id=film_category.film_id
GROUP BY category_id;


WITH avg_rentalrate AS (
SELECT SUM(rental_rate) as total
FROM film 
GROUP BY rating )

SELECT AVG(total)
FROM avg_rentalrate
;

-- Return all films that have the rating that is biggest category 
-- (ie. rating with the highest count of films)
SELECT title, rating
FROM film
WHERE rating = (SELECT rating 
				FROM film
			   GROUP BY rating
			   ORDER BY COUNT(*)
			   LIMIT 1);


WITH highest_rating AS (
SELECT title, rating, COUNT(*) AS highest_count
FROM film
GROUP BY rating, title 
ORDER BY COUNT(*)

)

SELECT title, rating
FROM highest_rating
ORDER BY rating
;


-- Return all purchases from the longest standing customer
-- (ie customer who has the earliest payment_date)
SELECT * 
FROM payment
WHERE customer_id = (SELECT customer_id
					  FROM payment
					  ORDER BY payment_date
					 LIMIT 1);
                     
                     
                     
WITH longest_standing AS (SELECT *
FROM payment 
ORDER BY payment_date
LIMIT 1)

SELECT *
FROM longest_standing
;