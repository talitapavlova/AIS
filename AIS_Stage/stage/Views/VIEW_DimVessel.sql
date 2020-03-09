




CREATE VIEW [stage].[VIEW_DimVessel]
AS
	(Select 
			MMSI, 
			IMO, 
			Type_of_mobile, 
			Call_Sign, 
			Name, 
			Ship_type,
			Width, 
			Length, 
			Draught, 
			Timestamp
		FROM dbo.Extract_Vessel)