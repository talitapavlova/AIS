






/*  Test4 - Insert updates for already existent record, coming with multiple rows 	  
	   The following test execute the ETL process 3 times using csv. files containg updates for an already existent record in dim_vessel. The updates come in several rows, for each csv. file.
	   The test verifies the logic for both utility.Batch and Dim_Vessel tables:
		- For utility.Batch table it is verified if the SP generates a new row, each time the ETL process is executed
		- For Dim_Vessel it is verified if the slowly changing dimension refers to the correct batch information for each type2 record of the same unique identifier
*/
CREATE  PROCEDURE [testBackUp].[Test999 - Batch Insert updates for already existent record, coming with multiple rows]
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
	execute [extract].[AIS_Data_CSV] 'C:\AIS\Tests\test_Batch\Test04_1.csv' 
	execute utility.Add_Batch 1
	execute load.Dim_Vessel_L
	truncate table extract.AIS_Data
	select * from utility.Batch
	

	--step2: Second execution of ETL, of non existent record
	execute [extract].[AIS_Data_CSV] 'C:\AIS\Tests\test_Batch\Test04_2.csv' 
	execute utility.Add_Batch 1
	execute load.Dim_Vessel_L
	truncate table extract.AIS_Data
	select * from utility.Batch

	--step3: Second execution of ETL, of non existent record
	execute [extract].[AIS_Data_CSV] 'C:\AIS\Tests\test_Batch\Test04_3.csv' 
	execute utility.Add_Batch 1
	execute load.Dim_Vessel_L
	truncate table extract.AIS_Data

	select * from edw.Dim_Vessel
	select * from utility.Batch


/*ASSERT*/
  -- evaluate that utility.Batch contain 2 rows
	set @rowCount_Batch= (select count(*) from edw.Dim_Vessel )
    EXEC tSQLt.AssertEqualsString 3, @rowCount_Batch;  

  	-- Checking if each old record reffers to the correct batch number for BatchCreated attribute 
	set @batchCreated_oldRec = ( select BatchCreated from edw.Dim_Vessel where MMSI = '219013485' and  Valid_To = '2020-03-26 16:55:42.0000000')
	EXEC tSQLt.AssertEqualsString 1 , @batchCreated_oldRec;  
	
	-- Checking if each old record reffers to the correct batch number for BatchUpdated attribute 
	set @batchUpdated_oldRec = ( select BatchUpdated from edw.Dim_Vessel where MMSI = '219013485' and  Valid_To = '2020-03-26 16:55:42.0000000')
	EXEC tSQLt.AssertEqualsString 1 , @batchUpdated_oldRec;  

	-- Checking if each old record reffers to the correct batch number for BatchCreated attribute 
	set @batchCreated_oldRec = ( select BatchCreated from edw.Dim_Vessel where MMSI = '219013485' and  Valid_To = '2020-03-26 16:55:43.0000000')
	EXEC tSQLt.AssertEqualsString 1 , @batchCreated_oldRec;  
	
	-- Checking if each old record reffers to the correct batch number for BatchUpdated attribute 
	set @batchUpdated_oldRec = ( select BatchUpdated from edw.Dim_Vessel where MMSI = '219013485' and  Valid_To = '2020-03-26 16:55:43.0000000')
	EXEC tSQLt.AssertEqualsString 1 , @batchUpdated_oldRec;  

    -- Checking if each old record reffers to the correct batch number for BatchCreated attribute 
	set @batchCreated_oldRec = ( select BatchCreated from edw.Dim_Vessel where MMSI = '219013485' and  Valid_To = '2020-03-26 16:55:44.0000000')
	EXEC tSQLt.AssertEqualsString 1 , @batchCreated_oldRec;  
	
	-- Checking if each old record reffers to the correct batch number for BatchUpdated attribute 
	set @batchUpdated_oldRec = ( select BatchUpdated from edw.Dim_Vessel where MMSI = '219013485' and  Valid_To = '2020-03-26 16:55:44.0000000')
	EXEC tSQLt.AssertEqualsString 1 , @batchUpdated_oldRec;  

	-- Checking if each old record reffers to the correct batch number for BatchCreated attribute 
	set @batchCreated_oldRec = ( select BatchCreated from edw.Dim_Vessel where MMSI = '219013485' and  Valid_To = '2020-03-26 16:55:45.0000000')
	EXEC tSQLt.AssertEqualsString 1 , @batchCreated_oldRec;  
	
	-- Checking if each old record reffers to the correct batch number for BatchUpdated attribute 
	set @batchUpdated_oldRec = ( select BatchUpdated from edw.Dim_Vessel where MMSI = '219013485' and  Valid_To = '2020-03-26 16:55:45.0000000')
	EXEC tSQLt.AssertEqualsString 1 , @batchUpdated_oldRec;  

	-- Checking if each old record reffers to the correct batch number for BatchCreated attribute 
	set @batchCreated_oldRec = ( select BatchCreated from edw.Dim_Vessel where MMSI = '219013485' and  Valid_To = '2020-03-26 16:55:46.0000000')
	EXEC tSQLt.AssertEqualsString 1 , @batchCreated_oldRec;  
	
	-- Checking if each old record reffers to the correct batch number for BatchUpdated attribute 
	set @batchUpdated_oldRec = ( select BatchUpdated from edw.Dim_Vessel where MMSI = '219013485' and  Valid_To = '2020-03-26 16:55:46.0000000')
	EXEC tSQLt.AssertEqualsString 1 , @batchUpdated_oldRec;  

	-- Checking if  new record reffers to the correct batch numbers for BatchCreated attribute 
	set @batchCreated_newRec = (select BatchCreated from edw.Dim_Vessel where MMSI = '219013485' and  Valid_To = '9999-12-31 00:00:00.0000000')
	EXEC tSQLt.AssertEqualsString 1, @batchCreated_newRec;  
 
	-- Checking if each new record reffers to the correct batch numbers for BatchUpdated attribute 
	set @batchUpdated_newRec = (select BatchUpdated from edw.Dim_Vessel where MMSI = '219013485' and  Valid_To = '9999-12-31 00:00:00.0000000')
	EXEC tSQLt.AssertEqualsString null, @batchUpdated_newRec;  
 
end 
 -- exec tsqlt.Run @TestName = '[testBatch].[Test6 - Insert updates for already existent record, coming with multiple rows]'