

/****** 
	Change log: 
		2020-03-25	Stored procedure created for testing stored procedures targetting Dim_Vessel
		2020-04-10	Stored procedure updated for testing the effect of the stored procedures utility.Add_Batch on Dim_Vessel. The update consists of:
						-add execution of utility.Batch SP;
						-expand table expected with [BatchCreated] and [BatchUpdated] attributes;
						-expand insert statement of expected table with the expected values for the above mentioned attributes, for providing the possibility of comparison with the actual Dim_Vessel table, hence 
							checking if the record contains the correct batch number.

	Test4 - Insert many(10) already existing records containing no updates 
			The test performs the ETL targeting Dim_Vessel one time, where the source file contains records already existent in Dim_vessel. However, the new records contain no updates.  
			 The test verifies if the output of the ETL process is as expected. As well as verifying the number of rows in Dim_Vessel after the ETL process had been executed.
			 UPDATE: Furthermore, it is verified if the record contains the correct batch number, when Add_Batch is included.
******/

CREATE PROCEDURE [testDimVessel].[Test4 - Insert many already existing records containing no updates]
AS
BEGIN

/*ARRANGE*/ 
 IF OBJECT_ID('expected') IS NOT NULL DROP TABLE expected;
 
 DECLARE @rowCount_Dim_Vessel int
   
  -- truncate tables to have accurate test results 
	truncate table edw.Dim_Vessel
	truncate table extract.AIS_Data
	truncate table utility.Batch

  --Prepare Dim_Vessel to be pre-populated with 10 records, simulting a previous execution of the ETL
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

   --Prepare utility.Batch table to be pre-populated with 1 records, simulting a previous execution of the ETL
    insert into utility.Batch
	values (1,10,1,0,'2020-03-26 16:55:41.0000000',	'2020-03-26 16:55:41.0000000', GETDATE())

  --create table expected, having the same structure as Dim_Vessel
   create table expected (
	[Vessel_Key] [int] IDENTITY(1,1) NOT NULL,
	[MMSI] [char](9) NOT NULL,
	[Vessel_Name] [nvarchar](200) NULL,
	[IMO] [nvarchar](10) NULL,
	[Call_Sign] [nvarchar](10) NULL,
	[Ship_Type] [int] NULL,
	[MID] [nvarchar](100) NULL,
	[MID_Number] [int] NULL,
	[Dimension_To_Bow] [int] NULL,
	[Dimension_To_Stern] [int] NULL,
	[Length] [int] NULL,
	[Dimension_To_Port] [int] NULL,
	[Dimension_To_Starboard] [int] NULL,
	[Beam] [int] NULL,
	[Position_Type_Fix] [int] NULL,
	[BatchCreated] [int] NULL,
	[BatchUpdated] [int] NULL,
	[Valid_From] [datetime2](7) NULL,
	[Valid_To] [datetime2](7) NULL,
  )

  --values expected to be in Dim_Vessel after accumulating all executions of the ETL
	insert into expected
	values ('205769000', null, null, null, null, 'Belgium',205, null, null, null, null, null, null, null, 1, NULL,  '2020-03-26 16:55:41.0000000',	'9999-12-31 00:00:00.0000000')
	insert into expected
	values ('211789180','IRIS' ,null, null, null,'Germany (Federal Republic of)',211, null,null,null,null,null,null,null, 1, NULL,  '2020-03-26 16:55:41.0000000',	'9999-12-31 00:00:00.0000000')
	insert into expected
	values ('219006916', 'RI322 SINNE FRIHED', null, null, null,'Denmark',	219, null,null,null,null,null,null,null, 1, NULL,  '2020-03-26 16:55:41.0000000',	'9999-12-31 00:00:00.0000000')
	insert into expected
	values ('219013485','TOVE KAJGAARD',null, null, null, 'Denmark',	219, null,null,null,null,null,null,null, 1, NULL,  '2020-03-26 16:55:41.0000000',	'9999-12-31 00:00:00.0000000')
	insert into expected
	values ('219330000','NEPTUN AS 202',null, null, null,'Denmark',	219, null,null,null,null,null,null,null, 1, NULL,  '2020-03-26 16:55:41.0000000',	'9999-12-31 00:00:00.0000000')
	insert into expected
	values ('220334000', 'STINE FN396',	null, null, null, 'Denmark',	220, null,null,null,null,null,null,null, 1, NULL,  '2020-03-26 16:55:41.0000000',	'9999-12-31 00:00:00.0000000')
	insert into expected
	values ('222530728','BJORNSHOLM', null, null, null, 'not in use',	222, null,null,null,null,null,null,null, 1, NULL,  '2020-03-26 16:55:41.0000000',	'9999-12-31 00:00:00.0000000')
	insert into expected
	values ('244813000','BIT FORCE', null, null, null, 'Netherlands (Kingdom of the)',	244, null,null,null,null,null,null,null, 1, NULL,  '2020-03-26 16:55:41.0000000',	'9999-12-31 00:00:00.0000000')
	insert into expected
	values ('259896000', null,	null,null,null, 'Norway',	259,null,null,null,null,null,null,null, 1, NULL,  '2020-03-26 16:55:40.0000000',	'9999-12-31 00:00:00.0000000')
	insert into expected
	values ('311055900','SKANDI CONSTRUCTOR','9431642',	'C6ZH8 ',	70,	   'Bahamas (Commonwealth of the)',	311, 42, 78, 120,  13,11, 24, 1, 1, NULL,  '2020-03-26 16:55:41.0000000',	'9999-12-31 00:00:00.0000000')
	

/*ACT*/
	-- ETL for Dim_Vessel to insert the following CSV. file records, consisting of record already existent in Dim_Vessel with no updates
	execute [extract].[AIS_Data_CSV]'C:\AIS\Tests\Test4.csv'
	execute utility.Add_Batch 1
	execute [load].[Dim_Vessel_L]	
	truncate table extract.AIS_Data
	
	/*   CSV content:
			~MMSI|AIS Message Type|Longitude|Latitude|MID Number|MID|Navigation Status|Rate of Turn (ROT)|Speed Over Ground (SOG)|Position Accuracy|Course Over Ground (COG)|True Heading (HDG)|Manoeuvre Indicator|RAIM Flag|Repeat Indicator|Received Time UTC-Unix|Vessel Name|IMO Number|Call Sign|Ship Type|Dimension to Bow|Dimension to Stern|Length|Dimension to Port|Dimension to Starboard|Beam|Position Type Fix|ETA month|ETA day|ETA hour|ETA minute|Draught|Destination
			219013485|5|10.163510|57.944600|219|Denmark|7|0|2,5|0|143,6|149|0|0|0|26-03-2020 16:55:41|TOVE KAJGAARD||||||||||||||||
			259896000|5|12.050940|54.408540|259|Norway|0|0|12,7|0|90,1|90|0|0|0|26-03-2020 16:55:40|||||||||||||||||
			222530728|5|12.311000|56.126280|222|not in use|0|-128|0,1|0|226,0|511|0|0|0|26-03-2020 16:55:41|BJORNSHOLM||||||||||||||||
			311055900|5|||311|Bahamas (Commonwealth of the)|||||||||0|26-03-2020 16:55:41|SKANDI CONSTRUCTOR|9431642|C6ZH8  |70|42|78|120|13|11|24|1|03|21|12|34|5,5|ODENSE 
			636092297|3|11.336810|57.492710|636|Liberia (Republic of)|0|0|9,6|0|130,8|131|0|0|0|26-03-2020 16:55:43|JOHANN||||||||||||||||	
	*/

 -- set rowCount for Dim_Vessel
	set @rowCount_Dim_Vessel= (select count(*) from edw.Dim_Vessel )
 
/*ASSERT*/
  -- evaluate the actual table (Dim_Vessel) and the expected table
	 EXEC tSQLt.AssertEqualsTable 'expected', 'edw.Dim_Vessel';

 -- evaluate if expected rowCount for Dim_Vessel is 2
	EXEC tSQLt.AssertEqualsString 10, @rowCount_Dim_Vessel;  
 
end 

 -- exec tsqlt.Run @TestName = '[testDimVessel].[Test4 - Insert many already existing records containing no updates]'