use ecommerce_sql;

-- Question 1 : Write a query to find the Total Revenue, Total Units Sold, and Average Price Per Unit for every Category.
select p.category,sum(oi.final_price) as Total_Revenue, count(oi.order_id) as Total_Units_Sold, ROUND(sum(oi.final_price) / count(oi.order_id),2) as Avg_price_Per_Unit
from products p 
left join order_items oi on p.product_id = oi.product_id
group by p.category
order by sum(oi.final_price) DESC;

-- Question 2 : Identify the top 5 products that have generated the most revenue, and show their current stock level alongside their reorder level.

select p.product_id, p.product_name, FORMAT(sum(oi.final_price),2) as Total_Revenue, sum(i.stock_available) as Cur_InvLevels, max(i.reorder_level) as Reo_Levels
from products p 
left join order_items oi on p.product_id = oi.product_id
left join inventory i on p.product_id = i.product_id
group by p.product_id, p.product_name
order by sum(oi.final_price) DESC limit 5;

-- Question 3 : The CEO doesn't want to see 1,000 products. They only want to see the ones they need to spend money on right now.
-- Logic : 	We need to find products where the Total Stock (across all warehouses) is less than the Reorder Level.

select p.product_id, p.product_name, sum(i.stock_available) as Total_Stock, sum(i.reorder_level) as Reord_Level
from products p
left join inventory i on p.product_id = i.product_id
group by p.product_id, p.product_name
having Total_Stock < Reord_level;

SELECT 
    p.product_name, 
    SUM(i.stock_available) AS Total_Stock, 
    SUM(i.reorder_level) AS Total_Requirement,
    CASE 
        WHEN SUM(i.stock_available) < SUM(i.reorder_level) THEN 'Low Stock'
        ELSE 'Healthy'
    END AS Status
FROM products p
JOIN inventory i ON p.product_id = i.product_id
GROUP BY p.product_id, p.product_name
LIMIT 10;

-- Question 4 : Your data shows that you sell products on different platforms (Amazon, Myntra, Flipkart, etc.). The CEO wants to know which platform is the most profitable.
-- In your platforms table, you have a column called commission_rate. This is the percentage the platform takes from every sale.
-- The Goal: Calculate the Net Revenue (Total Sales minus the Platform Commission) for each platform.

select pl.platform_id, pl.platform_name, pl.commission_rate, FORMAT(sum(oi.final_price),2) as gross_revenue, FORMAT(sum(oi.final_price) - ROUND((pl.commission_rate *(sum(oi.final_price)/100)),2),2) as net_revenue       
from orders o
join platforms pl on pl.platform_id = o.platform_id
join order_items oi on o.order_id = oi.order_id
group by pl.platform_id,pl.platform_name, pl.commission_rate
Order by net_revenue DESC; 

-- Question 5 : Monthly Revenue Trend

select monthname(o.order_date) as Order_Month,year(o.order_date) as Order_Year, sum(oi.final_price) as Total_revenue,
count(Distinct oi.order_id) as Total_Units, Round(sum(oi.final_price)/count(Distinct oi.order_id),2) as Avg_Ord_Val
from orders o 
left join order_items oi on o.order_id = oi.order_id
group by year(o.order_date), month(o.order_date),monthname(o.order_date)
order by year(o.order_date), month(o.order_date);

-- Question 6 (Follow up) - why the dip at June 2025. (Which Platform)

select p.platform_id, p.platform_name, count(distinct oi.order_id) as Total_Units, FORMAT(sum(oi.final_price),2) as Total_Revenue
from orders o
join platforms p on o.platform_id = p.platform_id
join order_items oi on o.order_id = oi.order_id
where monthname(o.order_date) = 'June' and year(o.order_date) = '2025'
group by p.platform_id, p.platform_name;

-- Here we can notice the platform crash , we need to look at our inventory - did we run out of best selling products? or 
-- stopped running ads in june? Q7 - Show the categories which took hit in June compared to May 2025

select p.category, Count(distinct CASE WHEN MONTH(o.order_date)='5' Then o.order_id END) as May_Orders,
				   Count(distinct CASE WHEN MONTH(o.order_date)='6' THEN o.order_id END) as June_Orders
from products p
join order_items oi on p.product_id = oi.product_id
join orders o on oi.order_id = o.order_id
WHERE year(o.order_date) = '2025'
group by p.category;










