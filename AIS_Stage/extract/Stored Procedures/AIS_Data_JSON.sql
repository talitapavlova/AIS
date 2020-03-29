
---------------------------JSON

CREATE    PROCEDURE [extract].[AIS_Data_JSON]
AS
BEGIN 

-- Insert Unknown members

INSERT INTO AIS_Stage.dbo.Extract_Vessel 
SELECT 	
	Timestamp, 
	Type_of_mobile, 
	MMSI, 
	Latitude,
	Longitude,
	Navigational_Status,
	ROT,
	SOG,
	COG,
	Heading,
	IMO,
	Call_Sign,
	Name,
	Ship_type,
	Cargo_type,
	Width,
	Length,
	Type_of_position_fixing_device,
	Draught,
	Destination,
	ETA,
	Data_source_type,
	A,
	B,
	C,
	D	
FROM OPENROWSET (BULK 'C:\Users\stefy\Desktop\375.json', SINGLE_CLOB) as j 
	CROSS APPLY OPENJSON(BulkColumn)
	WITH(
			Timestamp nvarchar(100) '$.Timestamp',
			Type_of_mobile nvarchar(100) '$."Type of mobile" ',
			MMSI nvarchar(100) '$.MMSI',
			Latitude nvarchar(100) '$.Latitude',
			Longitude nvarchar(100) '$.Longitude',
			Navigational_Status nvarchar(100) '$.NavigationalStatus',
			ROT nvarchar(100) '$.ROT',
			SOG nvarchar(100) '$.SOG',
			COG nvarchar(100) '$.COG',
			Heading nvarchar(100) '$.Heading',
			IMO nvarchar(100) '$.IMO',
			Call_Sign nvarchar(100) '$.Callsign',
			Name nvarchar(100) '$.Name',
			Ship_type nvarchar(100) '$."Ship type" ',
			Cargo_type nvarchar(100) '$."Cargo type" ',
			Width nvarchar(100) '$.Width',
			Length nvarchar(100) '$.Length',
			Type_of_position_fixing_device nvarchar(100) '$."Type of position fixing device" ',
			Draught nvarchar(100) '$.Draught',
			Destination nvarchar(100) '$.Destination',
			ETA nvarchar(100) '$.ETA',
			Data_source_type nvarchar(100) '$."Data source type"',
			A nvarchar(100) '$.A',
			B nvarchar(100) '$.B',
			C nvarchar(100) '$.C',
			D nvarchar(100) '$.D'	
	)
END