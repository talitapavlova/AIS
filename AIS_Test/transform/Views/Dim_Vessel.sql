





CREATE VIEW [transform].[Dim_Vessel]
AS

WITH 
tbl_VesselCheckExists AS (	
SELECT distinct
	new.MMSI as MMSI,
	old.MMSI AS MMSI_exists,
	new.Vessel_Name as VesselName,
	CASE 
		WHEN new.Vessel_Name = old.Vessel_Name THEN 0
		WHEN new.Vessel_Name IS NULL AND old.Vessel_Name IS NULL THEN 0
		ELSE 1
	END AS isVesNameChanged,  
	new.MID as MID,
	CASE 
		WHEN new.MID = old.MID THEN 0
		WHEN new.MID IS NULL AND old.MID IS NULL THEN 0
		ELSE 1
	END AS isMIDChanged
FROM AIS_Test.dbo.AIS_Data new
LEFT JOIN AIS_Test.edw.Dim_Vessel old  
		ON new.MMSI = old.MMSI 
)

SELECT 
	MMSI,
	VesselName,
	MID,
	CASE
		WHEN MMSI_exists IS NOT NULL THEN 1
		ELSE 0
	END as MMSI_exists,
	isVesNameChanged + isMIDChanged as isChanged
FROM tbl_VesselCheckExists