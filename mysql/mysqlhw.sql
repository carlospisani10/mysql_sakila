-- 1a. Display the first and last names of all actors from the table `actor`. 
use sakila;

select first_name, last_name from actor;


-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.

SELECT CONCAT(first_name, " ", last_name) AS 'Actor_Name' FROM actor;



-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?

select first_name, last_name, actor_id from actor
where (first_name = 'Joe');

-- 2b. Find all actors whose last name contain the letters `GEN`:

select first_name, last_name, actor_id from actor
where (last_name like '%GEN%');

-- 2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:
select first_name, last_name, actor_id from actor
where (last_name like '%LI%');
-- how do i change the column orders of a query answer?

-- 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT country, country_id FROM country
WHERE country.country IN ('Afghanistan','Bangladesh', 'China');

-- 3a. Add a `middle_name` column to the table `actor`. Position it between `first_name` and `last_name`. Hint: you will need to specify the data type.
ALTER TABLE actor
ADD COLUMN `middle_name` VARCHAR(50) NOT NULL AFTER `first_name`;

-- 3b. You realize that some of these actors have tremendously long last names. Change the data type of the `middle_name` column to `blobs`.
ALTER TABLE actor MODIFY middle_name BLOB;

-- 3c. Now delete the `middle_name` column.
ALTER TABLE actor DROP COLUMN middle_name;

-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name,COUNT(*) as count FROM actor GROUP BY last_name ORDER BY count DESC;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT last_name,COUNT(*) as count FROM actor GROUP BY last_name having count > 1 ORDER BY count DESC;

-- 4c. Oh, no! The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`, 
-- the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.
UPDATE actor
SET first_name = 'HARPO'
WHERE last_name= 'WILLIAMS';

SELECT first_name, last_name FROM actor
where first_name = 'HARPO';

-- 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! 
-- In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`. Otherwise, change the first name to `MUCHO GROUCHO`, 
-- as that is exactly what the actor will be with the grievous error. 
-- BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO `MUCHO GROUCHO`, HOWEVER! (Hint: update the record using a unique identifier.)

UPDATE actor
SET first_name = 'GROUCHO'
WHERE last_name= 'WILLIAMS';

SELECT first_name, last_name FROM actor
where first_name = 'GROUCHO';
 
-- address5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?
-- skip for now, select * from address

-- 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:
use sakila

SELECT * FROM address;
SELECT * FROM staff;

SELECT staff.first_name, staff.last_name, address.address
FROM staff
INNER JOIN address
ON staff.address_id= address.address_id;

-- 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.

SELECT payment.staff_id, staff.first_name, staff.last_name, payment.amount, payment.payment_date FROM staff
INNER JOIN payment ON
staff.staff_id = payment.staff_id AND payment_date LIKE '2005-08%';

-- 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.
select * from film;
select * from film_actor;

SELECT film.title, count(film_actor.actor_id) as actor_count
from film
inner join film_actor
on film_actor.film_id = film.film_id
group by film_actor.film_id;


-- 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
select count(inventory_id) from inventory
where film_id in
(
select film_id from film
where title = "Hunchback Impossible"
)

-- 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:

select customer.first_name, customer.last_name, sum(payment.amount) as total_spent
from customer
inner join payment
on customer.customer_id = payment.customer_id
group by payment.customer_id
order by customer.last_name ASC;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. 
-- Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English. 

select * from `language`;
select * from film;

select title from film
where (title like 'Q%') 
or (title like 'K%') 
and language_id in 
( 
select `language_id` from `language`
where `name` = "English"
);


-- 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.

select first_name, last_name from actor
where actor_id IN
(
select actor_id from film_actor
where film_id IN
(
select film_id from film
where title = "Alone Trip"
)
);

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. 
-- Use joins to retrieve this information.

select * from city;
select * from customer;
select * from address;
select * from country;

select customer.email, country.country, city.city, address.district 
from country
	inner join city
		on country.country_id = city.country_id and country.country like '%CANADA%'
	inner join address
		on city.city_id = address.city_id
	inner join customer
		on address.address_id = customer.address_id;
        
-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as famiy films.

select title from film
where film_id in 
(
select film_id from film_category
where category_id in
(
select category_id from category
where `name` = "Family"
)
);

-- 7e. Display the most frequently rented movies in descending order.
        


