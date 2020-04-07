



CREATE PROCEDURE [load].[Dim_Vessel_L]
AS
	
IF OBJECT_ID('tempdb..#newRecords') IS NOT NULL DROP TABLE #newRecords
SELECT 
	MMSI, 
	VesselName, 
	MID, 
	Batch,
	ReceivedTime,
	Valid_To,
	VesselRowNumDesc,
	VesselRowNumAsc,
	MMSI_exists,
	isChanged
INTO #newRecords
FROM  [transform].[Dim_Vessel_T]

UPDATE AIS_EDW.edw.Dim_Vessel
SET Valid_To = b.ReceivedTime,
	BatchUpdated = b.Batch
FROM AIS_EDW.edw.Dim_Vessel a
INNER JOIN #newRecords b 
	ON a.MMSI = b.MMSI 
	AND b.VesselRowNumAsc = 1
WHERE a.BatchUpdated IS NULL 
	AND b.MMSI_exists = 1 
	AND b.isChanged > 0

INSERT INTO AIS_EDW.edw.Dim_Vessel (
	MMSI, 
	MID,  
	Vessel_Name, 
	BatchCreated,
	BatchUpdated,
	Valid_From, 
	Valid_To) 
SELECT 	
	MMSI, 
	MID, 
	VesselName,
	Batch,
	CASE 
		WHEN VesselRowNumDesc != 1 THEN Batch
		ELSE NULL
	END,
	ReceivedTime,
	Valid_To
FROM #newRecords
WHERE MMSI_exists = 0
	OR (MMSI_exists = 1 AND isChanged > 0)