--Q1 Create a list of all the different (distinct) replacement costs of the films.
SELECT MIN(DISTINCT replacement_cost)
fROM film;

--Q2 Write a query that gives an overview of how many films have replacements costs in the following cost ranges
-- 1.	low: 9.99 - 19.99
-- 2.	medium: 20.00 - 24.99
-- 3.	high: 25.00 - 29.99
-- Question: How many films have a replacement cost in the "low" group?

SELECT COUNT(*),
CASE 
WHEN replacement_cost BETWEEN 9.99 AND 20 THEN 'low'
WHEN replacement_cost BETWEEN 20 AND 25 THEN 'medium'
WHEN replacement_cost BETWEEN 25 AND 30 THEN 'high'
END as costs
FROM film
GROUP BY costs;

-- Q3 Task: Create a list of the film titles including their title, length, and category name ordered descendingly by length. 
-- Filter the results to only the movies in the category 'Drama' or 'Sports'.
-- Question: In which category is the longest film and how long is it?

SELECT f.title,f.length,c.name
FROM film f JOIN film_category fc ON (f.film_id = fc.film_id) JOIN category c on (c.category_id = fc.category_id)
WHERE c.name IN ('Drama','Sports')
ORDER BY f.length DESC;

-- Q4 Create an overview of how many movies (titles) there are in each category (name).
-- Question: Which category (name) is the most common among the films?

SELECT c.name, COUNT(*)
FROM film f JOIN film_category fc ON (f.film_id = fc.film_id) JOIN category c on (c.category_id = fc.category_id)
GROUP BY c.name
ORDER BY count DESC;

-- Q5 Task: Create an overview of the actors' first and last names and in how many movies they appear in.
--Question: Which actor is part of most movies??

SELECT a.first_name, a.last_name, COUNT(*)
FROM film f JOIN film_actor fa ON (f.film_id = fa.film_id) JOIN actor a ON (fa.actor_id = a.actor_id)
GROUP BY a.first_name,a.last_name
ORDER BY count DESC ;

-- Q6 Task: Create an overview of the addresses that are not associated to any customer.
--Question: How many addresses are that?

SELECT COUNT(*)
FROM address a LEFT JOIN customer c ON (c.address_id = a.address_id)
WHERE c.address_id is null;

--Q7 Task: Create an overview of the cities and how much sales (sum of amount) have occurred there.
--Question: Which city has the most sales?

SELECT city.city,SUM(p.amount) as sales
FROM payment p JOIN customer c ON(p.customer_id = c.customer_id) JOIN address a ON (a.address_id = c.address_id) JOIN city ON (a.city_id = city.city_id)
GROUP BY city.city
ORDER BY sales DESC;


--Q8 Task: Create an overview of the revenue (sum of amount) grouped by a column in the format "country, city".
-- Question: Which country, city has the least sales?

SELECT ctry.country,city.city,SUM(p.amount) as sales
FROM payment p JOIN customer c ON(p.customer_id = c.customer_id) JOIN address a ON (a.address_id = c.address_id) JOIN city ON (a.city_id = city.city_id) JOIN country ctry ON (city.country_id = ctry.country_id)
GROUP BY ctry.country,city.city
ORDER BY sales ASC;

-- Q9 Task: Create a list with the average of the sales amount each staff_id has per customer.
--Question: Which staff_id makes on average more revenue per customer? 
SELECT staff_id,AVG(subquery.total)
FROM 
(SELECT SUM(amount) as total, customer_id,staff_id 
	FROM payment 
	GROUP BY customer_id, staff_id) as subquery
GROUP BY staff_id;

-- Q10 Task: Create a query that shows average daily revenue of all Sundays.
--Question: What is the daily average revenue of all Sundays?

SELECT 
AVG(total)
FROM 
	(SELECT
	 SUM(amount) as total,
	 DATE(payment_date),
	 EXTRACT(dow from payment_date) as weekday
	 FROM payment
	 WHERE EXTRACT(dow from payment_date)=0
	 GROUP BY DATE(payment_date),weekday) daily;

-- Q11 Task: Create a list of movies - with their length and their replacement cost - that are longer than the average length in each replacement cost group.
-- Question: Which two movies are the shortest on that list and how long are they?

SELECT film_id,title,length
FROM film f1
WHERE
length >
(SELECT AVG(length) as avg_length
FROM film f2
WHERE f1.replacement_cost = f2.replacement_cost
GROUP BY replacement_cost)
ORDER BY length;

-- Q12 Topic: Uncorrelated subquery
--Task: Create a list that shows the "average customer lifetime value" grouped by the different districts.

SELECT district.district, AVG(district.sales) as avg_sales
FROM
(SELECT  a.district,p.customer_id, SUM(p.amount) as sales
FROM payment p JOIN customer c ON (p.customer_id = c.customer_id) JOIN address a ON (c.address_id = a.address_id) 
GROUP BY p.customer_id, a.district
ORDER BY p.customer_id) as district
GROUP BY district.district
ORDER BY avg_sales DESC;


-- Q13 Task: Create a list that shows all payments including the payment_id, amount, and the film category (name) plus the total amount that was made in this category. Order the results ascendingly by the category (name) and as second order criterion by the payment_id ascendingly.
--Question: What is the total revenue of the category 'Action' and what is the lowest payment_id in that category 'Action'?

SELECT main.payment_id, main.name, main.amount, sales.total_sales
FROM
(SELECT p.payment_id,c.name,p.amount
FROM payment p JOIN rental r ON (p.rental_id = r.rental_id) JOIN inventory i ON (r.inventory_id = i.inventory_id) JOIN film_category fc ON (i.film_id = fc.film_id) JOIN category c ON (fc.category_id = c.category_id)
) main JOIN
(SELECT c.name,SUM(p.amount) total_sales
FROM payment p JOIN rental r ON (p.rental_id = r.rental_id) JOIN inventory i ON (r.inventory_id = i.inventory_id) JOIN film_category fc ON (i.film_id = fc.film_id) JOIN category c ON (fc.category_id = c.category_id)
GROUP BY c.name
) sales
ON (main.name = sales.name)
ORDER BY main.name, main.payment_id;

-- Q14 Task: Create a list with the top overall revenue of a film title (sum of amount per title) for each category (name).
--Question: Which is the top-performing film in the animation category?

SELECT f.title, c.name, SUM(p.amount)
FROM payment p JOIN rental r ON (p.rental_id = r.rental_id) JOIN inventory i ON (r.inventory_id = i.inventory_id) JOIN film_category fc ON (i.film_id = fc.film_id) JOIN category c ON (fc.category_id = c.category_id) JOIN film f ON (fc.film_id = f.film_id)
WHERE c.name = 'Animation'
GROUP BY f.title,c.name
ORDER BY sum DESC;





