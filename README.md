# KMS_CASE_STUDY
Data Analysis of Kultra Mega Stores (KMS) inventory using Structured Query Language (SQL) to solve the Case Scenarios.
This repository contains a complete SQL analysis of a retail dataset from **KMS**, focusing on sales, customers, shipping, and profitability insights using MIcrosoft SQL Server (SSMS)
## Dataset Overview
The dataset [KMS Sql Case Study.csv](https://github.com/user-attachments/files/21054975/KMS.Sql.Case.Study.csv) includes:
- Order and Shipping details
- Customer segmentation
- Product categories and sales
- Regional and provincial data
- Financial details such as sales, profit, and shipping cost

## Business Questions Answered
### Case Scenario 1
1. Which category has the highest sales?
2. What are the top 3 and bottom 3 regions in terms of sales?
3. What were the total sales of appliances in Ontario?
4. How can KMS increase revenue from the bottom 10 customers?
5. Which shipping method incurred the highest shipping cost?

### Case Scenario 2

6. Who are the most valuable customers, and what do they buy?
7. Which small business customer had the highest sales?
8. Which corporate customer placed the most orders (2009–2012)?
9. Which consumer customer was the most profitable?
10. Which customer returned items, and what segment do they belong to?
11. Did KMS appropriately spend shipping costs based on order priority?

---

SQL
'''
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
--There's no column for the returned Status
--- was shipping cost appropriately spent based on order priority?
SELECT  [Order_Priority], [Ship_Mode],
	COUNT(*) AS Num_Orders,
	AVG([Shipping_Cost]) AS Avg_Shipping_cost
FROM KMS_Sql_Case_Study
GROUP BY  [Order_Priority], [Ship_Mode]
ORDER BY [Order_Priority], Avg_Shipping_cost DESC;
'''

## 🛠 Tools Used

- *Microsoft SQL Server (SSMS)*
- *SQL* (T-SQL for querying and analysis)
- *Excel* (for inspecting the CSV)



## 🧑‍💼 Author

*Patience Ayeni*  
patienceboluwatife62@gmail.com

