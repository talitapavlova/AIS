




/*
Change log: 
	2020-03-01	NP	View created
	2020-03-27	SI	Added Exist and isChanged logic
	2020-04-06	NP	Updated selection of rows to insert logic; Moved Valid_To calculations from load to transform; Added batch
	2020-04-10	NP	Updated to include more columns
*/


CREATE    VIEW [transform].[Dim_Vessel_T]
AS

WITH 
Vessels AS (	
SELECT
	new.MMSI,
	ISNULL(new.Vessel_Name, old.Vessel_Name) AS Vessel_Name,
	ISNULL(new.MID, old.MID) AS MID,
	ISNULL(new.MID_Number, old.MID_Number) AS MID_Number,
	ISNULL(new.IMO, old.IMO) AS IMO,
	ISNULL(new.Call_Sign, old.Call_Sign) AS Call_Sign,
	ISNULL(new.Ship_Type, old.Ship_Type) AS Ship_Type,
	ISNULL(new.Dimension_To_Bow, old.Dimension_To_Bow) AS Dimension_To_Bow,
	ISNULL(new.Dimension_To_Stern, old.Dimension_To_Stern) AS Dimension_To_Stern,
	ISNULL(new.Length, old.Length) AS Length,
	ISNULL(new.Dimension_To_Port, old.Dimension_To_Port) AS Dimension_To_Port,
	ISNULL(new.Dimension_To_Starboard, old.Dimension_To_Starboard) AS Dimension_To_Starboard,
	ISNULL(new.Beam, old.Beam) AS Beam,
	ISNULL(new.Position_Type_Fix, old.Position_Type_Fix) AS Position_Type_Fix,
	new.Batch,
	new.ReceivedTime,
	CASE
		WHEN old.MMSI IS NOT NULL THEN 1
		ELSE 0
	END as MMSI_exists,
	CASE 
		WHEN old.Vessel_Name IS NOT NULL AND new.Vessel_Name IS NULL THEN 0
		WHEN ISNULL(new.Vessel_Name, 0) = ISNULL(old.Vessel_Name, 0) THEN 0
		ELSE 1
	END AS isVesselNameChanged,  
	CASE 
		WHEN old.MID_Number IS NOT NULL AND new.MID_Number IS NULL THEN 0
		WHEN ISNULL(new.MID_Number, 0) = ISNULL(old.MID_Number, 0) THEN 0
		ELSE 1
	END AS isMIDChanged,

	CASE 
		WHEN old.IMO IS NOT NULL AND new.IMO IS NULL THEN 0
		WHEN ISNULL(new.IMO, 0) = ISNULL(old.IMO, 0) THEN 0
		ELSE 1
	END AS isIMOChanged,
	CASE 
		WHEN old.Call_Sign IS NOT NULL AND new.Call_Sign IS NULL THEN 0
		WHEN ISNULL(new.Call_Sign, 0) = ISNULL(old.Call_Sign, 0) THEN 0
		ELSE 1
	END AS isCallSignChanged,
	CASE 
		WHEN old.Ship_Type IS NOT NULL AND new.Ship_Type IS NULL THEN 0
		WHEN ISNULL(new.Ship_Type, 0) = ISNULL(old.Ship_Type, 0) THEN 0
		ELSE 1
	END AS isShipTypeChanged,
	CASE 
		WHEN old.Dimension_To_Bow IS NOT NULL AND new.Dimension_To_Bow IS NULL THEN 0
		WHEN ISNULL(new.Dimension_To_Bow, 0) = ISNULL(old.Dimension_To_Bow, 0) THEN 0
		ELSE 1
	END AS isDimToBowChanged,
	CASE 
		WHEN old.Dimension_To_Stern IS NOT NULL AND new.Dimension_To_Stern IS NULL THEN 0
		WHEN ISNULL(new.Dimension_To_Stern, 0) = ISNULL(old.Dimension_To_Stern, 0) THEN 0
		ELSE 1
	END AS isDimToSternChanged,
	CASE 
		WHEN old.Length IS NOT NULL AND new.Length IS NULL THEN 0
		WHEN ISNULL(new.Length, 0) = ISNULL(old.Length, 0) THEN 0
		ELSE 1
	END AS isLengthChanged,
	CASE 
		WHEN old.Dimension_To_Port IS NOT NULL AND new.Dimension_To_Port IS NULL THEN 0
		WHEN ISNULL(new.Dimension_To_Port, 0) = ISNULL(old.Dimension_To_Port, 0) THEN 0
		ELSE 1
	END AS isDimToPortChanged,
	CASE 
		WHEN old.Dimension_To_Starboard IS NOT NULL AND new.Dimension_To_Starboard IS NULL THEN 0
		WHEN ISNULL(new.Dimension_To_Starboard, 0) = ISNULL(old.Dimension_To_Starboard, 0) THEN 0
		ELSE 1
	END AS isDimToStarboardChanged,
	CASE 
		WHEN old.Beam IS NOT NULL AND new.Beam IS NULL THEN 0
		WHEN ISNULL(new.Beam, 0) = ISNULL(old.Beam, 0) THEN 0
		ELSE 1
	END AS isBeamChanged,
	CASE 
		WHEN old.Position_Type_Fix IS NOT NULL AND new.Position_Type_Fix IS NULL THEN 0
		WHEN ISNULL(new.Position_Type_Fix, 0) = ISNULL(old.Position_Type_Fix, 0) THEN 0
		ELSE 1
	END AS isPositionTypeFixChanged
FROM extract.AIS_Data new
LEFT JOIN edw.Dim_Vessel old  
	ON new.MMSI = old.MMSI 
	AND old.BatchUpdated IS NULL
WHERE new.Message_Type in (24, 19, 5)
)
, 

UniqueVesselsInBatch AS (
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
	MIN(ReceivedTime) as ReceivedTime
FROM Vessels 
GROUP BY MMSI, Vessel_Name, MID, MID_Number, IMO, Call_Sign, Ship_Type, Dimension_To_Bow, 
	Dimension_To_Stern, Length,  Dimension_To_Port, Dimension_To_Starboard, Beam, Position_Type_Fix
)
,

VesselsInOrder AS (
SELECT
	uni.MMSI,
	uni.Vessel_Name,
	uni.MID,
	uni.MID_Number,
	uni.IMO,
	uni.Call_Sign,
	uni.Ship_Type,
	uni.Dimension_To_Bow,
	uni.Dimension_To_Stern,
	uni.Length, 
	uni.Dimension_To_Port,
	uni.Dimension_To_Starboard,
	uni.Beam,
	uni.Position_Type_Fix,
	v.Batch,
	uni.ReceivedTime,
	v.MMSI_exists,
	isVesselNameChanged + isMIDChanged + isIMOChanged + isCallSignChanged + 
		isShipTypeChanged + isPositionTypeFixChanged + isDimToBowChanged + isDimToSternChanged + 
		isLengthChanged + isDimToPortChanged + isDimToStarboardChanged + isBeamChanged AS isChanged,
	ROW_NUMBER() OVER(PARTITION BY uni.MMSI ORDER BY uni.ReceivedTime DESC) AS VesselRowNumDesc,
	ROW_NUMBER() OVER(PARTITION BY uni.MMSI ORDER BY uni.ReceivedTime ASC) AS VesselRowNumAsc
FROM UniqueVesselsInBatch uni
LEFT JOIN Vessels v
	ON uni.MMSI = v.MMSI 
	AND uni.ReceivedTime = v.ReceivedTime
)

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
	CASE
		WHEN VesselRowNumDesc = 1 THEN CAST('9999-12-31' as datetime2)
		ELSE LAG (ReceivedTime) OVER (PARTITION BY MMSI ORDER BY VesselRowNumDesc)
	END AS Valid_To,
	VesselRowNumDesc,
	VesselRowNumAsc,
	MMSI_exists,
	isChanged
FROM VesselsInOrder