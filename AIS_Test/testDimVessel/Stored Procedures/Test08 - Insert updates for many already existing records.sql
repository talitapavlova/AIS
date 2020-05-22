

/* Change log: 
	
	2020-03-25	SP created for testing SPs targeting Dim_Vessel
	2020-04-10	SP updated for testing the effect of the SP utility.Add_Batch on Dim_Vessel. The update consists of:
			-add execution of utility.Batch SP;
			-check if the type2 sowly changing dimension's records contains the correct batch number by closly checking 
				the values of [BatchCreated] and [BatchUpdated] attributes for a specific record, selected by MMSI criteria. The behaviour of the other records should follow,
				therefore it is assumed that if the tests for one record are passed, the others are passed as well.
	
	Test Description:
		Test08 - Insert updates for many already existing records
			The test performs the SPs targeting Dim_Vessel, where the source file contains 10 records having updated values for records that already exist in Dim_Vessel. 
			The test verifies the number of rows in Dim_Vessel after the ETL process had been executed.
			UPDATE: Furthermore, it is verified if the record contains the correct batch number, when Add_Batch SP is included.

	Set-up:
			Dim_Vessel prepopulated with the following records:
					Vessel_Key | MMSI |	IMO | Call_Sign | Ship_type | Ship_type_Description | MID | MID_Number | Dim_To_Bow | Dim_To_Stern | Length | Dim_to_Port | Dim_To_Starboard | Beam | Pos_type_fix | BatchCreated | BatchUpdated | Valid_From | Valid_To
					1	205769000	NULL	NULL	NULL	NULL	-1	Belgium	205	NULL	NULL	NULL	NULL	NULL	NULL	NULL	1	NULL	2020-03-26 16:55:41.0000000	9999-12-31 00:00:00.0000000
					2	211789180	IRIS	NULL	NULL	NULL	-1	Germany (Federal Republic of)	211	NULL	NULL	NULL	NULL	NULL	NULL	NULL	1	NULL	2020-03-26 16:55:41.0000000	9999-12-31 00:00:00.0000000
					3	219006916	RI322 SINNE FRIHED	NULL	NULL	NULL	-1	Denmark	219	NULL	NULL	NULL	NULL	NULL	NULL	NULL	1	NULL	2020-03-26 16:55:41.0000000	9999-12-31 00:00:00.0000000
					4	219013485	TOVE KAJGAARD	NULL	NULL	NULL	-1	Denmark	219	NULL	NULL	NULL	NULL	NULL	NULL	NULL	1	NULL	2020-03-26 16:55:41.0000000	9999-12-31 00:00:00.0000000
					5	219330000	NEPTUN AS 202	NULL	NULL	NULL	-1	Denmark	219	NULL	NULL	NULL	NULL	NULL	NULL	NULL	1	NULL	2020-03-26 16:55:41.0000000	9999-12-31 00:00:00.0000000
					6	220334000	STINE FN396	NULL	NULL	NULL	-1	Denmark	220	NULL	NULL	NULL	NULL	NULL	NULL	NULL	1	NULL	2020-03-26 16:55:41.0000000	9999-12-31 00:00:00.0000000
					7	222530728	BJORNSHOLM	NULL	NULL	NULL	-1	not in use	222	NULL	NULL	NULL	NULL	NULL	NULL	NULL	1	NULL	2020-03-26 16:55:41.0000000	9999-12-31 00:00:00.0000000
					8	244813000	BIT FORCE	NULL	NULL	NULL	-1	Netherlands (Kingdom of the)	244	NULL	NULL	NULL	NULL	NULL	NULL	NULL	1	NULL	2020-03-26 16:55:41.0000000	9999-12-31 00:00:00.0000000
					9	259896000	NULL	NULL	NULL	NULL	-1	NULL	259	NULL	NULL	NULL	NULL	NULL	NULL	NULL	1	NULL	2020-03-26 16:55:40.0000000	9999-12-31 00:00:00.0000000
					10	311055900	NULL	NULL	NULL	NULL	-1	Hong Kong (Special Administrative Region of China)	NULL	NULL	NULL	NULL	13	11	24	1	1	NULL	2020-03-26 16:55:41.0000000	9999-12-31 00:00:00.0000000	
			
			utility.Batch prepopulated with the following record:
				Batch | TotalRows | IsContinuousData | IsHistoricalData | MinReceivedTime | MaxReceivedTime | DateCreated
				1	10	1	0	2020-03-26 16:55:41.0000000	2020-03-26 16:57:41.0000000	2020-05-20 12:33:41.2866667

			CSV content:
					~MMSI|AIS Message Type|Longitude|Latitude|MID Number|MID|Navigation Status|Rate of Turn (ROT)|Speed Over Ground (SOG)|Position Accuracy|Course Over Ground (COG)|True Heading (HDG)|Manoeuvre Indicator|RAIM Flag|Repeat Indicator|Received Time UTC-Unix|Vessel Name|IMO Number|Call Sign|Ship Type|Dimension to Bow|Dimension to Stern|Length|Dimension to Port|Dimension to Starboard|Beam|Position Type Fix|ETA month|ETA day|ETA hour|ETA minute|Draught|Destination
					205769000|5|||311|Bahamas (Commonwealth of the)|||||||||0|26-03-2020 16:55:41|SKANDI CONSTRUCTOR|9431642|C6ZH8  |70|42|78|120|13|11|24|1|03|21|12|34|5,5|ODENSE
					211789180|5|||311|Bahamas (Commonwealth of the)|||||||||0|26-03-2020 16:55:41|SKANDI CONSTRUCTOR|9431642|C6ZH8  |70|42|78|120|13|11|24|1|03|21|12|34|5,5|ODENSE
					219006916|5|||311|Bahamas (Commonwealth of the)|||||||||0|26-03-2020 16:55:41|SKANDI CONSTRUCTOR|9431642|C6ZH8  |70|42|78|120|13|11|24|1|03|21|12|34|5,5|ODENSE
					219013485|5|||311|Bahamas (Commonwealth of the)|||||||||0|26-03-2020 16:55:41|SKANDI CONSTRUCTOR|9431642|C6ZH8  |70|42|78|120|13|11|24|1|03|21|12|34|5,5|ODENSE
					219330000|5|||311|Bahamas (Commonwealth of the)|||||||||0|26-03-2020 16:55:41|SKANDI CONSTRUCTOR|9431642|C6ZH8  |70|42|78|120|13|11|24|1|03|21|12|34|5,5|ODENSE
					220334000|5|||311|Bahamas (Commonwealth of the)|||||||||0|26-03-2020 16:55:41|SKANDI CONSTRUCTOR|9431642|C6ZH8  |70|42|78|120|13|11|24|1|03|21|12|34|5,5|ODENSE
					222530728|5|||311|Bahamas (Commonwealth of the)|||||||||0|26-03-2020 16:55:41|SKANDI CONSTRUCTOR|9431642|C6ZH8  |70|42|78|120|13|11|24|1|03|21|12|34|5,5|ODENSE
					244813000|5|||311|Bahamas (Commonwealth of the)|||||||||0|26-03-2020 16:55:41|SKANDI CONSTRUCTOR|9431642|C6ZH8  |70|42|78|120|13|11|24|1|03|21|12|34|5,5|ODENSE
					259896000|5|||311|Bahamas (Commonwealth of the)|||||||||0|26-03-2020 16:55:41|SKANDI CONSTRUCTOR|9431642|C6ZH8  |70|42|78|120|13|11|24|1|03|21|12|34|5,5|ODENSE
					311055900|5|||311|Bahamas (Commonwealth of the)|||||||||0|26-03-2020 16:55:41|SKANDI CONSTRUCTOR|9431642|C6ZH8  |70|42|78|120|13|11|24|1|03|21|12|34|5,5|ODENSE


******/	

CREATE PROCEDURE [testDimVessel].[Test08 - Insert updates for many already existing records]
AS
BEGIN

/*ARRANGE*/  

	DECLARE @rowCount_Dim_Vessel int
 
	DECLARE @batchCreated_oldRec int, @batchUpdated_oldRec int; 
	DECLARE @batchCreated_newRec int, @batchUpdated_newRec int; 

	IF OBJECT_ID('expected') IS NOT NULL DROP TABLE expected;
 
  -- truncate tables to have accurate test results 
	truncate table edw.Dim_Vessel
	truncate table archive.AIS_Data_archive
	truncate table extract.AIS_Data
	truncate table utility.Batch

  --Prepare Dim_Vessel to be pre-populated with 10 records, simulting a previous execution of the ETL
	insert into edw.Dim_Vessel 
	values ('205769000', null, null, null, null, -1, 'Belgium',205, null, null, null, null, null, null, null, 1, NULL,  '2020-03-26 16:55:41.0000000',	'9999-12-31 00:00:00.0000000')
	insert into edw.Dim_Vessel 
	values ('211789180','IRIS' ,null, null, null, -1, 'Germany (Federal Republic of)',211, null,null,null,null,null,null,null,1, NULL,  '2020-03-26 16:55:41.0000000',	'9999-12-31 00:00:00.0000000')
	insert into edw.Dim_Vessel 
	values ('219006916', 'RI322 SINNE FRIHED', null, null, null, -1, 'Denmark',	219, null,null,null,null,null,null,null, 1, NULL,  '2020-03-26 16:55:41.0000000',	'9999-12-31 00:00:00.0000000')
	insert into edw.Dim_Vessel 
	values ('219013485','TOVE KAJGAARD',null, null, null,  -1, 'Denmark',	219, null,null,null,null,null,null,null, 1, NULL,  '2020-03-26 16:55:41.0000000',	'9999-12-31 00:00:00.0000000')
	insert into edw.Dim_Vessel 
	values ('219330000','NEPTUN AS 202',null, null, null, -1, 'Denmark',	219, null,null,null,null,null,null,null, 1, NULL,  '2020-03-26 16:55:41.0000000',	'9999-12-31 00:00:00.0000000')
	insert into edw.Dim_Vessel 
	values ('220334000', 'STINE FN396',	null, null, null,  -1, 'Denmark',	220, null,null,null,null,null,null,null, 1, NULL,  '2020-03-26 16:55:41.0000000',	'9999-12-31 00:00:00.0000000')
	insert into edw.Dim_Vessel 
	values ('222530728','BJORNSHOLM', null, null, null, -1,  'not in use',	222, null,null,null,null,null,null,null, 1, NULL,  '2020-03-26 16:55:41.0000000',	'9999-12-31 00:00:00.0000000')
	insert into edw.Dim_Vessel 
	values ('244813000','BIT FORCE', null, null, null, -1,  'Netherlands (Kingdom of the)',	244, null,null,null,null,null,null,null, 1, NULL,  '2020-03-26 16:55:41.0000000',	'9999-12-31 00:00:00.0000000')
	insert into edw.Dim_Vessel 
	values ('259896000', null,	null, null, null, -1,  null, 259, null, null, null, null, null, null, null, 1, null,  '2020-03-26 16:55:40.0000000',	'9999-12-31 00:00:00.0000000')
	insert into edw.Dim_Vessel 
	values ('311055900',null, null,	null, null, -1, 'Hong Kong (Special Administrative Region of China)',	null, null, null, null,  13,11, 24, 1, 1, NULL,  '2020-03-26 16:55:41.0000000',	'9999-12-31 00:00:00.0000000')

	
   --Prepare utility.Batch table to be pre-populated with 1 records, simulting a previous execution of the ETL
    insert into utility.Batch
	values (1,10,1,0,'2020-03-26 16:55:41.0000000',	'2020-03-26 16:57:41.0000000', GETDATE())
	

/*ACT*/
	-- run SPs for Dim_Vessel including the dependent SPs
	execute [extract].[AIS_Data_CSV]'C:\AIS\Tests\test_DimVessel\Test8.csv'
	execute [archive].[AIS_Data_AddToArchive]
	execute [load].[Dim_Vessel_L]	
	execute utility.Add_Batch 1
	truncate table extract.AIS_Data

   -- set rowCount for Dim_Vessel
 	set @rowCount_Dim_Vessel= (select count(*) from edw.Dim_Vessel )

/*ASSERT*/ 
    -- evaluate if expected rowCount for Dim_Vessel is 20
	EXEC tSQLt.AssertEqualsString 20, @rowCount_Dim_Vessel;  

   --evaluate the record (of Dim_Vessel) where MMSI=205769000 contains the correct Batch information*/	
	 -- Checking if the old record reffers to the correct batch number for BatchCreated attribute 
	set @batchCreated_oldRec = ( select BatchCreated from edw.Dim_Vessel where MMSI = '205769000' and  Valid_To = '2020-03-26 16:55:41.0000000')
	EXEC tSQLt.AssertEqualsString 1 , @batchCreated_oldRec;  

	-- Checking if the old record reffers to the correct batch number for BatchUpdated attribute 
	set @batchUpdated_oldRec = ( select BatchUpdated from edw.Dim_Vessel where MMSI = '205769000' and  Valid_To = '2020-03-26 16:55:41.0000000')
	EXEC tSQLt.AssertEqualsString 2 , @batchUpdated_oldRec;  
			
	-- Checking if the new record reffers to the correct batch numbers for BatchCreated attribute 
	set @batchCreated_newRec = (select BatchCreated from edw.Dim_Vessel where MMSI = '205769000' and  Valid_To = '9999-12-31 00:00:00.0000000')
	EXEC tSQLt.AssertEqualsString 2, @batchCreated_newRec;  
 
    -- Checking if the new record reffers to the correct batch numbers for BatchUpdated attribute 
	set @batchUpdated_newRec = (select BatchUpdated from edw.Dim_Vessel where MMSI = '205769000' and  Valid_To = '9999-12-31 00:00:00.0000000')
	EXEC tSQLt.AssertEqualsString null, @batchUpdated_newRec;  

end 

 -- exec tsqlt.Run @TestName = '[testDimVessel].[Test08 - Insert updates for many already existing records]'