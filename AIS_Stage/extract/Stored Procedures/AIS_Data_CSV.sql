
/*
Change log: 
	2020-02-27	SI	Stored procedure created
	2020-04-06	NP	Added Batch logic
	2020-04-10	NP	Added extra columns; Uppdated so file name can be a parameter
*/

/*

 - The following procedure uses the OEPNROWSET and FILEFORMAT for allowing to import csv. data line by line into a TEMPORARY table, with no defined structure. 
	An alternative would be to use BULK INSERT and have an already created table in the SQL Server, where to import the data. However, for aviding creating 
	the intial table only with the purpose of extracting initial data and keeping the solution neat, the OEPNROWSET with FILEFORMAT solution had been chosen. 
	For OPENROWSET to perform accordingly a FILEFORMAT has to be cerated. The file can be created manually or be generated using the BCP utility. 
	* For more information : https://docs.microsoft.com/en-us/sql/relational-databases/import-export/use-a-format-file-to-bulk-import-data-sql-server?view=sql-server-ver15

*/
 

CREATE PROCEDURE [extract].[AIS_Data_CSV] (@File nvarchar(50) = 'C:\AIS\output_in_use.csv')
AS

DECLARE
@Batch int,
@sql nvarchar(1000)

SELECT @Batch = ISNULL(MAX(Batch) + 1, 1) 
FROM utility.Batch;

SET @sql = N' IF OBJECT_ID(''tempdb..##IncomingRecords'') IS NOT NULL DROP TABLE ##IncomingRecords
	SELECT *
	INTO ##IncomingRecords
	FROM OPENROWSET ( BULK''' + @File + ''',   
		FIRSTROW = 2,
		FORMATFILE = ''C:\AIS\format.fmt''				  					
	) AS a WHERE a.Repeat_Indicator = 0'

EXEC (@sql)	
			
INSERT INTO extract.AIS_Data (
	  MMSI
	, Message_Type
	, Longitude
	, Latitude
	, MID_Number
	, MID
	, Navigation_Status
	, Rate_Of_Turn_ROT
	, Speed_Over_Ground_SOG
	, Position_Accuracy
	, Course_Over_Ground_COG
	, True_Heading_HDG
	, Manoeuvre_Indicator
	, RAIM_Flag
	, ReceivedTime
	, Vessel_Name
	, IMO
	, Call_Sign
	, Ship_Type
	, Dimension_To_Bow
	, Dimension_To_Stern
	, Length
	, Dimension_To_Port
	, Dimension_To_Starboard
	, Beam
	, Position_Type_Fix
	, ETA_month
	, ETA_day
	, ETA_hour
	, ETA_minute
	, ETA_Draught
	, Destination
	, Batch
) SELECT  
	  MMSI
	, CAST(Message_Type AS tinyint)
	, CAST(Longitude AS decimal(10, 6))
	, CAST(Latitude AS decimal(10, 6))
	, CAST(MID_Number AS int)
	, MID
	, CAST(Navigation_Status AS tinyint)
	, CAST(Rate_Of_Turn_ROT AS int)
	, CAST(REPLACE(Speed_Over_Ground_SOG, ',', '.') AS decimal(10, 2))
	, CAST(Position_Accuracy  AS tinyint)
	, CAST(REPLACE(Course_Over_Ground_COG, ',', '.') AS decimal(10, 2))
	, CAST(True_Heading_HDG AS int)
	, CAST(Manoeuvre_Indicator AS tinyint)
	, CAST(RAIM_Flag AS tinyint)
	, CONVERT(datetime2(7), Received_Time, 103)
	, Vessel_Name
	, IMO
	, Call_Sign
	, CAST(Ship_Type AS int)
	, CAST(Dimension_To_Bow AS int)
	, CAST(Dimension_To_Stern AS int)
	, CAST(Length AS int)
	, CAST(Dimension_To_Port AS int)
	, CAST(Dimension_To_Starboard AS int)
	, CAST(Beam AS int)
	, CAST(Position_Type_Fix AS tinyint)
	, CAST(ETA_month AS tinyint)
	, CAST(ETA_day AS tinyint)
	, CAST(ETA_hour AS tinyint)
	, CAST(ETA_minute AS tinyint)
	, CAST(REPLACE(ETA_Draught, ',', '.') AS decimal(6, 2))
	, Destination
	, @Batch
FROM ##IncomingRecords