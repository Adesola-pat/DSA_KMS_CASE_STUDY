-- Creating a database
CREATE DATABASE kms_sales_db;
USE kms_sales_db;

-- This query is to create a table where the file can be imported to
CREATE TABLE Sales_Case (
Row_ID INT,
Order_ID INT,
Order_Date DATE,
Order_Priority NVARCHAR(50),
Order_Quantity INT,
Sales FLOAT,
Discount FLOAT,
Ship_Mode NVARCHAR(50),
Profit FLOAT,
Unit_Price FLOAT,
Shipping_Cost FLOAT,
Customer_Name NVARCHAR(50),
Province NVARCHAR(50),
Region NVARCHAR(50),
Customer_segment NVARCHAR(50),
Product_Category NVARCHAR(50),
Product_Sub_Category NVARCHAR(50),
Product_Name NVARCHAR(100),
Product_Container NVARCHAR(50),
Product_BAse_Margin FLOAT,
Ship_Date DATE
)
-- This query is to confirm if the table has been imported successfully
SELECT TOP 10 * FROM KMS_Sql_Case_Study   

-- CASE SCENARIO 1
-- WHICH CATEGORY HAS THE HIGHEST SALES?
SELECT [Product_Category], SUM(Sales)
AS Total_Sales
FROM KMS_Sql_Case_Study
GROUP BY [Product_Category]
ORDER BY Total_Sales DESC;

-- WHAT ARE THE TOP 3 AND BOTTOM 3 REGIONS IN TERMS OF SALES
--TOP 3 REGIONS BY TOTAL SALES
SELECT Top 3 [Region], SUM(Sales)
AS Total_Sales
FROM KMS_Sql_Case_Study
GROUP BY [Region]
ORDER BY Total_Sales DESC;

--- BOTTOM 3 REGIONS BY TOTAL SALES
SELECT Top 3 [Region], SUM(Sales)
AS Total_Sales
FROM KMS_Sql_Case_Study
GROUP BY [Region]
ORDER BY Total_Sales ASC;

-- THE TOTAL SALES OF APPLIANCES IN ONTARIO
SELECT SUM(Sales) AS Total_Sales
FROM KMS_Sql_Case_Study
WHERE Province = 'Ontario' AND
[Product_Sub_Category]= 'Appliances';

---Advice the management of KMS on what to do to increase the revenue from bottom 10 customers
SELECT TOP 10 [Customer_Name],
SUM(Sales) As Total_Sales
FROM KMS_Sql_Case_Study
GROUP BY [Customer_Name]
ORDER BY Total_Sales ASC;

/* Business Advice
KMS can offer discounts or some sort of black sales for the customers
Also, they can pair lower selling products with the top performing products in a form of "buy 1 get another free gift" to increase sales
*/

--KMS incured the most shipping cost using which shipping method?
SELECT [Ship_Mode], SUM([Shipping_Cost]) AS Total_Shipping_Cost
FROM KMS_Sql_Case_Study
GROUP BY [Ship_Mode]
ORDER BY Total_Shipping_Cost DESC;

/* CASE SCENARIO 2
Who are the most valuable customers and what products or services do they typically purchase
*/
--Top 10 customers by total sales
SELECT TOP 10 [Customer_Name],
SUM(Sales) As Total_Sales
FROM KMS_Sql_Case_Study
GROUP BY [Customer_Name]
ORDER BY Total_Sales DESC;
--- What product category did they purchase most?
SELECT [Customer_Name],[Product_Sub_Category], SUM(Sales) AS Category_Sales
FROM KMS_Sql_Case_Study
WHERE [Customer_Name] IN (
	SELECT TOP 10 [Customer_Name]
	FROM KMS_Sql_Case_Study
	GROUP BY [Customer_Name]
	ORDER BY SUM(Sales) DESC
)
GROUP BY [Customer_Name], [Product_Sub_Category]
ORDER BY [Customer_Name], Category_Sales DESC

-- Which small business customer had the highest sales?
SELECT TOP 1 [Customer_Name],
SUM(Sales) AS Total_Sales
FROM KMS_Sql_Case_Study
WHERE [Customer_Segment] = 'Small Business'
GROUP BY [Customer_Name]
ORDER BY Total_Sales DESC;

--Which corporate customer placed the most number of orders from 2009 to 2012?
SELECT TOP 1 [Customer_Name],
COUNT(DISTINCT [Order_ID]) AS Order_Count
FROM KMS_Sql_Case_Study
WHERE [Customer_Segment]= 'Corporate' AND YEAR (TRY_CAST(Order_Date AS DATE)) BETWEEN 2009 AND 2012
GROUP BY [Customer_Name]
ORDER BY Order_Count DESC;

-- Which Consumer customer was the most profitable one?
SELECT TOP 1 [Customer_Name],
SUM(Profit) AS Total_Profit
FROM KMS_Sql_Case_Study
WHERE [Customer_Segment]= 'Consumer'
GROUP BY [Customer_Name]
ORDER BY Total_Profit DESC;

-- Which customer returned items, and what segment do they belong to?
--- first alter the initial table and add the column for the order status
ALTER TABLE KMS_Sql_Case_Study
ADD Order_Status VARCHAR(50);

--- after importing the file for the order status then merge the two tables

MERGE INTO KMS_Sql_Case_Study AS target
USING [dbo].[Order_Status] AS source
ON target.order_id = source.order_id
WHEN MATCHED THEN
	UPDATE SET target.Order_ID = source.Order_ID;

	select * from KMS_Sql_Case_Study

	---to check the return status

--- was shipping cost appropriately spent based on order priority?
SELECT  [Order_Priority], [Ship_Mode],
	COUNT(*) AS Num_Orders,
	AVG([Shipping_Cost]) AS Avg_Shipping_cost
FROM KMS_Sql_Case_Study
GROUP BY  [Order_Priority], [Ship_Mode]
ORDER BY [Order_Priority], Avg_Shipping_cost DESC;