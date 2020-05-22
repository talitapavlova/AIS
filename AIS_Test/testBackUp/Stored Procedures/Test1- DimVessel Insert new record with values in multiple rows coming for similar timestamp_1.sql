







/******
	Change log: 
		2020-04-10	Stored procedure created for testing the effect of the stored procedures utility.Add_Batch on Dim_Vessel. 
	
	Test13 - Insert new record with values in multiple rows	  
	   The following test execute the ETL process using a csv. file containg several rows for the same MMSI, each holding different updates.
	   The test verifies if the record contains the correct information.
*/
CREATE PROCEDURE [testBackUp].[Test1- DimVessel Insert new record with values in multiple rows coming for similar timestamp]
AS
BEGIN

/*ARRANGE*/ 
  DECLARE @rowCount_Dim_Vessel int
  DECLARE @batchCreated int, @batchUpdated int

 IF OBJECT_ID('expected') IS NOT NULL DROP TABLE expected;
 
	-- truncate tables to have accurate test results 
  truncate table edw.Dim_Vessel
  truncate table archive.AIS_Data_archive
  truncate table extract.AIS_Data
  truncate table utility.Batch

/*ACT*/
	--step1: First execution of ETL, of non existent record
	execute [extract].[AIS_Data_CSV] 'C:\AIS\Tests\test_DimVessel\Test14.csv' 
	execute [archive].[AIS_Data_AddToArchive]
	execute [load].[Dim_Vessel_L]	
	execute utility.Add_Batch 1
	truncate table extract.AIS_Data

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

	--insert into expected
	--values ('219013485','SKANDI CONSTRUCTOR',	'9431642',	'3 ',	70, 'Cargo, all ships of this type',  'Bahamas (Commonwealth of the)',	311, 42, 78, 120,  13,11, 24, 1, 1, NULL,  '2020-03-26 16:50:39.0000000',	'9999-12-31 00:00:00.0000000')
  	
	--insert into expected
	--values ('219013485','SKANDI CONSTRUCTOR',	'9431642',	'3 ',	70, 'Cargo, all ships of this type',  'Bahamas (Commonwealth of the)',311, null, null, null, null, null, null,null, 1, 1,  '2020-03-26 16:50:35.0000000',	'2020-03-26 16:50:39.0000000')
  
 --   insert into expected
	--values ('219013485','SKANDI CONSTRUCTOR',	null,	null, null, -1, 'Bahamas (Commonwealth of the)',	311, null, null, null, null, null, null,null, 1, 1,  '2020-03-26 16:50:32.0000000',	'2020-03-26 16:50:35.0000000')
  


/*ASSERT*/
    -- Extra measurement, for checking if there is a slowly changing dimension for MMSI = 219013485
	set @rowCount_Dim_Vessel= (select count(*) from edw.Dim_Vessel where MMSI = '219013485')
	EXEC tSQLt.AssertEqualsString 1, @rowCount_Dim_Vessel; 
 	  
	---- evaluate the actual table (Dim_Vessel) and the expected table
 --   EXEC tSQLt.AssertEqualsTable 'expected', 'edw.Dim_Vessel';

	----evaluate the actual record (of Dim_Vessel) cross-refferences the correct Batch information*/	
 --   -- checking for old record's BatchCreated and BatchUpdated attributes
	--set @batchCreated = ( select BatchCreated from edw.Dim_Vessel where MMSI = '219013485' and Valid_To = '2020-03-26 16:50:35.0000000' )
	--EXEC tSQLt.AssertEqualsString 1 , @batchCreated;  
	
	--set @batchUpdated = (select BatchUpdated from edw.Dim_Vessel where MMSI = '219013485' and Valid_To = '9999-12-31 00:00:00.0000000' )
	--EXEC tSQLt.AssertEqualsString null, @batchUpdated;  
 
end 
 -- exec tsqlt.Run @TestName = '[testDimVessel].[Test13 - Insert new record with values in multiple rows]'