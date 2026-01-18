# Project Architecture

## 1. Overview
This project implements an end-to-end analytics architecture using SQL Server as the data layer and SAP Analytics Cloud (SAC) as the visualization layer. The goal is to demonstrate enterprise-style data modeling, KPI definition, and executive reporting.

The architecture follows a layered BI approach:
- Data Storage
- Semantic / KPI Layer
- Analytics & Visualization

---

## 2. Data Source Layer (SQL Server)
The source system is Microsoft SQL Server, accessed and managed using SQL Server Management Studio (SSMS).

### Core Tables
- FactSales
- FactInventoryDaily
- DimDate
- DimProduct
- DimStore
- DimCustomer
- DimSupplier

The data is modeled using a star schema to support analytical queries and high-performance aggregations.

---

## 3. Data Modeling Layer (Star Schema)
The central fact table is `FactSales`, which captures transactional sales data.

Dimension tables provide descriptive context:
- Date dimension for time-based analysis
- Product and Supplier dimensions for product analytics
- Store dimension for regional performance
- Customer dimension for customer-level insights

This structure enables efficient slicing and dicing across multiple business dimensions.

---

## 4. KPI & Semantic Layer (SQL Views)
Business KPIs are defined in SQL Server using views to ensure centralized and reusable logic.

Examples of KPIs include:
- Total Revenue
- Total Cost
- Total Profit
- Profit Margin %
- Revenue by Store
- Profit by Product
- Daily Revenue Trend

Defining KPIs at the database layer avoids logic duplication across reporting tools and ensures consistency.

---

## 5. Analytics & Visualization Layer (SAP Analytics Cloud)
KPI views are exported from SQL Server and imported into SAP Analytics Cloud as models.

SAP Analytics Cloud is used to:
- Build executive dashboards
- Visualize trends and performance
- Provide business-friendly insights

Dashboards include:
- Executive Overview
- Revenue Performance by Store
- Time-based Revenue Trends

This separation of concerns aligns with enterprise BI best practices.

---

## 6. Design Principles Followed
- Star schema modeling
- Centralized KPI definitions
- Separation of data and visualization layers
- Reproducible and documented architecture

---

## 7. Future Enhancements
Potential future improvements include:
- Automated data refresh pipelines
- Live SQL Server connection to SAC
- Advanced time intelligence KPIs (MoM, YoY)
- Inventory optimization analytics
