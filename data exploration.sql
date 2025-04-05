show tables;

-- check total rows
select COUNT(*) 
from brands;

select COUNT(distinct model_name) 
from BRANDS;

select COUNT(*) 
from PRODUCTS;

select COUNT(distinct product_name) 
from PRODUCTS;

select COUNT(*) 
from CUSTOMER_SESSIONS;

select COUNT(*) 
from CUSTOMERS;

select COUNT(*) 
from ORDER_ITEMS;

select COUNT(*) 
from ORDERS;

select COUNT(*) 
from PAYMENTS;

select COUNT(*) 
from product_category;

select COUNT(*) 
from PRODUCT_SUBCATEGORY;

select COUNT(*) 
from REVIEWS;

-- describe the tables
describe brands;
describe customer_sessions;
describe customers;
describe order_items;
describe orders;
describe payments;
describe product_category;
describe product_subcategory;
describe products;
describe reviews;

-- To see the table creation structure and explore the database schema with foreign key

show create table brands;
show create table customer_sessions;
show create table customers;
show create table order_items;
show create table orders;
show create table payments;
show create table product_category;
show create table product_subcategory;
show create table products;
show create table reviews;


-- data exploration
select *
from brands
limit 10;

-- product prices seems inconsistent to the real prices, so update the price list by finding the minimal related prices using ai.

SET SQL_SAFE_UPDATES = 0; -- safe update to avoid update errors

update brands
set price = 799
where model_name like 'iPhone%';

UPDATE brands
SET price = CASE 
    -- Apple Products
    WHEN model_name = 'MacBook Pro' THEN 1299
    WHEN model_name = 'iPad Air' THEN 599
    WHEN model_name = 'Apple Watch' THEN 399
    WHEN model_name = 'AirPods Pro' THEN 249
    WHEN model_name = 'iMac' THEN 1299
    WHEN model_name = 'Mac Mini' THEN 699
    WHEN model_name = 'HomePod' THEN 299
    WHEN model_name = 'Apple TV' THEN 179
    WHEN model_name = 'AirTag' THEN 29

    -- Samsung Products
    WHEN model_name = 'Galaxy S21' THEN 799
    WHEN model_name = 'Galaxy Tab S7' THEN 649
    WHEN model_name = 'Galaxy Watch' THEN 249
    WHEN model_name = 'Galaxy Buds' THEN 149
    WHEN model_name = 'Galaxy Book' THEN 999
    WHEN model_name = 'Galaxy Z Fold' THEN 1799
    WHEN model_name = 'Galaxy A52' THEN 499
    WHEN model_name = 'Galaxy Note 20' THEN 999
    WHEN model_name = 'Galaxy S20 FE' THEN 699
    WHEN model_name = 'Galaxy M51' THEN 399

    -- Dell Products
    WHEN model_name = 'XPS 13' THEN 999
    WHEN model_name = 'Inspiron 15' THEN 549
    WHEN model_name = 'Alienware m15' THEN 1499
    WHEN model_name = 'Latitude 14' THEN 1099
    WHEN model_name = 'Precision 3560' THEN 1399
    WHEN model_name = 'G5 Gaming Desktop' THEN 799
    WHEN model_name = 'Vostro 15' THEN 649
    WHEN model_name = 'XPS 15' THEN 1199
    WHEN model_name = 'Inspiron 14' THEN 499
    WHEN model_name = 'Alienware Aurora' THEN 1299

    -- HP Products
    WHEN model_name = 'Spectre x360' THEN 1099
    WHEN model_name = 'Envy 13' THEN 899
    WHEN model_name = 'Pavilion 15' THEN 649
    WHEN model_name = 'Omen 30L' THEN 1299
    WHEN model_name = 'EliteBook 840' THEN 1199
    WHEN model_name = 'ProBook 450' THEN 749
    WHEN model_name = 'ZBook Power' THEN 1499
    WHEN model_name = 'Victus 16' THEN 799
    WHEN model_name = 'Envy x360' THEN 899
    WHEN model_name = 'Pavilion Gaming' THEN 799

    -- Nike Products
    WHEN model_name = 'Air Max' THEN 120
    WHEN model_name = 'Air Force 1' THEN 90
    WHEN model_name = 'Air Jordan' THEN 150
    WHEN model_name = 'React Infinity' THEN 160
    WHEN model_name = 'Free Run' THEN 100
    WHEN model_name = 'Metcon 7' THEN 130
    WHEN model_name = 'Pegasus 38' THEN 120
    WHEN model_name = 'Zoom Fly' THEN 160
    WHEN model_name = 'Blazer' THEN 100
    WHEN model_name = 'Dunk Low' THEN 100

    -- Adidas Products
    WHEN model_name = 'Ultraboost' THEN 180
    WHEN model_name = 'NMD R1' THEN 140
    WHEN model_name = 'Superstar' THEN 85
    WHEN model_name = 'Stan Smith' THEN 85
    WHEN model_name = 'Yeezy Boost' THEN 220
    WHEN model_name = 'Terrex' THEN 120
    WHEN model_name = 'Gazelle' THEN 80
    WHEN model_name = 'Forum Low' THEN 90
    WHEN model_name = 'ZX 2K Boost' THEN 150
    WHEN model_name = 'Adilette' THEN 25

    -- IKEA Products
    WHEN model_name = 'Billy Bookcase' THEN 50
    WHEN model_name = 'Kallax Shelf' THEN 70
    WHEN model_name = 'Ektorp Sofa' THEN 499
    WHEN model_name = 'Malm Bed' THEN 199
    WHEN model_name = 'Poäng Chair' THEN 79
    WHEN model_name = 'Lack Table' THEN 10
    WHEN model_name = 'Hemnes Dresser' THEN 249
    WHEN model_name = 'Besta Cabinet' THEN 200
    WHEN model_name = 'Strandmon Chair' THEN 279
    WHEN model_name = 'Fjällbo Shelf' THEN 100
END
WHERE model_name IN (
    'MacBook Pro', 'iPad Air', 'Apple Watch', 'AirPods Pro', 'iMac', 'Mac Mini', 'HomePod', 'Apple TV', 'AirTag',
    'Galaxy S21', 'Galaxy Tab S7', 'Galaxy Watch', 'Galaxy Buds', 'Galaxy Book', 'Galaxy Z Fold', 'Galaxy A52',
    'Galaxy Note 20', 'Galaxy S20 FE', 'Galaxy M51', 'XPS 13', 'Inspiron 15', 'Alienware m15', 'Latitude 14',
    'Precision 3560', 'G5 Gaming Desktop', 'Vostro 15', 'XPS 15', 'Inspiron 14', 'Alienware Aurora',
    'Spectre x360', 'Envy 13', 'Pavilion 15', 'Omen 30L', 'EliteBook 840', 'ProBook 450', 'ZBook Power',
    'Victus 16', 'Envy x360', 'Pavilion Gaming', 'Air Max', 'Air Force 1', 'Air Jordan', 'React Infinity',
    'Free Run', 'Metcon 7', 'Pegasus 38', 'Zoom Fly', 'Blazer', 'Dunk Low', 'Ultraboost', 'NMD R1', 'Superstar',
    'Stan Smith', 'Yeezy Boost', 'Terrex', 'Gazelle', 'Forum Low', 'ZX 2K Boost', 'Adilette', 'Billy Bookcase',
    'Kallax Shelf', 'Ektorp Sofa', 'Malm Bed', 'Poäng Chair', 'Lack Table', 'Hemnes Dresser', 'Besta Cabinet',
    'Strandmon Chair', 'Fjällbo Shelf'
);

SET SQL_SAFE_UPDATES = 1;

select distinct model_name,price 
from brands; -- now the price list is consistent

-- done with BRANDs table


select *
from products
limit 10;

select *
from orders
limit 10;

-- lets analyze the products table(having product_id and product_name columns only), check duplicates, null values etc and take the refined table for further data analysis.

-- check for duplicate rows in the products table
with duplicate_rows as(
select product_name, count(*) as duplicate_count
from products
group by product_name
having count(*)>1)
select count(*) from duplicate_rows ; -- there are 50 different product_names that appear more than once in the products table 


-- take the unique product names only for analysis
with duplicates as (
select product_name, count(*) as duplicate_count
from products
group by product_name
having count(*)>1 
),

-- checking if product_id of duplicate_products are also same or different
duplicate_products_info as (
select p.product_id, d.product_name
from duplicates d
left join products p on d.product_name = p.product_name), -- product_id's are different for each duplicate products so,
															-- i will take only the unique product_id and names for further analysis

-- from the duplicate rows take only the unique rows with unique product_names
product_names_with_rank as (
select p.product_id, d.product_name,
	row_number() over(partition by d.product_name order by product_name desc) as ranks
from duplicates d
left join products p on d.product_name = p.product_name)

select product_id, product_name
from product_names_with_rank
where ranks = 1;

-- take all the unique products with unique product names from the products table
with ranked_products as (
select product_id,product_name, 
	row_number() over(partition by product_name) ranks
from products),

unique_products as (
select product_id,product_name
from ranked_products
where ranks = 1)
select count(*) from unique_products;

-- optimized solution to take all the unique products with unique product names from the products table
select min(product_id) as product_id, product_name
from products
group by product_name;

-- create new products table with unique products only
drop view unique_products;
create view unique_products as
with duplicate_rows as(
select *,
	row_number() over(partition by model_name) as ranks
from brands)
select model_name,brand_name,subcategory_id,cost,price,stock_quantity,supplier_id,added_date 
from duplicate_rows
where ranks = 1;


-- create the unique products table with existing product_id
create view all_products as
with unique_products_table as (
select min(product_id) as product_id, product_name
from products
group by product_name)
select *
from unique_products_table u1
left join unique_products u2
on u1.product_name = u2.model_name;


-- create new product table in the database schema and move all data from all_products view to that new table
-- create table all_unique_products as
-- select * from all_products;

select * 
from all_unique_products
limit 10;

SELECT *
FROM order_items
order by quantity desc;

SELECT *
FROM orders
LIMIT 10;

select count(*)
from order_items;