





CREATE PROCEDURE [dbo].[SP_Extract_Vessel]
AS
BEGIN 

-- Insert Unknown members

INSERT INTO AIS_Stage.dbo.Extract_Vessel (
	Timestamp, 
	Type_of_mobile, 
	MMSI, 
	Latitude,
	Longitude,
	NavigationalStatus,
	ROT,
	SOG,
	COG,
	Heading,
	IMO,
	Callsign,
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
)
SELECT 	
	Timestamp, 
	Type_of_mobile, 
	MMSI, 
	Latitude,
	Longitude,
	NavigationalStatus,
	ROT,
	SOG,
	COG,
	Heading,
	IMO,
	Callsign,
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
FROM OPENROWSET (BULK 'C:\Users\winpc\Desktop\Vessels_FEW_Records.json', SINGLE_CLOB) as j 
	CROSS APPLY OPENJSON(BulkColumn)
	WITH(
			Timestamp nvarchar(100) '$.Timestamp',
			Type_of_mobile nvarchar(100) '$."Type of mobile" ',
			MMSI nvarchar(100) '$.MMSI',
			Latitude nvarchar(100) '$.Latitude',
			Longitude nvarchar(100) '$.Longitude',
			NavigationalStatus nvarchar(100) '$.NavigationalStatus',
			ROT nvarchar(100) '$.ROT',
			SOG nvarchar(100) '$.SOG',
			COG nvarchar(100) '$.COG',
			Heading nvarchar(100) '$.Heading',
			IMO nvarchar(100) '$.IMO',
			Callsign nvarchar(100) '$.Callsign',
			Name nvarchar(100) '$.Name',
			Ship_type nvarchar(100) '$.Ship_type',
			Cargo_type nvarchar(100) '$.Cargo_type',
			Width nvarchar(100) '$.Width',
			Length nvarchar(100) '$.Length',
			Type_of_position_fixing_device nvarchar(100) '$.Type_of_position_fixing_device',
			Draught nvarchar(100) '$.Draught',
			Destination nvarchar(100) '$.Destination',
			ETA nvarchar(100) '$.ETA',
			Data_source_type nvarchar(100) '$.Data_source_type',
			A nvarchar(100) '$.A',
			B nvarchar(100) '$.B',
			C nvarchar(100) '$.C',
			D nvarchar(100) '$.D'	
	)
END