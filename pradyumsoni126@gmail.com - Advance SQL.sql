--SQL Advance Case Study


--Q1--BEGIN 
select [State] from [dbo].[FACT_TRANSACTIONS] as T 
inner join [dbo].[DIM_LOCATION] L on T.[IDLocation] = L.[IDLocation]
where year([Date])>2004 group by [State]

--Q1--END

--Q2--BEGIN
select top 1 [State], sum([Quantity]) as Sold_Count_of_Samsung_Cellphone from [dbo].[FACT_TRANSACTIONS] T 
inner join [dbo].[DIM_MODEL] M on t.[IDModel] = m.[IDModel] 
inner join [dbo].[DIM_MANUFACTURER] MA on MA.[IDManufacturer] = M.[IDManufacturer] 
inner join [dbo].[DIM_LOCATION] L on T.[IDLocation] = L.[IDLocation] 
where [Manufacturer_Name] = 'Samsung' group by [State], [Manufacturer_Name] order by sum([Quantity]) desc


--Q2--END

--Q3--BEGIN      
select [Model_Name], [ZipCode], [State], count(*) as No_of_Transaction from [dbo].[FACT_TRANSACTIONS] t 
inner join [dbo].[DIM_MODEL] m on t.[IDModel] = m.[IDModel]
inner join [dbo].[DIM_LOCATION] l on t.[IDLocation] = l.[IDLocation] 
group by [Model_Name], [ZipCode], [State]


--Q3--END

--Q4--BEGIN
select top 1 [Model_Name], [Unit_price] as Price from [dbo].[DIM_MODEL] m order by [Unit_price]


--Q4--END

--Q5--BEGIN
select [Model_Name], sum([TotalPrice])/ sum([Quantity]) as Avg_Price from FACT_TRANSACTIONS 
inner join DIM_MODEL on FACT_TRANSACTIONS.[IDModel] = DIM_MODEL.[IDModel]
inner join DIM_MANUFACTURER on DIM_MODEL.[IDManufacturer] = DIM_MANUFACTURER.[IDManufacturer]
where [Manufacturer_Name] in (select [Manufacturer_Name] from (select top 5 [Manufacturer_Name], sum([Quantity])[SALES QUANTITY] from FACT_TRANSACTIONS 
inner join DIM_MODEL on FACT_TRANSACTIONS.[IDModel] = DIM_MODEL.[IDModel]
inner join DIM_MANUFACTURER on DIM_MODEL.[IDManufacturer] = DIM_MANUFACTURER.[IDManufacturer]
group by [Manufacturer_Name] order by sum([Quantity]) desc)T1) 
group by [Model_Name] order by avg([TotalPrice])



--Q5--END

--Q6--BEGIN
select [Customer_Name], avg([TotalPrice]) as Avg_Amt_spent from [dbo].[FACT_TRANSACTIONS] t 
inner join [dbo].[DIM_CUSTOMER] c on t.[IDCustomer] = c.[IDCustomer]
where year([Date])=2009 
group by [Customer_Name] 
having avg([TotalPrice])>500


--Q6--END
	
--Q7--BEGIN  
select [Model_Name] from (select top 5 [Model_Name], sum([Quantity])[QUANTITY] from [dbo].[FACT_TRANSACTIONS] t 
inner join [dbo].[DIM_MODEL] m on t.[IDModel] = m.[IDModel]	
where year([Date])=2008 group by [Model_Name] order by sum([Quantity]) desc) n
INTERSECT
select [Model_Name] from (select top 5 [Model_Name], sum([Quantity])[QUANTITY] from [dbo].[FACT_TRANSACTIONS] t 
inner join [dbo].[DIM_MODEL] m on t.[IDModel] = m.[IDModel]
where year([Date])=2009 group by [Model_Name] order by sum([Quantity]) desc) n
INTERSECT
select [Model_Name] from (select top 5 [Model_Name], sum([Quantity])[QUANTITY] from [dbo].[FACT_TRANSACTIONS] t 
inner join [dbo].[DIM_MODEL] m on t.[IDModel] = m.[IDModel]	
where year([Date])=2010 group by [Model_Name] order by sum([Quantity]) desc) n
	


--Q7--END	

--Q8--BEGIN
select [Manufacturer_Name], [Year] from (select top 1 [Manufacturer_Name], [YEAR] from (select top 2 [Manufacturer_Name], year([Date])[YEAR], sum([TotalPrice])[SALES] from FACT_TRANSACTIONS 
inner join DIM_MODEL on FACT_TRANSACTIONS.[IDModel] = DIM_MODEL.[IDModel]
inner join DIM_MANUFACTURER on DIM_MODEL.[IDManufacturer] = DIM_MANUFACTURER.[IDManufacturer] 
where year([Date])=2009
group by [Manufacturer_Name], year([Date]) 
order by sum([TotalPrice]) desc)T1 order by [SALES])T3
UNION 
select [Manufacturer_Name], [Year] from (select top 1 [Manufacturer_Name], [YEAR] from (select top 2 [Manufacturer_Name], year([Date])[YEAR], sum([TotalPrice])[SALES] from FACT_TRANSACTIONS 
inner join DIM_MODEL on FACT_TRANSACTIONS.[IDModel] = DIM_MODEL.[IDModel]
inner join DIM_MANUFACTURER on DIM_MODEL.[IDManufacturer] = DIM_MANUFACTURER.[IDManufacturer] 
where year([Date])=2010
group by [Manufacturer_Name], year([Date]) 
order by sum([TotalPrice]) desc)T1 order by [SALES])T4 order by [YEAR]




--Q8--END

--Q9--BEGIN
select [Manufacturer_Name] from (select [Manufacturer_Name], year([Date])[YEAR] from FACT_TRANSACTIONS 
inner join DIM_MODEL on FACT_TRANSACTIONS.[IDModel] = DIM_MODEL.[IDModel]
inner join DIM_MANUFACTURER on DIM_MODEL.[IDManufacturer] = DIM_MANUFACTURER.[IDManufacturer]	
where year([Date])=2010
group by [Manufacturer_Name], year([Date]))T5
EXCEPT
select [Manufacturer_Name] from (select [Manufacturer_Name], year([Date])[YEAR] from FACT_TRANSACTIONS 
inner join DIM_MODEL on FACT_TRANSACTIONS.[IDModel] = DIM_MODEL.[IDModel]
inner join DIM_MANUFACTURER on DIM_MODEL.[IDManufacturer] = DIM_MANUFACTURER.[IDManufacturer]	
where year([Date])=2009
group by [Manufacturer_Name], year([Date]))T6


--Q9--END

--Q10--BEGIN
select top 100 [Customer_Name], avg([TotalPrice]) as Avg_Spent, avg([Quantity]) as Avg_Qty, year([Date]) as Year,
(((avg([totalprice]) - lag(avg([totalprice]))
over(partition by [Customer_Name] order by [Customer_Name], year(date)))
/lag(avg([totalprice])) 
over(partition by [customer_name] order by [customer_name], year(date)))*100) as percent_change
from [dbo].[FACT_TRANSACTIONS] t inner join [dbo].[DIM_CUSTOMER] c on t.[IDCustomer] = c.[IDCustomer]
group by [Customer_Name],year([Date]) order by [Customer_Name], year([Date]), avg([TotalPrice]) desc




--Q10--END