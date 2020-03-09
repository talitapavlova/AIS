





CREATE VIEW [stage].[VIEW_DimVessel]
AS
	Select 
			MMSI, 
			IMO, 
			Type_of_mobile, 
			Call_Sign, 
			Name, 
			Ship_type,
			Cast(Width as decimal) as Width_, 
			Cast(Length as decimal) as Length_,
			Cast(Draught as decimal) as Draugth_, 
			Cast(Timestamp as datetime2) as DateCreated_
		FROM dbo.Extract_Vessel