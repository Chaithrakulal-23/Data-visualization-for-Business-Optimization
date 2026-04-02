# Inventory Demand & Supply Dashboard — SQL Server to MySQL Migration
 Dashboard Link - https://app.powerbi.com/links/AZhrc98Jf3?ctid=51697115-1ecd-42b5-b509-2d62c3919f76&pbi_source=linkShare&bookmarkGuid=4a27c216-8284-4f79-aa2b-a070e1e7c2c2

##  Project Overview

This project involves **transitioning Power BI reports from a SQL Server (Test Environment) to a MySQL (Production) data source**.

The dashboard tracks **inventory demand, availability, supply shortages, and financial loss/profit** across products and dates — helping businesses make data-driven inventory decisions.

---

## 🗄️ Data Sources

| Environment | Database |
|-------------|----------|
| Test | MS SQL Server (MSSQL Workbench) |
| Production | MySQL Database |

### Dataset 1 — Test Environment Inventory Dataset

| Column | Description |
|--------|-------------|
| `Order_Date_DD_MM_YYYY` | Date of the order |
| `Product_ID` | Unique product identifier |
| `Availability` | Units available |
| `Demand` | Units demanded |

### Dataset 2 — Products Dataset

| Column | Description |
|--------|-------------|
| `Product_ID` | Unique product identifier |
| `Product_Name` | Name of the product |
| `Unit_Price` | Price per unit |

![MYSQL Workbench](your-image-link-here)
---

## Steps Followed

### Step 1 — Database Setup (MSSQL)

Both Excel files were imported into MS SQL Server and the following database was created:

```sql
CREATE DATABASE test_env;
USE test_env;
```

### Step 2 — Dataset Validation

```sql
-- View raw tables
SELECT * FROM [dbo].[Products];
SELECT * FROM [dbo].[Test Environment Inventory Dataset];

-- Check distinct values
SELECT DISTINCT product_id FROM [dbo].[Products];
SELECT DISTINCT product_id FROM [dbo].[Test Environment Inventory Dataset];
SELECT DISTINCT Order_Date_DD_MM_YYYY FROM [dbo].[Test Environment Inventory Dataset];
SELECT DISTINCT Availability FROM [dbo].[Test Environment Inventory Dataset];
SELECT DISTINCT Demand FROM [dbo].[Test Environment Inventory Dataset];
```

### Step 3 — Join & Create New Table

A joined table combining both datasets was created for use in Power BI:

```sql
SELECT * INTO New_table1 FROM (
    SELECT 
        a.[Order_Date_DD_MM_YYYY],
        a.Product_ID,
        a.Availability,
        a.Demand,
        b.Product_Name,
        b.Unit_Price
    FROM [dbo].[Test Environment Inventory Dataset] AS a
    LEFT JOIN [dbo].[Products] AS b
        ON a.Product_ID = b.Product_ID
) X;

-- Verify the new table
SELECT * FROM New_table1;
```

### Step 4 — Power BI Desktop

- Connected to SQL Server and imported `New_table1`
- Opened **Power Query Editor** → checked **Column Profiling**, **Column Quality**, **Column Distribution**
- Fixed **data types** where needed
- Applied a **custom background** to the report canvas

---

## 📐 DAX Measures & Calculated Columns

### 📁 Base Measures

```dax
Total Number of Days = 
DISTINCTCOUNT('Demand/Availability Data'[Order_Date_DD_MM_YYYY].[Date])
```

```dax
Total Demand = 
SUM('Demand/Availability Data'[Demand])
```

```dax
Total Availability = 
SUM('Demand/Availability Data'[Availability])
```

### 📁 KPI Page 1 — Supply Measures

```dax
Average Demand Per Day = 
DIVIDE('Measures Table'[Total Demand], 'Measures Table'[Total Number of Days])
```

```dax
Average Availability Per Day = 
DIVIDE('Measures Table'[Total Availability], 'Measures Table'[Total Number of Days])
```

```dax
Total Supply Shortage = 
[Total Demand] - [Total Availability]
```

### 📁 Calculated Column

```dax
LOSS/PROFIT = 
'Demand/Availability Data'[Availability] - 'Demand/Availability Data'[Demand]
```

### 📁 KPI Page 2 — Financial Measures

```dax
Total Loss = 
SUMX(
    FILTER('Demand/Availability Data', 'Demand/Availability Data'[LOSS/PROFIT] < 0),
    'Demand/Availability Data'[LOSS/PROFIT] * 'Demand/Availability Data'[Unit_Price]
) * -1
```

```dax
Total Profit = 
SUMX(
    FILTER('Demand/Availability Data', 'Demand/Availability Data'[LOSS/PROFIT] > 0),
    'Demand/Availability Data'[LOSS/PROFIT] * 'Demand/Availability Data'[Unit_Price]
)
```

```dax
Average Loss Per Day = 
DIVIDE([Total Loss], [Total Number of Days])
```

---

## 📊 Dashboard Pages & KPIs

### Page 1 — Supply Overview

| KPI | Visual |
|-----|--------|
| Average Demand Per Day | Card |
| Average Availability Per Day | Card |
| Total Supply Shortage | Card |

> **Filters Applied:** Product Name, Order Date

---

### Page 2 — Financial Performance

| KPI | Visual |
|-----|--------|
| Total Loss | Card |
| Total Profit | Card |
| Average Daily Loss | Card |

> **Filters Applied:** Product Name, Order Date

---

## 🔄 Migration: Test → Production

| Stage | Details |
|-------|---------|
| Source (Test) | MS SQL Server — `New_table1` |
| Target (Production) | MySQL Database |
| Change | Update Power BI data source connection from MSSQL to MySQL |
| Schema | `Order_Date`, `Product_ID`, `Availability`, `Demand`, `Product_Name`, `Unit_Price` |

---

## 💡 Key Insights

- **Supply Shortage** highlights products where demand consistently exceeds availability
- **Total Loss** quantifies the financial impact of stock-outs using unit price
- **Total Profit** captures surplus inventory value where availability exceeds demand
- **Average Loss Per Day** provides a normalized daily view for trend monitoring
- Filters by **Product Name** and **Order Date** allow granular drill-down on both pages
