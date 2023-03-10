/* DML */
/* SELECT 敘述 (SELECT statement) */
-- SELECT STATEMENT Syntex 

 SELECT [ ALL | DISTINCT ]
 [ TOP expression [ PERCENT ] [ WITH TIES ] ] <select_list>
 [INTO new_table_name]
 FROM <table_source >
 [WHERE <search_condition>]
 [GROUP BY <grouping column list>]
 [HAVING <having condition>]
 [ORDER BY <order_expression> [ASC|DESC]]
 [COMPUT <expression>]
 
 <select_list>::=
	{*
	 |{table_name|view_name|table_alias}.*
	 |{column_name|IDENTITYCOL|ROWCUIDCOL|expression}
	  [[AS] column_alias]
	}[,...n]

---------------------------------------------------------------------------------
/* about select statemnet */
 --指定欄位名稱
   -- *
   -- column_name,column_name,...
   -- expression
---------------------------------------------------------------------------------

/* simple example: database 'pubs'  table authors  */
use pubs
go
select au_id, au_lname,au_fname,state,city
from  authors
where state='MI'
----------------------------------------------------------------------------------

/* fill data with select statement */
select 'abc'

select 'abc' from dual -- for oracle 

select 5

select 5+5

select 3+5*3-2

  --進階用法:
select 1+(select count(*) from titles) 
--------------------------------------------------

use pubs
go

select au_id
from authors

select '作者代號',au_id
from authors

-- 練習:
-- 請寫出可產生下列查詢結果的SQL script

------------------------------
作者代號409-56-7008
作者代號648-92-1872
作者代號238-95-7766
...

-- 解答: 
select ...

----------------------------------------------------------------

/* select all fields -->  '*'  */
select * 
from authors
where state='MI'

  -- 練習:列印出 database:adventureworks table:humanresources.employee 所有資料
  -- 解答:
          
----------------------------------------------------------------------------------
  

/* select all fields and all records */
select * 
from authors
----------------------------------------------------------------------------------

/* Renaming columns in Query Results */      -- Query Result 處理方式
  -- 原始查詢
use pubs
go

select au_id,au_lname,au_fname,city,state
from authors
where state='CA'

  -- title renaming (1) 
select au_id 作者ID, au_lname 名,au_fname 姓, city,state
from authors
where state='CA'

  -- or (只 SQL Server 支援)
select  作者ID=au_id, 名=au_lname, 姓=au_fname, city,state
from authors
where state='CA'

  -- or   (正規)
select au_id as 作者ID, au_lname as 名,au_fname as 姓, city,state
from authors
where state='CA'
----------------------------------------------------------------------------------

/* 字串結合運算元 */

USE pubs
go

SELECT * FROM authors 

SELECT au_lname+' '+ au_fname AS 姓名
FROM authors

SELECT au_lname+' '+ au_fname AS [name]
FROM authors

SELECT '作家' AS 抬頭, au_lname+' '+ au_fname AS 姓名
FROM authors 

-- 練習:
  -- 請寫出可產生下列查詢結果的SQL script

                   姓名                                                            
--------     ------------------------------ 
作家姓名     Bennet Abraham
作家姓名     Blotchet-Halls Reginald
作家姓名     Carson Cheryl
作家姓名     DeFrance Michel
 ...            ...


-- 解答:
SELECT ...
FROM authors     
---------------------------------------------------------------------------------

/* P/L SQL */ 
SELECT EMP_NAME || ',' || SEX AS TEST_TITLE
---------------------------------------------------------------------------------

/* 數學運算元 */

USE pubs
go

SELECT title_id as 書號, title as 書名, price as 單價
FROM titles

SELECT title_id as 書號, title as 書名, price as 原價, price*0.8
FROM titles



--練習:
  -- 請寫出可產生下列查詢結果的SQL script
/*
折扣   書號     書名                                                                               原價                    折扣價                     
-----  -------  ----------------------------------------------------------------------- --------------------- ----------------------- 
八折   BU1032   The Busy Executive's Database Guide                                 19.9900               15.99200
八折   BU1111   Cooking with Computers: Surreptitious Balance Sheets         11.9500               9.56000
八折   BU2075   You Can Combat Computer Stress!                                     2.9900                2.39200
八折   BU7832   Straight Talk About Computers                                          19.9900               15.99200
八折   MC2222   Silicon Valley Gastronomic Treats                                     19.9900               15.99200
 ...

*/

--解答:
select '八折' as 折扣, title_id as 書號, title as 書名, price as 原價, price*0.8 as 折扣價
from titles

--練習:
  -- 請寫出可產生下列查詢結果的SQL script
/*
                                  pub_name                                 
------------------------    ---------------------------------------- 
the publisher's name is     New Moon Books
the publisher's name is     Binnet & Hardley
the publisher's name is     Algodata Infosystems
the publisher's name is     Five Lakes Publishing
the publisher's name is     Ramona Publishers
...

*/

--解答:
select 'the publisher''s name is' as ' ' , title as pub_name
from titles

---------------------------------------------------------------------------------

/* Eliminating Duplicate Query Result with DISTINCT */
use pubs 
go 

use Northwind
select *from Suppliers;

select count (distinct Country)
from Suppliers;

select count (distinct Country)
from Suppliers
where Country is not null;

select count (distinct CustomerID)
from Orders
where  year (OrderDate) = 1997;


/* question 1: 請問書局(store)分布在幾個州(state)內
    from table stores
*/
select state
from stores
  -- with distinct
select distinct state
from stores
-------------------------------------------
--with count() function

select count(state)
from stores
  -- with distinct
select count(distinct state) 
from stores
----------------------------------------------------------------------------------
--homework:
  distinct 如何處理 null 值 ?
  
----------------------------------------------------------------------------------
/* alias of table name */
use pubs
go

select pub_id,pub_name
from publishers

select p.pub_id, p.pub_name
from publishers p

select p.pub_id, t.title_id
from publishers as p, titles as t;

select pub_id, p.pub_name
from publishers p          --可以，但是儘量不要如此用

  
  -- example of two tables
select a.title_id, a.title, b.pub_name, b.state
from  titles a, publishers b
where a.pub_id = b.pub_id and
       b.state='CA'
================================================================
/* 關於 FROM 子句
   FROM \\Server_Name\DatabaseName.SchemaName.TableName(or ViewName)
   1.Database 未指定時依SSMS物件總管連結之資料庫
   2.Schema 未指定時以 default schema (大多是 dbo)   
*/
================================================================
/***************************************************************
 *                                                                                                            *
 *       Selecting Rows: the WHERE clause                                       *
 *                                                                                                             *
 ****************************************************************/
-- 1. WHERE search_condition
-- 2. search condition 中設定的資料行，可以不用出現在 select_list中。
   --example:
   USE AdventureWorks 
   GO
   SELECT ProductID,[Name]   
   FROM Production.Product
   WHERE ListPrice = 0
------------------------------
/* Searching Condition: 7種 */
  　-- 1. Comparsion (比較運算)
    -- 2. Range (範圍)
    -- 3. List (列舉)
    -- 4. String Matching (字串比對)
    -- 5. Null
    -- 6. Joins
    -- 7. Subquery

use pubs
go

  /* 1. Comparsion */
  -- =, >, < , !=,  <>, !>, !< ,>=, <=, 
  --and,or,not 
  -- example 1:
use pubs
go

select * 
from titles
where  price > 20

  --英文字母
select a.au_lname, a.au_fname
from authors a
where a.au_lname > 'McBodden'

  --組合
select title_id, title, type, advance
from titles
where (type='business' or type='psychology')
          and advance < 5500

-- 比較
select title_id, title, type, advance
from titles
where type='business' or type='psychology'
          and advance < 5500

-- 練習:AdventureWorks.Production.Product, 找出listprice小於200
        且listprice不為零的產品 productid,name,listprice
-- 解答:
        USE AdventureWorks;

		select productid, name, listprice
		from Production.Product
		where listprice < 200;
------------------------------------------------------------------------------
-- 進階練習: Adventureworks.HumanResources.Employee 找出12月份壽星
             (hints: DATEPART() )
-- 解答: 
         USE AdventureWorks 

		 select  *
		 from HumanResources.Employee
		 where DATEPART (month,BirthDate) = 12; 

		 select *
		 from HumanResources.Employee
		 where month (BirthDate) = 12;
---------------------------------------------------------------------
-- 更進階練習:Adventureworks.HumanResources.Employee 找出下個月份壽星
             (hints: DATEPART(),GETDATE(),MONTH(),DATEADD() )
-- 解答:
         USE AdventureWorks 
         GO
         SELECT ......   
--------------------------------------------------------------------------
               
 /*2.  range   --> between /not between */
-- <value expression>[NOT] BETEEN <low value expression> AND <high vaule expression>
-- 端點注意事項(SQL Server 2005 與 oracle)
    -- between >= =<, not between < >

-- example1:
use pubs
go

select title_id,ytd_sales
from titles
where ytd_sales between 4095 and 12000

-- example2:
use pubs 
go

select *
from titles;

select title_id,ytd_sales
from titles
where ytd_sales not between 4095 and 12000
  
  --練習: 將example2 改寫為 comparsion
  
  -- 解答:
select title_id,ytd_sales
from titles
where (  ytd_sales< 4095 or  ytd_sales>12000);

  
  -- 注意 NOT BETWEEN 會降低系統執行效率，儘量少用。
  --------------------------------------------------------------------------
  --習題: AdventureWorks.HumanResources.Employee, 找出員工入廠日期(HireDate)
          介於 1997-1-1 ~1997-12-31 

  -- 解答: 
  use AdventureWorks
  select *
  from HumanResources.Employee
  where year (HireDate) = 1997;
  go

  select EmployeeID,HireDate
  from HumanResources.Employee
  where  HireDate between '1997-1-1' and '1997-12-31';
    
---------------------------------------------------------------------------------------

   /*3. List  --> IN / NOT IN */
use pubs
go 

  -- example 1:
select au_lname, state
from authors
where state in ('CA','IN','MD')
  
  --練習: 加州(CA)、印第安那州(IN)以外地區作者
select au_lname, state
from authors
where state not in ('CA','IN');

  -- 注意 NOT IN 會降低系統執行效率，儘量少用。
  ----------------------------------------------------------------
-- example 2: northwind料庫中找出產品(products)的供應商(suppliers)
              國籍(country)是('Canada','Australia','Germany')
              的產品代號(productid),產品名稱(productname),及供應商代號(supplierid)
   use Northwind 
   go

   
   select productid,productname,supplierid 
   from products
   where SupplierID in ( 
                        select SupplierID 
                        from suppliers 
                        where Country in ('Canada','Australia','Germany'))                
  ------------------------------------------------------------------------
  --練習:承上題，找出有上述國籍('Canada','Australia','Germany')
         供應商供應商品的訂單單號 (hints:[Order Details])
  
  --解答:  
    use Northwind 
    go
    
	select *
	from [Order Details];

    select distinct OrderID 
    from [Order Details]  
    where ProductID in   (
							select ProductID
							from Products
							where supplierid in (
											select supplierid
											from Suppliers
											where Country in  ('Canada','Australia','Germany'))
											);
-----------------------------------------------------------         

   /* 4. String Pattern-Matching --> LIKE / NOT LIKE  */
   
   -- 萬用字元說明:
      1. [%]
      2. [_]
      3. [-]
      4. [^]  
         
-- example1: [%] 
use pubs
go 

select au_id,phone
from authors
where phone like '415%'

--習題  電話號碼包含 '24'
--解答:

select au_id,phone
from authors
where phone like '%24%'


--example2: [_] 
select au_id,au_lname,au_fname,zip 
from authors
where (zip like '94_18')

--練習: (pubs.authors  phone  ??????...7??3
--解答:
select au_id,au_lname,au_fname,phone
from authors
where (phone like '%7__3')

--example3:[-]
select au_id,au_lname,au_fname
from authors
where (au_lname like '[A-D]%')

--example4:[^] (au_lname 不為A-D開頭)
select au_id,au_lname,au_fname
from authors
where (au_lname like '[^A-D]%')
      
--練習:database:advertureworks, table:Production.Product
       查詢產品名稱第一個字是'A'或'B'或'C'開頭，但第二個字
       不是'h'的產品。
--解答:
use AdventureWorks 

select Name
from Production.Product
where (Name like '[A-C][^h]%');
go


-------------------------------------
--進階討論1:like pattern %, _  效率
-- example:
use AdventureWorks
go

select ProductID,OrderQty
from Sales.SalesOrderDetail
where (CarrierTrackingNumber like '%-403c-98')

select ProductID,OrderQty
from Sales.SalesOrderDetail
where (CarrierTrackingNumber like '_-403c-98')
      or(CarrierTrackingNumber like '__-403c-98')
      or(CarrierTrackingNumber like '___-403c-98')
      or(CarrierTrackingNumber like '____-403c-98')

--進階討論2:字串比較時，大小寫區分問題
  1.資料庫定序中(collate)如果包含_CS --> CASE SENSITIVE
  2.資料庫定序中(collate)如果包含_CI --> CASE INSENSITIVE
  -- example:
     --create database:dbcs (collate _CS)
     CREATE DATABASE dbci
     COLLATE Chinese_Taiwan_Stroke_CS_AS 
     GO
	 drop database dbci;
     
     USE dbci
     GO
     
     -- create table t1
     CREATE TABLE t1
     (p_id INT,
      p_name VARCHAR(30))
     GO
     
     --insert data into table t1
     INSERT INTO t1 VALUES(11, 'Broker');
     INSERT INTO t1 VALUES(12, 'BROKER'); 
     
	 select * from t1;
     --test (case sensitive)
     SELECT * FROM t1
     WHERE p_name LIKE 'Br%'
        
        --只有第一筆符合
     --練習:測試 case insensitive
---------------------------------------------------------------------
  /*5. null --> IS NULL / IS NOT NULL */
 use pubs; 

select title_id, title, price
from titles
where price is null

-- 小心!
select au_id,au_lname,au_fname
from authors
where au_fname ='null' 
    --語法(syntax) 沒錯,但語意(semantic)卻完全不同。


--習題: 找出 advance 小於5000或未知的書
--解答:
select *
from titles
where (advance < 5000 or advance is null); 
--------------------------------------------------------------------------
          
--進階討論: 當資料中包含null值時，邏輯與比較運算子會傳回第三種結果
            (UNKNOW) 而非只有TRUE或FALSE
   -- example:
      USE Northwind
      GO
      
      SELECT * FROM Employees WHERE Region is null 
      GO   -- Region is null 的員工資料
      
      SELECT EmployeeID,'居住地'+Region
      FROM Employees  --null+everything --> null
        
                
-------------------------------------------------------------------------------

/************************************************************
 *                                                                           *
 *           Built_in Function / Aggregate Function     *
 *                                                                           *
 ************************************************************/

/* Single-row Functions */
 -- UPPER(), LOWER()
 -- Example:
use pubs
go 

SELECT UPPER(city) 城市, LOWER(au_lname) 名
FROM authors
WHERE state like '%CA%'
---------------------------------------------------------------------  
 
/* aggregate function */
   --count()
   --sum()
   --avg()
   --max()
   --min()

-- simple example:
use pubs
go 

select count(*) 數量,
          avg(price) 平均單價 ,
          sum(ytd_sales) 銷售總量,
          max(price) 最高單價,
          min(price) 最低單價
from titles
where advance > 1000

select *
from titles
where advance > 1000

use Northwind
select  count (distinct CustomerID)
from Orders
where year (OrderDate)= 1997;

select  count (distinct OrderID)
from Orders
where CustomerID in 
	(
		select CustomerID
		from Customers
		where  Country = 'USA'
	) and  year (OrderDate)= 1997;
-----------------------------------------

/* COUNT() */
   -- cardinatity 計數 COUNT(*)
   -- expression 計數 COUNT(field | expression)
use pubs 
go 

select * from titles 

  -- count(*)   count rows of query result
select count(*) 
from titles
 
  -- count(filed) count number of not null value   
select count(title_id)
from titles

select count(price)   --about null
from titles
---------------------------------------------
/* count  with distinct */
-- example: (1997 年有幾家客戶下訂單, northwind.order) 
use northwind
go

select count(customerid)
from orders
where year(orderdate) = 1997     --???
  
-- 正解: 
select count(distinct customerid)
from orders
where year(orderdate) = 1997

 -- 練習: (pubs.sales, 1994 年有幾家書局(stor_id) 下過訂單) 
 -- 解答:
 use pubs
 go 

 
-----------------------------------------------------------

/* SUM() */ 
  -- SUM(<value expression>) 
  -- SUM(DISTINCT <value expression>) 
  
  -- example: 
  use northwind
  go

  sp_help orderdetail 

  select * from [Order Details];

    --聚合函數只會顯示一筆、只會在where後才執行
  select count(*) as 項次數, sum (UnitPrice * Quantity) as 總計
  from [Order Details]
  where OrderID = 10399;

  select count(distinct ProductID) as  ProductID,
			  max(UnitPrice) as '最高價',
			  min(UnitPrice) as '最低價',
			  round (avg(UnitPrice), 2) as '平均值'
  from Products
  where SupplierID in (
				select SupplierID
				from Suppliers
				where Country ='USA');

  select sum(unitprice*quantity) as '訂單: 10743 總金額'
  from orderdetail
  where orderid=10743 
---------------------------------------------------------------------------- 
/* AVG() */
   -- AVG([ALL]<value expression>) 
   -- AVG(DISTINCT<value expression>) 

   -- example:(AdventureWorks.Sales.SalesOrderDetail, 產品 777 的平均單價)
   use AdventureWorks
   go

   select avg(unitprice) as 平均單價
   from Sales.SalesOrderDetail
   where productid=777
   
   -- 練習: avg() = sum()/count(*) ? (pubs.titles, 書籍價格(price) ), why?
   use pubs
   go

   select avg(price) 
   from titles
          -- 14.7662
   select sum(price)/count(*)
   from titles
          -- 13.1255
-------------------------------------------
                        -- 進階討論: 平均數，眾數，中位數

/* Extrema function: MIN(), MAX() */
  --example1:
    use AdventureWorks
    go

    select max(listprice),min(listprice) 
    from Production.Product

    select max(SellStartDate) as [max], min(SellStartDate) as [min]
    from Production.Product

    select max(Name) as [max], min(Name) as [min]
    from Production.Product
--------------------------------------------------------------------
  -- 練習1: 找出listprice 不為零的最便宜的產品 listprice
               (AdventureWorks.Production.Product)
     -- 解答:
   select min (listprice)
   from Production.Product
   where listprice >0;
     
  -- 練習2: 將練習一中的產品列出產品代號(productid) 及名稱(name)
     -- 解答:
     select productid,name,listprice
     from Production.Product
     where listprice in (
					select min (listprice)
					from Production.Product
					where listprice > 0
					);
-------------------------------------------------------------
  
  --習題:找出比平均單價還貴的書 (pubs.titles)
      --解答:
  --加重習題: 找出比心理學類最貴的書還貴的書(pubs.titles) 　 
     -- 解答:
 use pubs;

select title_id,title, price
from titles
where price >(
	select max(price)
    from titles
    where type='psychology'
	);
------------------------------------------------------------------------
/* 進階討論 */
/* about  aggregate function: */
use pubs
go 

select price 
from titles
where price>100
     -- (0 個資料列受到影響)

select avg(price)
from titles
where price>100
    -- (1 個資料列受到影響)
-------------------------------------------------------------
  
/***************************************************
 *         Null processing --> NVL()                               *
 ***************************************************/
/* NVL() Function  -- oracle only*/
select emp_id, nvl(salary,0) as salary
from employee;

================================================
/*******************************************************
 *                                                                                             *
 *    Sorting Query Result: ORDER BY 		                        *
 *                                                                                             *
 *******************************************************/

/* example 1 */
use pubs
go 

select price,title,pub_id
from titles

--isnull (如果是null，就改成0)
select isnull(price,0) as price,title,pub_id
from titles
order by price asc

--第一欄位由小到大排序
--如第一欄同值則第三欄由大到小
select isnull(price,0) as price,title,pub_id
from titles
order by 1 asc, 3 desc
---------------------------------------------

  -- 昇冪  (Sort Up)
select price,title,pub_id
from titles
order by price asc
----------------------------------------------

  -- 降冪 (Sort Down)
select price,title,pub_id
from titles
order by price desc
----------------------------------------------

  -- sorts within sorts 
select price, title_id,pub_id
from titles
where price is not null
order by price desc, pub_id asc
----------------------------------------------

   --Sort  --> what about Expressions ?
select pub_id, price*ytd_sales ytd_total, title_id
from titles   -- not sort
---------------------------------------------------------------

   -- sort by price*ytd_sales use column order 2
select pub_id, price*ytd_sales ytd_total, title_id
from titles  
order by 2 desc,pub_id asc
---------------------------------------------------------------
   -- sort by price*ytd_sales use column title ytd_total  
select pub_id, price*ytd_sales ytd_total, title_id
from titles 
order by ytd_total desc,pub_id asc
--------------------------------------------------------------------------
   -- 練習: (AdventureWorks.Sales.SalesOrderDetail), 依產品代號(productid) 由小到大排序
   --           產品代號相同者依數量(orderqty) 由大到小排序 
   -- 解答:
use AdventureWorks
select  productid,  orderqty
from Sales.SalesOrderDetail
order by productid asc, orderqty desc
go


-------------------------------------------------------------------------------------------
  -- ORDER BY WITH TIES
     --WITH TIES 是平手的意思, 當要顯示的資料在排序時有平手的狀況時, 則一併顯示出來 
     --example:
       USE Northwind 
       GO

	   --搜尋前三筆
	   select top(3)* from Products
	   --搜尋前10趴
	   select top(10) percent* from Products

       
       SELECT ProductID,ProductName,UnitPrice 
       FROM Products
       
       SELECT ProductID,ProductName,UnitPrice 
       FROM Products 
       ORDER BY UnitPrice DESC
       
       SELECT TOP 11 ProductID,ProductName,UnitPrice 
       FROM Products 
       ORDER BY UnitPrice DESC  -- (11 個資料列受到影響)
       
	   --取前11位，如有相同值，加上with ties會顯示出來
       SELECT TOP 11 WITH TIES ProductID,ProductName,UnitPrice 
       FROM Products 
       ORDER BY UnitPrice DESC  -- (12 個資料列受到影響)
       
         /*
           .
           .
           .
           27	Schoggi Schokolade	43.90
           63	Vegie-spread	    43.90    第11筆及12筆平手要一起列出        
         */
-----------------------------------------------------------------------
  --homework 1: ORDER BY 如何處理 NULL 值 (最大還是最小還是不理會?)  
  --homework 2: 如果沒有 ORDER BY, 查詢結果是依甚麼順序出現?           
-----------------------------------------------------------------------

/* ORDER BY 進階討論: ORDER BY ... COLLATE (定序問題討論)*/
  --使用ORDER BY 排序是依欄位預設COLLATION排
  --如果臨時要依某特定COLLATION排序，可以 ORDER BY ... COLLATE
  --example:
    use Northwind
    go
    
    --step 1: 查詢database northwind 的collation
    sp_helpdb northwind 
     ...
     Collation=Chinese_Taiwan_Stroke_CI_AS,...
      
    --step 2: create table test2
    create table dbo.test2
    (c_id char(5),
     city nvarchar(10)); 
     
    --step 3: insert data into table test2
    insert into dbo.test2
    values ('C0001',N'高雄'),
           ('C0002',N'台北'),
           ('C0003',N'嘉義'),
           ('COOO4',N'雲林')
          
    --step 4: select with order by
    select * from dbo.test2 order by city       
    
   c_id  city
   ----- ----------
   C0002 台北
   C0001 高雄
   COOO4 雲林
   C0003 嘉義       /* 以筆畫(stroke)排序 (預設) */

   (4 個資料列受到影響)

   --step 5: select with order by with collate 
   select * from dbo.test2 
   order by city collate Chinese_Taiwan_BOPOMOFO_CI_AS
   
   c_id  city
   ----- ----------
   C0002 台北
   C0001 高雄
   C0003 嘉義
   COOO4 雲林       /* 以注音(BOPOMOFO)排序 (COLLATE) */

   (4 個資料列受到影響)
      

=======================================================================       
/******************************************************************
 *                                                                                                                 *
 *     Grouping Data and Reporting from it :GROUP BY                    *
 *                                                                                                                 *
 *******************************************************************/

/* GROUP BY Syntax 
   select select_list
   from table_list
   [where conditions]
   [group by group_by_list]
   [order by order_by_list]
*/
/* GROUP BY 搭配 聚合函數 */
/* 聚合函數: count(),avg(),sum(),max(),min() */
   
----------------------------------------------------------------------------
use pubs
go
-- 參考
select * from titles order by type

select title_id,type price
from  titles
group by type


select type,price from titles
group by type     --X

select type,avg(price) as 平均單價 ,count(*) as 數量
from titles
group by type

select type,avg(price) as 平均單價 from titles
group by type

select pub_id,sum(ytd_sales) as 年銷售總量 from titles
group by pub_id

--Q1: 1997年每個客戶的訂單數
use Northwind;
select CustomerID, count(*) as 數量
from Orders
where year(OrderDate)= 1997
group by CustomerID
--Q2: 1997年VIP訂單數前三名,客戶代號,訂單數
-- 參考
select CustomerID as 客戶代號, count(*) as 訂單數
from Orders
where year(OrderDate)= 1997
group by CustomerID
order by 訂單數 desc

select zcustomerID, Empl

select * from titles
order by pub_id
----------------------------------------------------------
-- example1: 每家 publishers 出版書有幾類 (pubs.titles)
use pubs
go 

select pub_id,count(type) from titles
group by pub_id

 -- 原始資料
select * from titles order by pub_id

 -- 這樣才對
select pub_id,count(distinct type) from titles
group by pub_id
------------------------------------------------------------------------------

/* groups within group */
--example2: 每個 publishers 出版書各類各有幾本
select pub_id,type,count(type) 數量
from titles
group by pub_id, type

/* 錯誤示範 */
select pub_id, type, count(type) from titles
group by pub_id

--example2-1:接單員工/客戶 訂單統計 (norwind..orders)
use Northwind
go

select EmployeeID,CustomerID,COUNT(*) as 訂單數 
from Orders
group by EmployeeID,CustomerID
order by 1,2

select isnull (str(employeeid),'總計'), isnull (str(year (OrderDate)),'小計'),count(*)
from orders
group by  employeeid, year (OrderDate)
with rollup --統計

select year (OrderDate),employeeid,customerid,count(*)
from orders
group by  year (OrderDate),employeeid,customerid
order by 1,2 asc
with rollup --統計

select customerid, count(*)
from orders
group by customerid
order by 2 asc

      -- query result:
      EmployeeID  CustomerID 訂單數
      ----------- ---------- -----------
       1           ALFKI      2
       1           ANTON      1
       1           AROUT      3    /*1號員工接過 AROUT客戶 3張單*/
       ...
       2           BONAP      1
       2           BOTTM      2    /*2號員工接過 BOTTM客戶 2張單*/
       2           BSBEV      1
       ...

-- 練習:  AdventureWorks.Sales.SalesOrderHeader 
         (客戶代號 CustomerID/ 接單員工 SalesPersonID) 訂單數統計
      
-- 解答:
   use AdventureWorks
   go   
   

   
   -- query result:
   CustomerID  SalesPersonID 訂單數
   ----------- ------------- -----------
   1           280           4
   2           283           8
   3           275           6
   3           277           6
   ...
  
----------------------------------------------------------------------------

/* group by without aggregate function */
select pub_id from titles
group by pub_id

-- 練習: 各類書的平均單價和年度總銷售量(pubs.titles) */
  --解答:


-- 練習: (northwind.orders) 各客戶(CustomerID)訂單數(由多到少排序)
   -- 解答:
      USE Northwind 
      GO
      
      
      
   -- QUERY RESULT:
      CustomerID 訂單數
      ---------- -----------
      SAVEA      28
      ERNSH      24
      QUICK      22
      FOLKO      16 
      ...
---------------------------------------------------------------------------
--進階練習:上題練習中，查詢結果只看到客戶代號(CustomerID),請修改查詢statement
           令客戶公司名稱亦可顯示(Customers.CompanyName)
--解答:
      USE Northwind 
      GO
      
     
   
   -- QUERY RESULT:
      CustomerID CompanyName                              訂單數
      ---------- ---------------------------------------- -----------
      SAVEA      Save-a-lot Markets                       28
      ERNSH      Ernst Handel                             24
      QUICK      QUICK-Stop                               22
      FOLKO      Folk och fä HB                           16
      ...                    
--------------------------------------------------------------------------

--習題1: (AdventureWorks.Sales.SalesOrderDetail) 各類產品銷售總量排序(降冪)
--解答:
use AdventureWorks
go


----------------------------------------------------------------

--習題2: (AdventureWorks.Sales.SalesOrderDetail) 各類產品
--          2003年銷售總量排序(降冪)
-- 解答:



--------------------------------------------------------------------------------------

/* group by  with where */
use pubs
go 

select type, avg(price) from titles
where advance > 5000
group by type

 -- where/group/order/having 的順序
---------------------------------------------------------------------------

/* group by with order by */
select type, avg(price) from titles
where advance > 5000
group by type order by 2 desc
------------------------------------------------------------------------------

/* group by 進階討論(I): 關於 null */
 -- group by  欄位中的值若有 null, group by 會將所有的null歸成一群
 -- example:
 use Northwind
 go
 
 create table dbo.test3
 (c_id char(5),
  c_type char(3),
  note varchar(20));
  
 insert into dbo.test3
 values ('C0002','AAA','o.k.'),
        ('C0003','AAA',null),
        ('C0004','BBB','o.k.'),
        ('C0005',null,'test'),
        ('C0006',null,'test2'); 
        
 select * from dbo.test3 order by c_type 
 
 select c_type,COUNT(*) as 個數
 from dbo.test3
 group by c_type  
 
 -- query result:
 
   c_type 個數
   ------ -----------
   NULL   2          /* 會將所有的null歸成一群 */
   AAA    2
   BBB    1

   (3 個資料列受到影響)    
------------------------------------------------------------------------------

/* group by 進階討論(II): group by 指令與rollup 運算子 */
--在group by clause 中若有 groups within group 
  (使用兩個以上的欄位並搭配匯總函數)時，可以利用rollup
  再次階層匯總顯示。
  
--example:接單員工/客戶 訂單統計 (norwind..orders)
  
use Northwind
go
   --step 1: 接續example 2-1 (without rollup)
select EmployeeID,CustomerID,COUNT(*) as 訂單數 
from Orders
group by EmployeeID,CustomerID
order by 1,2

      -- query result:
      EmployeeID  CustomerID 訂單數
      ----------- ---------- -----------
       1           ALFKI          2
       1           ANTON      1
       1           AROUT       3    /*1號員工接過 AROUT客戶 3張單*/
       ...
       2           BONAP      1
       2           BOTTM      2    /*2號員工接過 BOTTM客戶 2張單*/
       2           BSBEV        1
       ...

   --step 2: group by with rollup
select EmployeeID,CustomerID,COUNT(*) as 訂單數 
from Orders
group by EmployeeID,CustomerID
WITH ROLLUP   


   --query result:
    ...
    1           WILMK       1
    1           WOLZA      1
    1           NULL       97   /*1號員工 接單統計 97(不分公司) */
    2           BONAP      1
    ...
    2           WHITC       1
    2           WILMK       3    /*2號員工接過 WILMK客戶 2張單*/
    2           NULL        80    /*2號員工 接單統計 80(不分公司) */ 
    3           ALFKI          1
    ...
    9           WARTH      1
    9           WELLI         1
    9           NULL        38   /*9號員工 接單統計 38(不分公司) */ 
    NULL    NULL       683  /*接單統計 683(不分員工、公司) */ 
  
  -- step 3: 修改step 2 利用isnull()改漂亮結果
  select isnull(convert(nvarchar,EmployeeID),N'總計'),
         isnull(CustomerID,N'小計'),
         COUNT(*) as 訂單數 
  from Orders
  group by EmployeeID,CustomerID
  WITH ROLLUP
  
  --query result:
    ...
    1           WILMK      1
    1           WOLZA      1
    1           小計       97   /*1號員工 接單統計 97(不分公司) */
    2           BONAP      1
    ...
    2           WHITC      1
    2           WILMK      3    /*2號員工接過 WILMK客戶 2張單*/
    2           小計       80   /*2號員工 接單統計 80(不分公司) */ 
    3           ALFKI      1
    ...
    9           WARTH      1
    9           WELLI      1
    9           小計       38   /*9號員工 接單統計 38(不分公司) */ 
    總計        小計       683  /*接單統計 683(不分員工、公司) */   
    
------------------------------------------------------------------------------

/* group by 進階討論(III): group by 指令與cube 運算子 */
--在group by clause 中若有 groups within group 
  (使用兩個以上的欄位並搭配匯總函數)時，可以利用cube
  包含所有可能組合。

--example:接單員工/客戶 訂單統計 (norwind..orders)
  
use Northwind
go
   --step 1: 接續example 2-1 (without rollup/cube)
select EmployeeID,CustomerID,COUNT(*) as 訂單數 
from Orders
group by EmployeeID,CustomerID
order by 1,2

   --step 2: with rollup
select EmployeeID,CustomerID,COUNT(*) as 訂單數 
from Orders
group by EmployeeID,CustomerID
with rollup

  --step 3: with cube
select EmployeeID,CustomerID,COUNT(*) as 訂單數 
from Orders
group by EmployeeID,CustomerID
with cube

   --query reault:
   EmployeeID  CustomerID 訂單數
   ----------- ---------- -----------
   1           ALFKI      2
   3           ALFKI      1
   4           ALFKI      2
   6           ALFKI      1
   NULL        ALFKI      6   /* 客戶 ALFKI 訂單數 6*/ 
   3           ANATR      2
   4           ANATR      1
   NULL        ANATR      3   /* 客戶 ANATR 訂單數 3*/
   ...
   8           WOLZA      1
   NULL        WOLZA      6   /* 客戶 WOLZA 訂單數 6*/
   NULL        NULL       683 /* 總訂單數 683 不區分 員工/客戶 */
  ------------------------------------------------------------------以下為員工統計觀點
   1           NULL       97  /* 1號員工 訂單數 97 不區分客戶 */
   2           NULL       80  /* 2號員工 訂單數 80 不區分客戶 */
   3           NULL       109
   ...
   9           NULL       38

------------------------------------------------------------------------------------

/* group by 進階討論(最終回): grouping() 函數 */
--grouping函數用以知會是否使用 rollup / cube
--example:
select EmployeeID,GROUPING(EmployeeID),CustomerID,
       GROUPING(CustomerID),COUNT(*) as 訂單數 
from Orders
group by EmployeeID,CustomerID
with cube

  --query result:
  EmployeeID       CustomerID        訂單數
  -----------   ---- ----------     ---- -----------
  1                    0    ALFKI             0    2
  3                    0    ALFKI             0    1
  4                    0    ALFKI             0    2
  6                    0    ALFKI             0    1   /* 沒用到CUBE 為0*/
  NULL            1    ALFKI              0    6   /* 有用到CUBE 為1*/
  ...

/***********************************************************
 *                                                                                                     *
 *                    THE HAVING STATEMENT                                  *
 *                                                                                                     *
 ***********************************************************/
  -- having and where 

/* the having clause */
--example 1:
  --wtihout having
use pubs
go

select type,count(*) from titles
group by type

  --with having statement
select type,count(*) from titles
group by type 
having count(*) > 2

  -- with having clause (case II)
select type,count(*) from titles
group by type
having type like 'p%'
----------------------------------------------------------

 --練習1 (having)
 -- 有兩個以上作者的州 (pubs.authors)
   --解答:
   select state, count(*)
   from authors
   group by state
   having count(*)  >2

   --哪個客戶只有下單過一次
   use Northwind
   select customerid, count(*)
   from Orders
   group by customerid
   having count(*) = 1

----------------------------------------------------

--習題1:找出每類書籍的平均價格並(pubs.titles)　
        按平均價格由高而低排列
   -- 解答:     

----------------------------------------------------
--HAVING 進階討論 : HAVING 的陷阱
  --example: 
    USE mis
    GO
       --預備動作   
          -- 修改dbo.employee 增加 job(職稱), deptno(部門代號)兩欄位
    ALTER TABLE dbo.employee
    ADD job varchar(40)
    
    ALTER TABLE dbo.employee
    ADD deptno char(10) 
  
    sp_help employee
    
       -- 命題: 找出程式設計師(Programmer)少於五名的所有部門
       SELECT deptno
       FROM employee
       WHERE job = 'Programmer'
       GROUP BY deptno
       HAVING COUNT(*) < 5;
       -- 思考: 如果部門裡一個程式設計師(Programmer)也沒有呢?
       -- 正解: (self join) 
       SELECT DISTINCT deptno 
       FROM employee AS E1
       WHERE 5 > (SELECT COUNT(DISTINCT E2.emp_id)
                  FROM employee AS E2
                  WHERE E1.deptno = E2.deptno 
                        AND E2.job = 'Programmer');
======================================
/*********************************************
 * 查詢 IDENTITY 或 ROWGUID 屬性的欄位    *
 *********************************************/
 -- example:
 USE AdventureWorks 
 GO
 
 sp_help 'sales.SalesOrderHeader' --(SalesOrderID int IDENTITY(1,1))
 
 SELECT SalesOrderID
 FROM Sales.SalesOrderHeader
 
 -- OR 可以這樣 
 SELECT IDENTITYCOL
 FROM Sales.SalesOrderHeader 
 
 -- ROWGUIDCOL 亦同
                       
========================================================================================

/**********************************************************************
 *                                                                                                                        *
 *            Advance Queries: Retrieving Data from Multiple Table            *
 *                                                                                                                         *
 ***********************************************************************/

/***********************************************************************
 *                                        JOIN TABLE                                                             *
 ************************************************************************/

/* A Long Long Story */ 
/* use database mis */
USE  mis
go
-----------------------------------------------------------
/* create table student */
DROP TABLE student

CREATE TABLE student
(stu_id char(8) primary key,
 stu_name char(20),
 major       char(12),
 birth         char(10)
)
--------------------------------------------------------
/* create table class */
CREATE TABLE class
(class_id char(6) primary key,
 class_name char(20),
 fac_id         char(6),
 room           char(6)
)
------------------------------------------------------------
/* create table enrollment */
CREATE TABLE enrollment
(class_id char(6) not null,
 stu_id    char(8) not null,
 grade     char(1)
primary key(class_id, stu_id)
)
--------------------------------------------------------------------
/* insert data into table student */
INSERT INTO student 
VALUES ('S001','John Martin','Math','1980/11/11')
 
INSERT INTO student 
VALUES ('S002','Chin Tom','Math','1979/02/03')

INSERT INTO student 
VALUES ('S003','Burns Lee','Computer','1981/10/10')

INSERT INTO student 
VALUES ('S004','Jacky wu','Art','1981/10/10')

------------------------------------------------------------------------
/* insert data into table class */
INSERT INTO class
VALUES ('F101','visual basic','T005','r204')

INSERT INTO class
VALUES ('F122','SQL server','T443','r204')

INSERT INTO class
VALUES ('F388','Delphi','T433','r205')
--------------------------------------------------------------------------

/* insert data into table enrollment */
INSERT INTO enrollment
VALUES ('F101','S001','A')

INSERT INTO enrollment
VALUES ('F101','S003','B')

INSERT INTO enrollment
VALUES ('F122','S003','C')

INSERT INTO enrollment
VALUES ('F122','S002','C')

select * from student
select * from class
select * from enrollment

----------------------------------------------------------------------------

/***********************
 *        Join                      *  
 ***********************/
 select *
 from student as s , enrollment as e
 where s.stu_id = e.stu_id
/*  WHAT IS A JOIN  */
  -- Join Syntax :
  /*
   SELECT select_list
   FROM table_1, table_2 [, tabel_3]...
   WHERE [table_1.]column join_operator [table2.]column 
  */
     -- or 
  /* 
     SELECT select_list
     FROM table_1 INNER{LEFT|RIHT|FULL}[ OUTER] |CROSS JOIN  table_2
                 ON join_condition
  */
--------------------------------------------------------------------

/* WHY JOINS ARE NECESSARY */

  -- Joins and  the Relational Model

---------------------------------------------------------------------

/* TYPE OF JOIN */
 -- cross joins
 -- Inner joins and outer joins
 -- Equi joins and Natural joins
 -- join query with additional conditions
 -- join not based on Equality (Not-Equal Join)
 -- Self-joins and Aliases 
 -- Join More then Two Tables
 -- Outer Joins (left outer, right outer, full)

------------------------------------------------------------------------------- 
/*cross joins */
 -- Cartesian product (卡式乘積)
USE mis
GO

SELECT *
FROM student,enrollment
                                                    -- SQL-89 

SELECT *
FROM student cross join enrollment
                                                   -- SQL-92
-------------------------------------------------------------------------

/* equi joins */
USE mis
GO
  --SQL-89
SELECT * 
FROM student,enrollment
WHERE student.stu_id=enrollment.stu_id
GO

  --SQL-92 
USE mis
GO
SELECT * 
FROM student INNER JOIN enrollment ON 
            student.stu_id=enrollment.stu_id
--------------------------------------------------------

/* Natural joins */
USE mis
GO
SELECT a.*,b.class_id,b.grade
FROM student a,enrollment b
WHERE a.stu_id=b.stu_id
GO

 -- (練習: SQL-92 寫法)
USE mis
GO
     
------------------------------------------------------

/* Join query with additional conditions */
/* part I 已知 class_name='SQL server' ----> class_id='F122' from class table */
USE mis
GO
SELECT a.stu_id, a.stu_name,a.major, b.class_id 
FROM student a, enrollment b
WHERE a.stu_id=b.stu_id
              and a.major='Math'
              and b.class_id='F122' 
GO

  -- (練習: SQL-92 寫法)
USE mis
GO

 

/* part II 未知 class_name='SQL server' ----> class_id='F122' from class table */
USE mis
GO
SELECT a.stu_id, a.stu_name,a.major, b.class_id 
FROM student a, enrollment b
WHERE a.stu_id=b.stu_id
              and a.major='Math'
              and b.class_id in 
                                      (SELECT class_id FROM class
                                       WHERE  class_name='SQL server')
GO

  -- (練習: SQL-92 寫法)
USE mis
GO

---------------------------------------------------------------------------------------------------

/*Another examples of Equi Joins */
-- example 1: 列出位於加州的出版商所出版的書籍(pubs.titles, pubs.publishers)
use pubs
go
select a.title_id, a.title, b.pub_name, b.state
from titles a, publishers b 
where a.pub_id = b.pub_id       -- join condition
      and b.state='CA'          -- where condition
      
   --or
select a.title_id, a.title, b.pub_name, b.state
from titles a inner join publishers b on (a.pub_id = b.pub_id)   -- join condition
where b.state='CA'          -- where condition 

   --比較
select a.title_id, a.title, b.pub_name, b.state
from titles a inner join publishers b 
on (a.pub_id = b.pub_id) and (b.state='CA')   -- join condition
        
-------------------------------------------------------------------------------------------------  

--example 2: 找出只曾經下過ㄧ次訂單的客戶公司名稱(northwind.orders, northwind.customers)
use northwind 
go
select c.companyname
from customers c inner join orders o on c.customerid=o.customerid
group by c.companyname having (count(c.companyname)=1) 
order by c.companyname  
-------------------------------------------------------------------------------------

-- example 3: 哪些客戶的shipname 和 companyname 不同 (northwind.customers, northwind.orders)
use northwind 
go
select c.companyname,o.shipname
from customers c inner join orders o on c.customerid=o.customerid    
order by c.companyname
   -- 加上 distinct
select distinct c.companyname,o.shipname
from customers c inner join orders o on c.customerid=o.customerid    
order by c.companyname
   -- 加上判別條件
select distinct c.companyname,o.shipname
from customers c inner join orders o on c.customerid=o.customerid    
where c.companyname <> o.shipname
order by c.companyname  
  -- 另一種寫法 
select distinct c.companyname,o.shipname
from customers c, orders o      
where c.customerid=o.customerid and 
          c.companyname <> o.shipname
order by c.companyname      -- 結果相同(但並不總是如此)

-------------------------------------------------------------------------------------------------- 
-- 練習1: 找出每個客戶公司名稱的訂單總量，並依訂單總量由大到小排序
-- 解答:
use northwind 
go

-- 練習2:找出每個客戶代號及公司名稱在1998年的訂單總量，並依訂單總量由大到小排序
-- 解答:
use northwind 
go

--------------------------------------------------------------------------------------------------------------

/* join three table */
-- example 1:計算每位職員替各家公司所處理的訂單數目(northwind.customers
--                  northwind.orders,northwind.employees)
use northwind
go
select c.companyname, e.lastname, count(e.lastname) as 訂單數目
from customers c inner join orders o on c.customerid=o.customerid
                            inner join employees e on o.employeeid=e.employeeid
group by c.companyname, e.lastname
-------------------------------------------------------------------------------------------

--練習1:查詢客戶訂單中的產品名稱(northwind.customers,orders,orderdetail,products)
--query result:
companyname                              orderdate               productname
---------------------------------------- ----------------------- ----------------------------------------
Alfreds Futterkiste                      1997-08-25 00:00:00.000 Chartreuse verte
Alfreds Futterkiste                      1997-08-25 00:00:00.000 Rössle Sauerkraut
Alfreds Futterkiste                      1997-08-25 00:00:00.000 Spegesild
...
--解答:
use northwind
select c.companyname,o.orderdate,p.productname
from ......
-----------------------------------------------------------------------------------------------------------------

/* join three table (pubs. stores, sales, titles) */
 -- 習題1: 列出位於加州的書局的代碼,銷售的書籍名稱,數量
 -- 解答:
use pubs
go
select a.stor_id, a.stor_name,a.state,b.title_id,c.title,b.qty
from stores a JOIN sales b ON a.stor_id=b.stor_id
                     JOIN titles c ON b.title_id=c.title_id 
where  a.state='CA'

------------------------------------------------------------------------------
 
-- 習題2: 列出位於加州各書局(書局名稱)的書籍銷售總量
-- query result:
/*
書局名稱               書籍銷售總量
---------------------------------------- -----------
Barnum's                                 125
News & Brews                          90
Fricative Bookshop                   60    
*/

--解答:
use pubs
go

-------------------------------------------------------------------------------------------------

/* join not based on Equality */
 -- join operators 不一定是 ' = ' , 可以是 >, <, >= (!<), <= (!>), <>(!=)
 -- 幾乎沒用到
-------------------------------------------------------------------------------------

/* Joining a Table with Itself: The Self-Join */
/* Self-Joins */
/* 找出同一天 生日的學生 */
USE mis
GO
SELECT a.stu_id, a.stu_name, a.birth
FROM student a inner join student b on a.birth=b.birth
WHERE a.stu_id != b.stu_id 
GO
              
-----------------------------------------------------------------------

/* self-join 習題 */
-- in database northwind 
-- displays pairs of employees who have the same job tilte.
-- hint: northwind.employees
  use northwind
  go
  
----------------------------------------------------------------------------------

/* Outer Joins: Showing the Background */

  -- Outer Join (SQL-89) (SQL Server 2012 已不支援)
      -- Left Outer Join,    *=  (包含左邊 table 中所有的 rows)
      -- Right Outer Join   =*  (包含右邊 table 中所有的 rows)

-- Left Outer Join
  -- example 1:
     -- equal join: (書局和出版商在同一州)
        use pubs
        go
        select s.stor_name, p.pub_name, s.state
        from stores s, publishers p
        where s.state = p.state

   -- left outer join: (書局和出版商在同一州,並且列出所有書局清單)(SQL-89)
        use pubs
        go
        select s.stor_name, p.pub_name, s.state
        from stores s, publishers p
        where s.state *= p.state
                -- 排排好
        select s.stor_name, p.pub_name, s.state
        from stores s, publishers p
        where s.state *= p.state
        order by 2 desc
          
             -- (SQL-92 寫法)
        use pubs
        go
        select s.stor_name, p.pub_name, s.state
        from stores s LEFT OUTER JOIN publishers p ON
                s.state = p.state
       order by 2 desc
 
   -- right outer join: (書局和出版商在同一州,並且列出所有出版社清單)
        use pubs
        go
        select s.stor_name, p.pub_name, s.state
        from stores s, publishers p
        where s.state =* p.state
        order by 1 desc

      -- (練習: SQL-92)
        use pubs
        go

        

/*  full outer join  (書局和出版商在同一州,並且列出所有 出版社清單及書局清單) */
        use pubs
        go
        select s.stor_name, p.pub_name, s.state
        from stores s FULL OUTER JOIN publishers p ON s.state = p.state
        order by 1 desc,2 desc
--------------------------------------------------------------------------------------------------------------
/* outer join example */
    -- example 1: 
       -- part 1:列出所有供應商,及供應商所供應的產品
    USE northwind
    GO
    
    SELECT s.supplierid,s.companyname,p.productid,p.productname
    FROM suppliers s inner join products p on s.supplierid=p.supplierid
    ORDER BY 1;

        --part 2:如果有供應商尚未輸入供應的產品資料
	INSERT INTO suppliers (COMPANYNAME,CONTACTNAME)    
	VALUES ('jack and mary','jack');
        --part 3:驗證insert 結果
    SELECT * FROM suppliers  -- ok.
        --part 4: part1查詢 
    SELECT s.supplierid,s.companyname,p.productid,p.productname
    FROM suppliers s inner join products p on s.supplierid=p.supplierid
    ORDER BY 1;
        
	  --結果,不會出現 supplierid=30 的廠商
        --解決的方法: (Outer join, Left outer join)
	    --外部連結運算子(outer join operator) 
    
    -- (left outer join solution)
    SELECT s.supplierid,s.companyname,p.productid,p.productname
    FROM suppliers s,products p
    WHERE s.supplierid*=p.supplierid 
    ORDER BY 1;
    
    -- (另一種寫法 LEFT OUTER JOIN SQL-92)
    SELECT s.supplierid,s.companyname,p.productid,p.productname
    FROM suppliers s LEFT OUTER JOIN products p ON s.supplierid=p.supplierid
    ORDER BY 1;
---------------------------------------------------------------------------------------------------------

--習題: 從 database northwind 中 列出所有客戶(customer)
--          id 和 名稱 及 1998 年訂單號碼 (不論該客戶是否有訂單)
--          (table customers, orders)
      -- 解答:     
      use northwind
      go
      select c.customerid, c.companyname,
                o.orderid, o.orderdate 
      from customers c, orders o
      where c.customerId *= o.customerId
                and datepart(year,o.orderdate)=1998
      go

      -- 加上 order by
      use northwind
      go
      select c.customerid, c.companyname,
                o.orderid, o.orderdate 
      from customers c, orders o
      where c.customerId *= o.customerId
                and datepart(year,o.orderdate)=1998
      order by c.customerid,o.orderid
      go                               -- (280 個資料列受到影響)

      -- outer join 寫法
      use northwind
      go
      select c.customerid, c.companyname,
                o.orderid, o.orderdate 
      from customers c left outer join  orders o
              on c.customerId = o.customerId
                   and datepart(year,o.orderdate)=1998
      order by c.customerid,o.orderid
      go                              -- (280 個資料列受到影響)

     -- 注意: (與上述兩種寫法結果不一樣)
      select c.customerid, c.companyname,
                o.orderid, o.orderdate 
      from customers c left outer join  orders o
              on c.customerId = o.customerId
      where datepart(year,o.orderdate)=1998    --先left out join後再where 篩選
      order by c.customerid,o.orderid
      go                             -- (270 個資料列受到影響) 
-----------------------------------------------------------------------------------------------------------

-- 進階討論: 為何不同? (outerjoin特別說明.sql) 
=====================================================================================================

/****************************************************************************
 *              Subqueries:Using Queries within Other Queries                                *
 *                     or Other Insert/Delete/Update calause                                         *
 *****************************************************************************/
                                                                                                        
 -- Subquery: A SELECT statement within another SELECT(INSERT,    
 --                     DELETE, UPDATE) statement                         
 
----------------------------------------------------------------------------------
/*子查詢的語法和 SELECT 敘述一樣, 但有下列的限制：
   1. 整個子查詢敘述需用小括弧 ( ) 括住。
   2. 子查詢中不能使用 COMPUTE、INTO 子句。
   3. 若子查詢中有用到 "SELECT TOP n...", 才可設定 ORDER BY 子句來排序。 */
----------------------------------------------------------------------------------
/*Type of subqueriers */
-- independent subqueries (nested scalar) 
-- dependent subqueries (correlated)
-----------------------------------------------------------------------------------------------------
/* Nested Query : (independent)
    Outer query 是以 Inner Subqueries 的結果為基礎來計算        */
  -- inner subquery 結果為單值:
     -- example 1: (比平均單價還貴的書籍, pubs.titles)
     USE pubs
     GO
     SELECT title_id,title,price
     FROM titles 
     WHERE price > (SELECT avg(price) FROM titles)
     -------------------------------------------------

     -- example 2:找出比'最貴的商業類書籍'還貴的書  　　                                       */
     SELECT title,price
     FROM titles
     WHERE  price >
                   (SELECT MAX(price)            --先找出最貴商業類書籍的價格
                    FROM titles
                    WHERE TYPE='business')
     -------------------------------------------------------------------------                    
     /* 練習  :從 database:northwind,table:products 中找出最貴單價商品之
                      品名(productname)、單價(unitprice) 如下列查詢結果:

                 價格                    品名
---------- --------------------- ----------------------------------------
最高價產品      263.50                Côte de Blaye

(1 個資料列受到影響)                
                       
*/
     -- 解答:
     USE northwind
     GO
   
---------------------------------------------------------------------------------------------------------------
   -- inner subquery 結果為多值: ([NOT] IN (Subqueries)) 
     --  example 1: 出版商業書籍的出版商名稱
    USE pubs
    GO
    SELECT publishers.pub_name
    FROM publishers 
    WHERE pub_id IN
                    (SELECT DISTINCT pub_id 
                     FROM titles
                     WHERE TYPE='business')
   ---------------------------------------------------------
     -- 練習4- :找出供應商品 "Chocolade" (Productname='Chocolade') 
                      的供應商名稱及國籍 (database: northwind, table: product,suppliers)
                      查詢結果如下:
                      公司名稱              國別
                      -------------------   -----------
                      Zaanse Snoepfabriek	Netherlands
     -- 解答: 
         use Northwind
         
         
     -----------------------------------------------------------------------------------                 
     -- 進階練習5- :找出供應商品 "Chocolade" (Productname='Chocolade') 
                      的供應商名稱及國籍 (database: northwind, table: product,suppliers)
                      查詢結果如下:
                      公司名稱              國別          產品代號  產品名稱
                      -------------------   -----------   --------  ---------
                      Zaanse Snoepfabriek	Netherlands	  48	    Chocolade  
         
     --  解答:  
         use Northwind
         
                               
   ----------------------------------------------------------                     
   -- inner subquery 結果為多值: ( [ANY | ALL] (Subqueries))
      -- example1 : 找出比每一本商業類書籍都還貴的書
      SELECT title, price
      FROM titles
      WHERE  price > ALL  (SELECT price
                           FROM titles
                           WHERE type='business')
     
     -- example2 : 找出比任何一本商業類書籍貴的書 
    SELECT title, price
    FROM titles
    WHERE  price > ANY  (SELECT price
                         FROM titles
                         WHERE type='business')
------------------------------------------------------------------------------------------
   -- 練習6- : 找出最近的訂單資料(database northwind/ tble orders)
   -- 解答:
   USE northwind
   GO
  
---------------------------------------------------------------------------------------------------
  -- 練習7- :找出最近的訂單資料(database northwind/ tble orders,[order details])的明細項
  -- 解答:
  use Northwind
  go
  
 
----------------------------------------------------------------------------------------------
/* dependent subqueries (correlated) */
--  WHERE [NOT] EXISTS (Subqueries) (dependent subquery)  　　                                       
   -- example1: 找出 1997/09/05 曾經接單的員工(database:northwind,
   --           table: employees/orders
   use northwind
   go
   select lastname, employeeid
   from employees e
   where exists (select * from orders o
                        where e.employeeid = o.employeeid
                        and o.orderdate = '1997/09/05') 

   -- 等價 join 寫法
   use northwind
   go
   select e.lastname, e.employeeid
   from employees e, orders o
   where e.employeeid = o.employeeid
                     and o.orderdate = '1997/09/05'
------------------------------------------------------------
   -- example2: 找出無明細項的訂單號碼 (database: northwind)
   use northwind
   go
   select m.orderid as 無明細單號 
   from orders m
   where not exists (select d.orderid
                              from orderdetail d
                              where m.orderid=d.orderid)
--------------------------------------------------------------
  -- example3: 找出每個產品的總出貨次數 (database:adventure/
                                         table:production.products,
                                               sales.salesorderdetail)
   use AdventureWorks 
   select p.productid as 產品代號, p.name as 產品名稱,
          (select COUNT(*)
           from Sales.SalesOrderDetail as d
           where d.ProductID = p.productid) as 出貨次數
   from Production.Product as p
   order by 3 desc
   ---------------------------------------------------------
   
   -- 練習8- : 找出每一個客戶的最近交易資訊
                    (database: adventureworks \ tabel:sales.salesorderheader,
                                                      sales.customer)
      查詢結果如下:
      最近交易日期             總交易次數     
      -----------------------  ----------  -----    -----
      2004-03-26 00:00:00.000	3	       66488	14324
      2003-10-02 00:00:00.000	1	       54958	22814
      2004-01-01 00:00:00.000	1	       60728	11407
      2004-05-28 00:00:00.000	1	       71088	28387
      ......
      
   -- 解答:
      use AdventureWorks
      
      select (select MAX(modifieddate)
              from Sales.SalesOrderHeader h
              where h.CustomerID=c.CustomerID) as 最近交易日期,
             (select COUNT(*)
              from Sales.SalesOrderHeader h
              where h.CustomerID=c.CustomerID) as 總交易次數,
             (select top 1 salesorderid
              from Sales.SalesOrderHeader h
              where h.CustomerID=c.CustomerID
                    order by ModifiedDate desc) as 最近訂單號碼,
             c.CustomerID as 客戶代號
     from Sales.Customer c                
   
--------------------------------------------------------------
  -- example4:
  -- 在 HAVING statement 中使用相關子查詢 (dependent subquery)
  -- example1: 找出產品訂購量是平均訂購量三倍以上的訂單資料
use northwind
go
---------------------------------------------------------------------
   /* 難題欣賞 */
select od1.productid,od1.orderid
from [order details] as od1
group by od1.productid,od1.orderid
having sum(od1.quantity)>3*(select avg(od2.quantity)
                                             from [order details] as od2
                                             where od2.productid = od1.productid)
--------------------------------------------------------------------------------------------                                  

/* home work: 最貴的書是哪一家出版社出版的? */
--解答:
use pubs
go

select pub_id, pub_name
from publishers
where pub_id =
  (select pub_id
   from titles
   where price =
         (select max(price) from titles)
   )
==============================================

/* 選取前幾筆資料 TOP (N) */ (非 ANSI ;  MySQL,Oracle  不支援,) 
  -- example 1 : 
use pubs
go

select top (3) * from employee

select top (10) percent * from employee
-----------------------------------------

  -- example 2: (將子查詢應用在TOP指令內):
  
use northwind
go
            /*子查詢先求出每月平均訂單數作為top值*/
select top (select count(*)/datediff(month,min(orderdate),max(orderdate)) from orders) 
       orderid,orderdate,customerid,employeeid
from orders
order by orderdate desc, orderid desc        
-----------------------------------------------------------------------------------------------

/* SELECT  TOP (n) 與 SET ROWCOUNT n*/

-- SET ROWCOUNT n  -->限制結果集大小
    --example 1:
    SET ROWCOUNT 10   <-- 限制結果集大小為10 
    
       --第一次查詢
    USE Northwind
    GO
         
    SELECT * FROM Orders
      --
      (10 個資料列受到影響)
      
       --第二次查詢
      USE AdventureWorks
      GO
      
      SELECT * FROM Sales.SalesOrderHeader   
       --
      (10 個資料列受到影響)
      ---------------------------------------------
      
      SET ROWCOUNT 0 <--取消限制結果集大小
         --再一次查詢
      USE Northwind
      GO
         
      SELECT * FROM Orders
      --
      (683 個資料列受到影響)
      
       --再次查詢
      USE AdventureWorks
      GO
      
      SELECT * FROM Sales.SalesOrderHeader   
       --
      (31465 個資料列受到影響)
      
-----------------------------------------------------------------------------------------------
 --習題: 將銷售總量大於30的書名列出前五名
 --解答:
use pubs
go


=========================================================================
/*****************************************************************
 *            SELECT CLAUSE 執行邏輯(理論順序)                   *
 *****************************************************************/
 
 (8) SELECT
 (9) [ALL | DISTINCT]
 (11)[TOP n] [INTO]
 (1) FROM 資料來源
 (3) [INNER|LEFT|RIGHT] JOIN
 (2) ON <join condition>
 (4) WHERE <condition>
 (5) [GROUP BY]
 (6) [WITH]
 (7) [HAVING] <condition>
 (10)[ORDER BY] [ASC | DESC]
 
=====================================================================================================
/* Subqueries in UPDATE, DELETD and INSERT Statements */
 
  --UPDATE
  -- example: 將銷售總量不到50的書打對折 
update titles 
set price = price*.5
where title_id in
    ( select  title_id
      from sales
      group by title_id
      having sum(qty) < 50
     )
------------------------------------------------------------
  --DELETE
  -- example: 將心理學類書籍銷售紀錄刪除
select * into sales_tmp from sales -- 預備動作
 
delete from sales_tmp
where title_id in
    (select title_id
     from titles
     where type='psychology')

select * from sales_tmp -- 檢視
--------------------------------------------------------------------------------------------------------
  
  -- INSERT 
  -- example: 將心理學類書籍銷售紀錄
  --                從 table sales INSERT INTO table sales_tmp
insert into sales_tmp(stor_id,ord_num,ord_date,qty,payterms,title_id)
(select * 
 from sales
 where title_id in 
    (select title_id 
      from titles
      where type='business')
)
-------------------------------------------------------------------------------------------------------

/************************************************************************
 *                                        SELECT INTO                                                            *
 *************************************************************************/
-- use to create a table and insert rows into  the table 

-- example 1: 
use northwind 
go
select productname as prodcuts, unitprice as price,unitprice*1.06 as tax
into #pricetable
from products

-- 驗證:
select * from #pricetable

/*練習:  copy sechma and data to table(#pricetable1) from
              table(products) */
  --解答: 
  

  -- 驗證:
    select * from pricetable

/* 練習: copy sechma only to table(#pricetable2) 
              from table(products) */

  --解答:
  drop table pricetable

 
--------------------------------------------------------------------------------

/* 將 SELECT 結果儲存在變數內 */
use northwind
go

DECLARE @vp_id    char(10)
DECLARE @vp_name  char(12)
SELECT @vp_id=employeeid, @vp_name=lastname
FROM   employees
WHERE  lastname='King'

SELECT @vp_id
SELECT @vp_name

-----------------------------------------------------------------------

/* 在 oracle 上 */
create table emp_test1 as
select * from employee;
===============================================

/*************************************************************************
 *  集合操作 --> UNION(聯集) , INTERSECT(交集), EXCEPT(差集)                  *
 **************************************************************************/
 UNION
   UNION 的條件:
     1. 欲合併的查詢結果, 其欄位數必須相同。
     2. 欲合併的查詢結果, 其對應的欄位 
        (如上圖的甲欄和丙欄、乙欄和丁欄) 一定要具備 "相容" 的資料型別, 即資料型別可以不同,
         但兩者必須能夠互相轉換。
   UNION 的結果:
     1. 合併結果的欄位名稱會以第一個查詢結果的欄位名稱為名稱。
     2. 合併時, 若對應的欄位具備不同的資料型別, 則 SQL Server 會進行相容性的型別轉換, 
        轉換的原則是以 "可容納較多資料的型別為主"。
     3. 在 SQL SERVER 中並不是每種資料型別都可以互相轉換。
        如果無法自動轉換, 除非我們介入強制轉換, 否則便會顯示錯誤訊息, 無法完成合併。         
   ----------------------------------------------------------------------------------------
   The Simplified Syntax
    select statement
      UNION
    select statement
   ---------------------------------------------------------------------------------------- 
   UNION 的完整語法:
      { <query_specification> | ( <query_expression> ) } 
      UNION [ ALL ] 
        <query_specification | ( <query_expression> ) 
      [ UNION [ ALL ] <query_specification> | ( <query_expression> ) 
      [ ...n ] ]    
 -------------------------------------------------------------------------------------------------------
 -- example :(練習01 資料庫中,合作廠商和客戶資料表)
 USE 練習01
 GO
 
 SELECT 聯絡人 AS 邀請名單, 地址
 FROM 合作廠商
 UNION
 SELECT 聯絡人, 地址
 FROM 客戶
 ORDER BY 聯絡人   
 
 --顯示全部的資料, 不論資料是否重複, 
   改用 UNION ALL 來合併：
 SELECT 聯絡人 AS 邀請名單, 地址
 FROM 合作廠商
 UNION ALL
 SELECT 聯絡人, 地址
 FROM 客戶
 ORDER BY 聯絡人
 
 --加入一些臨時資料 (這些臨時資料並不存在資料表中)
 SELECT 聯絡人 AS 邀請名單, 地址
 FROM 合作廠商
 UNION
 SELECT 聯絡人, 地址
 FROM 客戶
 UNION 
 SELECT '陳小明', '高雄市后安路34號5樓'
 ORDER BY 聯絡人
----------------------------------------------------------------------------------------------------
 
   --練習: a list of all the authors and publishers who live in Oakland or Berkeley
                   (資料庫:pubs, 資料表:authors,publishers)
   -- 解答:
   use pubs
   go
   select au_id, city
   from authors
   where city in ('Oakland','Berkeley')
   union
   select pub_id,city
   from publishers
   where city in ('Oakland','Berkeley')
   go
  
   -- 改進
   use pubs
   go
   select au_id 代碼, city
   from authors
   where city in ('Oakland','Berkeley')
   union
   select pub_id,city
   from publishers
   where city in ('Oakland','Berkeley')
   go
-----------------------------------------------
/* UNION 應注意事項 */
  -- GROUP BY , HAVING 子句 只能用在個別 select_statement
  -- ORDER BY , COMPUTE 子句 只能用在最後結果
  -- 只有第一個 select_statement 可以設定 INTO 子句
  -- ALL
  -- 合併順序  "由左至右" , 但小括弧 () 可改變順序
--------------------------------------------------------------------------------

  -- UNION 使用實例　--折扣對照表 (1)
use pubs
go
select '20% off' 折扣, title,price, price*.8 [discount price]
from titles
where price < 7.0
union 
select '10% off', title,price, price*.9 [discount price]
from titles
where price between 7.0 and 15.0
union 
select '30% off', title,price, price*.7 [discount price]
from titles
where price > 15.0
go
--------------------------------------------------------------------------------

  -- UNION 使用實例　--折扣對照表 (2) -- 小括弧()
use pubs
go
select '20% off' 折扣, title,price, price*.8 [discount price]
from titles
where price < 7.0
union 
(select '10% off', title,price, price*.9 [discount price]
 from titles
 where price between 7.0 and 15.0
 union 
 select '30% off', title,price, price*.7 [discount price]
 from titles
 where price > 15.0)
go                                       -- 只是 UNION 順序改變,結果不變
--------------------------------------------------------------------------------

  -- UNION 使用實例　--折扣對照表 (3) -- ORDER BY
use pubs
go
select '20% off' 折扣, title,price, price*.8 [discount price]
from titles
where price < 7.0
union 
select '10% off', title,price, price*.9 [discount price]
from titles
where price between 7.0 and 15.0
union 
select '30% off', title,price, price*.7 [discount price]
from titles
where price > 15.0
order by 1 desc
go
---------------------------------------------------------------------------------
  -- UNION 使用實例　--折扣對照表 (4)  -- INTO 子句  
use pubs
go
select '20% off' 折扣, title,price, price*.8 折扣價
into discount_table 
from titles
where price < 7.0
union 
select '10% off', title,price, price*.9 [discount price]
from titles
where price between 7.0 and 15.0
union 
select '30% off', title,price, price*.7 [discount price]
from titles
where price > 15.0
go

--驗證:
select * from discount_table 
-------------------------------------------------------
-- 練習: 將database:AdventureWorks, 
                  table:Production.product 中 ListPrice >= 5
                  的ProductID(產品代號)和Name(產品名稱)
                  與database:northwind, table:dbo.Products 中
                  UnitPrice >= 5 的ProductID 和 ProductName
                   查詢結果合併(UNION)
-- 解答:
use AdventureWorks
go
select ProductID as 產品代號, Name as 產品名稱
from Production.Product 
where ListPrice >= 5

use Northwind 
go
select ProductID, ProductName 
from dbo.Products
where UnitPrice >=5

......
UNION
......

  -- 結果:
  訊息 468，層級 16，狀態 9，行 1
  無法解析 UNION 作業中 "Chinese_Taiwan_Stroke_CI_AS" 與 "SQL_Latin1_General_CP1_CI_AS" 
  之間的定序衝突。
  -- 解法1:
  1. 直接修改資料庫定序 <select-20100105.ppt p.4>
  2. 新建資料庫 northwind_temp (定序改為 SQL_Latin1_General_CP1_CI_AS)
     再將 northwind 資料庫匯入

select A.ProductID as 產品代號, A.Name as 產品名稱
from AdventureWorks.Production.Product A 
where ListPrice >= 5
UNION
select B.ProductID, B.ProductName 
from Northwind_temp.dbo.Products B
where UnitPrice >=5

 --解法2:
select A.ProductID as 產品代號, A.Name as 產品名稱
from AdventureWorks.Production.Product A 
where ListPrice >= 5
UNION
select B.ProductID, B.ProductName collate SQL_Latin1_General_CP1_CI_AS 
from Northwind.dbo.Products B
where UnitPrice >=5

==========================================================

/* 衍生資料表 (derived tables) */
--example 1:
USE northwind
GO
SELECT *
FROM (SELECT employeeid,firstname+' '+lastname AS emp_name
            FROM employees) AS DerivedTable

--example 2: 找出訂單數量在前五名的客戶
USE northwind
GO
SELECT TOP 5  *
FROM (SELECT companyname, COUNT(companyname) AS ordercount
            FROM customers c INNER JOIN orders o ON c.customerid=o.customerid
            GROUP BY c.companyname) AS DerivedTable
ORDER BY OrderCount DESC
==============================================================
/* 跨資料庫查詢 */
-- example 1:
USE northwind
GO
SELECT *
INTO mis..orders
FROM northwind..orders
--驗證:
USE mis
GO
SELECT * FROM orders

--example 2:
USE northwind
GO
SELECT DISTINCT c.companyname,o.shipname
FROM customers c INNER JOIN mis..orders o ON c.customerid=o.customerid
WHERE c.companyname<>o.shipname
============================================================
/* Multipart Names*/
存取資料庫物件時，可以利用多部份名稱(Multipart Names),格式如下:

ServerName.[DatabaseName].[SchemaName].ObjectName

 -- ServerName 可以是 "連結伺服器" 或 "遠端伺服器"
 -- 若省略部份的中繼節點: DatabaseName..ObjectName

=========================================================================
/* 連結伺服器與分散式查詢*/


========================================================================
/*******************************************
 * 追蹤與偵錯SQL指令-- SQL Server Profiler *
 *******************************************/
 SQL Server 2008 --> 效能工具 --> SQL Server Profiler-->
 檔案-->新增追蹤-->驗證-->連接-->追蹤屬性-->執行
 
 SSMS
 USE AdventureWorks 
 GO
 SELECT * FROM Sales.SalesOrderHeader
 GO
 
 --觀察 SQL Server Profiler

=====================================================================
/* 另一種說法 */

 -- Using a Subquery as a Derived Table 
 -- Using a Subquery as an Expression 
 -- Using a Subquery to Correlate Data 

  /* Using a Subquery as a Derived Table */
   -- example1: 
      use northwind
      go
      select t1.orderid, t1.orderdate, t1.productid, t1.quantity
      from (select om.orderid, om.orderdate, 
                         od.productid, od.quantity
                from orders om, [order details] od
                where om.orderid=od.orderid
                          and year(om.orderdate) = 1996
                          and month(om.orderdate) = 7)   as t1 
       go          

   -- example2: (select inot, 訂單加兩成試算) 
      use northwind
      go
      select t1.orderid, t1.orderdate, t1.productid, 
                t1.quantity*1.2 as add_quantity
      into t2
      from (select om.orderid, om.orderdate, 
                         od.productid, od.quantity
                from orders om, [order details] od
                where om.orderid=od.orderid
                          and year(om.orderdate) = 1996
                          and month(om.orderdate) = 7)   as t1 
   
       go          

    -- 驗證
    use northwind
    go
    select * from t2
    go
----------------------------------------------------------------------------------

-- Using a Subquery as an Expression 
  --example 1: 找出 比 (三月份各訂項平均價格) 還多的訂項
  
     --(1997三月份各訂項平均價格) as a expression
     use northwind
     go
     select avg(od.unitprice*od.quantity) as '1997三月訂項平均價格'
     from orders om, [order details] od
     where om.orderid=od.orderid
                and year(om.orderdate)=1997 
                and month(om.orderdate)=3
     go

     -- 找出 比 (三月份各訂項平均價格) 還多的訂項
     select om.orderid, od.productid, od.unitprice*od.quantity as '訂項價格'
     from orders om, [order details] od
     where od.unitprice*od.quantity > 
                                 (select avg(od.unitprice*od.quantity) as '1997三月訂項平均價格'
                                  from orders om, [order details] od
                                  where om.orderid=od.orderid
                                  and year(om.orderdate)=1997 
                                  and month(om.orderdate)=3)


 