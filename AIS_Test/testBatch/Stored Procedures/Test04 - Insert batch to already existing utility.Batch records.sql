




/* 
Change log: 
		2020-04-13	Stored procedure created for testing stored procedure targetting utility.Batch

Test Description:
	[Test04 - Insert batch to already existing utility.Batch records] 
			The test performs the stored procedure targeting utility.Batch table and the dependent one, the extract_AIS_Data_CSV stored procedure.
			The test is executed in a scenario where the source file contains 1000 records and the utility.Batch table is prepolulated with 10 records.   
			The test verifies if the utility.Batch table holds 11 records after the execution of the stored procedure.**/

CREATE PROCEDURE [testBatch].[Test04 - Insert batch to already existing utility.Batch records] 
AS
BEGIN

/*ARRANGE*/  
  
   DECLARE @rowCount_Batch int

  -- truncate tables to have accurate test results 
	truncate table edw.Dim_Vessel
	truncate table extract.AIS_Data
	truncate table utility.Batch

  --Prepare utility.Batch table to be pre-populated with 10 records, simulting 10 previous executions of the ETL
    insert into utility.Batch
	values (1,1000,1,0,'2020-03-26 16:55:41.0000000',	'2020-03-26 16:55:42.0000000', GETDATE())
	 
	insert into utility.Batch
	values (2,1200,1,0,'2020-03-26 17:55:41.0000000',	'2020-03-26 17:55:42.0000000', GETDATE())
	 
	insert into utility.Batch
	values (3,1300,1,0,'2020-03-26 18:55:41.0000000',	'2020-03-26 18:55:43.0000000', GETDATE())

    insert into utility.Batch
	values (4,1400,1,0,'2020-03-26 19:55:41.0000000',	'2020-03-26 19:55:42.0000000', GETDATE())
	 
	insert into utility.Batch
	values (5,1500,1,0,'2020-03-26 20:55:41.0000000',	'2020-03-26 20:55:42.0000000', GETDATE())
	 
	insert into utility.Batch
	values (6,1600,1,0,'2020-03-26 21:55:41.0000000',	'2020-03-26 21:55:43.0000000', GETDATE())

    insert into utility.Batch
	values (7,1700,1,0,'2020-03-26 22:55:41.0000000',	'2020-03-26 22:55:42.0000000', GETDATE())
	 
	insert into utility.Batch
	values (8,1800,1,0,'2020-03-26 23:55:41.0000000',	'2020-03-26 23:56:42.0000000', GETDATE())
	 
	insert into utility.Batch
	values (9,1900,1,0,'2020-03-26 23:57:41.0000000',	'2020-03-26 23:58:43.0000000', GETDATE())

	insert into utility.Batch
	values (10, 2000,1,0,'2020-03-26 23:58:41.0000000',	'2020-03-26 23:59:43.0000000', GETDATE())

/*ACT*/	
  -- run relevant SPs
	execute [extract].[AIS_Data_CSV] 'C:\AIS\Tests\test_Batch\Test4.csv'   
	execute utility.Add_Batch 1
	
/*ASSERT*/
  -- evaluate if utility.Batch contains 11 rows
	set @rowCount_Batch= (select count(*) from utility.Batch )
    EXEC tSQLt.AssertEqualsString 11, @rowCount_Batch;  

end 

 -- exec tsqlt.Run @TestName = '[testBatch].[Test04 - Insert batch to already existing utility.Batch records]'