

create database test_env

use test_env

select * from [dbo].[Products]

select * from [dbo].[Test Environment Inventory Dataset]

select product_id from Products

select distinct product_id from [dbo].[Test Environment Inventory Dataset]

select distinct Order_Date_DD_MM_YYYY from [dbo].[Test Environment Inventory Dataset]

select distinct [Availability] from [dbo].[Test Environment Inventory Dataset]

select distinct Demand from [dbo].[Test Environment Inventory Dataset]


----------------------------------------------------------------------------------------------------------------

select * from [dbo].[Test Environment Inventory Dataset] as a
left join [dbo].[Products] as b
on a.Product_ID=b.Product_ID

select a.[Order_Date_DD_MM_YYYY] ,a.Product_ID,a.Demand,b.Product_Name,b.Unit_Price
from [dbo].[Test Environment Inventory Dataset] as a
left join [dbo].[Products] as b
on a.Product_ID=b.Product_ID

-----------------------------------------------------------------------------------------------------------------
--INSERT THE ABOVE VALUES INTO SEPERATE TABLE WHICH MAY HELP TO USE IN POWERBI NAME IT  AS New_table

select * into New_table1 from
(select a.[Order_Date_DD_MM_YYYY] ,a.Product_ID,a.Availability,a.Demand,b.Product_Name,b.Unit_Price
from [dbo].[Test Environment Inventory Dataset] as a
left join [dbo].[Products] as b
on a.Product_ID=b.Product_ID) X

----------------------------------------------------------------------------------------------------------------
--u can use this new table in powerbi 

select * from New_table1

------------------------------------------------------------------------------------------------------------------

--Creating PRODUCTION DATABASE

Create database PROD

USE PROD

Select * from [dbo].[Prod+Env+Inventory+Dataset]

Select distinct Order_Date_DD_MM_YYYY from [dbo].[Prod+Env+Inventory+Dataset]
where Order_Date_DD_MM_YYYY is null or Order_Date_DD_MM_YYYY =' '

Select distinct Product_ID from [dbo].[Prod+Env+Inventory+Dataset]
where Order_Date_DD_MM_YYYY is null or Order_Date_DD_MM_YYYY =' '


Select distinct Product_ID from [dbo].[Prod+Env+Inventory+Dataset]		--this dataset contain 22 record but product dataset contains 20n records its a mismatch or any issue if u consider that 21is 7 and 22 is 11 this is called "data quality issue"

--so we updatew the table

update [dbo].[Prod+Env+Inventory+Dataset]
set Product_ID =7 where Product_ID=21

update [dbo].[Prod+Env+Inventory+Dataset]
set Product_ID =11 where Product_ID=22

Select distinct Product_ID from [dbo].[Prod+Env+Inventory+Dataset] order by Product_ID

----

Select distinct Availability from [dbo].[Prod+Env+Inventory+Dataset]

Select distinct Demand from [dbo].[Prod+Env+Inventory+Dataset]

--------------------------------------------------------------------------------------------------------

select * into New_table1 from
(select a.[Order_Date_DD_MM_YYYY] ,a.Product_ID,a.Availability,a.Demand,b.Product_Name,b.Unit_Price
from [dbo].[Prod+Env+Inventory+Dataset] as a
left join [dbo].[Products] as b
on a.Product_ID=b.Product_ID) X

select * from New_table1