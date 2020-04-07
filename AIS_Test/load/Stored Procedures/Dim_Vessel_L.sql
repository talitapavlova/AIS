

--execute [load].[Dim_Vessel_L]

CREATE      PROCEDURE [load].[Dim_Vessel_L]
AS

-- temporary
--TRUNCATE table AIS_EDW.edw.Dim_Vessel
		
IF OBJECT_ID('tempdb..#newRecords') IS NOT NULL DROP TABLE #newRecords
SELECT 
	MMSI, 
	VesselName, 
	MID, 
	MMSI_exists,
	isChanged 
INTO #newRecords
FROM  [transform].[Dim_Vessel]

UPDATE AIS_Test.edw.Dim_Vessel
SET Valid_To = GetDate()
WHERE MMSI in (SELECT MMSI 
				FROM #newRecords 
				WHERE MMSI_exists = 1 AND isChanged > 0)
						AND Valid_To = CAST('9999-12-31' as datetime2)

INSERT INTO AIS_Test.edw.Dim_Vessel (
	MMSI, 
	MID,  
	Vessel_Name, 
	Valid_From, 
	Valid_To) 
SELECT 	
	MMSI, 
	MID, 
	VesselName,
	CAST( CONVERT(varchar, getdate(), 0) AS datetime2),
	CAST('9999-12-31' AS datetime2) 			
FROM #newRecords
WHERE MMSI_exists = 0
	OR (MMSI_exists = 1 AND isChanged > 0)

-- TEMPORARY SOLUTION: delete everything from dbo.AIS_data
--TRUNCATE table dbo.AIS_Data