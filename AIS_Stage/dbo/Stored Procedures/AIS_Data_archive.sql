


CREATE PROCEDURE [dbo].[AIS_Data_archive]
AS
BEGIN 

INSERT INTO AIS_EDW.archive.AIS_Data_archive (
	[MMSI]
   ,[Vessel_Name]
   ,[Latitude_Degree]
   ,[Latitde_MinutesSeconds]
   ,[Latitude_CardinalDirection]
   ,[Longitude_Degree]
   ,[Longitude_MinutesSeconds]
   ,[Longitude_CardinalDirection ]
   ,[SOG]
   ,[COG]
   ,[RecievedTime]
   ,[MID])
( SELECT 
	[MMSI]
   ,[Vessel_Name]
   ,[Latitude_Degree]
   ,[Latitde_MinutesSeconds]
   ,[Latitude_CardinalDirection]
   ,[Longitude_Degree]
   ,[Longitude_MinutesSeconds]
   ,[Longitude_CardinalDirection ]
   ,[SOG]
   ,[COG]
   ,[RecievedTime]
   ,[MID]
FROM dbo.AIS_Data)

END