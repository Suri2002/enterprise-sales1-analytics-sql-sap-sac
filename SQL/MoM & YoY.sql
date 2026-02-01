Select Top 5 DateKey, [Date],[Year],[Month]
From ops.DimDate
Order By [Date];

---Monthly Revenue BASE View---
Create Or Alter View ops.vw_KPI_MonthlyRevenue AS
Select 
   d.[year],
   d.[Month],
   Cast(DateFromParts(d.[Year],d.[Month],1)As date) As MonthStartDate,
   Sum(fs.Quantity*fs.UnitPrice) As MonthlyRevenue
From ops.FactSales fs
Join ops.DimDate d
     ON d.DateKey = fs.DateKey
Group By
     d.[Year],d.[Month];
Go

---MoM Revenue Growth view---
Create Or Alter View ops.vw_KPI_MoM_Revenue As
With M As(
     Select
	     [Year],
		 [Month],
		 MonthStartDate,
		 MonthlyRevenue,
		 Lag(MonthlyRevenue) Over (Order By MonthStartDate) As PrevMonthRevenue
	 From ops.vw_KPI_MonthlyRevenue
)
Select
   [Year],
   [Month],
   MonthStartDate,
   MonthlyRevenue,
   PrevMonthRevenue,
   (MonthlyRevenue - PrevMonthRevenue) As MoM_Change,
   Cast((MonthlyRevenue - PrevMonthRevenue)*100.0 / NullIF(PrevMonthRevenue,0)
   As Decimal(10,2)) AS MoM_GrowthPct
From M;
Go

---YoY Revenue Growth view---
Create Or Alter View ops.vw_KPI_YoY_Revenue AS
With M AS (
     Select
	      [Year],
		  [Month],
		  MonthStartDate,
        MonthlyRevenue,
        LAG(MonthlyRevenue, 12) OVER (ORDER BY MonthStartDate) AS PrevYearSameMonthRevenue
    FROM ops.vw_KPI_MonthlyRevenue
)
SELECT
    [Year],
    [Month],
    MonthStartDate,
    MonthlyRevenue,
    PrevYearSameMonthRevenue,
    (MonthlyRevenue - PrevYearSameMonthRevenue) AS YoY_Change,
    CAST(
        (MonthlyRevenue - PrevYearSameMonthRevenue) * 100.0 / NULLIF(PrevYearSameMonthRevenue, 0)
    AS DECIMAL(10,2)) AS YoY_GrowthPct
FROM M;
GO

---Extend DimDate + Sales to support YoY---
Declare @d Date = '2024-01-01'
While @d<='2025-12-31'
Begin 
   If Not Exists (Select 1 From ops.DimDate Where DateKey =Convert(Int, Convert(Varchar(8), @d, 112)))
   Insert Into ops.DimDate
   (DateKey, [Date],[Year],[Quarter],[Month],MonthName,[Day],DayOfWeek,Dayname,isWeekend)
   Values
   (
      Convert(Int, Convert(Varchar(8),@d,112)), @d, 
	  Year(@d),Datepart(QUARTER, @d), Month(@d), DateName(Month, @d),
	  Day(@d), DatePart(WeekDay, @d), DateName(WeekDay, @d),
	  Case When DatePart(WeekDay,@d) IN (1,7) Then 1 Else 0 End
	);
	Set @d = DateAdd(Day,1,@d);
End
GO
