

CREATE VIEW [transform].[Dim_Vessel]
AS
	(Select 
		MMSI,
		Vessel_Name,
		substring(reverse(Latitude), 1, 1) as Lat_Cardinal_Direction ,
		substring(Latitude, 1,  CHARindex( '°', Latitude, 1)) as Lat_Degree,
		substring(Latitude,  CHARINDEX('°', Latitude)+1,  CHARINDEX('''', Latitude)-(CHARINDEX('°', Latitude))) as Lat_MinSec,
		substring(reverse(Longitude), 1, 1) as Long_Cardinal_Direction ,
		substring(Longitude, 1,  CHARindex( '°', Longitude, 1)) as Long_Degree,
		substring(Longitude,  CHARINDEX('°', Longitude)+1,  CHARINDEX('''', Longitude)-(CHARINDEX('°', Longitude))) as Long_MinSec, 
		convert(decimal(10,2), replace(SOG, ',', '.') ) as SOG ,
		convert(decimal(10,2), replace(COG, ',', '.') ) as COG ,
		convert(datetime2, RecievedTime, 103) as DateCreated,
		MID
	FROM dbo.Extract_Data)