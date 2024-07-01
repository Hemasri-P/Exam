

Use exam
CREATE TABLE artists (
    artist_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    country VARCHAR(50) NOT NULL,
    birth_year INT NOT NULL
);

CREATE TABLE artworks (
    artwork_id INT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    artist_id INT NOT NULL,
    genre VARCHAR(50) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (artist_id) REFERENCES artists(artist_id)
);

CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    artwork_id INT NOT NULL,
    sale_date DATE NOT NULL,
    quantity INT NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (artwork_id) REFERENCES artworks(artwork_id)
);

INSERT INTO artists (artist_id, name, country, birth_year) VALUES
(1, 'Vincent van Gogh', 'Netherlands', 1853),
(2, 'Pablo Picasso', 'Spain', 1881),
(3, 'Leonardo da Vinci', 'Italy', 1452),
(4, 'Claude Monet', 'France', 1840),
(5, 'Salvador Dalí', 'Spain', 1904);

INSERT INTO artworks (artwork_id, title, artist_id, genre, price) VALUES
(1, 'Starry Night', 1, 'Post-Impressionism', 1000000.00),
(2, 'Guernica', 2, 'Cubism', 2000000.00),
(3, 'Mona Lisa', 3, 'Renaissance', 3000000.00),
(4, 'Water Lilies', 4, 'Impressionism', 500000.00),
(5, 'The Persistence of Memory', 5, 'Surrealism', 1500000.00);

INSERT INTO sales (sale_id, artwork_id, sale_date, quantity, total_amount) VALUES
(1, 1, '2024-01-15', 1, 1000000.00),
(2, 2, '2024-02-10', 1, 2000000.00),
(3, 3, '2024-03-05', 1, 3000000.00),
(4, 4, '2024-04-20', 2, 1000000.00);

Select * from artists;
Select * from artworks;
Select * from sales;

--### Section 1: 1 mark each

--1. Write a query to display the artist names in uppercase.
Select name  from artists




--2. Write a query to find the total amount of sales for the artwork 'Mona Lisa'.



--3. Write a query to calculate the price of 'Starry Night' plus 10% tax.

--4. Write a query to extract the year from the sale date of 'Guernica'.

--### Section 2: 2 marks each

--5. Write a query to display artists who have artworks in multiple genres.
select artists.artist_id , count(artworks.genre) as multipleGenre from artworks

join artists on artists.artist_id=artworks.artist_id
group by  artists.artist_id  having count(genre) >1;

--6. Write a query to find the artworks that have the highest sale total for each genre.
select artworks.artwork_id, count(total_amount) as amount ,
rank() over ( PARTITION BY artworks.artwork_id ORDER BY sales.total_amount ) from artworks
join sales on sales.artwork_id=artworks.artwork_id
group by artworks.artwork_id 

--7. Write a query to find the average price of artworks for each artist.
select artist_id ,avg(price) as avgprice from artworks
group by artist_id order by avgprice  


--8. Write a query to find the top 2 highest-priced artworks and the total quantity sold for each.
Select top(2) sales.artwork_id,max(price) as highest_priced  , sales.total_amount from artworks
join sales on sales.artwork_id=artworks.artwork_id
group by sales.artwork_id, sales.total_amount

--9. Write a query to find the artists who have sold more artworks than the average number of artworks sold per artist.


--10. Write a query to display artists whose birth year is earlier than the average birth year of artists from their country.

--11. Write a query to find the artists who have created artworks in both 'Cubism' and 'Surrealism' genres.
Select artists.artist_id,artworks.genre from artworks 
left join artists on artists.artist_id=artworks.artist_id
join sales on sales.artwork_id=artworks.artwork_id
group by artists.artist_id, artworks.genre having genre='Cubism'
intersect
Select artists.artist_id,artworks.genre from artworks 
left join artists on artists.artist_id=artworks.artist_id
join sales on sales.artwork_id=artworks.artwork_id
group by artists.artist_id, artworks.genre having genre='Surrealism'
--12. Write a query to find the artworks that have been sold in both January and February 2024.
select sales.artwork_id,sales.sale_date from sales
join  artworks on artworks.artwork_id=sales.artwork_id
where DATEPART(yyyy,sale_date)=2024
and DATEPART(mm,sale_date)=01
or DATEPART(mm,sale_date)=02;

--13. Write a query to display the artists whose average artwork price is higher than every artwork price in the 'Renaissance' genre.
with cte_tableartworkPrice
as (
Select  artworks.artwork_id, avg(price) as Avgprice from sales
join  artworks on artworks.artwork_id=sales.artwork_id
group by artworks.artwork_id  )


Select * from cte_tableartworkPrice
where Avgprice > ( select  genre from artworks where genre='Renaissance')

Select * from artists;
Select * from artworks;
Select * from sales;

--14. Write a query to rank artists by their total sales amount and display the top 3 artists.
Select top(3) artworks.artwork_id , max(sales.total_amount),
rank() over (partition by price order by sales.total_amount) as ranking
from sales
join  artworks on artworks.artwork_id=sales.artwork_id
group by artworks.artwork_id ,sales.total_amount

--15. Write a query to create a non-clustered index on the `sales` table to improve query performance for queries filtering by `artwork_id`.
create clustered
--### Section 3: 3 Marks Questions

--16.  Write a query to find the average price of artworks for each artist and only include artists whose average artwork 
--price is higher than the overall average artwork price.
with cte_EachArtworkPrice
as (
Select  artworks.artwork_id, avg(price) as Avgprice from sales
join  artworks on artworks.artwork_id=sales.artwork_id
group by artworks.artwork_id  )

Select * from cte_EachArtworkPrice
where Max( Avgprice )> all( Select Avgprice from sales )
--17.  Write a query to create a view that shows artists who have created artworks in multiple genres.
create view vwmultipleGenres
as 
select  artists.artist_id , count(artworks.genre) as multipleGenre from artworks
join artists on artists.artist_id=artworks.artist_id
group by  artists.artist_id  having count(genre) >1;

Select * from vwmultipleGenres

--18.  Write a query to find artworks that have a higher price than the average price of artworks by the same artist.
 with cte_ArtworksByArtits
 as (
 Select  artworks.artwork_id,   Avg(price) as AvgPrice from sales
 join  artworks on artworks.artwork_id=sales.artwork_id
group by artworks.artwork_id
 )
Select * from  cte_ArtworksByArtits
 where AvgPrice > ( Select AvgPrice from sales )
--### Section 4: 4 Marks Questions

--19.  Write a query to convert the artists and their artworks into JSON format.

select a.author_id,a.name,a.country,a.birth_year ,
(select a.author_id,a.name,a.country,a.birth_yearfrom artworks aw where a.author_id=aw.author_id
for json path) as json path
from artists aw
for json path, root(artists)



--20.  Write a query to export the artists and their artworks into XML format.
Select 
artist_id as [artists/id],
name as [artists/name] ,
country as [artists/country],
birth_year as [artists/birth_year] (select artist_id as [artists/id],
name as [artists/name] ,
country as [artists/country],
birth_year as [artists/birth_year] from artistworks aw where a.author_id=aw.author_id
for xml path ), type 
from artists a
for xml path(artists) , root(artworks)

--#### Section 5: 5 Marks Questions

--21. Create a stored procedure to add a new sale and update the total sales for the artwork.
--Ensure the quantity is positive, and use transactions to maintain data integrity.
Create procedure  AddNewScale
as
begin
 Select quantity from sales
insert into sales (sale_id, inserted ,artwork_id ) 
end
go

exec 
Select * from sales
Select * from artworks


--22. Create a multi-statement table-valued function (MTVF) to return the total quantity sold for 
--each genre and use it in a query to display the results.

--23. Create a scalar function to calculate the average sales amount for artworks in 
--a given genre and write a query to use this function for 'Impressionism'.
create function Calculate_AverageSales
( @total_amount int, @artwork_id int,@genre nvarchar(50) )
returns int
as 
begin
Declare @total_amount int;
 Select Avg(total_amount) 
 from sales
 returns @total_amount
 end
 go


 Exec  Calculate_AverageSales @artwork_id =1,
  @genre='Impressionism'
--24. Create a trigger to log changes to the `artworks` table into an `artworks_log` table, capturing the `artwork_id`,
--`title`, and a change description.
create trigger t


--25. Write a query to create an NTILE distribution of artists based on their total sales, divided into 4 tiles.


--### Normalization (5 Marks)

--26. **Question:**
--    Given the denormalized table `ecommerce_data` with sample data:

--| id  | customer_name | customer_email      | product_name | product_category | product_price | order_date | order_quantity | order_total_amount |
--| --- | ------------- | ------------------- | ------------ | ---------------- | ------------- | ---------- | -------------- | ------------------ |
--| 1   | Alice Johnson | alice@example.com   | Laptop       | Electronics      | 1200.00       | 2023-01-10 | 1              | 1200.00            |
--| 2   | Bob Smith     | bob@example.com     | Smartphone   | Electronics      | 800.00        | 2023-01-15 | 2              | 1600.00            |
--| 3   | Alice Johnson | alice@example.com   | Headphones   | Accessories      | 150.00        | 2023-01-20 | 2              | 300.00             |
--| 4   | Charlie Brown | charlie@example.com | Desk Chair   | Furniture        | 200.00        | 2023-02-10 | 1              | 200.00             |

--Normalize this table into 3NF (Third Normal Form). Specify all primary keys, foreign key constraints, unique constraints, not null constraints, and check constraints.
Create table customers( Customer_id int primary key ,
                          customer_name varchar(50),
						  customer_email nvarchar(100) )


create table Products ( Product_id int primary key ,
                       product_name varchar(50),
					   product_category varchar(80), )


create table orders ( Order_id int primary key ,
					    order_date date not null,
						order_quantity int not null,
						order_total_amount int not null )

create table OrdersInfo ( OrderInfo_id int primary key,
                        Customer_id int constraint  orderaInfo_id references OrdersInfo,
						Product_id int constraint  orderaInfo_id references OrdersInfo,
						Order_id int constraint  orderaInfo_id references OrdersInfo )


	Insert into Customers values( 1   , 'Alice Johnson' , 'alice@example.com'),
	(  2   , 'Bob Smith' ,    'bob@example.com'),
	(3   , 'Alice Johnson' , 'alice@example.com'),
	(4   ,'Charlie Brown',  'charlie@example.com' )





--### ER Diagram (5 Marks)

--27. Using the normalized tables from Question 27, create an ER diagram. 
--Include the entities, relationships, primary keys, foreign keys, unique constraints, not null constraints, 
--and check constraints. Indicate the associations using proper ER diagram notation.

