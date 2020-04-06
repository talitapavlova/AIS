


CREATE VIEW [transform].[Dim_Vessel_T]
AS

WITH 
VesselCheckExists AS (	
SELECT DISTINCT
	new.MMSI as MMSI,
	CASE
		WHEN old.MMSI IS NOT NULL THEN 1
		ELSE 0
	END as MMSI_exists,
	new.Vessel_Name as VesselName,
	CASE 
		WHEN ISNULL(new.Vessel_Name, 0) = ISNULL(old.Vessel_Name, 0) THEN 0
		ELSE 1
	END AS isVesNameChanged,  
	new.MID as MID,
	CASE 
		WHEN ISNULL(new.MID, 0) = ISNULL(old.MID, 0) THEN 0
		ELSE 1
	END AS isMIDChanged,
	new.Batch,
	new.RecievedTime
FROM dbo.AIS_Data new
LEFT JOIN AIS_EDW.edw.Dim_Vessel old  
		ON new.MMSI = old.MMSI 
		AND old.BatchUpdated IS NULL
)
,

VesselValidFromAndTo AS (
SELECT 
	MMSI,
	VesselName,
	MID,
	Batch,
	RecievedTime,
	ROW_NUMBER() OVER(PARTITION BY MMSI ORDER BY RecievedTime DESC) as VesselRowNumDesc,
	ROW_NUMBER() OVER(PARTITION BY MMSI ORDER BY RecievedTime ASC) as VesselRowNumAsc,
	MMSI_exists,
	isVesNameChanged + isMIDChanged as isChanged
FROM VesselCheckExists
)

SELECT 
	MMSI,
	VesselName,
	MID,
	Batch,
	RecievedTime,
	CASE
		WHEN VesselRowNumDesc = 1 THEN CAST('9999-12-31' as datetime2)
		ELSE LAG (RecievedTime) OVER (PARTITION BY MMSI ORDER BY VesselRowNumDesc)
	END AS Valid_To,
	VesselRowNumDesc,
	VesselRowNumAsc,
	MMSI_exists,
	isChanged
FROM VesselValidFromAndTo