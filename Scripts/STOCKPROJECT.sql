CREATE DATABASE DATASET; ----- DataBase Creation
GO
USE DATASET;
GO
CREATE SCHEMA Stock; --- Schema Creation
GO

IF OBJECT_ID ('Stock_Price', 'U') IS NOT NULL ---- Table Creation 
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

BULK INSERT Stock_Price  --- Bulk Insert
FROM 'C:\Users\Japhary\Desktop\Data Analysis\Project\Data Set For Task\2) Stock Prices Data Set.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n',
	TABLOCK
	);
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
	ROUND(COALESCE(Stock_Open, High), 2) AS Stock_Open,
	ROUND(High, 2) AS Stock_High, -- Remain Two decimal point
	ROUND(Low, 2) AS Stock_Low, -- Remain Two decimal point
	ROUND (Stock_Close, 2) AS Stock_Close, -- Remain Two decimal point
	Volume
FROM Stock_Price
WHERE High IS NOT NULL 
  AND Low IS NOT NULL 
  AND High >= Low; 

