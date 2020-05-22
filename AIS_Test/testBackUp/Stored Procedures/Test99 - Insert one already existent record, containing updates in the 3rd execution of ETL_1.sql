





/* Test3 - Test3 - Insert one already existent record, containing updates in the 3rd execution of ETL
	  
	   The following test execute 3 times the ETL process. In the first and second executions complete new records are introduced, while in the 3rd execution of ETL updates for an already existing record in Dim_Vessel are inserted. 
	   It verifies the logic for both utility.Batch and Dim_Vessel tables:
		- For utility.Batch table it is verified if the SP generates a new row, each time the ETL process is executed
		- For Dim_Vessel it is verified if the slowly changing dimension refers to the correct batch information for each type2 record
*/
CREATE    PROCEDURE [testBackUp].[Test99 - Insert one already existent record, containing updates in the 3rd execution of ETL]
AS
BEGIN

/*ARRANGE*/ 
  DECLARE @rowCount_Batch int;
  DECLARE @batchCreated_oldRec int, @batchUpdated_oldRec int; 
  DECLARE @batchCreated_newRec int, @batchUpdated_newRec int; 

  IF OBJECT_ID('expected') IS NOT NULL DROP TABLE expected;
 
    -- truncate tables to have accurate test results 
	truncate table edw.Dim_Vessel
	truncate table extract.AIS_Data
	truncate table utility.Batch

/*ACT*/
	--step1: First execution of ETL, of non existent record 
	execute [extract].[AIS_Data_CSV] 'C:\AIS\Tests\test_Batch\Test03_1.csv' 
	execute utility.Add_Batch 1
	execute load.Dim_Vessel_L
	truncate table extract.AIS_Data

	--step2: Second execution of ETL, of non existent record
	execute [extract].[AIS_Data_CSV] 'C:\AIS\Tests\test_Batch\Test03_2.csv' 
	execute utility.Add_Batch 1
	execute load.Dim_Vessel_L
	truncate table extract.AIS_Data

	--step3: Third execution of ETL, containing updates for record in step1
	execute [extract].[AIS_Data_CSV] 'C:\AIS\Tests\test_Batch\Test03_3.csv' 
	execute utility.Add_Batch 1
	execute load.Dim_Vessel_L
	truncate table extract.AIS_Data


/*ASSERT*/
  -- evaluate that utility.Batch contain 2 rows
	set @rowCount_Batch= (select count(*) from edw.Dim_Vessel )
    EXEC tSQLt.AssertEqualsString 3, @rowCount_Batch;  

  	-- Checking if the old record reffers to the correct batch number for BatchCreated attribute 
	set @batchCreated_oldRec = ( select BatchCreated from edw.Dim_Vessel where MMSI = '219013485' and  Valid_To = '2020-03-26 16:55:41.0000000')
	EXEC tSQLt.AssertEqualsString 1 , @batchCreated_oldRec;  
	
	-- Checking if the old record reffers to the correct batch number for BatchUpdated attribute 
	set @batchUpdated_oldRec = ( select BatchUpdated from edw.Dim_Vessel where MMSI = '219013485' and  Valid_To = '2020-03-26 16:55:41.0000000')
	EXEC tSQLt.AssertEqualsString 3 , @batchUpdated_oldRec;  
	
	-- Checking if the new record reffers to the correct batch numbers for BatchCreated attribute 
	set @batchCreated_newRec = (select BatchCreated from edw.Dim_Vessel where MMSI = '219013485' and  Valid_To = '9999-12-31 00:00:00.0000000')
	EXEC tSQLt.AssertEqualsString 3, @batchCreated_newRec;  
 
	-- Checking if the new record reffers to the correct batch numbers for BatchUpdated attribute 
	set @batchUpdated_newRec = (select BatchUpdated from edw.Dim_Vessel where MMSI = '219013485' and  Valid_To = '9999-12-31 00:00:00.0000000')
	EXEC tSQLt.AssertEqualsString null, @batchUpdated_newRec;  
 
end 
 -- exec tsqlt.Run @TestName = '[testBatch].[Test6 - Insert one already existent record, containing updates in the 3rd execution of ETL]'