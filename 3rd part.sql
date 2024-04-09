#Add ‘sales_rank’ column that ranks rows from best to worst for each country 
#based on total amount with tax earned each month. 

WITH sales_numbers_main AS(

    SELECT
      LAST_DAY(EXTRACT(DATETIME FROM sales_header.OrderDate), MONTH) AS order_month,
      sales_territory.CountryRegionCode AS country_region_code,
      sales_territory.Name AS region,
      COUNT(sales_header.SalesOrderID) AS no_orders,
      COUNT(DISTINCT sales_header.CustomerID) AS no_customers,
      COUNT(DISTINCT sales_header.SalesPersonID) AS no_sales_persons,
      CAST(ROUND(SUM(sales_header.TotalDue)) AS INT64) AS total_w_tax

    FROM 
      `adwentureworks_db.salesorderheader` AS sales_header
    INNER JOIN
      `adwentureworks_db.salesterritory` AS sales_territory
    ON
      sales_territory.TerritoryID = sales_header.TerritoryID

    GROUP BY
      order_month,
      country_region_code,
      region)


SELECT 
  sales_numbers_main.*,
  RANK() OVER (PARTITION BY country_region_code ORDER BY total_w_tax DESC) AS country_sales_rank,
  SUM(total_w_tax) OVER (PARTITION BY country_region_code, region ORDER BY order_month) AS cumulative_sum

FROM 
  sales_numbers_main

ORDER BY 
  country_region_code, 
  region, 
  country_sales_rank;
