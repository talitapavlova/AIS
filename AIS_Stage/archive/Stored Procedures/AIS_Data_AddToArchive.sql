


CREATE PROCEDURE [archive].[AIS_Data_AddToArchive]
AS
BEGIN 

INSERT INTO archive.AIS_Data_archive (
	[MMSI]
   ,[Vessel_Name]
   ,[Latitude_Degree]
   ,[Latitde_MinutesSeconds]
   ,[Latitude_CardinalDirection]
   ,[Longitude_Degree]
   ,[Longitude_MinutesSeconds]
   ,[Longitude_CardinalDirection]
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
   ,[Longitude_CardinalDirection]
   ,[SOG]
   ,[COG]
   ,[RecievedTime]
   ,[MID]
FROM extract.AIS_Data)

END