USE FERRETERIAS2
GO
-- VIEW 1
CREATE VIEW VW_ARTICULOS AS
SELECT
    -- ARTICULOS
    A.ARTID, A.ARTNOMBRE, A.ARTDESCRIPCION, A.ARTPRECIO,
    -- FAMILIAS
    F.FAMID, F.FAMNOMBRE, F.FAMDESCRIPCION
FROM ARTICULOS A
INNER JOIN FAMILIAS F ON A.FAMID = F.FAMID
GO

-- VIEW 2
CREATE VIEW VW_CLIENTES AS
SELECT
    -- CLIENTES
    C.CTEID, C.CTENOMBRE, C.CTEAPEPAT, C.CTEAPEMAT, C.CTEDOM, C.CTETEL, C.CTECEL, C.CTERFC, C.CTECURP, C.CTEFECHANACIMIENTO, C.CTESEXO,
    -- COLONIAS
    CO.COLID, CO.COLNOMBRE, CO.COLCP,
    -- MUNICIPIOS
    M.MUNID, M.MUNNOMBRE
FROM CLIENTES C
INNER JOIN COLONIAS CO ON C.COLID = CO.COLID
INNER JOIN MUNICIPIOS M ON CO.MUNID = M.MUNID
GO
--VIEW 3
CREATE VIEW VW_EMPLEADOS AS
SELECT E.EMPID, E.EMPNOMBRE, E.EMPAPEPAT, E.EMPAPEMAT, E.EMPDOM, E.EMPTEL, E.EMPCEL, E.EMPFECHAINGRESO, E.EMPFECHANACIMIENTO,
Z.ZONAID, Z.ZONANOMBRE
FROM EMPLEADOS E
INNER JOIN ZONAS Z ON E.ZONAID = Z.ZONAID;

--VIEW 4
CREATE VIEW VW_VENTAS AS
SELECT V.VTEFOLIO, V.VTEFECHA,
F.FERRID, F.FERRNOMBRE, F.FERRDOMICILIO, F.FERRTEL,
VE.*,
VC.*
FROM VENTAS V
INNER JOIN FERRETERIA F ON V.FERRID = F.FERRID
INNER JOIN VW_EMPLEADOS VE ON V.EMPID = VE.EMPID
INNER JOIN VW_CLIENTES VC ON V.CTEID = V.CTEID 


--VIEW 5 
CREATE VIEW VW_DETALLES AS
SELECT D.DETCANTIDAD, D.DETPRECIO,
VA.*,
VV.*
FROM DETALLES D
INNER JOIN VW_ARTICULOS VA ON D.ARTID = VA.ARTID
INNER JOIN VW_VENTAS VV ON D.VTEFOLIO = VV.VTEFOLIO

DROP VIEW VW_PRODUCTOS
DROP VIEW VW_CLIENTES
DROP VIEW VW_EMPLEADOS
DROP VIEW VW_VENTAS
DROP VIEW VW_DETALLES


SELECT * FROM VW_DETALLES