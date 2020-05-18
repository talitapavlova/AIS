






/*
Change log: 
	2020-04-01	NP	View created with Vessel, Date and Time
	2020-04-10	SI	Added Latitude and Longitude
	2020-04-11	NP	Added measures
	2020-04-24	NP	Added Voyage
*/

CREATE VIEW [transform].[Fact_Route_T]
AS

SELECT 
	ves.Vessel_Key,
	a.MMSI,
	dt.Date_Key,
	tm.Time_Key,
	lat.Latitude_Key,
	long.Longitude_Key,
	a.Navigation_Status,
	voy.Voyage_Key,
	a.Rate_Of_Turn_ROT,
	a.Speed_Over_Ground_SOG,
	a.Course_Over_Ground_COG,
	a.True_Heading_HDG,
	a.Position_Accuracy,
	a.Manoeuvre_Indicator,
	a.RAIM_Flag,
	a.ETA_Draught AS Draught,
	a.Batch
FROM archive.AIS_Data_archive a
LEFT JOIN AIS_EDW.edw.Dim_Vessel ves  
	ON a.MMSI = ves.MMSI 
	AND a.ReceivedTime >= ves.Valid_From
	AND a.ReceivedTime < ves.Valid_To
LEFT JOIN AIS_EDW.edw.Dim_Date dt  
	ON CAST(a.ReceivedTime as date) = dt.Date
LEFT JOIN AIS_EDW.edw.Dim_Time tm  
	ON CAST(a.ReceivedTime as time) = tm.Time
LEFT JOIN AIS_EDW.edw.Dim_Latitude lat
	ON a.Latitude * 1000000 = lat.Latitude_Key
LEFT JOIN AIS_EDW.edw.Dim_Longitude long
	ON a.Longitude * 1000000 = long.Longitude_Key
LEFT JOIN AIS_EDW.edw.Dim_Voyage voy  
	ON a.MMSI = voy.MMSI 
	AND voy.Is_Current = 1
WHERE a.Batch > (SELECT ISNULL(MAX(Batch), 0) from utility.Batch)
GO


