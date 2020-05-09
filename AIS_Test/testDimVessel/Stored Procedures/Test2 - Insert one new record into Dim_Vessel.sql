


/*	
	Change log: 
		2020-03-25	Stored procedure created for testing stored procedures targetting Dim_Vessel
		2020-04-10	Stored procedure updated for testing the effect of the stored procedures utility.Add_Batch on Dim_Vessel. The update consists of:
						-add execution of utility.Batch SP;
						-expand table expected with [BatchCreated] and [BatchUpdated] attributes;
						-expand insert statement of expected table with the expected valued for the above mentioned attributes;
						-check if the record contains the correct batch number in 2 ways: 
							-by the comparison of expected and actual Dim_Vessel table;
							-by closly checking the values of above mentioned attributes. 


	Test2: Insert one new record into Dim_Vessel:
		The test perfoms the ETL targeting Dim_Vessel one time, where the source file contains one record.
		The test verifies if the output of the ETL process is as expected.
		UPDATE: Furthermore, it is verified if the record contains the correct batch number, when Add_Batch SP is included 

	- Dim_Vessel
		- no content
	- CSV content:
			~MMSI|AIS Message Type|Longitude|Latitude|MID Number|MID|Navigation Status|Rate of Turn (ROT)|Speed Over Ground (SOG)|Position Accuracy|Course Over Ground (COG)|True Heading (HDG)|Manoeuvre Indicator|RAIM Flag|Repeat Indicator|Received Time UTC-Unix|Vessel Name|IMO Number|Call Sign|Ship Type|Dimension to Bow|Dimension to Stern|Length|Dimension to Port|Dimension to Starboard|Beam|Position Type Fix|ETA month|ETA day|ETA hour|ETA minute|Draught|Destination
			311055900|5|||311|Bahamas (Commonwealth of the)|||||||||0|26-03-2020 16:55:41|SKANDI CONSTRUCTOR|9431642|C6ZH8  |70|42|78|120|13|11|24|1|03|21|12|34|5,5|ODENSE 

*/

CREATE PROCEDURE [testDimVessel].[Test2 - Insert one new record into Dim_Vessel]
AS
BEGIN
  
/*ARRANGE phase: Where you arrange database objects taking part in the test along with creating expected objects and mocking actual tables if needed*/ 
  
  IF OBJECT_ID('expected') IS NOT NULL DROP TABLE expected;

  DECLARE @batchCreated int, @batchUpdated int
   
  -- truncate tables to have accurate test results 
  truncate table edw.Dim_Vessel
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
	values ('311055900','SKANDI CONSTRUCTOR',	'9431642',	'C6ZH8 ',	70,	   'Bahamas (Commonwealth of the)',	311, 42, 78, 120,  13,11, 24, 1, 1, NULL,  '2020-03-26 16:55:41.0000000',	'9999-12-31 00:00:00.0000000')
  
  
/*ACT phase: This is where you run the object (stored procedure or view) under test*/
 
  -- ETL for Dim_Vessel records
	execute [extract].[AIS_Data_CSV]'C:\AIS\Tests\Test2.csv'
	execute utility.Add_Batch 1
	execute [load].[Dim_Vessel_L]	
	truncate table extract.AIS_Data

/* ASSERT phase: It is the final step which compares expected results with actual results and on the bases of comparison a test is passed or failed */

  -- evaluate the actual table (Dim_Vessel) and the expected table
    EXEC tSQLt.AssertEqualsTable 'expected', 'edw.Dim_Vessel';
  
  --evaluate the actual record (of Dim_Vessel) cross-refferences the correct Batch information*/	
    -- checking for old record's BatchCreated and BatchUpdated attributes
	set @batchCreated = ( select BatchCreated from edw.Dim_Vessel where MMSI = '311055900' )
	EXEC tSQLt.AssertEqualsString 1 , @batchCreated;  
	
	set @batchUpdated = (select BatchUpdated from edw.Dim_Vessel where MMSI = '311055900')
	EXEC tSQLt.AssertEqualsString null, @batchUpdated;  
end

-- exec tsqlt.Run @TestName = '[testDimVessel].[Test2 - Insert one new record into Dim_Vessel]'