/* Checking Null Values */

Select * from superstoredb.dbo.superstore
WHERE OrderID IS NULL

Select * from superstoredb.dbo.superstore
WHERE OrderDate IS NULL

Select * from superstoredb.dbo.superstore
WHERE ShipmentDate IS NULL

Select * from superstoredb.dbo.superstore
WHERE ShipMode IS NULL

Select * from superstoredb.dbo.superstore
WHERE CustomerID IS NULL

Select * from superstoredb.dbo.superstore
WHERE CustomerName IS NULL

Select * from superstoredb.dbo.superstore
WHERE Segment IS NULL


Select * from superstoredb.dbo.superstore
WHERE Country IS NULL

Select * from superstoredb.dbo.superstore
WHERE City IS NULL

Select * from superstoredb.dbo.superstore
WHERE [State] IS NULL

Select * from superstoredb.dbo.superstore
WHERE PostalCode IS NULL

Select * from superstoredb.dbo.superstore
WHERE Region IS NULL

Select * from superstoredb.dbo.superstore
WHERE ProductID IS NULL

Select * from superstoredb.dbo.superstore
WHERE Category IS NULL

Select * from superstoredb.dbo.superstore
WHERE Sub_Category IS NULL

Select * from superstoredb.dbo.superstore
WHERE ProductName IS NULL

Select * from superstoredb.dbo.superstore
WHERE Sales IS NULL

Select * from superstoredb.dbo.superstore
WHERE Quantity IS NULL

Select * from superstoredb.dbo.superstore
WHERE Discount IS NULL

Select * from superstoredb.dbo.superstore
WHERE Profit IS NULL

/* Remove Duplicates 1 row  and Copy */
Select DISTINCT * into newSuperstore from superstoredb.dbo.superstore

/* Checking Type */
SELECT 
TABLE_CATALOG,
TABLE_SCHEMA,
COLUMN_NAME, 
DATA_TYPE,
TABLE_NAME 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'newSuperstore'


SELECT *, YEAR(OrderDate) OrderYear, DATEDIFF(day, OrderDate, ShipmentDate) DayDiff FROM newSuperstore  




 




Select DISTINCT * into UpdatednewSuperstore from newSuperstore

select sales from UpdatednewSuperstore
order by sales desc

select *  from newSuperstore

Select sales from newSuperstore
order by sales desc

Select Count(sales) from newSuperstore

Select Count(sales) from newSuperstore
where sales > 957

Select Count(sales) from UpdatednewSuperstore
where sales > 957




UPDATE UpdatednewSuperstore
SET Sales = 
    CASE
        WHEN Sales < (SELECT top 1 PERCENTILE_CONT(0.05) WITHIN GROUP (ORDER BY Sales) OVER ()  FROM UpdatednewSuperstore) THEN (SELECT top 1 PERCENTILE_CONT(0.05) WITHIN GROUP (ORDER BY Sales) OVER () FROM UpdatednewSuperstore)
        WHEN Sales > (SELECT top 1 PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY Sales) OVER ()  FROM UpdatednewSuperstore) THEN (SELECT top 1 PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY Sales) OVER () FROM UpdatednewSuperstore)
        ELSE Sales
    END;

UPDATE UpdatednewSuperstore
SET Quantity = 
    CASE
        WHEN Quantity < (SELECT top 1 PERCENTILE_CONT(0.05) WITHIN GROUP (ORDER BY Quantity) OVER ()  FROM UpdatednewSuperstore) THEN (SELECT top 1 PERCENTILE_CONT(0.05) WITHIN GROUP (ORDER BY Quantity) OVER () FROM UpdatednewSuperstore)
        WHEN Quantity > (SELECT top 1 PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY Quantity) OVER ()  FROM UpdatednewSuperstore) THEN (SELECT top 1 PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY Quantity) OVER () FROM UpdatednewSuperstore)
        ELSE Quantity
    END;

select Quantity from newSuperstore
order by  Quantity desc


select Quantity from UpdatednewSuperstore
order by Quantity desc


UPDATE UpdatednewSuperstore
SET Profit = 
    CASE
        WHEN Profit < (SELECT top 1 PERCENTILE_CONT(0.05) WITHIN GROUP (ORDER BY Profit) OVER ()  FROM UpdatednewSuperstore) THEN (SELECT top 1 PERCENTILE_CONT(0.05) WITHIN GROUP (ORDER BY Profit) OVER () FROM UpdatednewSuperstore)
        WHEN Profit > (SELECT top 1 PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY Profit) OVER ()  FROM UpdatednewSuperstore) THEN (SELECT top 1 PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY Profit) OVER () FROM UpdatednewSuperstore)
        ELSE Profit
    END;


select Profit from newSuperstore
order by  Profit desc


select Profit from UpdatednewSuperstore
order by Profit desc

Select * FROM UpdatednewSuperstore
order by Sales desc, Quantity desc, Profit desc 

Alter TABLE UpdatednewSuperstore
ADD  ThisOrdersDayDiff  int

select * from UpdatednewSuperstore

Update UpdatednewSuperstore
SET ThisOrdersDayDiff = DATEDIFF(DAY,OrderDate,ShipmentDate)

Alter TABLE UpdatednewSuperstore
ADD  OrderYear  int

Update UpdatednewSuperstore
SET OrderYear = YEAR(OrderDate)

select * from UpdatednewSuperstore

Alter table UpdatednewSuperstore
Add Revenue int

Update UpdatednewSuperstore
Set Revenue = Sales - ((Sales*Discount) / 100)

Select CustomerID, Segment ,MIN(OrderDate) FirstOrder, MAX(OrderDate) LastOrder, DATEDIFF(DAY,MIN(OrderDate),'01.01.2018') Tenure, DATEDIFF(DAY,MAX(OrderDate),'01.01.2018') Recency,
COUNT(Distinct OrderID) Frequency , SUM(Revenue) Monetary ,
AVG(Revenue) AvgMonetary, Sum(Quantity) Quantity , AVG(Quantity) AvgQuantity 
SUM(Revenue) / Sum(Quantity) UnitPrice
from UpdatednewSuperstore
Group By CustomerID

select * from superstorerfm

DROP TABLE superstorerfm

SELECT CustomerID,
    COUNT(Quantity) AS BasketSize,
    DATEDIFF(DAY,MAX(OrderDate),'01.01.2018') AS Recency,
    DATEDIFF(DAY,MIN(OrderDate),'01.01.2018') AS Tenure,
    DATEDIFF(MONTH,MIN(OrderDate),'01.01.2018') AS TenureInMonths,

    COUNT(DISTINCT OrderID) AS Frequency,
    CAST(SUM(Quantity*UnitPrice)AS INT) AS Monetary,
        NULL RecencyScore,
        NULL FrequencyScore,
        NULL MonetaryScore
INTO SuperstoreRFM
FROM UpdatednewSuperstore
GROUP BY CustomerID



UPDATE superstorerfm SET RecencyScore = 
(
 SELECT SCORE FROM
 (
    SELECT hw.* , NTILE(5) OVER(ORDER BY RECENCY DESC) AS SCORE
    FROM superstorerfm AS hw
 ) T
    WHERE T.CustomerID = superstorerfm.CustomerID
)



-- FREQUENCY_SCORE HAS CALCULATED

UPDATE superstorerfm SET FrequencyScore = 
(
 SELECT SCORE FROM
 (
    SELECT hw.* , NTILE(5) OVER(ORDER BY FREQUENCY) AS SCORE
    FROM superstorerfm AS hw
 ) T
    WHERE T.CustomerID = superstorerfm.CustomerID
)


UPDATE superstorerfm SET MonetaryScore = 
(
 SELECT SCORE FROM
 (
    SELECT hw.* , NTILE(5) OVER(ORDER BY MONETARY) AS SCORE
    FROM superstorerfm AS hw
 ) T
    WHERE T.CustomerID = superstorerfm.CustomerID
)

select * from SuperstoreRFM

ALTER TABLE SuperstoreRFM ADD RF_SCORE AS (CONVERT(VARCHAR,RecencyScore) + CONVERT(VARCHAR,FrequencyScore) ) 

ALTER TABLE SuperstoreRFM ADD RFM_SCORE AS (CONVERT(VARCHAR,RecencyScore) + CONVERT(VARCHAR,FrequencyScore) + CONVERT(VARCHAR,MonetaryScore)) 


ALTER TABLE SuperstoreRFM
DROP COLUMN FR_SCORE

ALTER TABLE SuperstoreRFM ADD SEGMENT VARCHAR(50)

UPDATE SuperstoreRFM SET SEGMENT = 'Hibernating'
WHERE RecencyScore LIKE '[1-2]%' AND FrequencyScore LIKE '[1-2]%'

UPDATE SuperstoreRFM SET SEGMENT = 'At Risk'
WHERE RecencyScore LIKE '[1-2]%' AND FrequencyScore LIKE '[3-4]%'

UPDATE SuperstoreRFM SET SEGMENT = 'Can Not Lose'
WHERE RecencyScore LIKE '[1-2]%' AND FrequencyScore LIKE '[5]%'

UPDATE SuperstoreRFM SET SEGMENT = 'About To Sleep'
WHERE RecencyScore LIKE '[3]%' AND FrequencyScore LIKE '[1-2]%'

UPDATE SuperstoreRFM SET SEGMENT = 'Need Attention'
WHERE RecencyScore LIKE '[3]%' AND FrequencyScore LIKE '[3]%'

UPDATE SuperstoreRFM SET SEGMENT = 'Loyal Customers'
WHERE RecencyScore LIKE '[3-4]%' AND FrequencyScore LIKE '[4-5]%'

UPDATE SuperstoreRFM SET SEGMENT = 'Promising'
WHERE RecencyScore LIKE '[4]%' AND FrequencyScore LIKE '[1]%'

UPDATE SuperstoreRFM SET SEGMENT = 'New Customers'
WHERE RecencyScore LIKE '[5]%' AND FrequencyScore LIKE '[1]%'

UPDATE SuperstoreRFM SET SEGMENT = 'Potential Loyalists'
WHERE RecencyScore LIKE '[4-5]%' AND FrequencyScore LIKE '[2-3]%'

UPDATE SuperstoreRFM SET SEGMENT = 'Champions'
WHERE RecencyScore LIKE '[5]%' AND FrequencyScore LIKE '[4-5]%' 

SELECT * FROM SuperstoreRFM

Select *, USS.ProductName, USS.City, USS.Region, USS.Segment, 
USS.Category, USS.ShipMode, USS.Sub_Category, USS.Country, USS.CustomerName, USS.[State] from SuperstoreRFM SRFM right Join UpdatednewSuperstore USS On SRFM.CustomerID = USS.CustomerID

SELECT SEGMENT,COUNT(SEGMENT) SegmentCount ,ROUND(AVG(Tenure),0) TENURE, ROUND(AVG(Recency),0) RECENCY, ROUND(AVG(Frequency),0) FREQUENCY ,ROUND(AVG(Monetary),0) AVG_MONETARY, ROUND(SUM(Monetary),0) TOTAL_MONETARY ,ROUND(AVG(BasketSize),0) BASKET_SIZE
FROM SuperstoreRFM 
GROUP BY SEGMENT


/* SQL FOR INSIGHTS */ 

/*Segmente göre değerler*/
SELECT SRFM.SEGMENT, COUNT(DISTINCT uss.CustomerID) SegmentCount ,ROUND(AVG(Tenure),0) TENURE, ROUND(AVG(Recency),0) RECENCY, ROUND(AVG(Frequency),0) FREQUENCY ,ROUND(AVG(Monetary),0) AVG_MONETARY, 
ROUND(SUM(Monetary),0) TOTAL_MONETARY ,ROUND(AVG(BasketSize),0) BASKET_SIZE, AVG(USS.Sales) AVG_SALES, AVG(USS.Profit) AVG_PROFIT,
SUM(USS.Sales) TOTAL_SALES, SUM(USS.Profit) TOTAL_PROFIT
FROM SuperstoreRFM SRFM LEFT JOIN UpdatednewSuperstore USS ON SRFM.CustomerID  = USS.CustomerID
GROUP BY SRFM.SEGMENT 


/*Şehre göre Satış*/
SELECT City,ROUND(AVG(Monetary),0) AVG_MONETARY, ROUND(SUM(Monetary),0) TOTAL_MONETARY,ROUND(AVG(BasketSize),0) BASKET_SIZE, 
AVG(USS.Sales) AVG_SALES, AVG(USS.Profit) AVG_PROFIT, SUM(USS.Sales) TOTAL_SALES, SUM(USS.Profit) TOTAL_PROFIT
FROM SuperstoreRFM SRFM LEFT JOIN UpdatednewSuperstore USS ON SRFM.CustomerID = USS.CustomerID
GROUP BY City
ORDER BY TOTAL_SALES DESC

/*Bölgeye göre satış*/
SELECT USS.Region,ROUND(AVG(Monetary),0) AVG_MONETARY, ROUND(SUM(Monetary),0) TOTAL_MONETARY,ROUND(AVG(BasketSize),0) BASKET_SIZE, 
AVG(USS.Sales) AVG_SALES, AVG(USS.Profit) AVG_PROFIT, SUM(USS.Sales) TOTAL_SALES, SUM(USS.Profit) TOTAL_PROFIT
FROM SuperstoreRFM SRFM LEFT JOIN UpdatednewSuperstore USS ON SRFM.CustomerID = USS.CustomerID
GROUP BY USS.Region
ORDER BY TOTAL_SALES DESC  


/*Aya göre satış*/
SELECT MONTH(USS.OrderDate) AY,ROUND(AVG(Monetary),0) AVG_MONETARY, ROUND(SUM(Monetary),0) TOTAL_MONETARY,ROUND(AVG(BasketSize),0) BASKET_SIZE, 
AVG(USS.Sales) AVG_SALES, AVG(USS.Profit) AVG_PROFIT, SUM(USS.Sales) TOTAL_SALES, SUM(USS.Profit) TOTAL_PROFIT
FROM SuperstoreRFM SRFM LEFT JOIN UpdatednewSuperstore USS ON SRFM.CustomerID = USS.CustomerID
GROUP BY MONTH(USS.OrderDate)
ORDER BY TOTAL_SALES DESC



/*Mevsime göre satış*/
SELECT T1.MEVSIM AY,ROUND(AVG(T1.AVG_MONETARY),0) AVG_MONETARY, ROUND(SUM(T1.TOTAL_MONETARY),0) TOTAL_MONETARY,ROUND(AVG(T1.BASKET_SIZE),0) BASKET_SIZE, 
AVG(T1.AVG_SALES) AVG_SALES, AVG(T1.AVG_PROFIT) AVG_PROFIT, SUM(T1.TOTAL_SALES) TOTAL_SALES, SUM(T1.TOTAL_PROFIT) TOTAL_PROFIT FROM
(SELECT MONTH(USS.OrderDate) AY,ROUND(AVG(Monetary),0) AVG_MONETARY, ROUND(SUM(Monetary),0) TOTAL_MONETARY,ROUND(AVG(BasketSize),0) BASKET_SIZE, 
AVG(USS.Sales) AVG_SALES, AVG(USS.Profit) AVG_PROFIT, SUM(USS.Sales) TOTAL_SALES, SUM(USS.Profit) TOTAL_PROFIT,
CASE
   WHEN MONTH(USS.OrderDate) IN (12,1,2) THEN 'KIS'
   WHEN MONTH(USS.OrderDate) IN (3,4,5) THEN 'ILKBAHAR'
   WHEN MONTH(USS.OrderDate) IN (6,7,8) THEN 'YAZ'
   ELSE'SONBAHAR'
 END AS MEVSIM
FROM SuperstoreRFM SRFM LEFT JOIN UpdatednewSuperstore USS ON SRFM.CustomerID = USS.CustomerID
GROUP BY MONTH(USS.OrderDate)
) T1
GROUP BY T1.MEVSIM
ORDER BY SUM(T1.TOTAL_SALES) DESC


/*En çok satanlar (miktar)*/
SELECT ProductName,USS.Quantity,ROUND(AVG(Monetary),0) AVG_MONETARY, ROUND(SUM(Monetary),0) TOTAL_MONETARY,ROUND(AVG(BasketSize),0) BASKET_SIZE, 
AVG(USS.Sales) AVG_SALES, AVG(USS.Profit) AVG_PROFIT, SUM(USS.Sales) TOTAL_SALES, SUM(USS.Profit) TOTAL_PROFIT
FROM SuperstoreRFM SRFM LEFT JOIN UpdatednewSuperstore USS ON SRFM.CustomerID = USS.CustomerID
GROUP BY ProductName,USS.Quantity 
ORDER BY USS.Quantity DESC 

/*En çok satanlar (Fiyatlar)*/
SELECT ProductName, USS.Sales, USS.Discount ,(USS.Sales)-(USS.Sales*USS.Discount/100) Revenue  ,ROUND(AVG(Monetary),0) AVG_MONETARY, ROUND(SUM(Monetary),0) TOTAL_MONETARY,ROUND(AVG(BasketSize),0) BASKET_SIZE, 
AVG(USS.Sales) AVG_SALES, AVG(USS.Profit) AVG_PROFIT, SUM(USS.Sales) TOTAL_SALES, SUM(USS.Profit) TOTAL_PROFIT
FROM SuperstoreRFM SRFM LEFT JOIN UpdatednewSuperstore USS ON SRFM.CustomerID = USS.CustomerID
GROUP BY ProductName, USS.Sales, USS.Discount
ORDER BY  SUM(USS.Sales) DESC    
    


/*Ürünler

SELECT USS.ProductName ,COUNT(SRFM.SEGMENT) SegmentCount ,ROUND(AVG(Tenure),0) TENURE, ROUND(AVG(Recency),0) RECENCY, ROUND(AVG(Frequency),0) FREQUENCY ,ROUND(AVG(Monetary),0) AVG_MONETARY, 
ROUND(SUM(Monetary),0) TOTAL_MONETARY ,ROUND(AVG(BasketSize),0) BASKET_SIZE, AVG(USS.Sales) AVG_SALES, AVG(USS.Profit) AVG_PROFIT,
SUM(USS.Sales) TOTAL_SALES, SUM(USS.Profit) TOTAL_PROFIT
FROM SuperstoreRFM SRFM LEFT JOIN UpdatednewSuperstore USS ON SRFM.CustomerID  = USS.CustomerID
GROUP BY USS.ProductName  
*/





























