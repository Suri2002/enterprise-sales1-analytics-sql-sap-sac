---From schema/01_create_schema.sql---

USE [EnterpriseSalesOps2]
GO
ALTER TABLE [ops].[Promotions] DROP CONSTRAINT [CK_Promo_Discount]
GO
ALTER TABLE [ops].[Promotions] DROP CONSTRAINT [CK_Promo_DateRange]
GO
ALTER TABLE [ops].[PricingHistory] DROP CONSTRAINT [CK_Pricing_Price]
GO
ALTER TABLE [ops].[FactSales] DROP CONSTRAINT [CK_Sales_UnitPrice]
GO
ALTER TABLE [ops].[FactSales] DROP CONSTRAINT [CK_Sales_UnitCost]
GO
ALTER TABLE [ops].[FactSales] DROP CONSTRAINT [CK_Sales_Tax]
GO
ALTER TABLE [ops].[FactSales] DROP CONSTRAINT [CK_Sales_Qty]
GO
ALTER TABLE [ops].[FactSales] DROP CONSTRAINT [CK_Sales_Discount]
GO
ALTER TABLE [ops].[FactReturns] DROP CONSTRAINT [CK_Return_Qty]
GO
ALTER TABLE [ops].[FactInventoryDaily] DROP CONSTRAINT [CK_Inv_Safety]
GO
ALTER TABLE [ops].[FactInventoryDaily] DROP CONSTRAINT [CK_Inv_Reorder]
GO
ALTER TABLE [ops].[FactInventoryDaily] DROP CONSTRAINT [CK_Inv_OnHand]
GO
ALTER TABLE [ops].[DimSupplier] DROP CONSTRAINT [CK_Supplier_LeadTime]
GO
ALTER TABLE [ops].[DimProduct] DROP CONSTRAINT [CK_Product_Price]
GO
ALTER TABLE [ops].[DimProduct] DROP CONSTRAINT [CK_Product_Cost]
GO
ALTER TABLE [ops].[Promotions] DROP CONSTRAINT [FK_Promo_StartDate]
GO
ALTER TABLE [ops].[Promotions] DROP CONSTRAINT [FK_Promo_EndDate]
GO
ALTER TABLE [ops].[PricingHistory] DROP CONSTRAINT [FK_Pricing_ToDate]
GO
ALTER TABLE [ops].[PricingHistory] DROP CONSTRAINT [FK_Pricing_Product]
GO
ALTER TABLE [ops].[PricingHistory] DROP CONSTRAINT [FK_Pricing_FromDate]
GO
ALTER TABLE [ops].[FactSales] DROP CONSTRAINT [FK_Sales_Store]
GO
ALTER TABLE [ops].[FactSales] DROP CONSTRAINT [FK_Sales_Promo]
GO
ALTER TABLE [ops].[FactSales] DROP CONSTRAINT [FK_Sales_Product]
GO
ALTER TABLE [ops].[FactSales] DROP CONSTRAINT [FK_Sales_Date]
GO
ALTER TABLE [ops].[FactSales] DROP CONSTRAINT [FK_Sales_Customer]
GO
ALTER TABLE [ops].[FactReturns] DROP CONSTRAINT [FK_Return_Sales]
GO
ALTER TABLE [ops].[FactReturns] DROP CONSTRAINT [FK_Return_Date]
GO
ALTER TABLE [ops].[FactInventoryDaily] DROP CONSTRAINT [FK_Inv_Store]
GO
ALTER TABLE [ops].[FactInventoryDaily] DROP CONSTRAINT [FK_Inv_Product]
GO
ALTER TABLE [ops].[FactInventoryDaily] DROP CONSTRAINT [FK_Inv_Date]
GO
ALTER TABLE [ops].[DimProduct] DROP CONSTRAINT [FK_Product_Supplier]
GO
ALTER TABLE [ops].[DimCustomer] DROP CONSTRAINT [FK_DimCustomer_DimDate]
GO
ALTER TABLE [ops].[PricingHistory] DROP CONSTRAINT [DF_Pricing_UpdatedAt]
GO
ALTER TABLE [ops].[FactSales] DROP CONSTRAINT [DF_Sales_CreatedAt]
GO
ALTER TABLE [ops].[FactSales] DROP CONSTRAINT [DF_Sales_Tax]
GO
ALTER TABLE [ops].[FactSales] DROP CONSTRAINT [DF_Sales_Discount]
GO
ALTER TABLE [ops].[DimProduct] DROP CONSTRAINT [DF_Product_IsActive]
GO
ALTER TABLE [ops].[AuditLog] DROP CONSTRAINT [DF_Audit_ActionAt]
GO
/****** Object:  Index [IX_FactSales_Product]    Script Date: 11-01-2026 12:33:25 ******/
DROP INDEX [IX_FactSales_Product] ON [ops].[FactSales]
GO
/****** Object:  Index [IX_FactSales_DateStore]    Script Date: 11-01-2026 12:33:25 ******/
DROP INDEX [IX_FactSales_DateStore] ON [ops].[FactSales]
GO
/****** Object:  Index [IX_Inv_StoreProdDate]    Script Date: 11-01-2026 12:33:25 ******/
DROP INDEX [IX_Inv_StoreProdDate] ON [ops].[FactInventoryDaily]
GO
/****** Object:  Table [ops].[Promotions]    Script Date: 11-01-2026 12:33:25 ******/
DROP TABLE [ops].[Promotions]
GO
/****** Object:  Table [ops].[PricingHistory]    Script Date: 11-01-2026 12:33:25 ******/
DROP TABLE [ops].[PricingHistory]
GO
/****** Object:  Table [ops].[FactSales]    Script Date: 11-01-2026 12:33:25 ******/
DROP TABLE [ops].[FactSales]
GO
/****** Object:  Table [ops].[FactReturns]    Script Date: 11-01-2026 12:33:25 ******/
DROP TABLE [ops].[FactReturns]
GO
/****** Object:  Table [ops].[FactInventoryDaily]    Script Date: 11-01-2026 12:33:25 ******/
DROP TABLE [ops].[FactInventoryDaily]
GO
/****** Object:  Table [ops].[DimSupplier]    Script Date: 11-01-2026 12:33:25 ******/
DROP TABLE [ops].[DimSupplier]
GO
/****** Object:  Table [ops].[DimStore]    Script Date: 11-01-2026 12:33:25 ******/
DROP TABLE [ops].[DimStore]
GO
/****** Object:  Table [ops].[DimProduct]    Script Date: 11-01-2026 12:33:25 ******/
DROP TABLE [ops].[DimProduct]
GO
/****** Object:  Table [ops].[DimDate]    Script Date: 11-01-2026 12:33:25 ******/
DROP TABLE [ops].[DimDate]
GO
/****** Object:  Table [ops].[DimCustomer]    Script Date: 11-01-2026 12:33:25 ******/
DROP TABLE [ops].[DimCustomer]
GO
/****** Object:  Table [ops].[AuditLog]    Script Date: 11-01-2026 12:33:25 ******/
DROP TABLE [ops].[AuditLog]
GO
/****** Object:  Table [ops].[AuditLog]    Script Date: 11-01-2026 12:33:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [ops].[AuditLog](
	[AuditID] [bigint] IDENTITY(1,1) NOT NULL,
	[EntityName] [varchar](60) NOT NULL,
	[EntityKey] [varchar](120) NOT NULL,
	[ActionType] [varchar](20) NOT NULL,
	[ActionAt] [datetime] NOT NULL,
	[ActionBy] [varchar](80) NULL,
	[Details] [varchar](4000) NULL,
PRIMARY KEY CLUSTERED 
(
	[AuditID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [ops].[DimCustomer]    Script Date: 11-01-2026 12:33:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [ops].[DimCustomer](
	[CustomerID] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [varchar](40) NOT NULL,
	[LastName] [varchar](40) NOT NULL,
	[Email] [varchar](120) NULL,
	[Phone] [varchar](25) NULL,
	[CreatedDateKey] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [ops].[DimDate]    Script Date: 11-01-2026 12:33:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [ops].[DimDate](
	[DateKey] [int] NOT NULL,
	[Date] [date] NOT NULL,
	[Year] [smallint] NOT NULL,
	[Quarter] [tinyint] NOT NULL,
	[Month] [tinyint] NOT NULL,
	[MonthName] [varchar](15) NOT NULL,
	[Day] [tinyint] NOT NULL,
	[DayOfWeek] [tinyint] NOT NULL,
	[DayName] [varchar](10) NOT NULL,
	[IsWeekend] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DateKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [ops].[DimProduct]    Script Date: 11-01-2026 12:33:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [ops].[DimProduct](
	[ProductID] [int] IDENTITY(1,1) NOT NULL,
	[SKU] [varchar](40) NOT NULL,
	[ProductName] [varchar](120) NOT NULL,
	[Category] [varchar](60) NOT NULL,
	[Brand] [varchar](60) NOT NULL,
	[SupplierID] [int] NOT NULL,
	[StandardCost] [decimal](12, 2) NOT NULL,
	[ListPrice] [decimal](12, 2) NOT NULL,
	[IsActive] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ProductID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[SKU] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [ops].[DimStore]    Script Date: 11-01-2026 12:33:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [ops].[DimStore](
	[StoreID] [int] IDENTITY(1,1) NOT NULL,
	[StoreName] [varchar](100) NOT NULL,
	[City] [varchar](60) NOT NULL,
	[State] [char](2) NOT NULL,
	[Region] [varchar](40) NOT NULL,
	[OpenDate] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[StoreID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [ops].[DimSupplier]    Script Date: 11-01-2026 12:33:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [ops].[DimSupplier](
	[SupplierID] [int] IDENTITY(1,1) NOT NULL,
	[SupplierName] [varchar](120) NOT NULL,
	[Country] [varchar](60) NOT NULL,
	[LeadTimeDays] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[SupplierID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [ops].[FactInventoryDaily]    Script Date: 11-01-2026 12:33:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ops].[FactInventoryDaily](
	[InventoryID] [bigint] IDENTITY(1,1) NOT NULL,
	[DateKey] [int] NOT NULL,
	[StoreID] [int] NOT NULL,
	[ProductID] [int] NOT NULL,
	[OnHandQty] [int] NOT NULL,
	[ReorderPoint] [int] NOT NULL,
	[SafetyStock] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[InventoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_Inv] UNIQUE NONCLUSTERED 
(
	[DateKey] ASC,
	[StoreID] ASC,
	[ProductID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [ops].[FactReturns]    Script Date: 11-01-2026 12:33:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [ops].[FactReturns](
	[ReturnID] [bigint] IDENTITY(1,1) NOT NULL,
	[SalesID] [bigint] NOT NULL,
	[ReturnDateKey] [int] NOT NULL,
	[ReturnQty] [int] NOT NULL,
	[ReturnReason] [varchar](120) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ReturnID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [ops].[FactSales]    Script Date: 11-01-2026 12:33:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ops].[FactSales](
	[SalesID] [bigint] IDENTITY(1,1) NOT NULL,
	[DateKey] [int] NOT NULL,
	[StoreID] [int] NOT NULL,
	[CustomerID] [int] NOT NULL,
	[ProductID] [int] NOT NULL,
	[PromotionID] [int] NULL,
	[Quantity] [int] NOT NULL,
	[UnitPrice] [decimal](12, 2) NOT NULL,
	[UnitCost] [decimal](12, 2) NOT NULL,
	[DiscountAmount] [decimal](12, 2) NOT NULL,
	[TaxAmount] [decimal](12, 2) NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[SalesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [ops].[PricingHistory]    Script Date: 11-01-2026 12:33:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [ops].[PricingHistory](
	[PriceHistoryID] [bigint] IDENTITY(1,1) NOT NULL,
	[ProductID] [int] NOT NULL,
	[EffectiveFromKey] [int] NOT NULL,
	[EffectiveToKey] [int] NULL,
	[ListPrice] [decimal](12, 2) NOT NULL,
	[UpdatedBy] [varchar](80) NULL,
	[UpdatedAt] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[PriceHistoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [ops].[Promotions]    Script Date: 11-01-2026 12:33:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [ops].[Promotions](
	[PromotionID] [int] IDENTITY(1,1) NOT NULL,
	[PromoName] [varchar](120) NOT NULL,
	[StartDateKey] [int] NOT NULL,
	[EndDateKey] [int] NOT NULL,
	[DiscountPct] [decimal](5, 2) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[PromotionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Index [IX_Inv_StoreProdDate]    Script Date: 11-01-2026 12:33:25 ******/
CREATE NONCLUSTERED INDEX [IX_Inv_StoreProdDate] ON [ops].[FactInventoryDaily]
(
	[StoreID] ASC,
	[ProductID] ASC,
	[DateKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_FactSales_DateStore]    Script Date: 11-01-2026 12:33:25 ******/
CREATE NONCLUSTERED INDEX [IX_FactSales_DateStore] ON [ops].[FactSales]
(
	[DateKey] ASC,
	[StoreID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_FactSales_Product]    Script Date: 11-01-2026 12:33:25 ******/
CREATE NONCLUSTERED INDEX [IX_FactSales_Product] ON [ops].[FactSales]
(
	[ProductID] ASC
)
INCLUDE ( 	[Quantity],
	[UnitPrice],
	[UnitCost],
	[DiscountAmount],
	[TaxAmount],
	[DateKey],
	[StoreID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [ops].[AuditLog] ADD  CONSTRAINT [DF_Audit_ActionAt]  DEFAULT (getdate()) FOR [ActionAt]
GO
ALTER TABLE [ops].[DimProduct] ADD  CONSTRAINT [DF_Product_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [ops].[FactSales] ADD  CONSTRAINT [DF_Sales_Discount]  DEFAULT ((0)) FOR [DiscountAmount]
GO
ALTER TABLE [ops].[FactSales] ADD  CONSTRAINT [DF_Sales_Tax]  DEFAULT ((0)) FOR [TaxAmount]
GO
ALTER TABLE [ops].[FactSales] ADD  CONSTRAINT [DF_Sales_CreatedAt]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [ops].[PricingHistory] ADD  CONSTRAINT [DF_Pricing_UpdatedAt]  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [ops].[DimCustomer]  WITH CHECK ADD  CONSTRAINT [FK_DimCustomer_DimDate] FOREIGN KEY([CreatedDateKey])
REFERENCES [ops].[DimDate] ([DateKey])
GO
ALTER TABLE [ops].[DimCustomer] CHECK CONSTRAINT [FK_DimCustomer_DimDate]
GO
ALTER TABLE [ops].[DimProduct]  WITH CHECK ADD  CONSTRAINT [FK_Product_Supplier] FOREIGN KEY([SupplierID])
REFERENCES [ops].[DimSupplier] ([SupplierID])
GO
ALTER TABLE [ops].[DimProduct] CHECK CONSTRAINT [FK_Product_Supplier]
GO
ALTER TABLE [ops].[FactInventoryDaily]  WITH CHECK ADD  CONSTRAINT [FK_Inv_Date] FOREIGN KEY([DateKey])
REFERENCES [ops].[DimDate] ([DateKey])
GO
ALTER TABLE [ops].[FactInventoryDaily] CHECK CONSTRAINT [FK_Inv_Date]
GO
ALTER TABLE [ops].[FactInventoryDaily]  WITH CHECK ADD  CONSTRAINT [FK_Inv_Product] FOREIGN KEY([ProductID])
REFERENCES [ops].[DimProduct] ([ProductID])
GO
ALTER TABLE [ops].[FactInventoryDaily] CHECK CONSTRAINT [FK_Inv_Product]
GO
ALTER TABLE [ops].[FactInventoryDaily]  WITH CHECK ADD  CONSTRAINT [FK_Inv_Store] FOREIGN KEY([StoreID])
REFERENCES [ops].[DimStore] ([StoreID])
GO
ALTER TABLE [ops].[FactInventoryDaily] CHECK CONSTRAINT [FK_Inv_Store]
GO
ALTER TABLE [ops].[FactReturns]  WITH CHECK ADD  CONSTRAINT [FK_Return_Date] FOREIGN KEY([ReturnDateKey])
REFERENCES [ops].[DimDate] ([DateKey])
GO
ALTER TABLE [ops].[FactReturns] CHECK CONSTRAINT [FK_Return_Date]
GO
ALTER TABLE [ops].[FactReturns]  WITH CHECK ADD  CONSTRAINT [FK_Return_Sales] FOREIGN KEY([SalesID])
REFERENCES [ops].[FactSales] ([SalesID])
GO
ALTER TABLE [ops].[FactReturns] CHECK CONSTRAINT [FK_Return_Sales]
GO
ALTER TABLE [ops].[FactSales]  WITH CHECK ADD  CONSTRAINT [FK_Sales_Customer] FOREIGN KEY([CustomerID])
REFERENCES [ops].[DimCustomer] ([CustomerID])
GO
ALTER TABLE [ops].[FactSales] CHECK CONSTRAINT [FK_Sales_Customer]
GO
ALTER TABLE [ops].[FactSales]  WITH CHECK ADD  CONSTRAINT [FK_Sales_Date] FOREIGN KEY([DateKey])
REFERENCES [ops].[DimDate] ([DateKey])
GO
ALTER TABLE [ops].[FactSales] CHECK CONSTRAINT [FK_Sales_Date]
GO
ALTER TABLE [ops].[FactSales]  WITH CHECK ADD  CONSTRAINT [FK_Sales_Product] FOREIGN KEY([ProductID])
REFERENCES [ops].[DimProduct] ([ProductID])
GO
ALTER TABLE [ops].[FactSales] CHECK CONSTRAINT [FK_Sales_Product]
GO
ALTER TABLE [ops].[FactSales]  WITH CHECK ADD  CONSTRAINT [FK_Sales_Promo] FOREIGN KEY([PromotionID])
REFERENCES [ops].[Promotions] ([PromotionID])
GO
ALTER TABLE [ops].[FactSales] CHECK CONSTRAINT [FK_Sales_Promo]
GO
ALTER TABLE [ops].[FactSales]  WITH CHECK ADD  CONSTRAINT [FK_Sales_Store] FOREIGN KEY([StoreID])
REFERENCES [ops].[DimStore] ([StoreID])
GO
ALTER TABLE [ops].[FactSales] CHECK CONSTRAINT [FK_Sales_Store]
GO
ALTER TABLE [ops].[PricingHistory]  WITH CHECK ADD  CONSTRAINT [FK_Pricing_FromDate] FOREIGN KEY([EffectiveFromKey])
REFERENCES [ops].[DimDate] ([DateKey])
GO
ALTER TABLE [ops].[PricingHistory] CHECK CONSTRAINT [FK_Pricing_FromDate]
GO
ALTER TABLE [ops].[PricingHistory]  WITH CHECK ADD  CONSTRAINT [FK_Pricing_Product] FOREIGN KEY([ProductID])
REFERENCES [ops].[DimProduct] ([ProductID])
GO
ALTER TABLE [ops].[PricingHistory] CHECK CONSTRAINT [FK_Pricing_Product]
GO
ALTER TABLE [ops].[PricingHistory]  WITH CHECK ADD  CONSTRAINT [FK_Pricing_ToDate] FOREIGN KEY([EffectiveToKey])
REFERENCES [ops].[DimDate] ([DateKey])
GO
ALTER TABLE [ops].[PricingHistory] CHECK CONSTRAINT [FK_Pricing_ToDate]
GO
ALTER TABLE [ops].[Promotions]  WITH CHECK ADD  CONSTRAINT [FK_Promo_EndDate] FOREIGN KEY([EndDateKey])
REFERENCES [ops].[DimDate] ([DateKey])
GO
ALTER TABLE [ops].[Promotions] CHECK CONSTRAINT [FK_Promo_EndDate]
GO
ALTER TABLE [ops].[Promotions]  WITH CHECK ADD  CONSTRAINT [FK_Promo_StartDate] FOREIGN KEY([StartDateKey])
REFERENCES [ops].[DimDate] ([DateKey])
GO
ALTER TABLE [ops].[Promotions] CHECK CONSTRAINT [FK_Promo_StartDate]
GO
ALTER TABLE [ops].[DimProduct]  WITH CHECK ADD  CONSTRAINT [CK_Product_Cost] CHECK  (([StandardCost]>=(0)))
GO
ALTER TABLE [ops].[DimProduct] CHECK CONSTRAINT [CK_Product_Cost]
GO
ALTER TABLE [ops].[DimProduct]  WITH CHECK ADD  CONSTRAINT [CK_Product_Price] CHECK  (([ListPrice]>=(0)))
GO
ALTER TABLE [ops].[DimProduct] CHECK CONSTRAINT [CK_Product_Price]
GO
ALTER TABLE [ops].[DimSupplier]  WITH CHECK ADD  CONSTRAINT [CK_Supplier_LeadTime] CHECK  (([LeadTimeDays]>=(0)))
GO
ALTER TABLE [ops].[DimSupplier] CHECK CONSTRAINT [CK_Supplier_LeadTime]
GO
ALTER TABLE [ops].[FactInventoryDaily]  WITH CHECK ADD  CONSTRAINT [CK_Inv_OnHand] CHECK  (([OnHandQty]>=(0)))
GO
ALTER TABLE [ops].[FactInventoryDaily] CHECK CONSTRAINT [CK_Inv_OnHand]
GO
ALTER TABLE [ops].[FactInventoryDaily]  WITH CHECK ADD  CONSTRAINT [CK_Inv_Reorder] CHECK  (([ReorderPoint]>=(0)))
GO
ALTER TABLE [ops].[FactInventoryDaily] CHECK CONSTRAINT [CK_Inv_Reorder]
GO
ALTER TABLE [ops].[FactInventoryDaily]  WITH CHECK ADD  CONSTRAINT [CK_Inv_Safety] CHECK  (([SafetyStock]>=(0)))
GO
ALTER TABLE [ops].[FactInventoryDaily] CHECK CONSTRAINT [CK_Inv_Safety]
GO
ALTER TABLE [ops].[FactReturns]  WITH CHECK ADD  CONSTRAINT [CK_Return_Qty] CHECK  (([ReturnQty]>(0)))
GO
ALTER TABLE [ops].[FactReturns] CHECK CONSTRAINT [CK_Return_Qty]
GO
ALTER TABLE [ops].[FactSales]  WITH CHECK ADD  CONSTRAINT [CK_Sales_Discount] CHECK  (([DiscountAmount]>=(0)))
GO
ALTER TABLE [ops].[FactSales] CHECK CONSTRAINT [CK_Sales_Discount]
GO
ALTER TABLE [ops].[FactSales]  WITH CHECK ADD  CONSTRAINT [CK_Sales_Qty] CHECK  (([Quantity]>(0)))
GO
ALTER TABLE [ops].[FactSales] CHECK CONSTRAINT [CK_Sales_Qty]
GO
ALTER TABLE [ops].[FactSales]  WITH CHECK ADD  CONSTRAINT [CK_Sales_Tax] CHECK  (([TaxAmount]>=(0)))
GO
ALTER TABLE [ops].[FactSales] CHECK CONSTRAINT [CK_Sales_Tax]
GO
ALTER TABLE [ops].[FactSales]  WITH CHECK ADD  CONSTRAINT [CK_Sales_UnitCost] CHECK  (([UnitCost]>=(0)))
GO
ALTER TABLE [ops].[FactSales] CHECK CONSTRAINT [CK_Sales_UnitCost]
GO
ALTER TABLE [ops].[FactSales]  WITH CHECK ADD  CONSTRAINT [CK_Sales_UnitPrice] CHECK  (([UnitPrice]>=(0)))
GO
ALTER TABLE [ops].[FactSales] CHECK CONSTRAINT [CK_Sales_UnitPrice]
GO
ALTER TABLE [ops].[PricingHistory]  WITH CHECK ADD  CONSTRAINT [CK_Pricing_Price] CHECK  (([ListPrice]>=(0)))
GO
ALTER TABLE [ops].[PricingHistory] CHECK CONSTRAINT [CK_Pricing_Price]
GO
ALTER TABLE [ops].[Promotions]  WITH CHECK ADD  CONSTRAINT [CK_Promo_DateRange] CHECK  (([EndDateKey]>=[StartDateKey]))
GO
ALTER TABLE [ops].[Promotions] CHECK CONSTRAINT [CK_Promo_DateRange]
GO
ALTER TABLE [ops].[Promotions]  WITH CHECK ADD  CONSTRAINT [CK_Promo_Discount] CHECK  (([DiscountPct]>=(0) AND [DiscountPct]<=(100)))
GO
ALTER TABLE [ops].[Promotions] CHECK CONSTRAINT [CK_Promo_Discount]
GO
