




-- Test5 - Insert one already existing records containg update(s).

CREATE    PROCEDURE [testDimVessel].[Test5 - Insert one already existing records containg update(s). ]
AS
BEGIN
 DECLARE @rowCount_Dim_Vessel int
   
   IF OBJECT_ID('expected') IS NOT NULL DROP TABLE expected;
 
  -- truncate tables to have accurate test results 
  truncate table edw.Dim_Vessel
  truncate table extract.AIS_Data
  truncate table utility.Batch

  --Prepare Dim_Vessel to be pre-populated with 10 records
	insert into edw.Dim_Vessel 
	values ('205769000', null, null, null, null, 'Belgium',205, null, null, null, null, null, null, null, 1, NULL,  '2020-03-26 16:55:41.0000000',	'9999-12-31 00:00:00.0000000')
	insert into edw.Dim_Vessel 
	values ('211789180','IRIS' ,null, null, null,'Germany (Federal Republic of)',211, null,null,null,null,null,null,null, 1, NULL,  '2020-03-26 16:55:41.0000000',	'9999-12-31 00:00:00.0000000')
	insert into edw.Dim_Vessel 
	values ('219006916', 'RI322 SINNE FRIHED', null, null, null,'Denmark',	219, null,null,null,null,null,null,null, 1, NULL,  '2020-03-26 16:55:41.0000000',	'9999-12-31 00:00:00.0000000')
	insert into edw.Dim_Vessel 
	values ('219013485','TOVE KAJGAARD',null, null, null, 'Denmark',	219, null,null,null,null,null,null,null, 1, NULL,  '2020-03-26 16:55:41.0000000',	'9999-12-31 00:00:00.0000000')
	insert into edw.Dim_Vessel 
	values ('219330000','NEPTUN AS 202',null, null, null,'Denmark',	219, null,null,null,null,null,null,null, 1, NULL,  '2020-03-26 16:55:41.0000000',	'9999-12-31 00:00:00.0000000')
	insert into edw.Dim_Vessel 
	values ('220334000', 'STINE FN396',	null, null, null, 'Denmark',	220, null,null,null,null,null,null,null, 1, NULL,  '2020-03-26 16:55:41.0000000',	'9999-12-31 00:00:00.0000000')
	insert into edw.Dim_Vessel 
	values ('222530728','BJORNSHOLM', null, null, null, 'not in use',	222, null,null,null,null,null,null,null, 1, NULL,  '2020-03-26 16:55:41.0000000',	'9999-12-31 00:00:00.0000000')
	insert into edw.Dim_Vessel 
	values ('244813000','BIT FORCE', null, null, null, 'Netherlands (Kingdom of the)',	244, null,null,null,null,null,null,null, 1, NULL,  '2020-03-26 16:55:41.0000000',	'9999-12-31 00:00:00.0000000')
	insert into edw.Dim_Vessel 
	values ('259896000', null,	null,null,null, 'Norway',	259,null,null,null,null,null,null,null, 1, NULL,  '2020-03-26 16:55:40.0000000',	'9999-12-31 00:00:00.0000000')
	insert into edw.Dim_Vessel 
	values ('311055900','SKANDI CONSTRUCTOR','9431642',	'C6ZH8 ',	70,	   'Bahamas (Commonwealth of the)',	311, 42, 78, 120,  13,11, 24, 1, 1, NULL,  '2020-03-26 16:55:41.0000000',	'9999-12-31 00:00:00.0000000')


	-- ETL for Dim_Vessel to insert the folloewing CSV. file records, consisting of an already existing record in Dim_Vessel (where MMSI = 219013485) containing updates
	execute [extract].[AIS_Data_CSV]'C:\AIS\Tests\Test5.csv'
	execute [load].[Dim_Vessel_L]
	
	/*  CSV content:
			~MMSI|AIS Message Type|Longitude|Latitude|MID Number|MID|Navigation Status|Rate of Turn (ROT)|Speed Over Ground (SOG)|Position Accuracy|Course Over Ground (COG)|True Heading (HDG)|Manoeuvre Indicator|RAIM Flag|Repeat Indicator|Received Time UTC-Unix|Vessel Name|IMO Number|Call Sign|Ship Type|Dimension to Bow|Dimension to Stern|Length|Dimension to Port|Dimension to Starboard|Beam|Position Type Fix|ETA month|ETA day|ETA hour|ETA minute|Draught|Destination
			219013485|5|||311|Bahamas (Commonwealth of the)|||||||||0|26-03-2020 16:55:41|SKANDI CONSTRUCTOR|9431642|C6ZH8  |70|42|78|120|13|11|24|1|03|21|12|34|5,5|ODENSE 

	*/

 
 -- set rowCount for Dim_Vessel
 	set @rowCount_Dim_Vessel= (select count(*) from edw.Dim_Vessel )
 
 -- evaluate if expected rowCount for Dim_Vessel is 2
	EXEC tSQLt.AssertEqualsString 11, @rowCount_Dim_Vessel;  
 
end 

 -- exec tsqlt.Run @TestName = '[testDimVessel].[Test5 - Insert one already existing records containg update(s). ]'