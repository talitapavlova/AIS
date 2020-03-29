


CREATE VIEW [transform].[Dim_Vessel]
AS

WITH tbl_VesselCheckExists 
AS
(	SELECT distinct
			new.MMSI as newMMSI,
			old.MMSI AS MMSI_AlreadyExisting,
			new.Vessel_Name as newVesselName, 
			old.Vessel_Name as oldVesselName,  
			new.MID as newMID , 
			old.MID as oldMID,
			new.RecievedTime as newReceivedTime
	FROM dbo.AIS_Data new
		LEFT JOIN
	AIS_EDW.edw.Dim_Vessel old  
		ON new.MMSI = old.MMSI 
)	
,
tbl_VesselsToBeLoaded AS 
(
	SELECT 
		newMMSI,
		MMSI_AlreadyExisting,
		newVesselName, 
		oldVesselName,
		newMID, 
		oldMID,
		newReceivedTime,
		GETDATE() AS Valid_From, 
		CAST('9999-12-31' AS datetime2) Valid_To, 
		CASE 
		   --case when operating with both old and new records:
			WHEN MMSI_AlreadyExisting IS NOT NULL THEN  	
				--check if old records and new records have different values : if different set 1 , else null 
				(CASE 
			 		WHEN 
					  isNull(newVesselName, 0) != isNull(oldVesselName,0) 
					  OR isNull(newMID,0)  != isNull( oldMID,1) THEN 1
					ELSE null
				END)
			-- case when opearting only with new records (set 0): 
			ELSE 0 
		END AS Already_Existing
	FROM tbl_VesselCheckExists
)
	SELECT * FROM tbl_VesselsToBeLoaded