




CREATE VIEW [transform].[Fact_Route_T]
AS

SELECT 
	ves.Vessel_Key,
	dt.Date_Key,
	tm.Time_Key
FROM dbo.AIS_Data a
LEFT JOIN AIS_EDW.edw.Dim_Vessel ves  
	ON a.MMSI = ves.MMSI 
	AND ves.Valid_To = CAST('9999-12-31' as datetime2(7))
LEFT JOIN AIS_EDW.edw.Dim_Date dt  
	ON CAST(a.RecievedTime as date) = dt.Date
LEFT JOIN AIS_EDW.edw.Dim_Time tm  
	ON CAST(a.RecievedTime as time) = tm.Time