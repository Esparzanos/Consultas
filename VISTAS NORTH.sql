USE NORTHWIND 
GO
--vw_products--
CREATE VIEW vw_products AS.
SELECT
-- CATEGORIES
    C.CategoryID 'ID Categoria', C.CategoryName 'Nombre Categoria', C.Description 'Descripcion Categoria', C.Picture 'Imagen',
-- PRODUCTS
    P.ProductID 'ID Producto', P.ProductName 'Nombre Producto', P.QuantityPerUnit 'Cantidad x Unidad', P.UnitPrice 'Precio x Unidad', P.UnitsInStock 'Stock', P.ReorderLevel 'Reorder', P.Discontinued 'Discontinuado',
-- SUPPLIERS
    S.SupplierID 'ID Proveedor', S.CompanyName 'Nombre Compania', S.ContactName 'Nombre Contacto', S.ContactTitle 'Titulo Contacto', S.Address 'Proveedor Direccion', S.City 'Ciudad Proveedor', S.Region 'Region Proveedor', S.PostalCode 'CP Proveedor', S.Country 'Pais Proveedor', S.Phone 'Tel Proveedor', S.Fax 'Fax Proveedor', S.HomePage 'Page Proveedor'
FROM Products P
INNER JOIN Categories C ON P.CategoryID = C.CategoryID
INNER JOIN Suppliers S ON P.SupplierID = S.SupplierID
GO

--vw_orders--
CREATE VIEW vw_orders AS 
SELECT
-- ORDERS
    O.OrderID, O.OrderDate, O.RequiredDate, O.ShippedDate, O.Freight, O.ShipName, O.ShipAddress, O.ShipCity, O.ShipRegion, O.ShipPostalCode, O.ShipCountry,
-- EMPLOYEES
    E.EmployeeID, E.LastName, E.FirstName, E.Title, E.TitleOfCourtesy, E.BirthDate, E.HireDate, [Direccion] = E.Address, [Ciudad] = E.City, [Region Empleado] = E.Region, [Codigo Postal] = E.PostalCode, [Pais] = E.Country, E.HomePhone, E.Extension, E.Photo, E.Notes, E.ReportsTo, E.PhotoPath,
-- SHIPPERS
    S.ShipperID, [Compania Envio] = S.CompanyName,
-- CUSTOMERS
    C.CustomerID, C.CompanyName, C.ContactName, C.ContactTitle, C.Address, C.City, C.Region, C.PostalCode, C.Country, C.Phone, C.Fax
FROM Orders O
INNER JOIN Employees E on O.EmployeeID = E.EmployeeID
INNER JOIN Customers C on O.CustomerID = C.CustomerID
INNER JOIN Shippers S on O.ShipVia = S.ShipperID
GO

--vw_orderdetails--
CREATE VIEW vw_orderdetails AS
SELECT
-- ORDER DETAILS
    OD.UnitPrice, OD.Quantity, OD.Discount,
-- VW_ORDERS
    O.*,
-- VW_PRODUCTS
    P.*
FROM [Order Details] OD
INNER JOIN vw_orders O ON OD.OrderID = O.OrderID
INNER JOIN vw_products P ON OD.ProductID = P.[ID Producto]
GO

--SUPLEMENTARIAS--

--vw_territories--
CREATE VIEW vw_territories AS
SELECT 
	--TERRITORY
    t.TerritoryID, t.TerritoryDescription, 
	--REGION
    r.RegionID, r.RegionDescription
FROM territories t
INNER JOIN region r ON t.RegionID = r.RegionID
GO

--vw_employeeterritories--
CREATE VIEW vw_employeeterritories AS
SELECT 
	--EMPLOYEETERRITORIES
	et.TerritoryID, et.EmployeeID,
	--VW_TERRITORIES
	t.TerritoryDescription, t.RegionID, t.RegionDescription,
	--EMPLOYEE
    E.LastName, E.FirstName, E.Title, E.TitleOfCourtesy, E.BirthDate, E.HireDate, [Direccion] = E.Address, [Ciudad] = E.City, [Region Empleado] = E.Region, [Codigo Postal] = E.PostalCode, [Pais] = E.Country, E.HomePhone, E.Extension, E.Photo, E.Notes, E.ReportsTo, E.PhotoPath
FROM employeeterritories et
INNER JOIN vw_territories t ON et.TerritoryID = t.TerritoryID
INNER JOIN employees E ON et.EmployeeID = E.EmployeeID
GO

-- Crear vista
CREATE VIEW VistaCantidadOrdenesPorImporte AS
SELECT
    E.FirstName AS Nombre,
    E.LastName AS Apellido,
    SUM(CASE WHEN OD.UnitPrice * OD.Quantity BETWEEN 0 AND 100 THEN 1 ELSE 0 END) AS '0-100',
    SUM(CASE WHEN OD.UnitPrice * OD.Quantity BETWEEN 101 AND 200 THEN 1 ELSE 0 END) AS '101-200',
    SUM(CASE WHEN OD.UnitPrice * OD.Quantity BETWEEN 201 AND 300 THEN 1 ELSE 0 END) AS '201-300',
    SUM(CASE WHEN OD.UnitPrice * OD.Quantity BETWEEN 301 AND 400 THEN 1 ELSE 0 END) AS '301-400',
    SUM(CASE WHEN OD.UnitPrice * OD.Quantity >= 401 THEN 1 ELSE 0 END) AS '+401'
FROM vw_employeeterritories ET
JOIN vw_employeeterritories E ON ET.EmployeeID = E.EmployeeID
JOIN vw_orderdetails OD ON ET.EmployeeID = OD.EmployeeID
GROUP BY E.FirstName, E.LastName;

SELECT * FROM VistaCantidadOrdenesPorImporte;


DROP VIEW vw_orderdetails
GO
DROP VIEW vw_orders
GO
DROP VIEW vw_products
GO
DROP VIEW vw_territories
GO
DROP VIEW vw_employeeterritories
GO