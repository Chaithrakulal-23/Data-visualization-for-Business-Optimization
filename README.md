# Data Visualization for Business Optimization

### Dashboard Link : *(https://app.powerbi.com/links/AZhrc98Jf3?ctid=51697115-1ecd-42b5-b509-2d62c3919f76&pbi_source=linkShare&bookmarkGuid=4a27c216-8284-4f79-aa2b-a070e1e7c2c2)*

---

## Problem Statement

This dashboard helps businesses analyze inventory demand and availability to identify shortages, losses, and profit opportunities. It enables better decision-making by highlighting key performance indicators such as demand trends, supply shortages, and financial impact.

The goal of this project is to:
- Monitor average demand and availability per day
- Identify supply shortages
- Analyze profit and loss based on inventory performance
- Support business decisions using data-driven insights

---

## Steps followed 

- Step 1 : Data was initially available in Excel format containing two datasets:
  - Inventory Dataset (Order Date, Product ID, Availability, Demand)
  - Product Dataset (Product ID, Product Name, Unit Price)

- Step 2 : Imported both datasets into SQL Server (MSSQL).

- Step 3 : Created database:
```sql
CREATE DATABASE test_env;
USE test_env;
```

- Step 4 : Performed data validation using SQL queries:
```sql
SELECT DISTINCT Product_ID FROM Products;
SELECT DISTINCT Product_ID FROM [dbo].[Test Environment Inventory Dataset];
SELECT DISTINCT Order_Date_DD_MM_YYYY FROM [dbo].[Test Environment Inventory Dataset];
SELECT DISTINCT Availability FROM [dbo].[Test Environment Inventory Dataset];
SELECT DISTINCT Demand FROM [dbo].[Test Environment Inventory Dataset];
```

- Step 5 : Joined datasets:
```sql
SELECT a.Order_Date_DD_MM_YYYY, a.Product_ID, a.Availability, a.Demand,
       b.Product_Name, b.Unit_Price
FROM [dbo].[Test Environment Inventory Dataset] a
LEFT JOIN [dbo].[Products] b
ON a.Product_ID = b.Product_ID;
```

- Step 6 : Created new table for Power BI:
```sql
SELECT * INTO New_table1 FROM (
    SELECT a.Order_Date_DD_MM_YYYY, a.Product_ID, a.Availability, a.Demand,
           b.Product_Name, b.Unit_Price
    FROM [dbo].[Test Environment Inventory Dataset] a
    LEFT JOIN [dbo].[Products] b
    ON a.Product_ID = b.Product_ID
) X;
```

- Step 7 : Loaded data into Power BI Desktop using SQL Server connector.

- Step 8 : In Power Query:
  - Checked column profiling
  - Fixed data types
  - Validated data quality

- Step 9 : Created DAX measures for KPIs.

---

## DAX Measures

### Page 1 KPIs

```dax
Total Number of Days = DISTINCTCOUNT('Demand/Availability Data'[Order_Date_DD_MM_YYYY].[Date])
```

```dax
Total Demand = SUM('Demand/Availability Data'[Demand])
```

```dax
Total Availability = SUM('Demand/Availability Data'[Availability])
```

```dax
Average Demand Per Day = DIVIDE([Total Demand], [Total Number of Days])
```

```dax
Average Availability Per Day = DIVIDE([Total Availability], [Total Number of Days])
```

```dax
Total Supply Shortage = [Total Demand] - [Total Availability]
```

---

### Page 2 KPIs

```dax
LOSS/PROFIT = 'Demand/Availability Data'[Availability] - 'Demand/Availability Data'[Demand]
```

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
Average Loss Per Day = DIVIDE([Total Loss], [Total Number of Days])
```

---

## Visualizations

### Page 1
- Card visuals:
  - Average Demand Per Day
  - Average Availability Per Day
  - Total Supply Shortage

- Filters (Slicers):
  - Product Name
  - Order Date

---

### Page 2
- Card visuals:
  - Total Profit
  - Total Loss
  - Average Loss Per Day

- Filters (Slicers):
  - Product Name
  - Order Date

---

## Snapshot of Dashboard (Power BI Service)

![Dashboard Snapshot](Add your image link here)

---

## Report Snapshot (Power BI Desktop)

![Report Snapshot](Add your image link here)

---

## Insights

### [1] Demand vs Availability
- Helps identify whether supply meets demand
- Highlights shortage situations

### [2] Supply Shortage
- Indicates unmet demand
- Useful for inventory planning

### [3] Profit & Loss
- Profit when availability > demand
- Loss when demand > availability

### [4] Daily Trends
- Average metrics help in forecasting and decision-making

---

## Conclusion

This project demonstrates an end-to-end data analytics workflow by integrating SQL Server with Power BI. It provides insights into inventory performance, helping businesses reduce losses and improve supply planning through interactive dashboards.
