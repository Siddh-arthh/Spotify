SELECT * FROM my_projects.retail_sales;

-- checking nulls
SELECT *
FROM retail_sales
WHERE
    transactions_id IS NULL OR
    sale_date IS NULL OR
    sale_time IS NULL OR
    customer_id IS NULL OR
    gender IS NULL OR TRIM(gender) = '' OR
    age IS NULL OR
    category IS NULL OR TRIM(category) = '' OR
    quantity IS NULL OR
    price_per_unit IS NULL OR
    cogs IS NULL OR
    total_sale IS NULL;


-- DATA EXOLORATION
-- HOW MANY SALES WE HAVE?

SELECT count(transactions_id) from retail_sales;

# how many customers do we have?
select count(distinct customer_id) from retail_sales;

# how many categories do we have?
select distinct category from retail_sales;



#----------------------------------------------------------------------------------------------
#------------------Data Analysis and Business Key problems and answers-------------------------



-- Q.1 write a sql query to retreive for sales made  on '2022-11-05'

SELECT 
    *
FROM
    retail_sales
WHERE
    sale_date = '2022-11-05';


-- Q.2 write a query to retreive all transactions where category is 'clothing' and qty sold is more than 10 in the month of november 2022
SELECT *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND quantity > 10
    AND MONTH(sale_date) = 11
    AND YEAR(sale_date) = 2022;


-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT 
    category, SUM(total_sale) AS Total_sales, COUNT(*) AS Total_orders
FROM
    retail_sales
GROUP BY category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT 
    ROUND(AVG(age), 2) AS avg_age
FROM
    retail_sales
WHERE
    category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT 
    *
FROM
    retail_sales
WHERE
    total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT 
    category,
    gender,
    COUNT(transactions_id) AS total_transactions
FROM
    retail_sales
GROUP BY category , gender
ORDER BY category;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

WITH monthly_sales AS (
    SELECT 
        YEAR(sale_date) AS Year,
        MONTHNAME(sale_date) AS Month,
        ROUND(AVG(total_sale), 2) AS avg_sales
    FROM retail_sales
    GROUP BY DATE_FORMAT(sale_date, '%m-%y'), YEAR(sale_date), MONTHNAME(sale_date)
)
, rankk AS(
SELECT 
    *,
    RANK() OVER (PARTITION BY year ORDER BY avg_sales DESC) AS Rank_
FROM monthly_sales)
SELECT 
    *
FROM
    rankk
WHERE
    rank_ = 1;



-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales.

SELECT 
    customer_id, SUM(total_sale) AS total_sales
FROM
    retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT 
    category, COUNT(DISTINCT customer_id) AS TotalCustomer
FROM
    retail_sales
GROUP BY category;


-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

SELECT 
    CASE
        WHEN HOUR(sale_time) < 12 THEN 'Morning'
        WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS Shift,
    COUNT(*) AS Quantity
FROM
    retail_sales
GROUP BY shift;

