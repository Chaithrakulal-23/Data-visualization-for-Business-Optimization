# Inventory KPI Dashboard – Test to Production Migration

### Dashboard Link 
### SQL Server Data Source : https://app.powerbi.com/links/s0OXEFh-Mf?ctid=51697115-1ecd-42b5-b509-2d62c3919f76&pbi_source=linkShare&bookmarkGuid=5fa3bb5c-afe8-436c-b627-0687ff1db95e
### MYSQL Daatabase Data Source : https://app.powerbi.com/links/AZhrc98Jf3?ctid=51697115-1ecd-42b5-b509-2d62c3919f76&pbi_source=linkShare&bookmarkGuid=172a4f62-7d72-48e9-981a-bd8376e2c995
---

## Problem Statement

This dashboard provides real-time visibility into inventory performance by tracking demand vs. availability across products and dates. It helps operations and supply chain teams identify supply shortages, financial losses, and profit trends at a daily level.

Since supply shortages directly impact revenue, the dashboard enables stakeholders to act on shortfall patterns early. By transitioning the report from a **SQL Server (SSMS) test environment** to a **MySQL production environment**, the solution is now scalable, reliable, and ready for live operational use.

---

## Data Sources

| Dataset | Columns |
|---|---|
| Test Environment Inventory Dataset | `Order_Date_DD_MM_YYYY`, `Product_ID`, `Availability`, `Demand` |
| Products | `Product_ID`, `Product_Name`, `Unit_Price` |

Both datasets were originally in Excel format and imported into **Microsoft SQL Server (SSMS)** for the test environment, then migrated to **MySQL** for production.

---

## Steps Followed

### Phase 1 – Test Environment Setup (SQL Server / SSMS)

- **Step 1 :** Created a test database in SSMS and imported the two Excel datasets as tables.

```sql
CREATE DATABASE test_env;
USE test_env;

SELECT * FROM [dbo].[Products];
SELECT * FROM [dbo].[Test Environment Inventory Dataset];
```

- **Step 2 :** Validated dataset values by running exploratory queries.

```sql
SELECT DISTINCT product_id FROM Products;
SELECT DISTINCT product_id FROM [dbo].[Test Environment Inventory Dataset];
SELECT DISTINCT Order_Date_DD_MM_YYYY FROM [dbo].[Test Environment Inventory Dataset];
SELECT DISTINCT [Availability] FROM [dbo].[Test Environment Inventory Dataset];
SELECT DISTINCT Demand FROM [dbo].[Test Environment Inventory Dataset];
```

- **Step 3 :** Performed a `LEFT JOIN` between the inventory and products tables on `Product_ID` to enrich the dataset.

```sql
SELECT a.[Order_Date_DD_MM_YYYY], a.Product_ID, a.Demand,
       b.Product_Name, b.Unit_Price
FROM [dbo].[Test Environment Inventory Dataset] AS a
LEFT JOIN [dbo].[Products] AS b
ON a.Product_ID = b.Product_ID;
```

- **Step 4 :** Inserted the joined result into a new consolidated table `New_table1` for direct Power BI consumption.

```sql
SELECT * INTO New_table1 FROM (
    SELECT a.[Order_Date_DD_MM_YYYY], a.Product_ID, a.Availability, a.Demand,
           b.Product_Name, b.Unit_Price
    FROM [dbo].[Test Environment Inventory Dataset] AS a
    LEFT JOIN [dbo].[Products] AS b
    ON a.Product_ID = b.Product_ID
) X;

SELECT * FROM New_table1;
```

Snap of `New_table1` connection in Power BI (SQL Server – SSMS):

![New Table 1 - SQL Server Connection](https://github.com/Chaithrakulal-23/Data-visualization-for-Business-Optimization/blob/05da95fd975838b0ec73d965f1a482178be63a60/newtable1.png)

---

### Phase 2 – Power BI Report Development

- **Step 5 :** Loaded `New_table1` into Power BI Desktop using the **SQL Server** database connector.

- **Step 6 :** Opened Power Query Editor. Under the **View** tab, enabled **Column Distribution**, **Column Quality**, and **Column Profile**. Set column profiling to **entire dataset**.

Snap of Column Profiling in Power Query Editor:

![Column Profiling](https://github.com/Chaithrakulal-23/Data-visualization-for-Business-Optimization/blob/dae5b02dfcb99f2fa78a93f84bf06143c21763d0/columnprofiling.png)

- **Step 7 :** Reviewed data types and corrected them where needed. Added a background theme to the report canvas.

- **Step 8 :** Created the following **DAX Measures** in a dedicated `Measures Table`:

```dax
Total Number of Days = DISTINCTCOUNT('Demand/Availability Data'[Order_Date_DD_MM_YYYY].[Date])

Total Demand = SUM('Demand/Availability Data'[Demand])

Total Availability = SUM('Demand/Availability Data'[Availability])

Average Demand Per Day = DIVIDE([Total Demand], [Total Number of Days])

Average Availability Per Day = DIVIDE([Total Availability], [Total Number of Days])

Total Supply Shortage = [Total Demand] - [Total Availability]
```

Snap of Measures Table in the Data pane:

![DAX Measures Table](https://github.com/Chaithrakulal-23/Data-visualization-for-Business-Optimization/blob/b633d017c97a35b48a9d129b2f636e236eba8868/dax.png)

- **Step 9 :** Built **KPI Page 1** using Card visuals for:
  - Average Demand Per Day
  - Average Availability Per Day
  - Total Supply Shortage

  Added **Product Name** and **Order Date** slicers/filters to this page.

Snap of KPI Page 1 (Power BI Desktop):

![KPI Page 1 - Desktop](https://github.com/Chaithrakulal-23/Data-visualization-for-Business-Optimization/blob/e2bb6966092216cd429ca96274d6c1f028010131/page1d.png)

Snap of KPI Page 1 (Power BI Service – Published):

![KPI Page 1 - Published](https://github.com/Chaithrakulal-23/Data-visualization-for-Business-Optimization/blob/ac5450d28649d97c1dc366c453c4181ffa7c44e2/page1p.png)

- **Step 10 :** Created a calculated column for Loss/Profit analysis:

```dax
LOSS/PROFIT = 'Demand/Availability Data'[Availability] - 'Demand/Availability Data'[Demand]
```

- **Step 11 :** Created the following measures for **KPI Page 2**:

```dax
Total Loss = SUMX(
    FILTER('Demand/Availability Data', 'Demand/Availability Data'[LOSS/PROFIT] < 0),
    'Demand/Availability Data'[LOSS/PROFIT] * 'Demand/Availability Data'[Unit_Price]
) * -1

Total Profit = SUMX(
    FILTER('Demand/Availability Data', 'Demand/Availability Data'[LOSS/PROFIT] > 0),
    'Demand/Availability Data'[LOSS/PROFIT] * 'Demand/Availability Data'[Unit_Price]
)

Average Loss Per Day = DIVIDE([Total Loss], [Total Number of Days])
```

- **Step 12 :** Built **KPI Page 2** using Card visuals for:
  - Total Profit
  - Total Loss
  - Average Daily Loss

  Added **Product Name** and **Order Date** slicers/filters to this page.

Snap of KPI Page 2 (Power BI Desktop):

![KPI Page 2 - Desktop](https://github.com/Chaithrakulal-23/Data-visualization-for-Business-Optimization/blob/cde879531e79ba0db9c0de3a06a12c9e176baf3b/page2d.png)

Snap of KPI Page 2 (Power BI Service – Published):

![KPI Page 2 - Published](https://github.com/Chaithrakulal-23/Data-visualization-for-Business-Optimization/blob/c1aa35375ff98a1ae856d7e65f6ee925c95c3d70/page2p.png)

- **Step 13 :** Published the report to **Power BI Service** under the **Test Environment Workspace**.

---

### Phase 3 – Production Migration (SQL Server → MySQL)

- **Step 14 :** Imported the production datasets into **MySQL Workbench** under the `prod` schema. Verified data integrity by querying both tables.

Snap of MySQL Workbench – Inventory Dataset (`prod` schema):

![MySQL Inventory Dataset](https://github.com/Chaithrakulal-23/Data-visualization-for-Business-Optimization/blob/6323a7e2099f5693b6be12152a040b43b139c2a3/mysqlenv.png)

Snap of MySQL Workbench – Products Table (`prod` schema):

![MySQL Products Table](https://github.com/Chaithrakulal-23/Data-visualization-for-Business-Optimization/blob/e7f993592ba451eb4054dc11d44c1b6b4eb94aca/mysqlprod.png)

- **Step 15 :** Connected Power BI Desktop to the **MySQL Server** (`localhost`, database: `PROD`) using the MySQL database connector with the SQL statement `SELECT * FROM prod.new_table1`.

Snap of MySQL database connection dialog in Power BI:

![Connect to MySQL](https://github.com/Chaithrakulal-23/Data-visualization-for-Business-Optimization/blob/551d56a503813368ce07f2b7df433313183d9fb3/CONNECTMYSQL1.png)

- **Step 16 :** Opened the **Advanced Editor** in Power Query for the new MySQL query (`Query1`) and copied the `Source` step:

```m
Source = MySQL.Database("localhost", "PROD", [ReturnSingleDatabase=true, Query="SELECT * FROM prod.new_table1;"])
```

Snap of Advanced Editor – MySQL Source (Query1):

![Advanced Editor - MySQL Source](m1_advanced_editor.png)

- **Step 17 :** Navigated to the existing `Demand/Availability Data` query (originally pointing to SSMS), opened its **Advanced Editor**, and replaced the `Source` line with the copied MySQL source code. Validated — no syntax errors detected.

Snap of Advanced Editor – Demand/Availability Data after source swap:

![Advanced Editor - Demand/Availability Data Updated](m2_advanced_editor.png)

- **Step 18 :** Validated the migrated data against the original SSMS report to confirm row counts, column values, and KPI figures matched.

- **Step 19 :** Published the updated report to a separate **Production Workspace** in Power BI Service.

> **Two workspaces were maintained:**
> - `Test Workspace` → SSMS (SQL Server) data source
> - `Production Workspace` → MySQL data source

---

## KPI Summary

### Page 1 – Supply Overview

| KPI | Value | Description |
|---|---|---|
| Average Demand Per Day | 48.65 | Mean daily units demanded across all products |
| Average Availability Per Day | 24.70 | Mean daily units available across all products |
| Total Supply Shortage | 61K | Aggregate gap between demand and availability |

### Page 2 – Financial Performance

| KPI | Value | Description |
|---|---|---|
| Total Profit | 301K | Revenue earned from surplus availability (excess × unit price) |
| Total Loss | 8M | Revenue lost due to unmet demand (shortage × unit price) |
| Average Daily Loss | 2.97K | Mean financial loss per day |

---

## Filters Available

Both pages include the following interactive filters:

- **Product Name** – Filter KPIs by individual product
- **Order Date** – Filter KPIs by specific date range

---

## Insights

- Supply shortages can be identified at the product level, enabling targeted restocking decisions.
- The Loss/Profit column flags days where availability fell short of (loss) or exceeded (profit) demand.
- Total Loss (8M) far exceeds Total Profit (301K), indicating a critical and persistent supply shortage problem across the inventory.
- Average Daily Loss of 2.97K highlights the ongoing financial impact of unmet demand every single day.
- Migrating to MySQL ensures the dashboard runs on live production data, making KPIs operationally relevant.
