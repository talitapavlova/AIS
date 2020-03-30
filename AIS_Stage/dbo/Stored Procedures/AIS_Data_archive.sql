

CREATE PROCEDURE [dbo].[AIS_Data_archive]
AS
BEGIN 

INSERT INTO AIS_EDW.archive.AIS_Data_archive (
	[Timestamp],
    [Type_of_mobile],
    [MMSI],
    [Latitude],
    [Longitude],
    [Navigational_Status],
    [ROT],
    [SOG],
    [COG],
    [Heading],
    [IMO],
    [Call_Sign],
    [Name],
    [Ship_type],
    [Cargo_type],
    [Width],
    [Length],
    [Type_of_position_fixing_device],
    [Draught],
    [Destination],
    [ETA],
    [Data_source_type],
    [A],
    [B],
    [C],
    [D])
( SELECT 
	[Timestamp],
    [Type_of_mobile],
    [MMSI],
    [Latitude],
    [Longitude],
    [Navigational_Status],
    [ROT],
    [SOG],
    [COG],
    [Heading],
    [IMO],
    [Call_Sign],
    [Name],
    [Ship_type],
    [Cargo_type],
    [Width],
    [Length],
    [Type_of_position_fixing_device],
    [Draught],
    [Destination],
    [ETA],
    [Data_source_type],
    [A],
    [B],
    [C],
    [D]
FROM dbo.AIS_Data)

END