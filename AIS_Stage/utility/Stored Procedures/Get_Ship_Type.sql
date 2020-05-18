


/*
Change log: 
	2020-04	SI	Stored procedure created
*/


CREATE PROCEDURE [utility].[Get_Ship_Type] AS

BEGIN

/* 
Extract data from .csv file into SQL Server temporary table ##IncomingShipTypes
*/
IF OBJECT_ID('tempdb..#IncomingShipTypes') IS NOT NULL DROP TABLE #IncomingShipTypes
SELECT * INTO #IncomingShipTypes FROM OPENROWSET ( BULK 'C:\AIS\StaticDimensions\ShipType\ShipType.txt', FIRSTROW = 2,
		FORMATFILE = 'C:\AIS\StaticDimensions\ShipType\formatShipType.fmt') as tbl

/*
Insert unkown values into [edw].[Dim_Ship_Type]
*/
TRUNCATE TABLE [utility].[Dim_Ship_Type]

INSERT INTO [utility].[Dim_Ship_Type](
		Ship_Type_Key,
		Ship_Type_Description
) VALUES (
	-1,
	'NA'
) 

/*
Insert utility.Ship_Type into [edw].[Dim_Ship_Type]
*/

INSERT INTO [utility].[Dim_Ship_Type](
		Ship_Type_Key,
		Ship_Type_Description
) SELECT
	  	CAST(Ship_Type_Key as INT),
		Ship_Type_Description
FROM #IncomingShipTypes

END