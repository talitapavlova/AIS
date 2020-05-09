

/*
Test1:  The following test inserts an already existing record into Dim_Vessel containing updates. It verifies the logic for both utility.Batch and Dim_Vessel tables:
			- For utility.Batch table it is verified if the SP generates the correct information, each time the ETL process is executed.
			- For Dim_Vessel it is verified if the slowly changing dimension refers to the correct batch information for each type2 record*/

CREATE    PROCEDURE [testBatch].[Test1 - Insert one already existing record, containing updates] 
AS
BEGIN
  
  DECLARE @oldBatchCreated varchar(100), @oldBatchUpdated varchar(100)
  DECLARE @newBatchCreated varchar(100), @newBatchUpdated varchar(100)
  Declare @batch1_date datetime2,@batch2_date datetime2
  
  IF OBJECT_ID('expected_Vessel') IS NOT NULL DROP TABLE expected_Vessel;
  IF OBJECT_ID('expected_Batch') IS NOT NULL DROP TABLE expected_Batch;
 
  -- truncate tables to have accurate test results 
	truncate table edw.Dim_Vessel
	truncate table extract.AIS_Data
	truncate table utility.Batch

  -- Prepare Dim_Vessel to be pre-populated with one following record from the .csv file. Excute utility.Add_Batch SP, which is excecuted each time the ETL is triggered 
	execute [extract].[AIS_Data_CSV] 'C:\Users\stefy\Desktop\test_Batch\Test01.csv'   
	execute utility.Add_Batch 1
	execute [load].[Dim_Vessel_L]	
	truncate table extract.AIS_Data
	
  -- New ETL for Dim_Vessel with updates. Excute utility.Add_Batch SP, which is excecuted each time the ETL is triggered 
	execute [extract].[AIS_Data_CSV] 'C:\Users\stefy\Desktop\test_Batch\Test02.csv'   
	execute utility.Add_Batch 1
	execute [load].[Dim_Vessel_L]
	truncate table extract.AIS_Data


/* TEST for utility.Batch: Checking if the SP generates the correct information with each ETL process executed */

   --create table expected_Batch, having the same structure as utility.Batch
    create table expected_Batch (
		[Batch] [int] NOT NULL,
		[TotalRows] [int] NOT NULL,
		[IsContinuousData] [tinyint] NULL,
		[IsHistoricalData] [tinyint] NULL,
		[MinReceivedTime] [datetime2](7) NULL,
		[MaxReceivedTime] [datetime2](7) NULL,
		[DateCreated] [datetime2](7) NULL)

-- since DateCreated is dependednt on current time, DateCreated of each record is extracted from utility.Batch to be used in expected_Batch 
	set @batch1_date = (select DateCreated from utility.Batch where Batch = 1)
	set @batch2_date = (select DateCreated from utility.Batch where Batch = 2)

-- values to compare against when evaluting the actual table utility.Batch and the expected_Batch, after performing 2 times the ETL process:
	insert into expected_Batch values (1, 1, 1, 0, '2020-03-26 16:00:00.0000000',	'2020-03-26 16:00:00.0000000',  @batch1_date)
	insert into expected_Batch 	values (2, 1, 1, 0, '2020-03-26 16:35:41.0000000',	'2020-03-26 16:35:41.0000000',   @batch2_date) 

-- evaluate the actual table utility.Batchand and the expected_Batch table
	 EXEC tSQLt.AssertEqualsTable 'expected_Batch', 'utility.Batch';


/* Dim_Vessel test: Checking if each record of the slowly changing dimension points to the correct Batch row*/
	
-- Checking for old record's BatchCreated and BatchUpdated attributes
	set @oldBatchCreated = ( select BatchCreated from edw.Dim_Vessel where MMSI = '265410000' and  Valid_To = '2020-03-26 16:35:41.0000000')
	EXEC tSQLt.AssertEqualsString 1 , @oldBatchCreated;  
	
	set @oldBatchUpdated = (select BatchUpdated from edw.Dim_Vessel where MMSI = '265410000' and  Valid_To = '2020-03-26 16:35:41.0000000')
	EXEC tSQLt.AssertEqualsString 2, @oldBatchUpdated;  

-- Checking for updated record's BatchCreated and BatchUpdated attributes
	set @newBatchCreated = ( select BatchCreated from edw.Dim_Vessel where MMSI = '265410000' and  Valid_To = '9999-12-31 00:00:00.0000000')
	EXEC tSQLt.AssertEqualsString 2 , @newBatchCreated;  
	
	set @newBatchUpdated = (select BatchUpdated from edw.Dim_Vessel where MMSI = '265410000' and  Valid_To = '9999-12-31 00:00:00.0000000')
	EXEC tSQLt.AssertEqualsString null, @newBatchUpdated;  

end 

 -- exec tsqlt.Run @TestName = '[testBatch].[Test1 - Insert one already existing record, containing updates]'