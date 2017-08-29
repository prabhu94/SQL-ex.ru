All Queries solved using PostgreSQL (SQL Practice stage SELECT) 

-- Q1 > Straightforward query using price as a condition.
select model,speed,hd from PC where price<500 ;

-- Q2 > Query solved using type field where the type is 'printer.
select distinct maker from product where type='printer' ;

-- Q3 > Query for models of laptops where price is more than 1000.
select model,ram,screen from laptop where price>1000;

-- Q4 > Querying for color printers where the field color has a binary value of 'y' for yes and 'n' for no.
Select * from printer where color='y';

-- Q5 > Query using two fields from pc table where price < 600  and cd speed is 12x or 24x 
Select model,speed,hd from pc where price<600 and cd in ('12x','24x');

-- Q6 > Query to find laptops with a hard drive capacity of 10 Gb or higher and their speeds, using the distinct keyord to avoid duplicated data.
select distinct maker,speed from product join laptop on product.model=laptop.model where laptop.hd>=10

-- Q7 > Query to find the most commercially available products by maker 'B' . 
--The solution for this is based on two concepts :
--First, the price from each of the tables requires that the price of each type be coalesced to one column. This is possible by using union on 3 separate queries. The union keyword also ensures that the data is unique across the three queries' datasets.
--Second, to avoid duplication models with same price of different types, we use distinct keyword.
select distinct pc.model, pc.price from pc join product on pc.model=product.model where maker='B' 
union 
select distinct laptop.model, laptop.price from laptop join product on laptop.model=product.model where maker='B' 
union 
select distinct printer.model, printer.price from printer join product on printer.model=product.model where maker='B'

-- Q8 > query to find PC makers who do not make laptops
select maker from product where type in('PC') except select maker from product where type in ('Laptop')

-- Q9 > Simple query to find PC with speeds more than 450
Select distinct maker from product join PC on PC.model=product.model where pc.speed>=450

-- Q10 > Query to find models with highest price in the printer group
Select model,price from printer where price = (select max(price) from printer)
