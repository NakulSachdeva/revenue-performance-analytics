use ecommerce_sql;

-- Question 1 : Write a query to find the Total Revenue, Total Units Sold, and Average Price Per Unit for every Category.
select p.category,sum(oi.final_price) as Total_Revenue, count(oi.order_id) as Total_Units_Sold, ROUND(sum(oi.final_price) / count(oi.order_id),2) as Avg_price_Per_Unit
from products p 
left join order_items oi on p.product_id = oi.product_id
group by p.category
order by sum(oi.final_price) DESC;

-- Question 2 : Identify the top 5 products that have generated the most revenue, and show their current stock level alongside their reorder level.

select p.product_id, p.product_name, FORMAT(sum(DISTINCT oi.final_price),2) as Total_Revenue, sum(DISTINCT i.stock_available) as Cur_InvLevels, max(i.reorder_level) as Reo_Levels
from products p 
left join order_items oi on p.product_id = oi.product_id
left join inventory i on p.product_id = i.product_id
group by p.product_id, p.product_name
order by sum(oi.final_price) DESC limit 5;
-- With CTE's (Correct Answer)
WITH revenue AS (
    SELECT 
        product_id,
        SUM(final_price) AS total_revenue
    FROM order_items
    GROUP BY product_id
),
inventory_data AS (
    SELECT 
        product_id,
        SUM(stock_available) AS stock,
        MAX(reorder_level) AS reorder_level
    FROM inventory
    GROUP BY product_id
)
SELECT 
    p.product_id,
    p.product_name,
    r.total_revenue,
    i.stock,
    i.reorder_level
FROM products p
LEFT JOIN revenue r 
    ON p.product_id = r.product_id
LEFT JOIN inventory_data i 
    ON p.product_id = i.product_id
ORDER BY r.total_revenue DESC Limit 5;






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


-- Question 7 (Learning CTE's) - Create a CTE named CustomerInfo that selects customer_id, first_name, and city.
-- In your main query, join this CTE with the orders table to show the total number of orders per city.

WITH CustomerInfo AS (
	SELECT customer_id, first_name, city
    FROM customers
) -- This is the Common Table Expression 
SELECT ci.city, count(Distinct o.order_id) as Total_Orders
from CustomerInfo ci
left join orders o on ci.customer_id = o.customer_id
group by ci.city;

-- Question 8 : Create a CTE that finds all products with a mrp greater than 1000. 
-- In your main query, find how many of these "Premium" items were actually sold (join with order_items). 
WITH PremiumProducts AS (
	SELECT product_id,product_name,mrp
    from products 
    where mrp > 1000
)
select count(oi.order_item_id)
from PremiumProducts pp
left join order_items oi on pp.product_id = oi.product_id;
    
-- Question 9: calculate how "full" each warehouse is. In a real job, a manager would look at this and say, "Warehouse A is at 98% capacity; we need to stop sending shipments there."    

WITH warehouse_levels AS (
	SELECT warehouse_id, sum(stock_available) as Total_Stock
    FROM inventory
    GROUP BY warehouse_id
)
SELECT w.warehouse_city, Total_Stock ,CONCAT(ROUND((Total_Stock/w.capacity)*100,2),"%") as Capacity_utilization
FROM warehouses w
left join warehouse_levels wl on w.warehouse_id = wl.warehouse_id;

-- Question 10: show only categories where the Average Discount is higher than 3%.

WITH PriceAnalysis AS (	
	SELECT p.category,Round(Avg((p.mrp - oi.final_price)/p.mrp*100),2) as Avg_Dis
    FROM products p
    Join order_items oi on p.product_id = oi.product_id
    group by p.category
)
SELECT category, Avg_Dis
FROM PriceAnalysis 
Where Avg_Dis > 3;   

-- Question 11: The CEO wants to see a list of products and their Return-to-Sales Ratio.
-- Return To Sales Ratio is (Total Units Returned / Total Units Sold) * 100

WITH return_CTE AS (
	SELECT oi.product_id, coalesce(sum(oi.quantity),0) as Units_Returned
    from returns r
    join order_items oi on oi.order_item_id = r.order_item_id
    group by oi.product_id
),
sold_CTE AS (
	SELECT product_id, coalesce(sum(quantity),0) as Units_Sold
    from order_items
    group by product_id
)
select p.product_name, p.category,p.brand, Units_Sold ,Units_Returned, ROUND((Units_Returned / NULLIF(Units_Sold,0))*100,2) as RTS_Ratio
from products p
Left join sold_CTE s on s.product_id = p.product_id
left join return_CTE r on r.product_id = p.product_id
where Units_Sold > 0
Order by RTS_Ratio DESC;

select * from product_suppliers;
















































