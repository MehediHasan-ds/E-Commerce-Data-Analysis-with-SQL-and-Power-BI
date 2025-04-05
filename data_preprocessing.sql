
-- preprocess the orders, order_items, all_unique_products table

-- calculate total_amount in order_items and grand_total in orders table
SELECT COUNT(*)
FROM (
	SELECT price*quantity
	FROM all_unique_products aup
	JOIN order_items oi ON aup.product_id = oi.product_id
) AS allcount; -- 35940

SELECT COUNT(*)
FROM order_items; -- 35940

select count(distinct product_id)
from all_unique_products; -- 70

select count(distinct product_id)
from order_items; -- 69

-- So, there are some products in the order_items table that are not avaialble in the all_unique_products table, they are old products

-- replace unmateched product id from order_items with unique products with the least frequent products id in order_items table
UPDATE order_items oi
LEFT JOIN all_unique_products aup
    ON oi.product_id = aup.product_id
SET oi.product_id = '1a95d70a'
WHERE aup.product_id IS NULL;

-- model_name and product_names are same, so remove one
ALTER TABLE all_unique_products
DROP COLUMN model_name;

-- DROP TABLE brands;

-- we need to calculate the total_amount for the available products
SELECT order_id, price*quantity AS total_amount
FROM all_unique_products aup
LEFT JOIN order_items oi ON aup.product_id = oi.product_id
limit 10;

CREATE OR REPLACE VIEW total_order_amount AS
WITH total_amounts AS(
SELECT order_id, price*quantity AS total_amount
FROM all_unique_products aup
LEFT JOIN order_items oi ON aup.product_id = oi.product_id
)

SELECT o.order_id, (SUM(ta.total_amount)) AS order_total
FROM orders o
JOIN total_amounts ta ON o.order_id = ta.order_id
GROUP BY ta.order_id;

select *
from orders
limit 10;

select *
from total_order_amount
limit 10;

select o.order_id,customer_id, (toa.order_total-discount_applied+tax_amount+shipping_cost) as grand_total
from orders o
join total_order_amount toa on o.order_id = toa.order_id
limit 10;


-- preprocess customers, reviews table

SET SQL_SAFE_UPDATES = 0;
DROP TABLE products;