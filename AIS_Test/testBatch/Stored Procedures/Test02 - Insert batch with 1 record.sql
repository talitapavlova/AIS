﻿

/* 
Change log: 
		2020-04-13	Stored procedure created for testing stored procedure targetting utility.Batch

Test Description:
	Test02 - Insert first batch consisting of 1 record
		The test performs the stored procedure targeting utility.Batch table which is dependednt on the extract_AIS_Data_CSV SP. Therefore the later is included.
		The test is executed in a scenario where the source file contains 1 records. 
		The test verifies if the utility.Batch table holds 1 record, as well as evaluating the values of the fields after execution of SPs.

*/

CREATE PROCEDURE [testBatch].[Test02 - Insert batch with 1 record]
AS
BEGIN

/*ARRANGE*/

  DECLARE @rowCount_Batch int
  DECLARE @batchNo int, @totalRows int, @isContinuousData int, @isHistoricalData int; 
  DECLARE @minRecTime dateTime2, @maxRecTime datetime2, @dateCreated datetime2, @extractGetDate datetime2;

  IF OBJECT_ID('expected') IS NOT NULL DROP TABLE expected;

  -- truncate tables to have accurate test results 
  truncate table edw.Dim_Vessel
  truncate table archive.AIS_Data_archive
  truncate table extract.AIS_Data
  truncate table utility.Batch

/*ACT and ASSRT combined, for better visualization*/
  
   --execute ETL's stored procedures
	 execute [extract].[AIS_Data_CSV] 'C:\AIS\Tests\test_Batch\Test2.csv'   
	 execute utility.Add_Batch 1
	
   -- set rowCount for utility.Batch
     set @rowCount_Batch= (select count(*) from utility.Batch )
   -- evaluate the actual table utlity.Batch using rowCount  
     EXEC tSQLt.AssertEqualsString 1, @rowCount_Batch;  

	-- Checking for batch number
	set @batchNo = ( select Batch from utility.Batch)
	EXEC tSQLt.AssertEqualsString 1 , @batchNo;   

    -- Checking for total rows in batch
	set @totalRows = ( select TotalRows from utility.Batch)
	EXEC tSQLt.AssertEqualsString 1000 , @totalRows;  

	-- Checking for @isContinuousData number
	set @isContinuousData = ( select IsContinuousData from utility.Batch)
	EXEC tSQLt.AssertEqualsString 1 , @isContinuousData;  

    -- Checking for @isHistoricalData number
	set @isHistoricalData = ( select IsHistoricalData from utility.Batch)
	EXEC tSQLt.AssertEqualsString 0 , @isHistoricalData;  

	-- Checking for @minRecTime number
	set @minRecTime = ( select MinReceivedTime from utility.Batch)
	EXEC tSQLt.AssertEqualsString '2020-05-08 11:11:05.0000000' , @minRecTime;  

    -- Checking for @maxRecTime number
	set @maxRecTime = ( select MaxReceivedTime from utility.Batch)
	EXEC tSQLt.AssertEqualsString '2020-05-08 11:11:12.0000000' , @maxRecTime;  

	-- Checking for DateCreated 
	    /* Sine the @DateCreated field is created with GetDate() at the moment of the SP's execution, it will be imposible to assess its value in the test assertion by manually inputting it. 
		   The comparison can be made using the GetDate() function for this purpose. However, these can not be directly comparred. 
		   A work-around is necessary, to exclude the level of milliseconds, assuming the actual SP and the test assertion are executed on a time difference of milliseconds.
	       Therefore, the @extaracted date is used instead, to assess the current date, excluding the level of milliseconds:*/
	
	-- get date in the format yyyy-mm-dd hh-mm-ss, excluding the milisecond part
	set @extractGetDate = convert(varchar(25), GETDATE(), 20)
	
	set @dateCreated = convert(varchar(25), (select DateCreated from utility.Batch), 20)
	EXEC tSQLt.AssertEqualsString @extractGetDate , @dateCreated;  
end 

 -- exec tsqlt.Run @TestName = '[testBatch].[Test02 - Insert batch with 1 record]'