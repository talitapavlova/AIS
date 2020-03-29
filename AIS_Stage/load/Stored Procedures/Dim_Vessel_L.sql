


CREATE    PROCEDURE [load].[Dim_Vessel_L]
AS
		
-- use CTE since only working with few attributes from VIEW and disregard already existing records with no new data
WITH tbl_NewRecords 
	AS(
		SELECT 
			newMMSI, 
			newVesselName, 
			newMID, 
			newReceivedTime, 
			Valid_From, 
			Valid_To, 
			Already_Existing
		FROM  [transform].[Dim_Vessel] where Already_Existing is not null
	)
	
	MERGE INTO AIS_EDW.edw.Dim_Vessel dimTbl
	USING (SELECT distinct * FROM  tbl_NewRecords) s
		ON (dimTbl.MMSI = s.newMMSI)
	WHEN MATCHED THEN 
		UPDATE Set dimTbl.Valid_To = GetDate()
	WHEN NOT MATCHED THEN 
		INSERT (MMSI, MID,  Vessel_Name, Recieved_Time, Valid_From, Valid_To) 
				VALUES ( 
				newMMSI, 
				newMID, 
				newVesselName,
				newReceivedTime,
				GETDATE(),
				CAST('9999-12-31' AS datetime2));

--insert already existing records containing new data 
INSERT INTO AIS_EDW.edw.Dim_Vessel (MMSI, MID,  Vessel_Name, Recieved_Time, Valid_From, Valid_To) 
	SELECT 	
		newMMSI, 
		newMID, 
		newVesselName,
		newReceivedTime,
		GETDATE(),
		CAST('9999-12-31' AS datetime2) 			
	FROM [transform].[Dim_Vessel]
	WHERE (Already_Existing is not null)

-- TEMPORARY SOLUTION: delete everything from dbo.AIS_data
DELETE FROM dbo.AIS_Data