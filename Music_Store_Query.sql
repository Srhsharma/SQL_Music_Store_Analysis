--Q1: Who is the senior most employee based on job title?
/*
Select CONCAT(first_name ||' '|| last_name) as Full_name,levels from employee
order by levels desc
limit 1
*/

--Q2: Which countries have the most Invoices?
/*
SELECT COUNT(billing_country) AS Invoice_count, billing_country from invoice
group by billing_country
order by Invoice_count desc
limit 1
*/

--Q3: What are top 3 values of total invoice?
/*
SELECT total from invoice
order by total desc
limit 3
*/


--Q4: Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
--Write a query that returns one city that has the highest sum of invoice totals. 
--Return both the city name & sum of all invoice totals.

/*
select billing_city,sum(total) as invoice_total from invoice
group by billing_city
order by invoice_total desc
limit 1
*/

--Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer. 
--Write a query that returns the person who has spent the most money.

/*
SELECT customer.customer_id, first_name, last_name, SUM(total) AS total_spending
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
GROUP BY customer.customer_id
ORDER BY total_spending DESC
LIMIT 1
*/


--Question Set 2 - Moderate

--Q1: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
--Return your list ordered alphabetically by email starting with A.

/*
select distinct email,first_name,last_name,genre.name from customer
join invoice on invoice.customer_id=customer.customer_id
join invoice_line on invoice_line.invoice_id=invoice.invoice_id
join track on track.track_id=invoice_line.track_id
join genre on genre.genre_id=track.genre_id
where genre.name like 'Rock'
order by email
*/

--Q2: Let's invite the artists who have written the most rock music in our dataset. 
--Write a query that returns the Artist name and total track count of the top 10 rock bands.

/*
select artist.artist_id, artist.name, count(artist.name) as numbers from artist
join album on album.artist_id=artist.artist_id
join track on track.album_id=album.album_id
join genre on genre.genre_id=track.genre_id
where genre.name like 'Rock'
group by artist.artist_id
ORDER BY numbers DESC
LIMIT 10
*/

--Q3: Return all the track names that have a song length longer than the average song length. 
--Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first.
/*
select track.track_id, track.name, track.milliseconds as song_length from track
where milliseconds>(select avg(milliseconds)as avg_length from track)
order by milliseconds desc
*/

--Question Set 3 - Advance */
--Q1: Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent.

/*
with top_selling_artist as (
select artist.artist_id as artist_id,artist.name as artist_name, sum(invoice_line.quantity*invoice_line.unit_price) as sales
from invoice_line
join track on track.track_id=invoice_line.track_id
join album on album.album_id=track.album_id
join artist on artist.artist_id=album.artist_id
group by 1
order by sales desc
limit 1
)
select c.customer_id,c.first_name,c.last_name,tsa.artist_name,sum(il.quantity*il.unit_price) as total_sales
from invoice i
join customer as c on c.customer_id=i.customer_id
join invoice_line il on il.invoice_id = i.invoice_id
join track t on t.track_id = il.track_id
join album alb on alb.album_id = t.album_id
join top_selling_artist tsa on tsa.artist_id = alb.artist_id
GROUP BY 1,2,3,4
ORDER BY 5 DESC;
*/

--Q2: We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre 
--with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where 
--the maximum number of purchases is shared return all Genres.

/*
with popular_genre as (
select count(invoice_line.quantity)as purchases,customer.country, genre.name,genre.genre_id,
row_number() over(partition by customer.country order by count(invoice_line.quantity) desc) as row_no
from invoice_line
join invoice on invoice.invoice_id=invoice_line.invoice_id
join customer on customer.customer_id=invoice.customer_id
join track on track.track_id=invoice_line.track_id
join genre on genre.genre_id=track.genre_id
group by 2,3,4
order by 2 asc,1 desc
)
select * from popular_genre where row_no=1
*/

--Q3: Write a query that determines the customer that has spent the most on music for each country. 
--Write a query that returns the country along with the top customer and how much they spent. 
--For countries where the top amount spent is shared, provide all customers who spent this amount. 

/*
with highest_customer as(
select customer.customer_id,customer.first_name,customer.last_name,billing_country,sum(invoice.total) as total_spending,
row_number() over(partition by billing_country order by sum(total) desc ) as row_no
from invoice
join customer on customer.customer_id=invoice.customer_id
group by 1,2,3,4
order by 4 asc,5 desc)
select * from highest_customer where row_no=1
*/


