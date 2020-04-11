

/*
Change log: 
	2020-03-01	NP	Stored procedure created
	2020-03-30	SI	Added Update of Dim_Vessel for no longer valid rows
	2020-04-06	NP	Added Batch logic
	2020-04-10	NP	Updated to include more columns
*/

CREATE PROCEDURE [load].[Dim_Vessel_L]
AS
	
IF OBJECT_ID('tempdb..#newRecords') IS NOT NULL DROP TABLE #newRecords
SELECT 
	MMSI,
	Vessel_Name,
	MID,
	MID_Number,
	IMO,
	Call_Sign,
	Ship_Type,
	Dimension_To_Bow,
	Dimension_To_Stern,
	Length, 
	Dimension_To_Port,
	Dimension_To_Starboard,
	Beam,
	Position_Type_Fix,
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
	Vessel_Name,
	MID,
	MID_Number,
	IMO,
	Call_Sign,
	Ship_Type,
	Dimension_To_Bow,
	Dimension_To_Stern,
	Length, 
	Dimension_To_Port,
	Dimension_To_Starboard,
	Beam,
	Position_Type_Fix,
	BatchCreated,
	BatchUpdated,
	Valid_From, 
	Valid_To) 
SELECT 	
	MMSI,
	Vessel_Name,
	MID,
	MID_Number,
	IMO,
	Call_Sign,
	Ship_Type,
	Dimension_To_Bow,
	Dimension_To_Stern,
	Length, 
	Dimension_To_Port,
	Dimension_To_Starboard,
	Beam,
	Position_Type_Fix,
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