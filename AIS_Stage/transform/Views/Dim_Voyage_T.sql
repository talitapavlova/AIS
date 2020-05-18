




/*
Change log: 
	2020-04-21	NP	View created
*/


CREATE VIEW [transform].[Dim_Voyage_T]
AS

WITH 
Voyages AS (
SELECT 
	MMSI,
	ReceivedTime,
	ETA_month,
	ETA_day,
	ETA_hour,
	ETA_minute,
	Replace(Destination, '@', '') as Destination,
	Batch
FROM archive.AIS_Data_archive
WHERE Destination is not null
	AND Batch > (SELECT ISNULL(MAX(Batch), 0) from utility.Batch)
)
, 

UniqueVoyage_step1 AS (
SELECT
	MMSI,
	min(ReceivedTime) as minReceivedTime,
	max(ReceivedTime) as maxReceivedTime,
	Destination
FROM Voyages
GROUP BY MMSI, Destination
)
,

UniqueVoyage_step2 AS (
SELECT DISTINCT
	v.MMSI,
	uv.minReceivedTime,
	uv.maxReceivedTime,
	v.ETA_month,
	v.ETA_day,
	v.ETA_hour,
	v.ETA_minute,
	v.Destination,
	v.Batch
FROM UniqueVoyage_step1 uv
INNER JOIN Voyages v
	ON uv.MMSI = v.MMSI
	AND uv.maxReceivedTime = v.ReceivedTime
)
,

CleanedVoyageData AS (
SELECT
	MMSI,
	maxReceivedTime,
	count(MMSI) as RemoveFlag
FROM UniqueVoyage_step2 
GROUP BY MMSI, maxReceivedTime
)
,

UniqueVoyage_final AS (
SELECT
	cv.MMSI,
	minReceivedTime,
	cv.maxReceivedTime,
	ETA_month,
	ETA_day,
	ETA_hour,
	ETA_minute,
	Destination,
	Batch,
	ROW_NUMBER() OVER(PARTITION BY cv.MMSI ORDER BY cv.maxReceivedTime DESC) AS VoyageRowNumDesc
FROM CleanedVoyageData cv
LEFT JOIN UniqueVoyage_step2 uv 
	ON cv.MMSI = uv.MMSI
	AND cv.maxReceivedTime = uv.maxReceivedTime
WHERE cv.RemoveFlag = 1
)

SELECT
	uv.MMSI,
	uv.minReceivedTime,
	uv.maxReceivedTime,
	uv.ETA_month,
	uv.ETA_day,
	uv.ETA_hour,
	uv.ETA_minute,
	uv.Destination,
	uv.Batch,
	0 AS New_Row,
	CASE 
		WHEN uv.VoyageRowNumDesc = 1 THEN 1
		ELSE 0
	END AS Is_Current
FROM UniqueVoyage_final uv
INNER JOIN AIS_EDW.edw.Dim_Voyage dv
	ON uv.MMSI = dv.MMSI
	AND uv.Destination = dv.Destination
	AND dv.Is_Current = 1
	AND (uv.ETA_month != dv.ETA_month OR uv.ETA_day != dv.ETA_day OR uv.ETA_hour != dv.ETA_hour OR uv.ETA_minute != dv.ETA_minute)

UNION

SELECT
	uv.MMSI,
	uv.minReceivedTime,
	uv.maxReceivedTime,
	uv.ETA_month,
	uv.ETA_day,
	uv.ETA_hour,
	uv.ETA_minute,
	uv.Destination,
	uv.Batch,
	1 AS New_Row,
	CASE 
		WHEN uv.VoyageRowNumDesc = 1 THEN 1
		ELSE 0
	END AS Is_Current
FROM UniqueVoyage_final uv
LEFT JOIN AIS_EDW.edw.Dim_Voyage dv
	ON uv.MMSI = dv.MMSI
	AND uv.Destination = dv.Destination
	AND dv.Is_Current = 1
WHERE 
	dv.MMSI is null