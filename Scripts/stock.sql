CREATE DATABASE DATA_SET
GO

USE DATA_SET;
GO

CREATE SCHEMA Stock;

SELECT * FROM Stock_Price
GO

IF OBJECT_ID ('Stock_Price', 'U') IS NOT NULL
	DROP TABLE Stock_Price;

CREATE TABLE Stock_Price (
Symbol NVARCHAR(50),
Date Date,
Stock_Open FLOAT,
High Float,
Low Float,
Stock_Close Float,
Volume INT
);
GO

BULK INSERT Stock_Price
FROM 'C:\Users\Japhary\Desktop\Data Analysis\Project\Data Set For Task\2) Stock Prices Data Set.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n',
	TABLOCK
	);
GO

--- How to check if Symbol Column has cointain a Duplicate stock symbol
SELECT 
distinct Symbol,
COUNT(*) AS Nomber_of_Dupplicate
FROM Stock_Price
GROUP BY Symbol
HAVING COUNT(*) > 1

-- Check if symbol column has null entry
SELECT * FROM Stock_Price WHERE Symbol IS NULL; -- No Value which a null 

-- Check if Date column has null entry
SELECT * FROM Stock_Price WHERE Date IS NULL; -- No Value which a null 

-- Check if Date column has Any Enrty which Date are incorrect
SELECT * FROM Stock_Price WHERE Date > GETDATE()

-- Check if Stock_Open column has null entry
SELECT * FROM Stock_Price WHERE Stock_Open IS NULL; --- We found 11 entry are null 

-- Check if High column has null entry
SELECT * FROM Stock_Price WHERE High IS NULL; --- We found 8 entry are null 

-- Check if Low column has null entry
SELECT * FROM Stock_Price WHERE Low IS NULL; --- We found 8 entry are null 

-- Check if Stock_Close column has null entry
SELECT * FROM Stock_Price WHERE Stock_Close IS NULL; -- No Value which a null

-- Check if Volume column has null entry
SELECT * FROM Stock_Price WHERE Volume IS NULL; -- No Value which a null 

--- Data Preparation for Analysi

SELECT 
UPPER(TRIM(Symbol)) AS Symbol
FROM Stock_Price;

SELECT Date FROM Stock_Price;

SELECT 
Round(CASE WHEN Stock_Open IS NULL THEN High
	ELSE Stock_Open
END, 1) AS Stock_Open
FROM Stock_Price
WHERE Stock_Open IS NULL AND High > 0;

SELECT 
Round(High, 1) AS Stock_High
FROM Stock_Price
WHERE HIGH IS NOT NULL

SELECT 
Round(Low, 1) AS Stock_Low
FROM Stock_Price
WHERE HIGH IS  NULL

SELECT 
Round (Stock_Close, 1) AS Stock_Close
FROM Stock_Price;

SELECT
Volume
FROM Stock_Price


IF OBJECT_ID('stock.Stock_Prices', 'U') IS NOT NULL
	DROP TABLE stock.Stock_Prices;

CREATE TABLE stock.Stock_Prices(
	[Symbol] [nvarchar](50) NOT NULL,
	[Date] [date] NOT NULL,
	[Stock_Open] [float] NULL,
	[High] [float] NULL,
	[Low] [float] NULL,
	[Stock_Close] [float] NULL,
	[Volume] [float] NULL
)

TRUNCATE TABLE stock.Stock_Prices;
INSERT INTO stock.Stock_Prices 
	(
	Symbol,
	Date,
	Stock_Open,
	High,
	Low,
	Stock_Close,
	Volume
	)

--- Data Preparation for Analysi

SELECT 
	UPPER(TRIM(Symbol)) AS Symbol,
	Date,
	Round(
		CASE 
			WHEN Stock_Open IS NULL THEN High
			ELSE Stock_Open		---- Remove null and some 3 null which has a open value so we a going to use that open value
		END, 1) AS Stock_Open,  --- Remain one decimal point

	Round(High, 1) AS Stock_High, -- Remain one decimal point
	Round(Low, 1) AS Stock_Low, 
	Round (Stock_Close, 1) AS Stock_Close, -- Remain one decimal point

	Volume
FROM Stock_Price
WHERE High IS NOT NULL AND Low IS NOT NULL
	AND high < low --Remove all Duplicate in this two Columns
;


---- EDA (Exploratory Data Analysis) in SQL

-- Understand Dataset Structure
SELECT COUNT(*) AS Total_Row FROM Stock.Stock_Prices

-- Check columns and data types
EXEC sp_help 'Stock.Stock_Prices'

--- Data Quality Check
-- Missing Values / NULL Check
 SELECT 
	 COUNT(*) AS Total_Row,
	 COUNT(Symbol) AS Symbol_NotNull,
	 COUNT(Date) AS Date_NotNull,
	 COUNT(Stock_Open) AS Stock_Open_NotNull,
	 COUNT(High) AS High_NotNull,
	 COUNT(Low) AS Low_NotNull,
	 COUNT(Stock_Close) AS Stock_Close_NotNull,
	 COUNT(Volume) AS Volume_NotNull
 FROM Stock.Stock_Prices

--- Descriptive Statistics
-- Minimum, Maximum, Average

 SELECT 
    MIN(Stock_Open) AS Min_Open,
	MIN(Stock_Close) AS Min_Close,
	MIN(Volume) AS Min_Volume,

    MAX(Stock_Open) AS Max_Open,
	MAX(Stock_Close) AS Max_Close,
	MAX(Volume) AS Max_Volume,

    ROUND( AVG(Stock_Open), 1) AS Avg_Open,  
    ROUND( AVG(Stock_Close), 1) AS Avg_Close,
	ROUND( AVG(Volume), 1)		AS Avg_Volume
FROM Stock.Stock_Prices;

-- Check if High < Low (Bad Data)
SELECT *
FROM Stock.Stock_Prices
WHERE High < Low;


--Check negative prices
SELECT *
FROM Stock.Stock_Prices
WHERE Stock_Open < 0
OR Stock_Close < 0
OR High < 0
OR Low < 0;

--- Date Range
SELECT
    MIN([Date]) AS Start_Date,
    MAX([Date]) AS End_Date
FROM Stock.Stock_Prices;

-- Daily Records Trend
SELECT
    Date,
    COUNT(*) AS Number_of_Stocks
FROM Stock.Stock_Prices
GROUP BY Date
ORDER BY Date;

-- Number of Trading Days
SELECT
    COUNT(DISTINCT [Date])
AS Trading_Days
FROM Stock.Stock_Prices;

---- How much did each stock gain/loss daily?

SELECT 
	Symbol,
	Date,
	Stock_Open,
	Stock_Close,
	Round((Stock_Close-Stock_Open), 1) AS Price_Change
FROM Stock.Stock_Prices
WHERE Round((Stock_Close-Stock_Open), 1) > 0;


--- What percentage did the stock gain/loss?

SELECT 
	Symbol,
	Date,
	Stock_Open,
	Stock_Close,
	Concat(Round(((Stock_Close-Stock_Open) / Stock_Open) * 100, 2), '%') AS Price_Percentage
FROM Stock.Stock_Prices
WHERE Round(((Stock_Close-Stock_Open) / Stock_Open) * 100, 2) > 0;


--- Which stocks were highly volatile?

SELECT 
	Symbol,
	Date,
	High,
	low,
	Round((High - low), 1) AS Volatility
FROM Stock.Stock_Prices
ORDER BY Volatility DESC

--- What is the average closing price?

SELECT 
	Symbol,
	Round(AVG(Stock_Close), 1) AS Avg_Closing_Price
FROM Stock.Stock_Prices
GROUP BY Symbol
ORDER BY Avg_Closing_Price DESC


---- What is the highest stock price?
SELECT 
	Symbol,
	MAX(High) AS Max_highest
FROM Stock.Stock_Prices
GROUP BY Symbol
ORDER BY Max_highest DESC

---- What is the Lowest stock price?
SELECT
	Symbol,
	MIN(Low) AS Min_Lowest
FROM Stock.Stock_Prices
GROUP BY Symbol
ORDER BY Min_Lowest ASC;

--What are the monthly trading volume trends?

SELECT
YEAR(Date) AS Year,
MONTH(Date) AS Month,
SUM(Volume) AS Trading_Volume
FROM Stock.Stock_Prices
GROUP BY YEAR(Date), MONTH(Date)
ORDER BY Year, Month;


--- Which stock had the highest trading volume?
SELECT
	Symbol,
	SUM(Volume) AS Total_Number
FROM Stock.Stock_Prices
GROUP BY Symbol
ORDER BY Total_Number DESC 

---What is the trend over time?
SELECT
    Symbol,
    Date,
    Stock_Close,
    Round(AVG(Stock_Close) OVER (
        PARTITION BY Symbol
        ORDER BY [Date]
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ), 1) AS Moving_Average_7_Days
FROM Stock.Stock_Prices;

--- Which stocks are most risky?

SELECT TOP 5
	Symbol,
		ROUND(AVG(High-low), 1) AS Avg_Volatility
FROM Stock.Stock_Prices
GROUP BY Symbol
ORDER BY Avg_Volatility DESC;

--- How many profitable days did each stock have?

SELECT
    Symbol,
		COUNT(*) AS Profitable_Days
FROM Stock.Stock_Prices
WHERE Stock_Close > Stock_Open
GROUP BY Symbol
ORDER BY Profitable_Days DESC;

--- Which stock performed best each day?

WITH Daily_Return AS (
    SELECT
        Symbol,
        [Date],
        ((Stock_Close - Stock_Open) / Stock_Open) * 100 AS Return_Percentage
    FROM Stock.Stock_Prices
)

SELECT *
FROM (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY [Date]
               ORDER BY Return_Percentage DESC
           ) AS rn
    FROM Daily_Return
) x
WHERE rn = 1;

--- Moving Averages (Trend Detection)

SELECT 
	Symbol,
	Date,
	Stock_Close,
	Round(AVG(Stock_Close) OVER (PARTITION BY Symbol ORDER BY Date 
	ROWS BETWEEN 6 PRECEDING AND CURRENT ROW), 2) 
	AS Moving_Avg_7_Days
FROM Stock.Stock_Prices;





IF OBJECT_ID ('Stock_View', 'U') IS NOT NULL
	DROP TABLE Stock_View;

CREATE VIEW Stock_ViewS A

SELECT * FROM Stock.Stock_Prices

