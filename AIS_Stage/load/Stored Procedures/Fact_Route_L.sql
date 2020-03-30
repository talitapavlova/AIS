




CREATE PROCEDURE [load].[Fact_Route_L]
AS

-- temporary
TRUNCATE table AIS_EDW.edw.Fact_Route
	
INSERT INTO AIS_EDW.edw.Fact_Route (
	Vessel_Key,
	Date_Key,
	Time_Key )
SELECT 	
	COALESCE(Vessel_Key, -1),
	COALESCE(Date_Key, -1),
	COALESCE(Time_Key, -1)  			
FROM transform.Fact_Route_T