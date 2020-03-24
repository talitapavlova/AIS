

CREATE VIEW [transform].[Dim_Vessel]
AS
	Select 
			MMSI, 
			IMO, 
			Type_of_mobile, 
			Call_Sign, 
			Name, 
			Ship_type, 
			try_cast(replace([Latitude],'.','') as float) as Latitude,
			try_cast(replace([Longitude],'.','') as float) as Longitude,
			CAST(Width as float) as Width,
			CAST(Length as float) as Length,
			CAST(Draught as float) as Draugth,
			convert ([Timestamp], GETDATE(), 13) as DateCreated
		FROM dbo.Extract_Vessel