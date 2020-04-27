



-- Test6 - Insert already existing record containg update(s). Follow the records behavior and check for values

CREATE    PROCEDURE [testDimVessel].[Test6 - Insert already existing record containg update(s). Follow the records behavior and check for values]
AS
BEGIN
  
  DECLARE @rowCount_Dim_Vessel int

  DECLARE @oldName varchar(100), @updatedName varchar(100);
  
  DECLARE @oldIMO varchar(100), @updatedIMO varchar(100);

  DECLARE @oldShipType int, @updatedShipType int;

  DECLARE @oldDimToStarboard varchar(100), @updatedDimToStarboard varchar(100);

  DECLARE @oldBeam int,@updatedBeam int;


 
  IF OBJECT_ID('expected') IS NOT NULL DROP TABLE expected;
 
	-- truncate tables to have accurate test results 
	truncate table edw.Dim_Vessel
	truncate table extract.AIS_Data
	truncate table utility.Batch

   --Prepare Dim_Vessel to be pre-populated with 10 records
	insert into edw.Dim_Vessel 
	values ('205769000', null, null, null, null, 'Belgium',205, null, null, null, null, null, null, null, 1, NULL,  '2020-03-26 16:55:41.0000000',	'9999-12-31 00:00:00.0000000')
	insert into edw.Dim_Vessel 
	values ('211789180', null ,null, null, null,'Germany (Federal Republic of)',211, null,null,null,null,null,null,null, 1, NULL,  '2020-03-26 16:55:41.0000000',	'9999-12-31 00:00:00.0000000')
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


	-- ETL for Dim_Vessel to insert the folloewing CSV. file records, consisting of an already existing record in Dim_Vessel (where MMSI = 211789180) containing updates
	execute [extract].[AIS_Data_CSV]'C:\AIS\Tests\Test6.csv'
	execute [load].[Dim_Vessel_L]

	/*  CSV content:
			~MMSI|AIS Message Type|Longitude|Latitude|MID Number|MID|Navigation Status|Rate of Turn (ROT)|Speed Over Ground (SOG)|Position Accuracy|Course Over Ground (COG)|True Heading (HDG)|Manoeuvre Indicator|RAIM Flag|Repeat Indicator|Received Time UTC-Unix|Vessel Name|IMO Number|Call Sign|Ship Type|Dimension to Bow|Dimension to Stern|Length|Dimension to Port|Dimension to Starboard|Beam|Position Type Fix|ETA month|ETA day|ETA hour|ETA minute|Draught|Destination
			211789180|5|6.979007|56.625840|211|Germany (Federal Republic of)|0|-5|19,7|1|250,1|249|0|0|0|26-03-2020 16:55:47|STENA JUTLANDICA|9125944|SEAN@@@|64|30|153|183|28|5|33|1|03|26|18|15|6|SE GOT>DK FDH>SE GOT


	*/

	-- Extra measurement, for checking if there is a slowly changing dimension for MMSI = 211789180
	set @rowCount_Dim_Vessel= (select count(*) from edw.Dim_Vessel where MMSI = '211789180')
	EXEC tSQLt.AssertEqualsString 2, @rowCount_Dim_Vessel; 
 	
	-- Checking for Vessel_Name
	set @oldName = ( select Vessel_Name from edw.Dim_Vessel where MMSI = '211789180' and  Valid_To = '2020-03-26 16:55:47.0000000')
	EXEC tSQLt.AssertEqualsString null , @oldName;  
	set @updatedName = (select Vessel_Name from edw.Dim_Vessel where MMSI = '211789180' and Valid_To = '9999-12-31 00:00:00.0000000')
	EXEC tSQLt.AssertEqualsString 'STENA JUTLANDICA', @updatedName;  

	-- Checking for IMO
	set @oldIMO = ( select IMO from edw.Dim_Vessel where MMSI = '211789180' and  Valid_To = '2020-03-26 16:55:47.0000000')
	EXEC tSQLt.AssertEqualsString null , @oldIMO;  
	set @updatedIMO = (select IMO from edw.Dim_Vessel where MMSI = '211789180' and Valid_To = '9999-12-31 00:00:00.0000000')
	EXEC tSQLt.AssertEqualsString 9125944 , @updatedIMO;  

	-- Checking for Ship_Type
	set @oldShipType = ( select Ship_Type from edw.Dim_Vessel where MMSI = '211789180' and  Valid_To = '2020-03-26 16:55:47.0000000')
	EXEC tSQLt.AssertEqualsString null , @oldShipType;  
	set @updatedShipType = (select Ship_Type from edw.Dim_Vessel where MMSI = '211789180' and Valid_To = '9999-12-31 00:00:00.0000000')
	EXEC tSQLt.AssertEqualsString 64, @updatedShipType;  

	-- Checking for Beam
	set @oldBeam = ( select Beam from edw.Dim_Vessel where MMSI = '211789180' and  Valid_To = '2020-03-26 16:55:47.0000000')
	EXEC tSQLt.AssertEqualsString null , @oldBeam;  
	set @updatedBeam = (select Beam from edw.Dim_Vessel where MMSI = '211789180' and Valid_To = '9999-12-31 00:00:00.0000000')
	EXEC tSQLt.AssertEqualsString 33 , @updatedBeam;  

	-- Checking for Dimension_To_Starboard
	set @oldDimToStarboard = ( select Dimension_To_Starboard from edw.Dim_Vessel where MMSI = '211789180' and  Valid_To = '2020-03-26 16:55:47.0000000')
	EXEC tSQLt.AssertEqualsString null , @oldDimToStarboard;  
	set @updatedDimToStarboard = (select Dimension_To_Starboard from edw.Dim_Vessel where MMSI = '211789180' and Valid_To = '9999-12-31 00:00:00.0000000')
	EXEC tSQLt.AssertEqualsString 5 , @updatedDimToStarboard;  

end
  --exec tsqlt.Run @TestName = '[testDimVessel].[Test6 - Insert already existing record containg update(s). Follow the records behavior and check for values]'