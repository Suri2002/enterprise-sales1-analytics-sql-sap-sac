USE EnterpriseSalesOps2; 
GO
SET NOCOUNT ON;
GO

/* =========================================================
   1) DimDate � January 2025 (31 days)
========================================================= */
DECLARE @d DATE = '2025-01-01';
WHILE @d <= '2025-01-31'
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM ops.DimDate
        WHERE DateKey = CONVERT(INT, CONVERT(VARCHAR(8), @d, 112))
    )
    INSERT INTO ops.DimDate
    (DateKey, [Date], [Year], [Quarter], [Month], MonthName, [Day],
     DayOfWeek, DayName, IsWeekend)
    VALUES
    (
        CONVERT(INT, CONVERT(VARCHAR(8), @d, 112)),
        @d,
        YEAR(@d),
        DATEPART(QUARTER, @d),
        MONTH(@d),
        DATENAME(MONTH, @d),
        DAY(@d),
        DATEPART(WEEKDAY, @d),
        DATENAME(WEEKDAY, @d),
        CASE WHEN DATEPART(WEEKDAY, @d) IN (1,7) THEN 1 ELSE 0 END
    );
    SET @d = DATEADD(DAY, 1, @d);
END
GO

/* =========================================================
   2) Stores (4)
========================================================= */
IF NOT EXISTS (SELECT 1 FROM ops.DimStore WHERE StoreName='Phoenix Downtown')
INSERT INTO ops.DimStore VALUES ('Phoenix Downtown','Phoenix','AZ','West','2020-03-15');

IF NOT EXISTS (SELECT 1 FROM ops.DimStore WHERE StoreName='Tempe Central')
INSERT INTO ops.DimStore VALUES ('Tempe Central','Tempe','AZ','West','2021-06-01');

IF NOT EXISTS (SELECT 1 FROM ops.DimStore WHERE StoreName='Dallas North')
INSERT INTO ops.DimStore VALUES ('Dallas North','Dallas','TX','South','2019-09-10');

IF NOT EXISTS (SELECT 1 FROM ops.DimStore WHERE StoreName='Chicago Loop')
INSERT INTO ops.DimStore VALUES ('Chicago Loop','Chicago','IL','Midwest','2018-11-20');
GO

/* =========================================================
   3) Suppliers (4)
========================================================= */
IF NOT EXISTS (SELECT 1 FROM ops.DimSupplier WHERE SupplierName='Goodyear Manufacturing')
INSERT INTO ops.DimSupplier VALUES ('Goodyear Manufacturing','USA',7);

IF NOT EXISTS (SELECT 1 FROM ops.DimSupplier WHERE SupplierName='Michelin Corp')
INSERT INTO ops.DimSupplier VALUES ('Michelin Corp','France',10);

IF NOT EXISTS (SELECT 1 FROM ops.DimSupplier WHERE SupplierName='Bridgestone Ltd')
INSERT INTO ops.DimSupplier VALUES ('Bridgestone Ltd','Japan',12);

IF NOT EXISTS (SELECT 1 FROM ops.DimSupplier WHERE SupplierName='Continental AG')
INSERT INTO ops.DimSupplier VALUES ('Continental AG','Germany',14);
GO

/* =========================================================
   4) Products (5)
========================================================= */
DECLARE @SupGoodyear INT = (SELECT SupplierID FROM ops.DimSupplier WHERE SupplierName='Goodyear Manufacturing');
DECLARE @SupMichelin INT = (SELECT SupplierID FROM ops.DimSupplier WHERE SupplierName='Michelin Corp');
DECLARE @SupBridge   INT = (SELECT SupplierID FROM ops.DimSupplier WHERE SupplierName='Bridgestone Ltd');
DECLARE @SupConti    INT = (SELECT SupplierID FROM ops.DimSupplier WHERE SupplierName='Continental AG');

IF NOT EXISTS (SELECT 1 FROM ops.DimProduct WHERE SKU='TYR-001')
INSERT INTO ops.DimProduct VALUES ('TYR-001','All Season Tire','Tires','Goodyear',@SupGoodyear,60,95,1);

IF NOT EXISTS (SELECT 1 FROM ops.DimProduct WHERE SKU='TYR-002')
INSERT INTO ops.DimProduct VALUES ('TYR-002','Winter Grip Tire','Tires','Michelin',@SupMichelin,75,120,1);

IF NOT EXISTS (SELECT 1 FROM ops.DimProduct WHERE SKU='TYR-003')
INSERT INTO ops.DimProduct VALUES ('TYR-003','Performance Tire','Tires','Bridgestone',@SupBridge,90,150,1);

IF NOT EXISTS (SELECT 1 FROM ops.DimProduct WHERE SKU='TYR-004')
INSERT INTO ops.DimProduct VALUES ('TYR-004','Offroad Tire','Tires','Continental',@SupConti,110,180,1);

IF NOT EXISTS (SELECT 1 FROM ops.DimProduct WHERE SKU='ACC-001')
INSERT INTO ops.DimProduct VALUES ('ACC-001','Wheel Alignment','Service','InHouse',@SupConti,20,40,1);
GO

/* =========================================================
   5) Customers (10)
========================================================= */
WHILE (SELECT COUNT(*) FROM ops.DimCustomer) < 10
BEGIN
    DECLARE @n INT = (SELECT COUNT(*) FROM ops.DimCustomer) + 1;
    INSERT INTO ops.DimCustomer
    VALUES
    (
        'Customer'+CAST(@n AS VARCHAR),
        'User',
        'customer'+CAST(@n AS VARCHAR)+'@mail.com',
        '480555'+RIGHT('000'+CAST(@n AS VARCHAR),3),
        20250101
    );
END
GO

/* =========================================================
   6) Promotions (1)
========================================================= */
IF NOT EXISTS (SELECT 1 FROM ops.Promotions WHERE PromoName='Spring Sale')
INSERT INTO ops.Promotions VALUES ('Spring Sale',20250105,20250120,10);
GO

/* =========================================================
   7) FactSales � 500 rows (FAST, SET-BASED)
========================================================= */
DELETE FROM ops.FactSales;
GO

DECLARE @PromoID INT = (SELECT TOP 1 PromotionID FROM ops.Promotions);

;WITH N AS (
    SELECT TOP (500) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) n
    FROM sys.all_objects a CROSS JOIN sys.all_objects b
),
D AS (SELECT DateKey, ROW_NUMBER() OVER (ORDER BY DateKey) rn FROM ops.DimDate),
S AS (SELECT StoreID, ROW_NUMBER() OVER (ORDER BY StoreID) rn FROM ops.DimStore),
C AS (SELECT CustomerID, ROW_NUMBER() OVER (ORDER BY CustomerID) rn FROM ops.DimCustomer),
P AS (SELECT ProductID,ListPrice,StandardCost,ROW_NUMBER() OVER (ORDER BY ProductID) rn FROM ops.DimProduct)
INSERT INTO ops.FactSales
(DateKey,StoreID,CustomerID,ProductID,PromotionID,
 Quantity,UnitPrice,UnitCost,DiscountAmount,TaxAmount)
SELECT
    d.DateKey,
    s.StoreID,
    c.CustomerID,
    p.ProductID,
    CASE WHEN n.n % 4 = 0 THEN @PromoID ELSE NULL END,
    (n.n % 3) + 1,
    p.ListPrice,
    p.StandardCost,
    CASE WHEN n.n % 4 = 0 THEN ROUND((p.ListPrice*((n.n%3)+1))*0.10,2) ELSE 0 END,
    ROUND(((p.ListPrice*((n.n%3)+1)) -
         CASE WHEN n.n % 4 = 0 THEN (p.ListPrice*((n.n%3)+1))*0.10 ELSE 0 END) * 0.025,2)
FROM N n
JOIN D d ON d.rn = ((n.n-1)%31)+1
JOIN S s ON s.rn = ((n.n-1)%4)+1
JOIN C c ON c.rn = ((n.n-1)%10)+1
JOIN P p ON p.rn = ((n.n-1)%5)+1;
GO

/* =========================================================
   8) Inventory Snapshot � 20 rows
========================================================= */
DELETE FROM ops.FactInventoryDaily;

INSERT INTO ops.FactInventoryDaily
(DateKey,StoreID,ProductID,OnHandQty,ReorderPoint,SafetyStock)
SELECT 20250101, s.StoreID, p.ProductID, 100, 30, 20
FROM ops.DimStore s
CROSS JOIN ops.DimProduct p;
GO

/* =========================================================
   9) Final Validation
========================================================= */
SELECT
 (SELECT COUNT(*) FROM ops.DimDate) AS Dates,
 (SELECT COUNT(*) FROM ops.DimStore) AS Stores,
 (SELECT COUNT(*) FROM ops.DimSupplier) AS Suppliers,
 (SELECT COUNT(*) FROM ops.DimProduct) AS Products,
 (SELECT COUNT(*) FROM ops.DimCustomer) AS Customers,
 (SELECT COUNT(*) FROM ops.Promotions) AS Promos,
 (SELECT COUNT(*) FROM ops.FactSales) AS Sales,
 (SELECT COUNT(*) FROM ops.FactInventoryDaily) AS Inventory;
GO
