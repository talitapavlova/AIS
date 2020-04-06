




CREATE VIEW [transform].[Fact_Route_T]
AS

SELECT 
	ves.Vessel_Key,
	dt.Date_Key,
	tm.Time_Key,
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