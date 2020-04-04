








/**

 - The following procedure uses the OEPNROWSET and FILEFORMAT for allowing to import csv. data line by line into a TEMPORARY table, with no defined structure. 
	An alternative would be to use BULK INSERT and have an already created table in the SQL Server, where to import the data. However, for aviding creating 
	the intial table only with the purpose of extracting initial data and keeping the solution neat, the OEPNROWSET with FILEFORMAT solution had been chosen. 
	For OPENROWSET to perform accordingly a FILEFORMAT has to be cerated. The file can be created manually or be generated using the BCP utility. 
	* For more information : https://docs.microsoft.com/en-us/sql/relational-databases/import-export/use-a-format-file-to-bulk-import-data-sql-server?view=sql-server-ver15

 - Create FILEFORMAT file manually  - ONLY WHEN FIRST TIME RUNNING THIS PROCEDURE ON THE SERVER THE FOLLOWING MUST BE DONE:
		- Open a notepad file and replace with following text:
		
			14.0
			8
			1       SQLCHAR             0       200     "|"      1     MMSI                         SQL_Latin1_General_CP1_CI_AS
			2       SQLCHAR             0       200     "|"      2     Vessel_Name                  SQL_Latin1_General_CP1_CI_AS
			3       SQLCHAR             0       200     "|"      3     Latitude                     SQL_Latin1_General_CP1_CI_AS
			4       SQLCHAR             0       200     "|"      4     Longitude                    SQL_Latin1_General_CP1_CI_AS
			5       SQLCHAR             0       200     "|"      5     SOG                          SQL_Latin1_General_CP1_CI_AS
			6       SQLCHAR             0       200     "|"      6     COG                          SQL_Latin1_General_CP1_CI_AS
			7       SQLCHAR             0       200     "|"      7     RecievedTime                 SQL_Latin1_General_CP1_CI_AS
			8       SQLCHAR             0       200     "\r\n"   8     MID                          SQL_Latin1_General_CP1_CI_AS

		- Provide the path as the value of FILEFORMAT in OPENROWSET
 ***/
 

CREATE PROCEDURE [extract].[AIS_Data_CSV]
AS

--TRUNCATE table [dbo].[AIS_Data]

WITH 
tbl_IncomingRecords  AS ( 
	SELECT
		a.MMSI,
		a.Vessel_Name,
		a.Latitude,
		a.Longitude,
		a.SOG,
		a.COG,
		a.RecievedTime,
		a.MID
	FROM OPENROWSET ( BULK 'C:\AIS\output_in_use.csv',   
						FIRSTROW = 2,
						FORMATFILE ='C:\AIS\format.fmt'				  					
					) AS a WHERE a.MMSI is not null)

INSERT INTO dbo.AIS_Data (
	[MMSI],
    [Vessel_Name],
    [Latitude_Degree],
    [Latitde_MinutesSeconds],
    [Latitude_CardinalDirection],
    [Longitude_Degree],
    [Longitude_MinutesSeconds],
    [Longitude_CardinalDirection],
    [SOG],
    [COG],
    [RecievedTime],
    [MID]
) SELECT  
	MMSI,
	Vessel_Name,
	substring(Latitude, 1,  CHARindex( '°', Latitude, 1)),		-- Lat_Degree
	substring(Latitude,  CHARINDEX('°', Latitude)+1,  CHARINDEX('''', Latitude)-(CHARINDEX('°', Latitude))),		-- Lat_MinSec 
	substring(reverse(Latitude), 1, 1),							-- Lat_Cardinal_Direction
	substring(Longitude, 1,  CHARindex( '°', Longitude, 1)),	-- Long_Degree
	substring(Longitude,  CHARINDEX('°', Longitude)+1,  CHARINDEX('''', Longitude)-(CHARINDEX('°', Longitude))),	--Long_MinSec
    substring(reverse(Longitude), 1, 1),						-- Long_Cardinal_Direction 
	convert(decimal(10,2), replace(SOG, ',', '.') ),			-- SOG 
	convert(decimal(10,2), replace(COG, ',', '.') ),			-- COG 
	convert(datetime2, RecievedTime, 103),						-- RecievedTime
	MID
FROM tbl_IncomingRecords