



/*
Change log: 
	2020-03-26	NP	Stored procedure created
	2020-04-08	NP	Updated SP for correct week number
*/


CREATE   PROCEDURE [utility].[Get_Navigation_Status] AS

BEGIN
DECLARE
	@StartVal int = 0,
	@EndVal int = 15

SET NOCOUNT ON;
TRUNCATE table utility.Navigation_Status

WHILE( @StartVal <= @EndVal) 
	BEGIN 
			
		INSERT into utility.Navigation_Status (
				Navigation_Status_Key,
				Navigation_Status_Description
				) 
		VALUES (
				@StartVal,
				CASE @StartVal 
					WHEN 0 THEN 'under way using engine'
					WHEN 1 THEN 'at anchor'
					WHEN 2 THEN 'not under command'
					WHEN 3 THEN 'restricted maneuverability'
					WHEN 4 THEN 'constrained by her draught'
					WHEN 5 THEN 'moored'
					WHEN 6 THEN 'aground'
					WHEN 7 THEN 'engaged in fishing'
					WHEN 8 THEN 'under way sailing'
					WHEN 9 THEN 'reserved for future amendment of navigational status for ships carrying DG, HS, or MP, or IMO hazard or pollutant category C, high speed craft (HSC)'
					WHEN 10 THEN 'reserved for future amendment of navigational status for ships carrying dangerous goods (DG), harmful substances (HS) or marine pollutants (MP), or IMO hazard or pollutant category A, wing in ground (WIG)'
					WHEN 11 THEN 'power-driven vessel towing astern (regional use)'
					WHEN 12 THEN 'power-driven vessel pushing ahead or towing alongside (regional use)'
					WHEN 13 THEN 'reserved for future use'
					WHEN 14 THEN 'AIS-SART (active), MOB-AIS, EPIRB-AIS'
					WHEN 15 THEN 'undefined = default (also used by AIS-SART, MOB-AIS and EPIRB-AIS under test)'
				END
				) 
		SET @StartVal = @StartVal + 1 	
END   --end loop for all the current availabe types of Navigation Statuses

/*
Insert unkown values into [edw].[Dim_Navigation_Status]
*/
TRUNCATE TABLE [AIS_EDW].[edw].[Dim_Navigation_Status]
INSERT INTO [AIS_EDW].[edw].[Dim_Navigation_Status](
		Navigation_Status_Key,
		Navigation_Status_Description
) VALUES (
	-1,
	'NA'
) 

/*
Insert utility.Navigation_Status into [edw].[Dim_Navigation_Status]
*/

INSERT INTO [AIS_EDW].[edw].[Dim_Navigation_Status](
		Navigation_Status_Key,
		Navigation_Status_Description
) SELECT
	  	Navigation_Status_Key,
		Navigation_Status_Description
FROM utility.Navigation_Status

END