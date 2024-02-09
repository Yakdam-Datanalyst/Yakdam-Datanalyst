USE AdventureWorks2019

--Question 1
--Retrieve information about the products with colour values except null, red, silver/black, white and list price between
--£75 and £750. Rename the column StandardCost to Price. Also, sort the results in descending order by list price.

SELECT PRODUCTID,NAME,PRODUCTNUMBER,COLOR,LISTPRICE,PRODUCTLINE,StandardCost AS PRICE
FROM Production.Product
WHERE NOT COLOR IN ('NULL','RED','SILVER', 'BLACK', 'WHITE')
AND LISTPRICE BETWEEN 75 AND 750
ORDER BY LISTPRICE DESC;

--Question 2
--Find all the male employees born between 1962 to 1970 and with hire date greater than 2001 and 
--female employees born between 1972 and 1975 and hire date between 2001 and 2002.

SELECT*
FROM HUMANRESOURCES.EMPLOYEE
WHERE (GENDER = 'M' AND YEAR(BIRTHDATE) BETWEEN 1962 AND 1970 AND YEAR(HIREDATE)>2001)
OR (GENDER ='F' AND YEAR(BIRTHDATE) BETWEEN 1972 AND 1975 AND YEAR(HIREDATE) BETWEEN 2001 AND 2002);

--Question 3
--Create a list of 10 most expensive products that have a product number beginning with ‘BK’. 
--Include only the product ID, Name and colour.

SELECT TOP 10 PRODUCTID,NAME,COLOR
FROM PRODUCTION.PRODUCT
WHERE PRODUCTNUMBER LIKE 'BK%'
ORDER BY LISTPRICE DESC;

--Question 4
--Create a list of all contact persons, where the first 4 characters of the last name are the same as the first four characters of the email address.
--Also, for all contacts whose first name and the last name begin with the same characters, create a new column called full name combining first name and the last name only.
--Also provide the length of the new column full name.

SELECT 
    FirstName,
    LastName,
    PEA.EmailADDRESS,
    CASE WHEN LEFT(LastName, 4) = LEFT(EMAILADDRESS, 4) THEN 'Match' ELSE 'No Match' END AS LastNameEmailMatch,
    CASE WHEN LEFT(FirstName, 4) = LEFT(LastName, 4) THEN FirstName + ' ' + LastName ELSE NULL END AS FullName,
    CASE WHEN LEFT(FirstName, 4) = LEFT(LastName, 4) THEN LEN(FirstName + ' ' + LastName) ELSE NULL END AS FullNameLength
FROM 
    Person.Person AS PP
	INNER JOIN PERSON.EMAILADDRESS AS PEA
	ON PP.BUSINESSENTITYID = PEA.BUSINESSENTITYID
	ORDER BY FULLNAMELENGTH DESC;

--QUESTION 5
--Return all product subcategories that take an average of 3 days or longer to manufacture
	SELECT AVG(DAYSTOMANUFACTURE)AS AVGDAYSTOMANUFACTURE,PRODUCTSUBCATEGORYID
	FROM PRODUCTION.PRODUCT
	GROUP BY PRODUCTSUBCATEGORYID
	HAVING AVG(DAYSTOMANUFACTURE)>=3;

-- Question 6
--Create a list of product segmentation by defining criteria that places each item in a predefined segment as follows.
--If price gets less than £200 then low value. If price is between £201 and £750 then mid value. 
--If between £750 and £1250 then mid to high value else higher value.
--Filter the results only for black, silver and red color products.

SELECT PRODUCTID,NAME,COLOR,LISTPRICE,
CASE
WHEN LISTPRICE <200 THEN 'LOW VALUE'
WHEN LISTPRICE BETWEEN 201 AND 750 THEN 'MID VALUE'
WHEN LISTPRICE BETWEEN 750 AND 1250 THEN 'HIGH VALUE'
ELSE 'HIGHER VALUE'
END AS PRICESEGMENT
FROM PRODUCTION.PRODUCT
WHERE COLOR IN('BLACK', 'SILVER', 'RED');

--Question 7
--How many Distinct Job title is present in the Employee table?

SELECT DISTINCT COUNT(JOBTITLE)
FROM HUMANRESOURCES.EMPLOYEE;

-- Question 8
--Use employee table and calculate the ages of each employee at the time of hiring.

SELECT HRE.BUSINESSENTITYID, FIRSTNAME,LASTNAME,HIREDATE,
DATEDIFF(YEAR,BIRTHDATE,HIREDATE) AS AGEATHIRING
FROM HUMANRESOURCES.Employee AS HRE
INNER JOIN PERSON.PERSON AS PP
ON HRE.BUSINESSENTITYID = PP.BUSINESSENTITYID;

--Question 9
--How many employees will be due a long service award in the next 5 years, if long service is 20 years?

SELECT COUNT(*) AS employees_due_long_service_award
FROM Humanresources.Employee
WHERE DATEDIFF(YEAR,HIREDATE,DATEADD(YEAR, 5, '2024'))>= 20;

--Question 10
--How many more years does each employee have to work before reaching sentiment, if sentiment age is 65?

SELECT BUSINESSENTITYID, 
       DATEDIFF(YEAR, BIRTHDATE, '2024') AS Current_age,
       CASE
           WHEN DATEDIFF(YEAR, BIRTHDATE, '2024') >= 65 THEN 0
           ELSE 65 - DATEDIFF(YEAR, BIRTHDATE, '2024')
       END AS years_to_retirement
FROM Humanresources.Employee;

--Question 11
-- Implement new price policy on the product table base on the colour of the item. If white increase price by 8%,
--If yellow reduce price by 7.5%, If black increase price by 17.2%.
--If multi, silver, silver/black or blue take the square root of the price and double the value. 
--Column should be called Newprice. 
--For each item, also calculate commission as 37.5% of newly computed list price.

SELECT COLOR,LISTPRICE,
        CASE 
            WHEN Color = 'White' THEN ListPrice * 1.08
            WHEN Color = 'Yellow' THEN ListPrice * 0.925
            WHEN Color = 'Black' THEN ListPrice * 1.172
            WHEN Color IN ('Multi', 'Silver', 'Black', 'Blue') THEN SQRT(ListPrice) * 2
            WHEN Color IS NULL THEN ListPrice * 1
        END AS NEWLISTPRICE,
		CASE 
	WHEN Color = 'White' THEN ListPrice * 1.08 * 0.375
            WHEN Color = 'Yellow' THEN ListPrice * 0.925 * 0.375
            WHEN Color = 'Black' THEN ListPrice * 1.172 * 0.375
            WHEN Color IN ('Multi', 'Silver', 'Black', 'Blue') THEN SQRT(ListPrice) * 2 * 0.375
        END AS COMMISION
    FROM PRODUCTION.PRODUCT;

	
--Question 12
--Print the information about all the Sales.Person and their sales quota. 
--For every Sales person you should provide their FirstName, LastName, HireDate, SickLeaveHours and Region where they work.

SELECT FIRSTNAME, LASTNAME,HRE.HIREDATE,HRE.SICKLEAVEHOURS,
SSP.SALESQUOTA
FROM HUMANRESOURCES.EMPLOYEE AS HRE
INNER JOIN SALES.SALESPERSON AS SSP
ON HRE.BUSINESSENTITYID = SSP.BUSINESSENTITYID
INNER JOIN PERSON.PERSON AS PP
ON SSP.BUSINESSENTITYID = PP.BUSINESSENTITYID;

--Question 13
--Using adventure works, write a query to extract the following information.
--Product name,Product category name,Product subcategory name
--Sales person,Revenue,Month of transaction,Quarter of transaction,Region

SELECT PP.NAME AS PRODUCTNAME,PPC.NAME AS PRODUCTCATEGORYNAME,PPSC.NAME AS PRODUCTSUBCATEGORYNAME,
SSOH.SALESPERSONID,SSOH.ORDERDATE,
(SSOD.UNITPRICE*SSOD.ORDERQTY-SSOD.UNITPRICEDISCOUNT) AS REVENUE,
DATEPART(MM,SSOH.ORDERDATE)AS MONTHOFTRANSACTION,
DATEPART(QQ,SSOH.ORDERDATE) AS QUARTEROFTRANSACTION
FROM PRODUCTION.PRODUCT AS PP
INNER JOIN PRODUCTION.PRODUCTSUBCATEGORY AS PPSC
ON PP.PRODUCTSUBCATEGORYID =PPSC.PRODUCTSUBCATEGORYID
INNER JOIN PRODUCTION.PRODUCTCATEGORY AS PPC
ON PPSC.PRODUCTCATEGORYID = PPC.PRODUCTCATEGORYID
INNER JOIN SALES.SALESORDERDETAIL AS SSOD
ON PP.PRODUCTID = SSOD.PRODUCTID
INNER JOIN SALES.SALESORDERHEADER AS SSOH
ON SSOD.SALESORDERID = SSOH.SALESORDERID;

--Question 14
--Display the information about the details of an order i.e. order number, order date,
--amount of order, which customer gives the order and which salesman works for that customer
--and how much commission he gets for an order.

SELECT SOH.ORDERDATE,SALESORDERNUMBER,CUSTOMERID,SALESPERSONID,
SSP.COMMISSIONPCT,ORDERQTY
FROM SALES.SALESORDERHEADER AS SOH
INNER JOIN SALES.SALESORDERDETAIL AS SOD
ON SOH.SALESORDERID = SOD.SALESORDERID
INNER JOIN SALES.SALESPERSON AS SSP
ON SOH.TERRITORYID = SSP.TERRITORYID;

--Question 15
--For all the products calculate,Commission as 14.790% of standard cost,
-- Margin, if standard cost is increased or decreased as follows:
--Black: +22%,
--Red: -12%
--Silver: +15%
--Multi: +5%
--White: Two times original cost divided by the square root of cost For other colours, standard cost remains the same

SELECT
    StandardCost,PRODUCTID,NAME,COLOR,
    StandardCost * 0.1479 AS Commission, 
	CASE 
	WHEN COLOR = 'Black' THEN StandardCost * 1.22
        WHEN COLOR = 'Red' THEN StandardCost * 0.88
        WHEN COLOR = 'Silver' THEN StandardCost * 1.15
        WHEN COLOR = 'Multi' THEN StandardCost * 1.05
        WHEN COLOR = 'White' THEN (StandardCost * 2) / SQRT(StandardCost)
        ELSE StandardCost *1
    END AS MARGIN
FROM PRODUCTION.Product;

--Question 16
--Create a view to find out the top 5 most expensive products for each colour.

SELECT 
    Color,
    NAME,
    StandardCost
FROM (
    SELECT 
        Color,
        NAME,
        StandardCost,
        ROW_NUMBER() OVER (PARTITION BY Color ORDER BY StandardCost DESC) AS rn
    FROM PRODUCTION.Product
) ranked
WHERE rn <= 5;
