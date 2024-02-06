--- Management wants to make decisions on the various product lines used for production.
 -- As a new hired Data Analyst, they want you to pull only the unique product lines.
 --- Write a query for this

SELECT DISTINCT productline
FROM productlines ;

 You got an email from your line Manager requesting you to show information about the shipped orders made by the customer with customer number 103. 
--- Your result should have the following: customerNumber, orderNumber, orderDate and status.

SELECT customerNumber, orderNumber, orderDate, status
FROM orders
WHERE customerNumber = 103 ;

--- Our team is currently working on a project that requires identifying specific roles within the company. 
--- We need to retrieve employees who hold the job titles of either "Sales Rep" or "Marketing Manager." 
--- Would you be able to run the following SQL query for us?

SELECT *
FROM employees
WHERE jobTitle = 'Sales Rep'
OR jobTitle = "Marketing Manager" ;

--- As part of our data analysis and customer relationship management efforts, we would like to retrieve specific details to better serve our valued customers. 
--- Kindly show information about our customers who reside in USA and have a credit limit above $100,000. 
--- Your data should only contain contact last name contact first name and credit limit. Please share the data in ascending order based on the contact last names. 

Select contactLastName, contactFirstName, creditLimit
From customers
where country = "USA" 
AND creditLimit >100000 
Order by contactLastName ASC;

--- As a way to maximize resources, your company has requested that you pull up data showing the number of products produced using the various product lines.

SELECT productline, COUNT(productcode)
FROM products
GROUP BY productline;

--- Write an SQL query to calculate the total number of units sold for each product. Display the productName and the total number of units sold. 
--- Filter the results to include products with a total number of units sold greater than 500.

SELECT P.productName, sum(OD.quantityOrdered) as unit_sold
FROM orderdetails OD
JOIN products P
oN P.productCode = OD.productCode
GROUP BY OD.productCode
HAVING unit_sold >500;

--- How can you write the SQL code that generates order name, product name, msrp, price each for any product with code S10_1678 and where msrp is above price each.

SELECT P.productName, P.MSRP, OD.priceEach, OD.orderNumber, P.productCode
FROM products P
JOIN orderdetails OD
ON P.productCode = OD.productCode
WHERE P.productCode = "S10_1678"
HAVING P.MSRP > OD. priceEach;

--- List all offices and the total number of employees in each office

SELECT OfficeCode, count(employeeNumber) as total_number_of_employees
FROM employees
GROUP BY officeCode ;



