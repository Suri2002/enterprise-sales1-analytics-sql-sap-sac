--- Ensure DimDate Has 2024-01-01 to 2025-12-31---
DECLARE @StartDate date = '2024-01-01';
DECLARE @EndDate   date = '2025-12-31';

;WITH N AS (
    SELECT TOP (DATEDIFF(DAY, @StartDate, @EndDate) + 1)
           ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1 AS n
    FROM master..spt_values a
    CROSS JOIN master..spt_values b
),
D AS (
    SELECT DATEADD(DAY, n, @StartDate) AS [Date]
    FROM N
)
INSERT INTO ops.DimDate
(DateKey, [Date], [Year], [Quarter], [Month], MonthName, [Day],
 DayOfWeek, DayName, IsWeekend)
SELECT
    CONVERT(int, CONVERT(varchar(8), d.[Date], 112)) AS DateKey,
    d.[Date],
    YEAR(d.[Date]) AS [Year],
    DATEPART(QUARTER, d.[Date]) AS [Quarter],
    MONTH(d.[Date]) AS [Month],
    DATENAME(MONTH, d.[Date]) AS MonthName,
    DAY(d.[Date]) AS [Day],
    DATEPART(WEEKDAY, d.[Date]) AS DayOfWeek,
    DATENAME(WEEKDAY, d.[Date]) AS DayName,
    CASE WHEN DATEPART(WEEKDAY, d.[Date]) IN (1,7) THEN 1 ELSE 0 END AS IsWeekend
FROM D d
WHERE NOT EXISTS (
    SELECT 1
    FROM ops.DimDate dd
    WHERE dd.DateKey = CONVERT(int, CONVERT(varchar(8), d.[Date], 112))
);
GO

-- Validate date coverage
SELECT MIN([Date]) AS MinDate, MAX([Date]) AS MaxDate, COUNT(*) AS DateRows
FROM ops.DimDate;
GO

---Generate 24 months of FactSales---

DECLARE @StartDate date = '2024-01-01';
DECLARE @EndDate   date = '2025-12-31';

-- Safety checks (must exist due to FK constraints)
IF NOT EXISTS (SELECT 1 FROM ops.DimStore)    RAISERROR('DimStore is empty',16,1);
IF NOT EXISTS (SELECT 1 FROM ops.DimCustomer) RAISERROR('DimCustomer is empty',16,1);
IF NOT EXISTS (SELECT 1 FROM ops.DimProduct)  RAISERROR('DimProduct is empty',16,1);

;WITH Dates AS (
    SELECT DateKey, [Date], IsWeekend
    FROM ops.DimDate
    WHERE [Date] BETWEEN @StartDate AND @EndDate
),
-- Generate a small number of transactions per day:---
-- Weekdays: 3–6 rows/day, Weekends: 1–3 rows/day (approx)---
TxPerDay AS (
    SELECT
        d.DateKey,
        d.[Date],
        d.IsWeekend,
        CASE WHEN d.IsWeekend = 1
             THEN 1 + ABS(CHECKSUM(NEWID())) % 3   -- 1..3
             ELSE 3 + ABS(CHECKSUM(NEWID())) % 4   -- 3..6
        END AS TxCount
    FROM Dates d
),
-- Expand rows using a tally (1..TxCount per day)
Expanded AS (
    SELECT
        t.DateKey,
        t.[Date],
        ROW_NUMBER() OVER (PARTITION BY t.DateKey ORDER BY (SELECT NULL)) AS rn,
        t.TxCount
    FROM TxPerDay t
    JOIN (
        SELECT TOP (10) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
        FROM master..spt_values
    ) n
        ON n.n <= t.TxCount
),
-- Pick Store/Customer/Product deterministically but varied---
Picked AS (
    SELECT
        e.DateKey,
        e.[Date],
        s.StoreID,
        c.CustomerID,
        p.ProductID,

        -- Quantity 1..5
        1 + ABS(CHECKSUM(NEWID())) % 5 AS Quantity,

        -- Use product ListPrice/StandardCost with small random variation
        CAST(p.ListPrice * (0.95 + (ABS(CHECKSUM(NEWID())) % 11) / 100.0) AS decimal(12,2)) AS UnitPrice,
        CAST(p.StandardCost * (0.95 + (ABS(CHECKSUM(NEWID())) % 9) / 100.0) AS decimal(12,2)) AS UnitCost,

        -- Discount: 0 to 10% of unit price * qty (small realistic)
        CAST( (ABS(CHECKSUM(NEWID())) % 11) / 100.0 AS decimal(5,2)) AS DiscPct,

        -- Tax: 0–4% of (price*qty - discount)
        CAST( (ABS(CHECKSUM(NEWID())) % 5) / 100.0 AS decimal(5,2)) AS TaxPct

    FROM Expanded e
    CROSS APPLY (SELECT TOP 1 StoreID    FROM ops.DimStore    ORDER BY ABS(CHECKSUM(NEWID()))) s
    CROSS APPLY (SELECT TOP 1 CustomerID FROM ops.DimCustomer ORDER BY ABS(CHECKSUM(NEWID()))) c
    CROSS APPLY (SELECT TOP 1 ProductID, ListPrice, StandardCost
                 FROM ops.DimProduct
                 WHERE IsActive = 1
                 ORDER BY ABS(CHECKSUM(NEWID()))) p
)
INSERT INTO ops.FactSales
(DateKey, StoreID, CustomerID, ProductID, PromotionID,
 Quantity, UnitPrice, UnitCost, DiscountAmount, TaxAmount)
SELECT
    DateKey,
    StoreID,
    CustomerID,
    ProductID,
    NULL AS PromotionID,
    Quantity,
    UnitPrice,
    UnitCost,
    CAST((UnitPrice * Quantity) * DiscPct AS decimal(12,2)) AS DiscountAmount,
    CAST(((UnitPrice * Quantity) - ((UnitPrice * Quantity) * DiscPct)) * TaxPct AS decimal(12,2)) AS TaxAmount
FROM Picked;
GO

-- Validate inserted sales volume---
SELECT COUNT(*) AS SalesRows,
       MIN(DateKey) AS MinDateKey,
       MAX(DateKey) AS MaxDateKey
FROM ops.FactSales;
GO

---Retest Kpis views---
Select Top 30*
From ops.vw_KPI_MonthlyRevenue
Order by MonthStartDate;
go

Select Top 30*
From ops.vw_KPI_MoM_Revenue
order by MonthStartDate;
go

Select Top 30*
From ops.vw_KPI_YoY_Revenue
order by MonthStartDate;
go