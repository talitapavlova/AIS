


CREATE PROCEDURE [load].[Dim_Vessel_L]
AS

-- temporary
--TRUNCATE table AIS_EDW.edw.Dim_Vessel
	
IF OBJECT_ID('tempdb..#newRecords') IS NOT NULL DROP TABLE #newRecords
SELECT 
	MMSI, 
	VesselName, 
	MID, 
	Batch,
	RecievedTime,
	MMSI_exists,
	isChanged
INTO #newRecords
FROM  [transform].[Dim_Vessel]

UPDATE AIS_EDW.edw.Dim_Vessel
SET Valid_To = b.RecievedTime,
	BatchUpdated = b.Batch
FROM AIS_EDW.edw.Dim_Vessel a
INNER JOIN #newRecords b ON a.MMSI = b.MMSI
WHERE a.BatchUpdated IS NULL 
	AND b.MMSI_exists = 1 
	AND b.isChanged > 0

INSERT INTO AIS_EDW.edw.Dim_Vessel (
	MMSI, 
	MID,  
	Vessel_Name, 
	BatchCreated,
	Valid_From, 
	Valid_To) 
SELECT 	
	MMSI, 
	MID, 
	VesselName,
	Batch,
	RecievedTime,
	CAST('9999-12-31' AS datetime2)
FROM #newRecords
WHERE MMSI_exists = 0
	OR (MMSI_exists = 1 AND isChanged > 0)