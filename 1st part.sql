#Monthly sales numbers in each country & region

SELECT
  LAST_DAY(EXTRACT(DATETIME FROM sales_header.OrderDate), MONTH) AS order_month, #show last month day
  sales_territory.CountryRegionCode AS country_region_code,
  sales_territory.Name AS region,
  COUNT(sales_header.SalesOrderID) AS no_orders,
  COUNT(DISTINCT sales_header.CustomerID) AS no_customers,
  COUNT(DISTINCT sales_header.SalesPersonID) AS no_sales_persons,
  CAST(ROUND(SUM(sales_header.TotalDue)) AS INT64) AS total_w_tax #to have sum without .0

FROM 
  `adwentureworks_db.salesorderheader` AS sales_header
INNER JOIN
  `adwentureworks_db.salesterritory` AS sales_territory
ON
  sales_territory.TerritoryID = sales_header.TerritoryID

GROUP BY
  order_month,
  country_region_code,
  region;