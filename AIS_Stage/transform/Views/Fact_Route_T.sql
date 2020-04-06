



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
	AND a.RecievedTime >= ves.Valid_From
	AND a.RecievedTime < Valid_To
LEFT JOIN AIS_EDW.edw.Dim_Date dt  
	ON CAST(a.RecievedTime as date) = dt.Date
LEFT JOIN AIS_EDW.edw.Dim_Time tm  
	ON CAST(a.RecievedTime as time) = tm.Time