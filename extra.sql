USE Northwind
GO

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

SELECT vo.OrderID, vo.FirstName, vo.LastName, vo.CustomerID, vo.[Nombre Producto], vo.Quantity, vo.UnitPrice,
importe = isnull(sum(Quantity*UnitPrice),0)
FROM vw_orderdetails vo
group BY vo.OrderID, vo.FirstName
order by vo.OrderID asc

SELECT 
    o.OrderID,
    e.FirstName AS NombreEmpleado,
    e.LastName AS ApellidoEmpleado,
    p.ProductName AS NombreProducto,
    od.UnitPrice AS PrecioUnitario,
    od.Quantity AS Cantidad,
    (od.UnitPrice * od.Quantity) AS Importe
FROM Orders o
JOIN Employees e ON o.EmployeeID = e.EmployeeID
JOIN [Order Details] od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
ORDER BY e.FirstName;

select * from Orders


-- Crear vista
CREATE VIEW vw_CantidadOrdenesPorEmpleado AS
SELECT
    CONCAT(FirstName, ' ', LastName) AS Empleado,
    SUM(CASE WHEN E.EmployeeID BETWEEN 0 AND 100 THEN 1 ELSE 0 END) AS '0-100',
    SUM(CASE WHEN E.EmployeeID BETWEEN 101 AND 200 THEN 1 ELSE 0 END) AS '101-200',
    SUM(CASE WHEN E.EmployeeID BETWEEN 201 AND 300 THEN 1 ELSE 0 END) AS '201-300',
    SUM(CASE WHEN E.EmployeeID BETWEEN 301 AND 400 THEN 1 ELSE 0 END) AS '301-400',
    SUM(CASE WHEN E.EmployeeID >= 401 THEN 1 ELSE 0 END) AS '+401'
FROM Employees E
LEFT JOIN Orders O ON E.EmployeeID = O.EmployeeID
GROUP BY E.EmployeeID, FirstName, LastName;

SELECT * FROM vw_CantidadOrdenesPorEmpleado


SELECT
    Empleado,
    SUM(CASE WHEN ordenes BETWEEN 0 AND 100 THEN ordenes ELSE 0 END) '0 - 100'
	--SUM(CASE WHEN ordenes BETWEEN 101 AND 200 THEN ordenes ELSE 0 END) AS '101-200',
   -- SUM(CASE WHEN ordenes BETWEEN 201 AND 300 THEN ordenes ELSE 0 END) AS '201-300',
    --SUM(CASE WHEN ordenes BETWEEN 301 AND 400 THEN ordenes ELSE 0 END) AS '301-400',
    --SUM(CASE WHEN ordenes >= 401 THEN ordenes ELSE 0 END) AS '+401'
FROM (
    SELECT
        E.FirstName + ' ' + E.LastName AS Empleado,
        COUNT(O.OrderID) AS ordenes
    FROM Employees E
    INNER JOIN Orders O ON E.EmployeeID = O.EmployeeID
    GROUP BY E.FirstName + ' ' + E.LastName
) AS suma_ordenes
GROUP BY Empleado
GO


drop VW_ORDENESXEM

-- Crear vista
-- Crear vista
CREATE VIEW VistaCantidadOrdenesPorImporte3 AS
SELECT
    CONCAT(E.FirstName, ' ', E.LastName) AS NombreEmpleado,
    SUM(CASE WHEN TotalImporte BETWEEN 0 AND 100 THEN 1 ELSE 0 END) AS '0-100',
    SUM(CASE WHEN TotalImporte BETWEEN 101 AND 200 THEN 1 ELSE 0 END) AS '101-200',
    SUM(CASE WHEN TotalImporte BETWEEN 201 AND 300 THEN 1 ELSE 0 END) AS '201-300',
    SUM(CASE WHEN TotalImporte BETWEEN 301 AND 400 THEN 1 ELSE 0 END) AS '301-400',
    SUM(CASE WHEN TotalImporte >= 401 THEN 1 ELSE 0 END) AS '+401'
FROM (
    SELECT
        CONCAT(E.FirstName, ' ', E.LastName) AS NombreEmpleado,
        COUNT(OD.OrderID) AS CantidadOrdenes,
        SUM(OD.UnitPrice * OD.Quantity) AS TotalImporte
    FROM vw_orderdetails OD
    JOIN vw_employeeterritories ET ON OD.EmployeeID = ET.EmployeeID
    JOIN vw_employeeterritories E ON ET.EmployeeID = E.EmployeeID
    GROUP BY E.FirstName, E.LastName, OD.OrderID
) AS OrdenesPorImporte
GROUP BY NombreEmpleado;


SELECT * FROM VistaCantidadOrdenesPorImporte3;


	 


-- Crear vista
CREATE VIEW VistaImporte AS
SELECT
    CONCAT(E.FirstName, ' ',E.LastName) AS Empleado,
    SUM(CASE WHEN TotalImporte BETWEEN 0 AND 100 THEN 1 ELSE 0 END) AS '0-100',
    SUM(CASE WHEN TotalImporte BETWEEN 101 AND 200 THEN 1 ELSE 0 END) AS '101-200',
    SUM(CASE WHEN TotalImporte BETWEEN 201 AND 300 THEN 1 ELSE 0 END) AS '201-300',
    SUM(CASE WHEN TotalImporte BETWEEN 301 AND 400 THEN 1 ELSE 0 END) AS '301-400',
    SUM(CASE WHEN TotalImporte >= 401 THEN 1 ELSE 0 END) AS '+401'
FROM (
    SELECT
        E.EmployeeID,
        E.FirstName,
        E.LastName,
        COUNT(O.OrderID) AS CantidadOrdenes,
        SUM(OD.UnitPrice * OD.Quantity) AS TotalImporte
    FROM Employees E
    LEFT JOIN Orders O ON E.EmployeeID = O.EmployeeID
    LEFT JOIN [Order Details] OD ON O.OrderID = OD.OrderID
    GROUP BY E.EmployeeID, E.FirstName, E.LastName
) AS EmpleadoOrdenes



SELECT * FROM VistaImporte
ORDER BY EmployeeID;