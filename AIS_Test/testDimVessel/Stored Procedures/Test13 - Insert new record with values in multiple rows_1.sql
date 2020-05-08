

/******
	Change log: 
		2020-04-10	Stored procedure created for testing the effect of the stored procedures utility.Add_Batch on Dim_Vessel. 
	
	Test13 - Insert updates to already existing record with values in multiple rows	  
	   The following test execute the ETL process using a csv. file containg several rows for the same MMSI, each holding different updates.
	   The test verifies if the record contains the correct information.
*/
CREATE PROCEDURE [testDimVessel].[Test13 - Insert new record with values in multiple rows]
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

  --Prepare Dim_Vessel to be pre-populated with the record, simulting a previous execution of the ETL
	insert into edw.Dim_Vessel 
	values ('219013485','SKANDI CONSTRUCTOR',null, null, null, null, null, null,null,null,null,null,null,null, 1, NULL,  '2020-03-26 15:55:41.0000000',	'9999-12-31 00:00:00.0000000')
		
	 --Prepare utility.Batch table to be pre-populated with 1 records, simulting a previous execution of the ETL
    insert into utility.Batch
	values (1,1,1,0,'2020-03-26 15:55:41.0000000',	'2020-03-26 16:05:41.0000000', GETDATE())
	

/*ACT*/
	--step1: First execution of ETL
	execute [extract].[AIS_Data_CSV] 'C:\AIS\Tests\test_Batch\Test04_1.csv' 
	execute utility.Add_Batch 1
	execute load.Dim_Vessel_L
	truncate table extract.AIS_Data
	select * from edw.Dim_Vessel
	


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
 -- exec tsqlt.Run @TestName = '[testDimVessel].[Test13 - Insert new record with values in multiple rows]'