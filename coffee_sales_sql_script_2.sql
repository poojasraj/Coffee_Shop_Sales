use coffe_shop_sales_db;

select * from coffee_shop_sales; 

-- Data Cleaning
describe coffee_shop_sales; 

-- Chart Requirements
-- Calender Chart - Total Sales, Quantity and Orders
select
    concat(round(sum(unit_price*transaction_qty)/1000,1),'K') as Total_Sales,
    concat(round(sum(transaction_qty)/1000,1),'K') as Total_Qty_Sold,
    concat(round(count(transaction_id)/1000,1),'K') as Total_Orders
from coffee_shop_sales
where
    transaction_date = '2023-05-18';  
 
-- Sales Analysis in Weekdays and Weekends 
-- Weekdays- Mon-Fri
-- Weekends- Sat,Sun
Sun - 1
Mon -2
.
.
.
Sat -7

select
     case when DAYOFWEEK(transaction_date) in (1,7) then 'Weekends'
     else 'Weekdays'
     end as Day_type,
     concat(round(sum(unit_price*transaction_qty)/1000,1),'K') as Total_Sales
from coffee_shop_sales
where 
     Month(transaction_date) = 5
group by
     Day_type  
    
-- Sales Analysis by Store Location
select
      store_location,
      concat(round(sum(unit_price*transaction_qty)/1000,1),'K') as Total_Sales
from coffee_shop_sales
where
      Month(transaction_date) = 5
group by
      store_location
order by Total_Sales Desc;     

-- Sales Analysis by Product Category
select 
     product_category,
     round(sum(unit_price*transaction_qty),1) as Total_Sales
from coffee_shop_sales
where
    Month(transaction_date) = 5
group by product_category
order by Total_Sales Desc; 

-- Sales trend over a period
select 
     avg(Total_Sales) as Avg_Sales
from (        
      select 
          sum(unit_price*transaction_qty) as Total_Sales
      from coffee_shop_sales       
	  where
          Month(transaction_date) = 5 
      group by transaction_date
      ) as internal_query;
      
-- Daily sales for the month selected
select
    Day(transaction_date) as Day_of_Month, 
    round(sum(unit_price*transaction_qty),1) as Total_Sales
from coffee_shop_sales
where 
    Month(transaction_date) = 5
group by
    Day(transaction_date)
order by
    Day(transaction_date);   
    
-- Compare Daily Sales with Averege Sales
select
     Day_of_Month,
     case 
         when Total_Sales> Avg_Sales Then 'Above Average'
	     when Total_Sales< Avg_Sales Then 'Below Average'
     else 'Average'
     end as Sales_Status,
     Total_Sales
from (
      select 
           Day(transaction_date) as Day_of_Month,
           round(sum(unit_price*transaction_qty),1) as Total_Sales,
           avg(sum(unit_price*transaction_qty))over()  as Avg_Sales
      from coffee_shop_sales
      where
           month(transaction_date) = 5
      group by
		   Day_of_Month
       ) as Sales_data    
      order by 
           Day_of_Month     
      
    
     