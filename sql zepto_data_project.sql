drop tablee if exists zepto;

create table zepto(
sky_id SERIAL primary key,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountpercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightIngms INTEGER,
outofStock BOOLEAN,
quantity INTEGER
);



---data exploration--
---count of row---
select count(*)from zepto;

--simple dat--
select * from zepto
limit 10;

--null value--
select * from zepto
where name is null
or 
category is null
or
discountpercent is null
or
discountedSellingPrice is null
or
weightInGms is null
or
availableQuantity is null
or
outofStock is null
or
quantity is null;
 --different product  categories--
  select distinct category
  from zepto
  order by category;

  --product in stock vs out of stock--
  select outofstock,count(sky_id)
  from zepto
  group by outofstock;
  
--product names present multiple time--
select name,count(sky_id)as "Number of SKUs "
from zepto
group by name
having count(sky_id) > 1
order by count(sky_id) DESC;

--dat cleaning--
--products with price=0

select * from zepto
where mrp=0 or discountedSellingPrice=0;
delete from zepto
where mrp=0;

--convert paise to rupees--
update zepto
set mrp = mrp/100.0,
discountedSellingPrice=discountedSellingPrice/100.0;

select mrp,discountedSellingPrice from zepto

--- Q1 top 10 best product based on the discount percentage--
select distinct name, mrp,discountpercent
from zepto
order by discountpercent DESC
limit 10;
--Q2 product with hight MRP  out of stock--
select distinct name,mrp
from zepto 
where outofstock= True and mrp > 300
order by mrp DESC;

--Q3 calculate revenu for each category--
select category,
sum(discountedSellingPrice * availableQuantity) as total_revenue
from zepto
group by category
order by total_revenue;



--Q4 all products where mrp is greater than 500 and discount is less than 10%--
 select distinct name, mrp , discountpercent
 from zepto
 where mrp>500  and discountpercent<10
 order by mrp DESC, discountpercent DESC;




--Q5 top 5 category offering thehighest avarage discount percentage--

select category,
round (AVG(discountpercent),2) as avg_discount
from zepto
group by category
order by avg_discount DESC
limit 5;

--Q6 price per gram for products above 100g and stort best value--
select distinct name, weightInGms,discountedSellingPrice,
round(discountedSellingPrice/weightInGms,2) as price_per_gram
from zepto
where weightInGms>=100
order by price_per_gram;

--Q7 group of product into category low,medium, bulk--

select distinct name, weightInGms,
case when weightInGms < 1000 then 'low'
     when weightInGms < 1000 then 'medium'
     else 'bulk'
	 end as weight_category
	 from zepto;

--Q8  total inventory weight per category--
 select category,
 sum(weightInGms * availableQuantity)as total_weight
 from zepto
 group by category
 order by total_weight;


