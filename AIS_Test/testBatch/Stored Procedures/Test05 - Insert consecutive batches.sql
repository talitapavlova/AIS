
/* 
Change log: 
	2020-04-13	Stored procedure created for testing stored procedure targetting utility.Batch

Test Description:
	Test05 -  Insert 5 consecutive batches 
	The test performs the stored procedure targeting utility.Batch table 5 times, simulating 5 executions of the ETL process. The other dependent procedures are also executed*
	The test is executed in a scenario where the source file contains 1,10, 100, 1000, 10000 records each, all chronologically sorted.   
	The test verifies if the utility.Batch holds 5 records after the 5 execuitions, as well as checks 
		if the batches are stored in the order of execution by assessing the values of minReceivedTime and maxReceivedTime. **/

CREATE PROCEDURE [testBatch].[Test05 - Insert consecutive batches] 
AS
BEGIN

/*ARRANGE*/  
  
    DECLARE @rowCount_Batch int

    DECLARE @minRecTime_Batch1 dateTime2, @maxRecTime_Batch1 datetime2;
    DECLARE @minRecTime_Batch2 dateTime2, @maxRecTime_Batch2 datetime2;
    DECLARE @minRecTime_Batch3 dateTime2, @maxRecTime_Batch3 datetime2;
    DECLARE @minRecTime_Batch4 dateTime2, @maxRecTime_Batch4 datetime2;
    DECLARE @minRecTime_Batch5 dateTime2, @maxRecTime_Batch5 datetime2;

  -- truncate tables to have accurate test results 
	truncate table edw.Dim_Vessel
	truncate table extract.AIS_Data
	truncate table utility.Batch


/*ACT and ASSRT combined, for better visualization*/
 
 -- 5 consecutive exections of the ETL
	execute [extract].[AIS_Data_CSV] 'C:\AIS\Tests\test_Batch\Test5_01.csv'   
	execute utility.Add_Batch 1
    truncate table extract.AIS_Data

	execute [extract].[AIS_Data_CSV] 'C:\AIS\Tests\test_Batch\Test5_02.csv'   
	execute utility.Add_Batch 1
    truncate table extract.AIS_Data

	execute [extract].[AIS_Data_CSV] 'C:\AIS\Tests\test_Batch\Test5_03.csv'   
	execute utility.Add_Batch 1
    truncate table extract.AIS_Data

	execute [extract].[AIS_Data_CSV] 'C:\AIS\Tests\test_Batch\Test5_04.csv'   
	execute utility.Add_Batch 1
    truncate table extract.AIS_Data

	execute [extract].[AIS_Data_CSV] 'C:\AIS\Tests\test_Batch\Test5_05.csv'   
	execute utility.Add_Batch 1
    truncate table extract.AIS_Data

  -- set rowCount for utility.Batch
	set @rowCount_Batch= (select count(*) from utility.Batch )
   -- evaluate the actual table utlity.Batch using rowCount  
     EXEC tSQLt.AssertEqualsString 5, @rowCount_Batch;

    --Checking for @minRecTime of batch 1 
	set @minRecTime_Batch1 = (select MinReceivedTime from utility.Batch where Batch = 1)
    EXEC tSQLt.AssertEqualsString '2020-05-08 10:10:00.0000000' , @minRecTime_Batch1;  

    -- Checking for @maxRecTime of batch 1
	set @maxRecTime_Batch1 = ( select MaxReceivedTime from utility.Batch where Batch = 1)
	EXEC tSQLt.AssertEqualsString '2020-05-08 10:10:00.0000000' , @maxRecTime_Batch1;  

	--Checking for @minRecTime of batch 2 
	set @minRecTime_Batch2 = (select MinReceivedTime from utility.Batch where Batch = 2)
   EXEC tSQLt.AssertEqualsString '2020-05-08 11:11:00.0000000' , @minRecTime_Batch2;  

   -- Checking for @maxRecTime of batch 2
	set @maxRecTime_Batch2 = ( select MaxReceivedTime from utility.Batch where Batch = 2)
	EXEC tSQLt.AssertEqualsString '2020-05-08 11:21:05.0000000' , @maxRecTime_Batch2;  

	--Checking for @minRecTime of batch 3 
	set @minRecTime_Batch3 = (select MinReceivedTime from utility.Batch where Batch = 3)
    EXEC tSQLt.AssertEqualsString '2020-05-08 11:24:30.0000000' , @minRecTime_Batch3;  

    -- Checking for @maxRecTime of batch 3
	set @maxRecTime_Batch3 = ( select MaxReceivedTime from utility.Batch where Batch = 3)
	EXEC tSQLt.AssertEqualsString '2020-05-08 11:24:31.0000000' , @maxRecTime_Batch3;  

	--Checking for @minRecTime of batch 4 
	set @minRecTime_Batch4 = (select MinReceivedTime from utility.Batch where Batch = 4)
   EXEC tSQLt.AssertEqualsString '2020-05-08 11:26:41.0000000' , @minRecTime_Batch4;  

    -- Checking for @maxRecTime of batch 4
	set @maxRecTime_Batch4 = ( select MaxReceivedTime from utility.Batch where Batch = 4)
	EXEC tSQLt.AssertEqualsString '2020-05-08 11:26:49.0000000' , @maxRecTime_Batch4;  

	--Checking for @minRecTime of batch 5 
	set @minRecTime_Batch5 = (select MinReceivedTime from utility.Batch where Batch = 5)
   EXEC tSQLt.AssertEqualsString '2020-05-08 11:26:49.0000000' , @minRecTime_Batch5;  

    -- Checking for @maxRecTime of batch 5
	set @maxRecTime_Batch5 = ( select MaxReceivedTime from utility.Batch where Batch = 5)
	EXEC tSQLt.AssertEqualsString '2020-05-08 11:28:04.0000000' , @maxRecTime_Batch5;

end 

 -- exec tsqlt.Run @TestName = '[testBatch].[Test05 - Insert consecutive batches]'