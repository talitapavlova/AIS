
CREATE VIEW [stage].[VIEW_DimVessel]
AS
SELECT        Type_of_mobile, MMSI, IMO, Callsign, Name, Ship_type, Cargo_type, Width, Length, Draught
FROM            dbo.Extract_Vessel