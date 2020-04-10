USE [AIS_Stage]
GO

/****** Object:  View [transform].[Fact_Route_T]    Script Date: 10/04/2020 14.15.39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [transform].[Fact_Route_T]
AS

SELECT 
	ves.Vessel_Key,
	dt.Date_Key,
	tm.Time_Key,
	a.Speed_Over_Ground_SOG,
	a.Course_Over_Ground_COG,
	lat.Latitude_Degree,
	lat.Latitude_Min,
	lat.Latitude_Sec,
	long.Longitude_Degree,
	long.Longitude_Min,
	long.Longitude_Sec,
	a.Batch
FROM extract.AIS_Data a
LEFT JOIN AIS_EDW.edw.Dim_Vessel ves  
	ON a.MMSI = ves.MMSI 
	AND a.ReceivedTime >= ves.Valid_From
	AND a.ReceivedTime < Valid_To
LEFT JOIN AIS_EDW.edw.Dim_Date dt  
	ON CAST(a.ReceivedTime as date) = dt.Date
LEFT JOIN AIS_EDW.edw.Dim_Time tm  
	ON CAST(a.ReceivedTime as time) = tm.Time
LEFT JOIN AIS_EDW.edw.Dim_Latitude lat
	ON a.Latitude = lat.Latitude_Key
LEFT JOIN AIS_EDW.edw.Dim_Longitude long
	ON a.Longitude = long.Longitude_Key
GO


