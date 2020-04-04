

CREATE VIEW [transform].[Dim_Vessel]
AS

WITH 
tbl_VesselCheckExists AS (	
SELECT distinct
	new.MMSI as MMSI,
	old.MMSI AS MMSI_exists,
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
	Batch,
	RecievedTime
FROM dbo.AIS_Data new
LEFT JOIN AIS_EDW.edw.Dim_Vessel old  
		ON new.MMSI = old.MMSI 
)

SELECT 
	MMSI,
	VesselName,
	MID,
	Batch,
	RecievedTime,
	CASE
		WHEN MMSI_exists IS NOT NULL THEN 1
		ELSE 0
	END as MMSI_exists,
	isVesNameChanged + isMIDChanged as isChanged
FROM tbl_VesselCheckExists