







/*
Change log: 
	2020-03-26	NP	Stored procedure created
	2020-04-08	NP	Updated SP for correct week number
*/


CREATE   PROCEDURE [utility].[Get_Ship_Type] AS

BEGIN
DECLARE
	@StartVal int = 0,
	@EndVal int = 255

SET NOCOUNT ON;
TRUNCATE table utility.Ship_Type

WHILE( @StartVal <= @EndVal) 
	BEGIN 
			
		INSERT into utility.Ship_Type (
					Ship_Type_Code,
					Ship_Type_Description
				) 
		VALUES (
				@StartVal,
				CASE  
					WHEN @StartVal = 0 THEN 'Not available or No Ship'
					WHEN @StartVal BETWEEN 1 AND 19 THEN 'Reserved for future use'
					WHEN @StartVal = 20 THEN 'Wing in ground (WIG), all ships of this type'
					WHEN @StartVal = 21 THEN 'Wing in ground (WIG), Hazardous category A'
					WHEN @StartVal = 22 THEN 'Wing in ground (WIG), Hazardous category B'
					WHEN @StartVal = 23 THEN 'Wing in ground (WIG), Hazardous category C'
					WHEN @StartVal = 24 THEN 'Wing in ground (WIG), Hazardous category D'
					WHEN @StartVal BETWEEN 25 AND 29 THEN 'Wing in ground (WIG), Reserved for future use'
					WHEN @StartVal = 30 THEN 'Fishing'
					WHEN @StartVal = 31 THEN 'Towing'
					WHEN @StartVal = 32 THEN 'Towing: length exceeds 200m or breadth exceeds 25m'
					WHEN @StartVal = 33 THEN 'Dredging or underwater ops'
					WHEN @StartVal = 34 THEN 'Diving ops'
					WHEN @StartVal = 35 THEN 'Military ops'
					WHEN @StartVal = 36 THEN 'Sailing'
					WHEN @StartVal = 37 THEN 'Pleasure Craft'
					WHEN @StartVal BETWEEN 38 AND 39 THEN 'Reserved'
					WHEN @StartVal = 40 THEN 'High speed craft (HSC), all ships of this type'
					WHEN @StartVal = 41 THEN 'High speed craft (HSC), Hazardous category A'
					WHEN @StartVal = 42 THEN 'High speed craft (HSC), Hazardous category B'
					WHEN @StartVal = 43 THEN 'High speed craft (HSC), Hazardous category C'
					WHEN @StartVal = 44 THEN 'High speed craft (HSC), Hazardous category D'
					WHEN @StartVal BETWEEN 45 AND 48 THEN 'High speed craft (HSC), Reserved for future use'
					WHEN @StartVal = 49 THEN 'High speed craft (HSC), No additional information'
					WHEN @StartVal = 50 THEN 'Pilot Vessel'
					WHEN @StartVal = 51 THEN 'Search and Rescue vessel'
					WHEN @StartVal = 52 THEN 'Tug'
					WHEN @StartVal = 53 THEN 'Port Tender'
					WHEN @StartVal = 54 THEN 'Anti-pollution equipment'
					WHEN @StartVal = 55 THEN 'Law Enforcement'
					WHEN @StartVal BETWEEN 56 AND 57 THEN 'Spare - Local Vessel'
					WHEN @StartVal = 58 THEN 'Medical Transport'
					WHEN @StartVal = 59 THEN 'Noncombatant ship according to RR Resolution No. 18'
					WHEN @StartVal = 60 THEN 'Passenger, all ships of this type'
					WHEN @StartVal = 61 THEN 'Passenger, Hazardous category A'
					WHEN @StartVal = 62 THEN 'Passenger, Hazardous category B'
					WHEN @StartVal = 63 THEN 'Passenger, Hazardous category C'
					WHEN @StartVal = 64 THEN 'Passenger, Hazardous category D'
					WHEN @StartVal BETWEEN 65 AND 68 THEN 'Passenger, Reserved for future use'
					WHEN @StartVal = 69 THEN 'Passenger, No additional information'
					WHEN @StartVal = 70 THEN 'Cargo, all ships of this type'
					WHEN @StartVal = 71 THEN 'Cargo, Hazardous category A'
					WHEN @StartVal = 72 THEN 'Cargo, Hazardous category B'
					WHEN @StartVal = 73 THEN 'Cargo, Hazardous category C'
					WHEN @StartVal = 74 THEN 'Cargo, Hazardous category D'
					WHEN @StartVal BETWEEN 75 AND 78 THEN 'Cargo, Reserved for future use'
					WHEN @StartVal = 79 THEN 'Cargo, No additional information'
					WHEN @StartVal = 80 THEN 'Tanker, all ships of this type'
					WHEN @StartVal = 81 THEN 'Tanker, Hazardous category A'
					WHEN @StartVal = 82 THEN 'Tanker, Hazardous category B'
					WHEN @StartVal = 83 THEN 'Tanker, Hazardous category C'
					WHEN @StartVal = 84 THEN 'Tanker, Hazardous category D'
					WHEN @StartVal BETWEEN 85 AND 88 THEN 'Tanker, Reserved for future use'
					WHEN @StartVal = 89 THEN 'Tanker, No additional information'
					WHEN @StartVal = 90 THEN 'Other Type, all ships of this type'
					WHEN @StartVal = 91 THEN 'Other Type, Hazardous category A'
					WHEN @StartVal = 92 THEN 'Other Type, Hazardous category B'
					WHEN @StartVal = 93 THEN 'Other Type, Hazardous category C'
					WHEN @StartVal = 94 THEN 'Other Type, Hazardous category D'
					WHEN @StartVal BETWEEN 95 AND 98 THEN 'Other Type, Reserved for future use'
					WHEN @StartVal = 99 THEN 'Other Type, no additional information'
					WHEN @StartVal BETWEEN 100 AND 199 THEN 'Reserved, for regional use'
					WHEN @StartVal BETWEEN 200 AND 255 THEN 'Reserved, for future use'
				END
				) 
		SET @StartVal = @StartVal + 1 	
END   --end loop for all the current availabe types of Ship Types

/*
Insert unkown values into [edw].[Dim_Ship_Type]
*/
TRUNCATE TABLE [AIS_EDW].[edw].[Dim_Ship_Type]

INSERT INTO [AIS_EDW].[edw].[Dim_Ship_Type](
		Ship_Type_Code,
		Ship_Type_Description
) VALUES (
	-1,
	'NA'
) 

/*
Insert utility.Ship_Type into [edw].[Dim_Ship_Type]
*/

INSERT INTO [AIS_EDW].[edw].[Dim_Ship_Type](
		Ship_Type_Code,
		Ship_Type_Description
) SELECT
	  	Ship_Type_Code,
		Ship_Type_Description
FROM utility.Ship_Type

END