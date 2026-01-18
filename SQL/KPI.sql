---Executive Summary (Revenue, Cost, Profit, Margin)---
Select Sum(Quantity * UnitPrice) As GrossRevenue,
       Sum(Quantity * UnitCost) As TotalCost,
	   Sum(DiscountAmount) As TotalDiscount,
	   Sum(TaxAmount) As TotalTax,
	   Sum(Quantity * UnitPrice) - Sum(Quantity * UnitCost) - Sum(DiscountAmount) As Profit,
	   Cast((Sum(Quantity * unitPrice) - Sum(Quantity * UnitCost) - Sum(DiscountAmount)) / NullIF(Sum(Quantity * UnitPrice),0)*100.0
	   As Decimal(10,2)) As profitMarginPct
From ops.FactSales;

---Revenue by Store---
Select s.StoreName,
       Sum(fs.Quantity * fs.UnitPrice) As Revenue
From ops.FactSales fs
Join ops.DimStore s On s.StoreID = fs.StoreID
Group By s.StoreName
Order By Revenue DESC;

---Profit by Product---
Select p.ProductName,
       Sum(fs.Quantity * fs.UnitPrice) - Sum(fs.Quantity * fs.UnitCost) - Sum(fs.DiscountAmount) As Profit
From ops.FactSales fs
Join ops.DimProduct p On p.ProductID = fs.ProductID
Group By p.ProductName
Order by Profit Desc;

---Daily Revenue Trend---
Select d.[Date],
       Sum(fs.Quantity * fs.UnitPrice) AS DailyRevenue
From ops.FactSales fs
Join ops.DimDate d On d.DateKey = fs.DateKey
Group by d.[Date]
Order by d.[Date];

---Rolling 7day Revenue---
With Daily As
( 
Select d.[Date],
       Sum(fs.Quantity * fs.UnitPrice) As DailyRevenue
From ops.FactSales fs
Join ops.DimDate d On d.Datekey = fs.DateKey
Group By d.[Date]
)
Select
  [Date],
  DailyRevenue,
  Sum(DailyRevenue) Over (order by [Date] Rows Between 6 Preceding And Current Row) As Rolling7DayRevenue
From Daily
Order by [Date];

---Promo vs Non Promo Performance---
SELECT
  CASE WHEN PromotionID IS NULL THEN 'No Promo' ELSE 'Promo' END AS SaleType,
  COUNT(*) AS Lines,
  SUM(Quantity * UnitPrice) AS Revenue,
  SUM(DiscountAmount) AS TotalDiscount
FROM ops.FactSales
GROUP BY CASE WHEN PromotionID IS NULL THEN 'No Promo' ELSE 'Promo' END;


