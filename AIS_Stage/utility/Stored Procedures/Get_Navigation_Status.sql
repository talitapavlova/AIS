




/*
Change log: 
	2020-04-20	SI	Stored procedure created
*/


CREATE PROCEDURE [utility].[Get_Navigation_Status] AS
BEGIN

/* 
Extract data from .csv file into SQL Server temporary table ##IncomingNavigationalStatuses
*/
IF OBJECT_ID('tempdb..##IncomingNavigationalStatuses') IS NOT NULL DROP TABLE ##IncomingNavigationalStatuses
SELECT * INTO ##IncomingNavigationalStatuses FROM OPENROWSET ( BULK 'C:\AIS\StaticDimensions\NavigationStatus\NavigationStatus.txt', FIRSTROW = 2,
		FORMATFILE = 'C:\AIS\StaticDimensions\NavigationStatus\formatNavigationStatus.fmt') as tbl

/*
Insert unkown values into [edw].[Dim_Navigation_Status]
*/
TRUNCATE TABLE [AIS_EDW].[edw].[Dim_Navigation_Status]
INSERT INTO [AIS_EDW].[edw].[Dim_Navigation_Status](
		Navigation_Status_Key,
		Navigation_Status_Description
) VALUES (
	-1,
	'NA'
) 

/*
Insert into [edw].[Dim_Navigation_Status]
*/
INSERT INTO [AIS_EDW].[edw].[Dim_Navigation_Status](
		Navigation_Status_Key,
		Navigation_Status_Description
		)
SELECT
	  	CAST(Navigation_Status_Key AS INT),
		Navigation_Status_Description
FROM ##IncomingNavigationalStatuses 
END