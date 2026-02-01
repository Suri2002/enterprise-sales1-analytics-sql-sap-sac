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
- Month-over-Month (MoM) Revenue Growth
- Year-over_Year(YoY) Revenue Growth

Defining KPIs at the database layer avoids logic duplication across reporting tools and ensures consistency.
Time-intelligence KPIs (MoM and YoY) are implemented using SQL window functions to compare current performance against prior periods. These KPIs are exposed as views to ensure consistent calculations across all downstream analytics tools.

---

## 5. Data Quality & Validation
To ensure accuracy and reliability of analytics:
- Foreign key constraints enforce valid relationships between fact and dimension tables
- Numeric checks prevent invalid values (negative quantities, prices, or costs)
- KPI outputs were validated using manual aggregation queries to confirm correctness
- Edge cases (e.g., first month in MoM analysis) are handled gracefully using NULL logic

---

## 6. Analytics & Visualization Layer (SAP Analytics Cloud)
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

## 7. Performance & Scalability Considerations
- Star schema design minimizes join complexity for analytical queries
- Non-clustered indexes are applied on frequently filtered columns (Date, Store, Product)
- KPI calculations are pre-aggregated in SQL views to reduce dashboard computation time
- The architecture can scale to larger datasets by increasing data volume without changing the semantic layer

---

## 8. Design Principles Followed
- Star schema modeling
- Centralized KPI definitions
- Separation of data and visualization layers
- Reproducible and documented architecture
- Business-first KPI definitions aligned with executive reporting

---

## 9. Future Enhancements
Potential future improvements include:
- Automated data refresh pipelines
- Live SQL Server connection to SAC
- Inventory optimization analytics
