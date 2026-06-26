-- EDA
-- Explore All Object in the Database
SELECT * FROM INFORMATION_SCHEMA.TABLES

-- Explore All Columns in Database
SELECT * 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'Stock';

-- Explore All Symboll in Table
SELECT DISTINCT Symbol FROM Stock.Stock_Prices;

-- Explore Date 
--Find the OldestDate and LatestDate
SELECT 
	MIN(Date) AS OldestDate,
	MAX(Date) AS LatestDate,
	DATEDIFF(Year, MIN(Date), MAX(Date)) AS Year_Of_Market_Run
FROM Stock.Stock_Prices ;


--Find the Total of Volume
SELECT SUM(Volume) AS Total_Volume FROM Stock.Stock_Prices

--Find the averege of Volume
SELECT ROUND(AVG(Volume), 2) AS Avg_Volume FROM Stock.Stock_Prices

--Find the Total of Volume
SELECT COUNT(DISTINCT Stock_Open) AS Total_Stock_Open FROM Stock.Stock_Prices

--Find the Total of Volume
SELECT COUNT(DISTINCT Stock_Close)  AS Total_Stock_Close FROM Stock.Stock_Prices

SELECT COUNT(DISTINCT High) AS Total_High FROM Stock.Stock_Prices

SELECT COUNT(DISTINCT Low) AS Total_Number FROM Stock.Stock_Prices

SELECT COUNT(DISTINCT Symbol) AS Total_Number FROM Stock.Stock_Prices

-- Generate a Report that shows all key metrics of the Business

SELECT 'Total_Volume' AS Measure_Name, SUM(Volume) AS Measure_Value FROM Stock.Stock_Prices
UNION ALL
SELECT 'Avg_Volume' AS Measure_Name, ROUND(AVG(Volume), 2) AS Measure_Value FROM Stock.Stock_Prices
UNION ALL
SELECT 'Total_Stock_Open' AS Measure_Name, COUNT(DISTINCT Stock_Open) AS Measure_Value FROM Stock.Stock_Prices
UNION ALL
SELECT 'Total_Stock_Close' AS Measure_Name, COUNT(DISTINCT Stock_Close)  AS Measure_Value FROM Stock.Stock_Prices
UNION ALL
SELECT 'Total_Number_High' AS Measure_Name, COUNT(DISTINCT High) AS Measure_Value FROM Stock.Stock_Prices
UNION ALL
SELECT 'Total_Number_Low' AS Measure_Name, COUNT(DISTINCT Low) AS Measure_Value FROM Stock.Stock_Prices
UNION ALL
SELECT 'Total_Number_Symbol' AS Measure_Name, COUNT( Symbol) AS Measure_Value FROM Stock.Stock_Prices

--Find total volume by symbol
SELECT 
	Symbol,
	SUM(volume) AS Total_symbol,
	ROUND(AVG(volume), 2) AS Avg_symbol
FROM Stock.Stock_Prices
GROUP BY Symbol 
ORDER BY Total_symbol DESC



