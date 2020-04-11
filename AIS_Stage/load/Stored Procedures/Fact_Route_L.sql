
/*
Change log: 
	2020-03-27	NP	Stored procedure created
	2020-04-10	SI	Added Latitude and Longitude Key lookup 
	2020-04-11	NP	Added measures
*/

CREATE PROCEDURE [load].[Fact_Route_L]
AS
	
INSERT INTO AIS_EDW.edw.Fact_Route (
	Vessel_Key,
	Date_Key,
	Time_Key,
	Latitude_Key, 
	Longitude_Key, 
	Rate_Of_Turn_ROT,
	Speed_Over_Ground_SOG,
	Course_Over_Ground_COG,
	True_Heading_HDG,
	Position_Accuracy,
	Manoeuvre_Indicator,
	RAIM_Flag,
	Draught,
	Batch )
SELECT 	
	COALESCE(Vessel_Key, -1),
	COALESCE(Date_Key, -1),
	COALESCE(Time_Key, -1),
	COALESCE(Latitude_Key, -1),
	COALESCE(Longitude_Key, -1),
	Rate_Of_Turn_ROT,
	Speed_Over_Ground_SOG,
	Course_Over_Ground_COG,
	True_Heading_HDG,
	Position_Accuracy,
	Manoeuvre_Indicator,
	RAIM_Flag,
	Draught,
	Batch  			
FROM transform.Fact_Route_T
GO


