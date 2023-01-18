DROP TABLE IF EXISTS BigBasketProduct;
CREATE TABLE BigBasketProduct (
	indes SERIAL,
	product TEXT,
	category TEXT,
	sub_category TEXT,
	brand TEXT,
	sale_price DOUBLE PRECISION,
	market_price DOUBLE PRECISION,
	type TEXT,
	rating DOUBLE PRECISION,
	description TEXT
);

--Import the file
COPY BigBasketProduct
FROM 'C:\Users\nihar\Desktop\File\BigBasket Products.csv'
DELIMITER ','
CSV HEADER;

--View the dataset
SELECT *
FROM bigbasketproduct

--check the database size
SELECT pg_size_pretty(pg_database_size('Time Series Analysis'));

--check the table size
SELECT pg_size_pretty(pg_relation_size('bigbasketproduct'))

--check all the function in postgresql
SELECT routine_name 
FROM information_schema.routines 
WHERE routine_type='FUNCTION' 
  AND specific_schema='public'
  AND routine_name LIKE 'aliasmyfunctions%';
  
--view the total number of rows 
SELECT COUNT(*)
FROM bigbasketproduct

--view the number of columns of database
select table_name, count(*) as column_count 
from information_schema."columns"
where table_schema = 'public' 
GROUP by table_name order by column_count desc; 


--view the number columns in a table
SELECT COUNT(*) AS No_of_Column FROM information_schema.columns WHERE table_name ='bigbasketproduct';

--To know everything about table
SELECT table_schema, table_name, column_name, data_type 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE table_name = 'bigbasketproduct'

--view number distnict data in particular column
SELECT COUNT(DISTINCT product) AS DistnictProduct,
	   COUNT(DISTINCT category) AS DistnictCategory,
	   COUNT(DISTINCT sub_category) AS DistnictSubCategory,
	   COUNT(DISTINCT brand) AS DistnictBrand,
	   COUNT(DISTINCT type) AS DistnictType
FROM bigbasketproduct

--view distinct data of category column and sub_category column
SELECT DISTINCT category,sub_category
FROM bigbasketproduct
ORDER BY category 

--view the totalsaleprice of each product and sub_category product
SELECT category,sub_category,SUM(sale_price) AS TotalSalePrice
FROM bigbasketproduct
GROUP BY
	ROLLUP(
		category,
		sub_category
)
ORDER BY category

SELECT *
FROM bigbasketproduct
WHERE category IS NULL

--Check null values in each columns  (taken from stack overflow)
CREATE FUNCTION f_has_missing(_tbl regclass, _col text, OUT has_missing boolean)
  LANGUAGE plpgsql AS
$func$
BEGIN
   EXECUTE
   format($$SELECT EXISTS (SELECT FROM %s WHERE %2$I = '' OR %2$I IS NULL)$$, _tbl, _col)
   INTO has_missing;
END
$func$;

SELECT f_has_missing('bigbasketproduct', 'product');
SELECT f_has_missing('bigbasketproduct', 'category');
SELECT f_has_missing('bigbasketproduct', 'sub_category');
SELECT f_has_missing('bigbasketproduct', 'brand');
SELECT f_has_missing('bigbasketproduct', 'type');

SELECT *
FROM bigbasketproduct
WHERE product IS NULL

--delete null values
DELETE FROM bigbasketproduct
WHERE product IS NULL

--view the difference between market price and sale price of each product
SELECT product,sale_price-market_price AS ProfitOrLoss
FROM bigbasketproduct

--Filter 10 brand from which we are getting loss
SELECT brand,sale_price-market_price AS Loss
FROM bigbasketproduct
WHERE sale_price-market_price < 0
ORDER BY Loss 
LIMIT 10

--Filter top 10 sub_category from where we are getting loss
SELECT sub_category,sale_price-market_price AS Loss
FROM bigbasketproduct
WHERE sale_price-market_price < 0
ORDER BY Loss 
LIMIT 10

--Filter top 10 product,brand,category which has rating 5
SELECT product,
	   category,
	   sub_category,
	   brand,
	   rating
FROM bigbasketproduct
WHERE rating = 5
ORDER BY rating DESC
LIMIT 10

--view sub_category wise sales
SELECT sub_category,
	   SUM(sale_price) AS TotalSale
FROM bigbasketproduct
GROUP BY sub_category
HAVING SUM(sale_price) > 200000
ORDER BY TotalSale DESC

--finding duplicates
SELECT product,
       sub_category,
	   brand,
	   type,COUNT(*)
FROM bigbasketproduct
GROUP BY product,sub_category,brand,type
HAVING COUNT(*) > 1

--other method using row_number
SELECT *
FROM (
	SELECT product,
	sub_category,
	brand,
	type,
	ROW_NUMBER() OVER (PARTITION BY product,sub_category,brand,type) AS Row
	FROM bigbasketproduct
) dups
WHERE dups.Row > 1

SELECT *
FROM bigbasketproduct

--view top 10 product type
SELECT type,
	   SUM(sale_price) AS totalsale
FROM bigbasketproduct
GROUP BY type
ORDER BY totalsale DESC
LIMIT 20;






										 













						 
						 









