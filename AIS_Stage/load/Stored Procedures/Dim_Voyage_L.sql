



/*
Change log: 
	2020-04-24	NP	Stored procedure created
*/

CREATE PROCEDURE [load].[Dim_Voyage_L]
AS
	
IF OBJECT_ID('tempdb..#Voyages') IS NOT NULL DROP TABLE #Voyages
SELECT 
	MMSI,
	minReceivedTime,
	maxReceivedTime,
	ETA_month,
	ETA_day,
	ETA_hour,
	ETA_minute,
	Destination,
	Batch,
	New_Row,
	Is_Current
INTO #Voyages
FROM  [transform].[Dim_Voyage_T]

UPDATE AIS_EDW.edw.Dim_Voyage
SET ETA_month = b.ETA_month,
	ETA_day = b.ETA_day,
	ETA_hour = b.ETA_hour,
	ETA_minute = b.ETA_minute,
	Update_Timestamp = b.maxReceivedTime,
	Batch_Updated = b.Batch,
	Is_Current = b.Is_Current
FROM AIS_EDW.edw.Dim_Voyage a
INNER JOIN #Voyages b 
	ON a.MMSI = b.MMSI
WHERE a.Is_Current = 1
	AND b.New_Row = 0

UPDATE AIS_EDW.edw.Dim_Voyage
SET Update_Timestamp = b.minReceivedTime,
	Batch_Updated = b.Batch,
	Is_Current = 0
FROM AIS_EDW.edw.Dim_Voyage a
INNER JOIN #Voyages b 
	ON a.MMSI = b.MMSI
WHERE a.Is_Current = 1
	AND b.New_Row = 1

INSERT INTO AIS_EDW.edw.Dim_Voyage (
	MMSI,
	Start_Timestamp,
	Update_Timestamp,
	ETA_month,
	ETA_day,
	ETA_hour,
	ETA_minute,
	Destination,
	Batch_Created,
	Batch_Updated,
	Is_Current) 
SELECT 	
	MMSI,
	minReceivedTime,
	maxReceivedTime,
	ETA_month,
	ETA_day,
	ETA_hour,
	ETA_minute,
	Destination,
	Batch,
	Batch,
	Is_Current
FROM #Voyages
WHERE New_Row = 1