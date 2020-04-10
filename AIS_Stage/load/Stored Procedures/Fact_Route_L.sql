
CREATE   PROCEDURE [load].[Fact_Route_L]
AS
	
INSERT INTO AIS_EDW.edw.Fact_Route (
	Vessel_Key,
	Date_Key,
	Time_Key,
	SOG,
	COG,
	Batch )
SELECT 	
	COALESCE(Vessel_Key, -1),
	COALESCE(Date_Key, -1),
	COALESCE(Time_Key, -1),
	Speed_Over_Ground_SOG,
	Course_Over_Ground_COG,
	Batch  			
FROM transform.Fact_Route_T
GO


