USE [AIS_Stage]
GO

/****** Object:  StoredProcedure [load].[Fact_Route_L]    Script Date: 10/04/2020 14.16.19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [load].[Fact_Route_L]
AS
	
INSERT INTO AIS_EDW.edw.Fact_Route (
	Vessel_Key,
	Date_Key,
	Time_Key,
	SOG,
	COG,
	Latitude, 
	Longitude, 
	Batch )
SELECT 	
	COALESCE(Vessel_Key, -1),
	COALESCE(Date_Key, -1),
	COALESCE(Time_Key, -1),
	Speed_Over_Ground_SOG,
	Course_Over_Ground_COG,
	case when COALESCE(Latitude, -1) between 53.000000 and 59.999999 then Latitude else -1 end,
	case when COALESCE(Longitude, -1) between 3.000000 and 17.999999 then Longitude else -1 end,
	Batch  			
FROM transform.Fact_Route_T
GO


