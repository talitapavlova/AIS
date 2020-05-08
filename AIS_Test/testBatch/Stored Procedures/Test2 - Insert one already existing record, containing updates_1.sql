


/*
Test2:  The following test inserts an already existing record into Dim_Vessel containing updates. It verifies the logic for both utility.Batch and Dim_Vessel tables:
			- For utility.Batch table it is verified if the SP generates a new row, each time the ETL process is executed.
			- For Dim_Vessel it is verified if the slowly changing dimension refers to the correct batch information for each type2 record*/

CREATE   PROCEDURE [testBatch].[Test2 - Insert one already existing record, containing updates] 
AS
BEGIN

/*ARRANGE*/  
	DECLARE @rowCount_Batch int
	DECLARE @oldBatchCreated int, @oldBatchUpdated int
	DECLARE @newBatchCreated int, @newBatchUpdated int
   
  -- truncate tables to have accurate test results 
	truncate table edw.Dim_Vessel
	truncate table extract.AIS_Data
	truncate table utility.Batch

/*ACT*/	
  -- Prepare Dim_Vessel to be pre-populated with one following record from the .csv file. Excute utility.Add_Batch SP, which is excecuted each time the ETL is triggered 
	execute [extract].[AIS_Data_CSV] 'C:\AIS\Tests\test_Batch\Test01.csv'   
	execute utility.Add_Batch 1
	execute [load].[Dim_Vessel_L]	
	truncate table extract.AIS_Data

  -- New ETL for Dim_Vessel with updates. Excute utility.Add_Batch SP, which is excecuted each time the ETL is triggered 
	execute [extract].[AIS_Data_CSV] 'C:\AIS\Tests\test_Batch\Test02.csv'   
	execute utility.Add_Batch 1
	execute [load].[Dim_Vessel_L]
	truncate table extract.AIS_Data
	
/*ASSERT*/
  -- evaluate that utility.Batch contain 2 rows
	set @rowCount_Batch= (select count(*) from edw.Dim_Vessel )
    EXEC tSQLt.AssertEqualsString 2, @rowCount_Batch;  


/* Dim_Vessel test: Checking if each record of the slowly changing dimension points to the correct Batch row*/	
-- Checking for old record's BatchCreated and BatchUpdated attributes
	set @oldBatchCreated = ( select BatchCreated from edw.Dim_Vessel where MMSI = '265410000' and  Valid_To = '2020-03-26 16:00:00.0000000')
	EXEC tSQLt.AssertEqualsString 1 , @oldBatchCreated;  
	
	set @oldBatchUpdated = (select BatchUpdated from edw.Dim_Vessel where MMSI = '265410000' and  Valid_To = '2020-03-26 16:00:00.0000000')
	EXEC tSQLt.AssertEqualsString 2, @oldBatchUpdated;  

-- Checking for updated record's BatchCreated and BatchUpdated attributes
	set @newBatchCreated = ( select BatchCreated from edw.Dim_Vessel where MMSI = '265410000' and  Valid_To = '9999-12-31 00:00:00.0000000')
	EXEC tSQLt.AssertEqualsString 2 , @newBatchCreated;  
	
	set @newBatchUpdated = (select BatchUpdated from edw.Dim_Vessel where MMSI = '265410000' and  Valid_To = '9999-12-31 00:00:00.0000000')
	EXEC tSQLt.AssertEqualsString null, @newBatchUpdated;  

end 

 -- exec tsqlt.Run @TestName = '[testBatch].[Test2 - Insert one already existing record, containing updates]'