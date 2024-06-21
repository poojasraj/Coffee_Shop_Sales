CREATE DATABASE coffe_shop_sales_db;

select * from coffee_shop_sales; 

-- Data Cleaning
describe coffee_shop_sales; 

-- Convert transaction_date column to proper date format
SET SQL_SAFE_UPDATES = 0;

update coffee_shop_sales
set transaction_date = STR_TO_DATE( transaction_date,'%d-%m-%Y');

alter table coffee_shop_sales
modify column transaction_date DATE;

-- Convert transaction_time column to proper time format
update coffee_shop_sales
set transaction_time = STR_TO_DATE(transaction_time,'%H:%i:%s')

alter table coffee_shop_sales
modify column transaction_time TIME;

describe coffee_shop_sales;

-- Change column name of transaction_id
alter table coffee_shop_sales
CHANGE COLUMN  transactin_id transaction_id INT;

-- Business Requirements
-- KPI Requirements

-- a) total sales 
select 
round(sum(unit_price*transaction_qty)) as Total_Sales
from coffee_shop_sales
where MONTH(transaction_date) = 5;

-- Increase or decrease in sales wrt previous month
select
MONTH(transaction_date) as Month,
round(sum(unit_price*transaction_qty)) as Total_Sales,
(sum(unit_price*transaction_qty) - LAG(sum(unit_price*transaction_qty),1)
OVER(order by MONTH(transaction_date)))/LAG(sum(unit_price*transaction_qty),1)
over(order by MONTH(transaction_date))*100 as Percentage_Increase_In_Sales_By_Month
from
coffee_shop_sales
where
MONTH(transaction_date) IN (4,5)
group by
MONTH(transaction_date)
order by
MONTH(transaction_date);

-- Total Orders
SELECT COUNT(transaction_id) as Total_Orders
FROM coffee_shop_sales 
WHERE MONTH (transaction_date)= 5 -- for month May 
   

-- Increase or Decrease in orders wrt previous month
select
MONTH(transaction_date) as Month,
round(COUNT(transaction_id)) as Total_Orders,
(COUNT(transaction_id) - LAG(COUNT(transaction_id),1)
OVER(order by MONTH(transaction_date)))/LAG(COUNT(transaction_id),1)
over(order by MONTH(transaction_date))*100 as Percentage_Increase_In_Orders_By_Month
from
coffee_shop_sales
where
MONTH(transaction_date) IN (4,5)
group by
MONTH(transaction_date)
order by
MONTH(transaction_date);      

-- Total Qty sold
select
sum(transaction_qty) as Total_Quantity_Sold
from coffee_shop_sales 
where 
MONTH(transaction_date) = 5;

-- Increase or decrease in total quantity sold wrt previous month
SELECT 
    MONTH(transaction_date) AS month,
    ROUND(SUM(transaction_qty)) AS total_quantity_sold,
    (SUM(transaction_qty) - LAG(SUM(transaction_qty), 1) 
    OVER (ORDER BY MONTH(transaction_date))) / LAG(SUM(transaction_qty), 1) 
    OVER (ORDER BY MONTH(transaction_date)) * 100 AS Percentage_Increase_In_Quantity_Sold_By_Month
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) IN (4, 5)   -- for April and May
GROUP BY 
    MONTH(transaction_date)
ORDER BY 
    MONTH(transaction_date);
