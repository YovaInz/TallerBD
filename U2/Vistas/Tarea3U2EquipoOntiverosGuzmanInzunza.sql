use northwind
go
-- view products
CREATE VIEW vw_products AS
SELECT 
P.ProductID, P.ProductName, P.QuantityPerUnit, 'Product Unit Price' = P.UnitPrice,
P.UnitsInStock, P.UnitsOnOrder, P.ReorderLevel, P.Discontinued,

S.SupplierID, S.CompanyName, S.ContactName, S.ContactTitle, S.Address, 
S.City, S.Region, 'Supplier Postal Code' = S.PostalCode, 'Supplier Country' = S.Country, S.Phone, 'Supplier Fax' = S.Fax, S.HomePage,

C.CategoryID, C.CategoryName, C.[Description], C.Picture

FROM Products P
INNER JOIN Suppliers S ON S.SupplierID = P.SupplierID
INNER JOIN Categories C ON C.CategoryID = P.CategoryID
GO
-- view orders
CREATE VIEW vw_orders AS
SELECT
O.OrderID, O.OrderDate, O.RequiredDate, O.ShippedDate, O.Freight, O.ShipName,
O.ShipAddress, O.ShipCity, O.ShipRegion, O.ShipPostalCode, O.ShipCountry,

E.EmployeeID, 'Employee Last Name' = E.LastName, 'Employee FirstName' = E.FirstName, E.Title, 
E.TitleOfCourtesy, E.BirthDate, E.HireDate, 'Employee Address' = E.Address,
'Employee City' = E.City, 'Employee Region' = E.Region, 'Employee Postal Code' = E.PostalCode, 
'Employee Country' = E.Country, E.HomePhone, E.Extension, E.Photo, E.Notes, E.ReportsTo, E.PhotoPath,

S.ShipperID, 'Shipper Company' = S.CompanyName, 'Shipper Phone' = S.Phone,

C.CustomerID, 'Customer Company' = C.CompanyName, 'Customer Contact Name' = C.ContactName, 
'Customer Contact Title' = C.ContactTitle, 'Customer Address' = C.Address,'Customer City' = C.City, 
'Customer Region' = C.Region, 'Customer Postal Code' = C.PostalCode, 'Customer Country' = C.Country, 
'Customer Phone' = C.Phone, 'Customer Fax' = C.Fax

FROM Orders O
INNER JOIN Employees E ON E.EmployeeID = O.EmployeeID
INNER JOIN Shippers S ON S.ShipperID = O.ShipVia
INNER JOIN Customers C ON C.CustomerID = O.CustomerID
GO

-- view order details ([ORDER DETAILS], vw_orders, vw_products)
CREATE VIEW vw_orderdetails AS
SELECT OD.UnitPrice, OD.Quantity, OD.Discount, VWO.*, VWP.*
FROM [Order Details] OD
INNER JOIN vw_products VWP ON VWP.ProductID = OD.ProductID
INNER JOIN vw_orders VWO ON VWO.OrderID = OD.OrderID
GO
-- Suplementarias
-- view territories (territories, region)
CREATE VIEW vw_territories AS
SELECT 
T.TerritoryID, T.TerritoryDescription,

R.RegionID, R.RegionDescription

FROM Territories T
INNER JOIN REGION R ON R.RegionID = T.RegionID
GO
-- view employeeterritories      (employeeterritories, vw_territories, employees)
CREATE VIEW vw_employeeterritories AS
SELECT 
ET.EmployeeID,

E.LastName, E.FirstName, E.Title, E.TitleOfCourtesy, E.BirthDate, E.HireDate, E.Address, E.City, E.Region, E.PostalCode,
E.Country, E.HomePhone, E.Extension, E.Photo, E.Notes, E.ReportsTo, E.PhotoPath,

VWT.*

FROM EmployeeTerritories ET
INNER JOIN vw_territories VWT ON VWT.TerritoryID = ET.TerritoryID
INNER JOIN Employees E ON E.EmployeeID = ET.EmployeeID
GO
select * from vw_orderdetails

select * from vw_territories
select * from vw_employeeterritories