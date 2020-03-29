



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
 

Create   PROCEDURE [extract].[AIS_Data_CSV]
AS
	WITH tbl_IncomingRecords  AS 
		( SELECT  a.* FROM OPENROWSET ( BULK 'C:\DummyData\375.csv',   
											FIRSTROW = 2,
											FORMATFILE ='C:\DummyData\test.fmt'				  					
											) AS a WHERE a.MMSI is not null)
											
	INSERT INTO dbo.AIS_Data
		SELECT  
			MMSI,
			Vessel_Name,

			substring(Latitude, 1,  CHARindex( '°', Latitude, 1)) as Lat_Degree,
			substring(Latitude,  CHARINDEX('°', Latitude)+1,  CHARINDEX('''', Latitude)-(CHARINDEX('°', Latitude))) as Lat_MinSec,
			substring(reverse(Latitude), 1, 1) as Lat_Cardinal_Direction ,
			substring(Longitude, 1,  CHARindex( '°', Longitude, 1)) as Long_Degree,
			substring(Longitude,  CHARINDEX('°', Longitude)+1,  CHARINDEX('''', Longitude)-(CHARINDEX('°', Longitude))) as Long_MinSec, 
            substring(reverse(Longitude), 1, 1) as Long_Cardinal_Direction ,
			convert(decimal(10,2), replace(SOG, ',', '.') ) as SOG ,
			convert(decimal(10,2), replace(COG, ',', '.') ) as COG ,
			convert(datetime2, RecievedTime, 103) as DateCreated,
			MID
		FROM tbl_IncomingRecords