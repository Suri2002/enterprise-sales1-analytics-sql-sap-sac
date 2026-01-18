# Enterprise Sales Analytics — SQL Server & SAP Analytics Cloud (SAC)

End-to-end analytics project showcasing **enterprise data modeling (star schema)** in **Microsoft SQL Server** and **executive dashboards** in **SAP Analytics Cloud**.

---

## What this project demonstrates
- Star schema design for analytics (facts + dimensions)
- Centralized KPI logic using SQL Views (single source of truth)
- Curated datasets exported from SQL Server and consumed in SAC
- Clean repo structure + documentation

---

## Architecture
**SQL Server (SSMS) → KPI Views → Export (CSV) → SAP Analytics Cloud (Import Models) → Dashboards**

More detail: [`docs/architecture.md`](docs/architecture.md)

---

## Data Model
### Fact Tables
- `ops.FactSales` — sales transactions (date/store/customer/product, pricing, discounts, tax)
- `ops.FactInventoryDaily` — daily inventory snapshot (date/store/product, on-hand, reorder point)

### Dimension Tables
- `ops.DimDate`
- `ops.DimStore`
- `ops.DimProduct`
- `ops.DimCustomer`
- `ops.DimSupplier`
- Optional: `ops.Promotions`, `ops.PricingHistory`, `ops.FactReturns`, `ops.AuditLog`

---

## KPIs (SQL Views)
KPIs are defined in SQL Server using **views** to avoid duplicating business logic in reporting tools.

Included KPIs:
- Total Revenue
- Total Cost
- Total Profit
- Profit Margin %
- Revenue by Store
- Profit by Product
- Daily Revenue Trend

KPI definitions: [`sql/kpi_views.sql`](sql/kpi_views.sql)

---

## SAP Analytics Cloud Dashboards
Dashboards were built in **SAC** using imported KPI datasets. ['sac/dashboards'](sac/dashboards)

---

## How to run (rebuild from scratch)
1. Create a new database (recommended): `EnterpriseSalesOps_Rebuild`
2. Run schema: [`sql/schema.sql`](sql/schema.sql)
3. Seed data: [`sql/seed_data.sql`](sql/seed_data.sql)
4. Create KPI views: [`sql/kpi_views.sql`](sql/kpi_views.sql)
5. Export KPI view results to CSV and import into SAC.

---

## Tools & Technologies
- Microsoft SQL Server (SSMS)
- T-SQL
- SAP Analytics Cloud (SAC)
- GitHub

---

## Future Enhancements
- MoM / YoY KPIs
- Automated refresh pipeline
- Live connectivity to SAC (Cloud Connector) where available
- Inventory optimization analytics (stockout risk, reorder suggestions)


