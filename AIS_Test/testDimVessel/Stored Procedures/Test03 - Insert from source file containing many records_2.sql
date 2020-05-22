


/******
	Change log: 
		2020-03-25	Stored procedure created for testing stored procedures targeting Dim_Vessel
		2020-04-10	Stored procedure updated for testing the effect of the stored procedures utility.Add_Batch on Dim_Vessel. The update consists of:
						-add execution of utility.Batch SP;
						-expand expected table with [BatchCreated] and [BatchUpdated] attributes;
						-expand insert statement of expected table with the expected values of the above mentioned attributes, for providing the possibility of comparison with the actual Dim_Vessel table, hence 
							checking if the record contains the correct batch number.

	Test Description:
		[Test03 - Insert from source file containing many records]
				(10 records had been cosidered, since it is a relatively small number and provides the possibility of visualizing and evaluating results of each record. 
				 It is assumed that if 10 records perform as expected, larger amount of records will behave the same).
		The test performs the SP targeting Dim_Vessel, where the source file contains 10 records. The test verifies if the output of the SPs is as expected.
		UPDATE: Furthermore, it is verified if the record contains the correct batch number, when Add_Batch SP is included. 

	Set-up:
		- Dim_Vessel
			- no content

		- CSV content:
			~MMSI|AIS Message Type|Longitude|Latitude|MID Number|MID|Navigation Status|Rate of Turn (ROT)|Speed Over Ground (SOG)|Position Accuracy|Course Over Ground (COG)|True Heading (HDG)|Manoeuvre Indicator|RAIM Flag|Repeat Indicator|Received Time UTC-Unix|Vessel Name|IMO Number|Call Sign|Ship Type|Dimension to Bow|Dimension to Stern|Length|Dimension to Port|Dimension to Starboard|Beam|Position Type Fix|ETA month|ETA day|ETA hour|ETA minute|Draught|Destination
			244813000|5|8.597500|57.854670|244|Netherlands (Kingdom of the)|0|7|13,6|0|68,0|66|0|0|0|26-03-2020 16:55:41|BIT FORCE||||||||||||||||
			219006916|5|8.127717|56.001370|219|Denmark|15|-128|0,0|0|254,7|511|0|0|0|26-03-2020 16:55:41|RI322 SINNE FRIHED||||||||||||||||
			219330000|5|11.739600|56.325370|219|Denmark|7|0|10,7|1|282,6|281|0|0|0|26-03-2020 16:55:41|NEPTUN AS 202||||||||||||||||
			205769000|5|6.599771|55.815250|205|Belgium|0|0|13,8|0|210,1|206|0|0|0|26-03-2020 16:55:41|||||||||||||||||
			211789180|5|6.979007|56.625840|211|Germany (Federal Republic of)|0|0|8,9|0|165,7|164|0|0|0|26-03-2020 16:55:41|IRIS||||||||||||||||
			220334000|5|11.126950|57.321250|220|Denmark|7|0|0,0|0|239,6|155|0|0|0|26-03-2020 16:55:41|STINE FN396||||||||||||||||
			219013485|5|10.163510|57.944600|219|Denmark|7|0|2,5|0|143,6|149|0|0|0|26-03-2020 16:55:41|TOVE KAJGAARD||||||||||||||||
			259896000|5|12.050940|54.408540|259|Norway|0|0|12,7|0|90,1|90|0|0|0|26-03-2020 16:55:40|||||||||||||||||
			222530728|5|12.311000|56.126280|222|not in use|0|-128|0,1|0|226,0|511|0|0|0|26-03-2020 16:55:41|BJORNSHOLM||||||||||||||||
			311055900|5|||311|Bahamas (Commonwealth of the)|||||||||0|26-03-2020 16:55:41|SKANDI CONSTRUCTOR|9431642|C6ZH8  |70|42|78|120|13|11|24|1|03|21|12|34|5,5|ODENSE 
			636092297|3|11.336810|57.492710|636|Liberia (Republic of)|0|0|9,6|0|130,8|131|0|0|0|26-03-2020 16:55:43|JOHANN||||||||||||||||
*****/

CREATE PROCEDURE [testDimVessel].[Test03 - Insert from source file containing many records]
AS
BEGIN

/*Arrange*/
  
  DECLARE @rowCount_Dim_Vessel int
  IF OBJECT_ID('expected') IS NOT NULL DROP TABLE expected;

  -- truncate tables to have accurate test results 
  truncate table edw.Dim_Vessel
  truncate table archive.AIS_Data_archive
  truncate table extract.AIS_Data
  truncate table utility.Batch

  --create table expected, having the same structure as Dim_Vessel
  create table expected (
	[Vessel_Key] [int] IDENTITY(1,1) NOT NULL,
	[MMSI] [char](9) NOT NULL,
	[Vessel_Name] [nvarchar](200) NULL,
	[IMO] [nvarchar](10) NULL,
	[Call_Sign] [nvarchar](10) NULL,
	[Ship_Type] [int] NULL,
	[Ship_Type_Description] [nvarchar](1000) NULL,
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

  --values expected to be in Dim_Vessel after inserting the values from the CSV. file 
	insert into expected
	values ('205769000', null, null, null, null, -1, 'Belgium',205, null, null, null, null, null, null, null, 1, NULL,  '2020-03-26 16:55:41.0000000',	'9999-12-31 00:00:00.0000000')
	insert into expected
	values ('211789180','IRIS' ,null, null, null, -1,'Germany (Federal Republic of)',211, null,null,null,null,null,null,null, 1, NULL,  '2020-03-26 16:55:41.0000000',	'9999-12-31 00:00:00.0000000')
	insert into expected
	values ('219006916', 'RI322 SINNE FRIHED', null, null, null,-1,'Denmark',	219, null,null,null,null,null,null,null, 1, NULL,  '2020-03-26 16:55:41.0000000',	'9999-12-31 00:00:00.0000000')
	insert into expected
	values ('219013485','TOVE KAJGAARD',null, null, null, -1,'Denmark',	219, null,null,null,null,null,null,null, 1, NULL,  '2020-03-26 16:55:41.0000000',	'9999-12-31 00:00:00.0000000')
	insert into expected
	values ('219330000','NEPTUN AS 202',null, null, null,-1,'Denmark',	219, null,null,null,null,null,null,null, 1, NULL,  '2020-03-26 16:55:41.0000000',	'9999-12-31 00:00:00.0000000')
	insert into expected
	values ('220334000', 'STINE FN396',	null, null, null,-1, 'Denmark',	220, null,null,null,null,null,null,null, 1, NULL,  '2020-03-26 16:55:41.0000000',	'9999-12-31 00:00:00.0000000')
	insert into expected
	values ('222530728','BJORNSHOLM', null, null, null, -1, 'not in use' ,	222, null,null,null,null,null,null,null, 1, NULL,  '2020-03-26 16:55:41.0000000',	'9999-12-31 00:00:00.0000000')
	insert into expected
	values ('244813000','BIT FORCE', null, null, null, -1,'Netherlands (Kingdom of the)',	244, null,null,null,null,null,null,null, 1, NULL,  '2020-03-26 16:55:41.0000000',	'9999-12-31 00:00:00.0000000')
	insert into expected
	values ('259896000', null,	null,null,null,-1, 'Norway',	259,null,null,null,null,null,null,null, 1, NULL,  '2020-03-26 16:55:40.0000000',	'9999-12-31 00:00:00.0000000')
	insert into expected
	values ('311055900','SKANDI CONSTRUCTOR','9431642',	'C6ZH8 ',	 70, 'Cargo, all ships of this type',	   'Bahamas (Commonwealth of the)',	311, 42, 78, 120,  13,11, 24, 1, 1, NULL,  '2020-03-26 16:55:41.0000000',	'9999-12-31 00:00:00.0000000')
	
/*ACT*/
  --run SPs targeting Dim_Vessel, including the ones in dependency relationship with it
  execute [extract].[AIS_Data_CSV]'C:\AIS\Tests\test_DimVessel\Test3.csv'
  execute [archive].[AIS_Data_AddToArchive]
  execute [load].[Dim_Vessel_L]	
  execute utility.Add_Batch 1
  truncate table extract.AIS_Data
 
/*ASSERT*/
  -- evaluate the actual table (Dim_Vessel) and the expected table
  EXEC tSQLt.AssertEqualsTable 'expected', 'edw.Dim_Vessel';

   -- set rowCount for Dim_Vessel
  set @rowCount_Dim_Vessel= (select count(*) from edw.Dim_Vessel )
 -- evaluate the actual table's (Dim_Vessel)  rowCount 
  EXEC tSQLt.AssertEqualsString 10, @rowCount_Dim_Vessel;  

end

-- exec tsqlt.Run @TestName = '[testDimVessel].[Test03 - Insert from source file containing many records]'