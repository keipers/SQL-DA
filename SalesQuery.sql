/*Dataset: The House Property Sales dataset on Kaggle contains a file named ‘raw_sales.csv.’ It includes the following variables:

Datesold: The date when an owner sold the house to a buyer.

Postcode: 4 digit postcode of the suburb where the owner sold the property

Price: Price for which the owner sold the property.

Bedrooms: Number of bedrooms*/


/*Which date corresponds to the highest number of sales?*/

SELECT TOP 1 datesold, COUNT(datesold) as NumSold
FROM Sales
GROUP BY datesold
ORDER BY NumSold DESC;


/* Find out the postcode with the highest average price per sale? (Using Aggregate Functions) */

SELECT TOP 1 postcode, AVG(price) as AvgP
FROM Sales
GROUP BY postcode
Order BY AvgP DESC;

/* Which year witnessed the lowest number of sales? */

SELECT TOP 1 DATEPART(YEAR, datesold) as SoldYear, COUNT(datesold) as NumSold
FROM Sales
GROUP BY DATEPART(YEAR, datesold)
ORDER BY NumSold ASC;

/* Use the window function to deduce the top six postcodes by year's price.  */

SELECT * FROM (SELECT DATEPART(YEAR, datesold) as SoldYear, postcode, SUM(price) AS TotalSales,
			RANK() OVER (PARTITION BY
								 DATEPART(YEAR, datesold)
								ORDER BY SUM(price)
							) pricerank
FROM Sales
GROUP BY postcode, DATEPART(YEAR, datesold) ) t
WHERE pricerank <= 6;
	
				
			





