-- first name
-- last name
-- ou sont stockés les scripts dans la machine et les enregistrer dans le brief sakila

-- 1.
select title
from film;

-- 2.

SELECT count(f.film_id), fc.category_id, c.name
FROM film AS f
JOIN film_category AS fc ON f.film_id = fc.film_id
join category as c on fc.category_id = c.category_id 
GROUP BY fc.category_id;


-- 3.
SELECT title, "length" 
from film
WHERE length > 120


-- 4.
SELECT title, release_year 
from film
where release_year BETWEEN 2004 AND 2006;

-- 5
SELECT f.title, c.name
FROM film AS f
JOIN film_category AS fc ON f.film_id = fc.film_id
join category as c on fc.category_id = c.category_id 
where c.name = "Comedy" or c.name = "Action"

-- 6

SELECT c.name, avg(rental_rate)
FROM film AS f
JOIN film_category AS fc ON f.film_id = fc.film_id
join category as c on fc.category_id = c.category_id 
group by c.name;




-- deuxieme partie (plus compliqué)

-- 1
SELECT title, COUNT(rental_id) as rent
FROM film AS f
JOIN inventory AS inv ON f.film_id = inv.inventory_id 
join rental as r on inv.inventory_id = r.inventory_id  
group by title
order by rent DESC 
LIMIT 10;


-- 2
SELECT first_name, count(f.film_id) as number_film
FROM actor a 
JOIN film_actor AS fa ON a.actor_id  = fa.actor_id  
join film as f on fa.actor_id = f.film_id 
group by a.first_name
order by number_film
limit 1;


-- 3

select strftime('%Y-%m', payment_date) as mois, sum(amount)
from payment p 
group by mois

-- 4
SELECT so.store_id, strftime('%Y', payment_date) as année, sum(p.amount) as montant_magasin
FROM payment p
join staff sa on p.staff_id = sa.staff_id 
join store so on sa.staff_id = so.store_id 
where année like "%2005%"
group by so.store_id 


-- 5
select first_name, count(rental_id) as location
FROM rental r 
join customer c on r.rental_id = c.customer_id 
group by first_name 
order by location desc
limit 10;


-- 6
WITH rental_film AS (
    SELECT f.film_id, f.title, i.inventory_id, r.rental_date
    FROM film f
    LEFT JOIN inventory i ON f.film_id = i.film_id
    LEFT JOIN rental r ON i.inventory_id = r.inventory_id
)

SELECT title
FROM rental_film
WHERE rental_date IS NULL OR rental_date < DATE('2006-02', '-6 months');



-- 7
SELECT st.staff_id, sum(p.amount)
from rental r 
join staff st on r.rental_id = st.staff_id 
join payment p on st.staff_id = p.staff_id
group by st.staff_id 

-- 8
SELECT c.name, count(r.rental_id) as location
FROM category c
JOIN film_category AS fc ON c.category_id  = fc.film_id
join film as f on fc.film_id  = f.film_id 
join inventory i on f.film_id = i.film_id 
join rental r on i.film_id = r.rental_id 
join customer c2 on r.rental_id = c2.customer_id
group by c.name
ORDER by location desc;

--9
SELECT AVG(julianday(return_date) - julianday(rental_date)) AS average_rental_duration
from rental
--join inventory i on f.film_id = i.film_id 
--join rental r on i.film_id = r.rental_id 


-- 10 

WITH tab_acteur_film AS (
-- selection de deux acteurs
    SELECT a1.actor_id AS actor_id1, a1.first_name AS first_name1, a1.last_name AS last_name1, fa1.film_id AS film_id1,
           a2.actor_id AS actor_id2, a2.first_name AS first_name2, a2.last_name AS last_name2, fa2.film_id AS film_id2
    FROM actor a1
    JOIN film_actor fa1 ON a1.actor_id = fa1.actor_id
    -- effectue une jointure avec la table actor deux fois, avec a1 et la deuxieme a2
    JOIN actor a2 ON a1.actor_id <> a2.actor_id -- < > pour eviter de compter un acteur avec lui mm
    JOIN film_actor fa2 ON a2.actor_id = fa2.actor_id
    WHERE fa1.film_id = fa2.film_id
)

SELECT first_name1, last_name1, first_name2, last_name2, COUNT(*) AS common_film_count
FROM tab_acteur_film
GROUP BY actor_id1, actor_id2, first_name1, last_name1, first_name2, last_name2
ORDER BY common_film_count DESC
LIMIT 2;

--bonus


WITH last_location AS (
	SELECT  r1.rental_date, r2.rental_date, (JULIANDAY(DATE(r2.rental_date)) - JULIANDAY(DATE(r1.rental_date))) as difference_date , r1.customer_id 
	FROM rental r1
	JOIN rental r2 ON r1.customer_id  = r2.customer_id AND DATE(r2.rental_date) > DATE(r1.rental_date )
	WHERE r2.rental_date NOT BETWEEN DATE(r1.rental_date, '+30 days') AND r1.rental_date
	ORDER BY difference_date
)
SELECT * 
FROM last_location 
GROUP BY customer_id 
HAVING difference_date > 30;




WITH last_location AS (
	SELECT  r1.rental_date, r2.rental_date, (JULIANDAY(DATE(r2.rental_date)) - JULIANDAY(DATE(r1.rental_date))) as difference_date , r1.customer_id 
	FROM rental r1
	JOIN rental r2 ON r1.customer_id  = r2.customer_id AND DATE(r2.rental_date) > DATE(r1.rental_date )
	WHERE r2.rental_date NOT BETWEEN DATE(r1.rental_date, '+30 days') AND r1.rental_date AND STRFTIME("%Y-%m",r1.rental_date) ="2005-08"
	ORDER BY difference_date
)
SELECT * 
FROM last_location
GROUP BY customer_id 
HAVING difference_date > 15;

-- bonus ajouter un nouveau film



Insert into film_category
 (film_id,category_id,last_update)
Values
('1001','1','2023');


