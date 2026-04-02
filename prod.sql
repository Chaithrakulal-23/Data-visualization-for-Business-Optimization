USE PROD;

Create table New_table1 as
Select 
 a.`Order Date (DD/MM/YYYY)` as `Order_Date_DD_MM_YYYY`,
 a.`Product ID` as `product_id`,
 a.Availability,
 a.Demand,
 b.`Product Name`as `product_name`,
 b.`Unit Price ($)` as `Unit_Price`
 from `prod+env+inventory+dataset` as a
left join prod.products as b
on a.`Product ID`=b.`Product ID`