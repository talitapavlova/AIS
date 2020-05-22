
/*	
	Change log: 
		2020-04-10	Stored procedure created for testing the effect of the utility.Add_Batch SP on Dim_Vessel. 

	Tes Description:
	
	Test12 - Insert updates to record coming in consecutive batches
			The following test execute 5 times the ETL process, where the first execution introduces a new records, while the subsequent executions consist of updated values.	
			The test verifies if the record contains the correct batch number for each timestamp the record was cosidered valid, by closly checking the values of [BatchCreated] and [BatchUpdated] attributes. 
*/


CREATE PROCEDURE [testDimVessel].[Test12 - Insert updates coming in consecutive batches]
AS
BEGIN

/*ARRANGE*/    
    DECLARE @rowCount_Dim_Vessel int 
    DECLARE @batchCreated_oldRec1 int, @batchUpdated_oldRec1 int; 
    DECLARE @batchCreated_oldRec2 int, @batchUpdated_oldRec2 int;  
    DECLARE @batchCreated_oldRec3 int, @batchUpdated_oldRec3 int; 
    DECLARE @batchCreated_oldRec4 int, @batchUpdated_oldRec4 int;
    DECLARE @batchCreated_validRec int,  @batchUpdated_validRec int; 


    IF OBJECT_ID('expected') IS NOT NULL DROP TABLE expected;
 
	-- truncate tables to have accurate test results 
    truncate table edw.Dim_Vessel
    truncate table archive.AIS_Data_archive
    truncate table extract.AIS_Data
    truncate table utility.Batch

/*ACT*/	
	-- First ETL simulation
	execute [extract].[AIS_Data_CSV]'C:\AIS\Tests\test_DimVessel\Test12_1.csv'
	execute [archive].[AIS_Data_AddToArchive]
	execute [load].[Dim_Vessel_L]	
	execute utility.Add_Batch 1
	truncate table extract.AIS_Data

	-- First ETL simulation
	execute [extract].[AIS_Data_CSV]'C:\AIS\Tests\test_DimVessel\Test12_2.csv'
	execute [archive].[AIS_Data_AddToArchive]
	execute [load].[Dim_Vessel_L]	
	execute utility.Add_Batch 1
	truncate table extract.AIS_Data

	-- First ETL simulation
	execute [extract].[AIS_Data_CSV]'C:\AIS\Tests\test_DimVessel\Test12_3.csv'
	execute [archive].[AIS_Data_AddToArchive]
	execute [load].[Dim_Vessel_L]	
	execute utility.Add_Batch 1
	truncate table extract.AIS_Data

	-- First ETL simulation
	execute [extract].[AIS_Data_CSV]'C:\AIS\Tests\test_DimVessel\Test12_4.csv'
	execute [archive].[AIS_Data_AddToArchive]
	execute [load].[Dim_Vessel_L]	
	execute utility.Add_Batch 1
	truncate table extract.AIS_Data

	-- First ETL simulation
	execute [extract].[AIS_Data_CSV]'C:\AIS\Tests\test_DimVessel\Test12_5.csv'
	execute [archive].[AIS_Data_AddToArchive]
	execute [load].[Dim_Vessel_L]	
	execute utility.Add_Batch 1
	truncate table extract.AIS_Data

/*ASSERT*/	
	-- set rowCount for Dim_Vessel
 	set @rowCount_Dim_Vessel= (select count(*) from edw.Dim_Vessel )
	---- evaluate if expected rowCount for Dim_Vessel is 5  
	EXEC tSQLt.AssertEqualsString 5, @rowCount_Dim_Vessel; 
 	
    --evaluate the correct Batch information*/	
	 -- Checking if the old record reffers to the correct batch number for BatchCreated attribute 
	set @batchCreated_oldRec1 = ( select BatchCreated from edw.Dim_Vessel where MMSI = '219013485' and  Valid_To = '2020-03-26 16:55:41.0000000')
	EXEC tSQLt.AssertEqualsString 1 , @batchCreated_oldRec1;  
	
	-- Checking if the old record reffers to the correct batch number for BatchUpdated attribute 
	set @batchUpdated_oldRec1 = ( select BatchUpdated from edw.Dim_Vessel where MMSI = '219013485' and  Valid_To = '2020-03-26 16:55:41.0000000')
	EXEC tSQLt.AssertEqualsString 2 , @batchUpdated_oldRec1;  

		 -- Checking if the old record reffers to the correct batch number for BatchCreated attribute 
	set @batchCreated_oldRec2 = ( select BatchCreated from edw.Dim_Vessel where MMSI = '219013485' and  Valid_To = '2020-03-26 17:00:41.0000000')
	EXEC tSQLt.AssertEqualsString 2 , @batchCreated_oldRec2;  
	
	-- Checking if the old record reffers to the correct batch number for BatchUpdated attribute 
	set @batchUpdated_oldRec2 = ( select BatchUpdated from edw.Dim_Vessel where MMSI = '219013485' and  Valid_To = '2020-03-26 17:00:41.0000000')
	EXEC tSQLt.AssertEqualsString 3 , @batchUpdated_oldRec2;  
	
	-- Checking if the old record reffers to the correct batch number for BatchCreated attribute 
	set @batchCreated_oldRec3 = ( select BatchCreated from edw.Dim_Vessel where MMSI = '219013485' and  Valid_To = '2020-03-26 17:10:41.0000000')
	EXEC tSQLt.AssertEqualsString 3 , @batchCreated_oldRec3;  
	
		-- Checking if the old record reffers to the correct batch number for BatchUpdated attribute 
	set @batchUpdated_oldRec3 = ( select BatchUpdated from edw.Dim_Vessel where MMSI = '219013485' and  Valid_To = '2020-03-26 17:10:41.0000000')
	EXEC tSQLt.AssertEqualsString 4 , @batchUpdated_oldRec3;  
	
	-- Checking if the old record reffers to the correct batch number for BatchCreated attribute 
	set @batchCreated_oldRec4 = ( select BatchCreated from edw.Dim_Vessel where MMSI = '219013485' and  Valid_To = '2020-03-26 17:25:41.0000000')
	EXEC tSQLt.AssertEqualsString 4 , @batchCreated_oldRec4;  
	
	-- Checking if the old record reffers to the correct batch number for BatchUpdated attribute 
	set @batchUpdated_oldRec4 = ( select BatchUpdated from edw.Dim_Vessel where MMSI = '219013485' and  Valid_To = '2020-03-26 17:25:41.0000000')
	EXEC tSQLt.AssertEqualsString 5 , @batchUpdated_oldRec4;  
	
	-- Checking if the valid record reffers to the correct batch numbers for BatchCreated attribute 
	set @batchCreated_validRec = (select BatchCreated from edw.Dim_Vessel where MMSI = '219013485' and  Valid_To = '9999-12-31 00:00:00.0000000')
	EXEC tSQLt.AssertEqualsString 5, @batchCreated_validRec;  
 
 	-- Checking if the valid record reffers to the correct batch numbers for BatchCreated attribute 
	set @batchUpdated_validRec = (select BatchUpdated from edw.Dim_Vessel where MMSI = '219013485' and  Valid_To = '9999-12-31 00:00:00.0000000')
	EXEC tSQLt.AssertEqualsString null, @batchUpdated_validRec;  

end
  --exec tsqlt.Run @TestName = '[testDimVessel].[Test12 - Insert updates coming in consecutive batches]'