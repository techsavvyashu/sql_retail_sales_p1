

SELECT * FROM retail_sales
limit 10

SELECT 
 COUNT (*)
FROM retail_sales 

-- Data Cleaning

SELECT * FROM retail_sales
WHERE   sale_date is NULL
		OR
		sale_time is NULL
		OR
		transactions_id is NULL
		OR
		customer_id is NULL
		OR
		gender is NULL
		OR
		category is NULL
		OR
		quantiy is NULL
		OR
		price_per_unit is NULL
		OR
		cogs is NULL
		OR
		total_sale is NULL
		
-- Data Exploration

-- How many sales we have?

SELECT COUNT (total_sale) AS TOTAL FROM retail_sales

-- How many UNIQUE Customers we have ?

SELECT 
	COUNT( DISTINCT customer_id) as Total_cust 
FROM  retail_sales   

SELECT DISTINCT category FROM retail_sales

-- Data Analysis & Business Key & Answers 

-- 1. Write a SQL query to retrieve all columns for sales made on '2022-11-05'
-- 2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and made in the month of November 2022
-- 3. Write a SQL query to calculate the total sales (total_sale) for each category
-- 4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category
-- 5. Write a SQL query to find all transactions where the total_sale is greater than 1000
-- 6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category
-- 7. Write a SQL query to calculate the average sale for each month. Find out best selling month in terms of average sale
-- 8. Write a SQL query to find the top 5 customers based on the highest total sales
-- 9. Write a SQL query to find the number of unique customers who purchased items from each category
-- 10. Write a SQL query to create each shift and number of orders (Example: Morning <12, Afternoon Between 12 to 17, Evening >17)


-- 1. Write a SQL query to retrieve all columns for sales made on '2022-11-05'

SELECT * 
FROM retail_sales
WHERE sale_date = '2022-11-05'

-- 2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in month of November 2022

SELECT 
	*
FROM retail_sales
WHERE 
	category = 'Clothing'
	AND sale_date BETWEEN  '2022-11-01' AND '2022-11-30' -- TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
	AND quantiy >=3
GROUP BY 1


-- 3. Write a SQL query to calculate the total sales (total_sale) for each category

SELECT 
	COUNT (*) as Total,
	category,
	SUM (total_sale) as Totalsale
FROM retail_sales
GROUP BY 2
ORDER BY 2

-- 4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category

SELECT 
	ROUND (AVG (age), 2) as AGE
FROM retail_sales
WHERE category ='Beauty'
GROUP BY 1

-- 5. Write a SQL query to find all transactions where the total_sale is greater than 1000

SELECT 
	transactions_id,
	total_sale
FROM retail_sales
WHERE total_sale > 1000
ORDER BY 2 ASC

-- 6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category

SELECT 
	gender,
	category,
	COUNT (*) as Total_sale
FROM retail_sales
GROUP BY 1,2
ORDER BY 2

SELECT DISTINCT category FROM retail_sales

-- 7. Write a SQL query to calculate the average sale for each month. Find out best selling month in terms of average sale

SELECT 
	year,
	month,
	avg_sale
FROM
(
	SELECT
		EXTRACT (YEAR FROM sale_date) as year,
		EXTRACT(MONTH FROM sale_date) as month,
		AVG (total_sale) as avg_sale,
		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG (total_sale) DESC) as rank
	FROM retail_sales
	GROUP BY 2,1
) as t1
WHERE RANK = 1
ORDER BY 1,3 DESC


-- 8. Write a SQL query to find the top 5 customers based on the highest total sales

SELECT 
	DISTINCT customer_id,
	SUM (total_sale)
FROM retail_sales
--WHERE TO_CHAR (sale_date, 'YYYY-MM') = '2023-01'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

-- 9. Write a SQL query to find the number of unique customers who purchased items from each category

SELECT 
	COUNT (DISTINCT customer_id),
	category
FROM retail_sales
GROUP BY 2

-- 10. Write a SQL query to create each shift and number of orders (Example: Morning <12, Afternoon Between 12 to 17, Evening >17)

WITH hourly_sales
AS
(
	SELECT *,
		CASE
			WHEN EXTRACT(HOUR FROM sale_time) <12 THEN 'Morning'
			WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
			ELSE 'Evening'
		END as shift
	FROM retail_sales
)
SELECT 
	shift,
	COUNT (*) AS total_order
FROM hourly_sales
GROUP BY 1

--  End of Project