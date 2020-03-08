

CREATE VIEW [stage].[VIEW_DimVessel]
AS
	WITH temp_VesselInfo_1 as
	(Select 
			Type_of_mobile, 
			MMSI, 
			IMO, 
			Callsign, 
			Name, 
			Ship_type, 
			Cargo_type, 
			Width, 
			Length, 
			Draught 
		FROM dbo.Extract_Vessel)
	SELECT * FROM temp_VesselInfo_1