



/******
	Change log: 
		2020-05-21	Stored procedure created for testing the ETL status comprised in the utility.Event_Log table

	Test01 - Successful ETL
			 The source file contains 20 records. The test verifies if the ETL is successful by evaluating the fields of the table.*/

CREATE PROCEDURE [testEventLog].[Test01 - Successful ETL]
AS
BEGIN
/*ARRANGE*/ 
  DECLARE @rowCount int;
  DECLARE @batch int, @severity int, @message varchar(200), @messageType varchar(100);

  IF OBJECT_ID('expected') IS NOT NULL DROP TABLE expected;
 
   --truncate tables to have accurate test results 
	truncate table edw.Dim_Vessel
	truncate table edw.Dim_Voyage
	truncate table edw.Fact_Route
	truncate table archive.AIS_Data_archive
	truncate table extract.AIS_Data
	truncate table utility.Batch
	truncate table utility.Event_Log
	
/*ACT*/
	-- ETL for Dim_Vessel to insert the following CSV. file records, consisting of 1 record in Dim_Vessel
	execute [etl].Run_ETL 1, 'C:\AIS\Tests\test_ErrorLog\Test1.csv'
	
/*ASSERT*/ 
	-- set rowCount for Dim_Voyage
	set @rowCount= (select count(*) from utility.Event_Log )

	 -- evaluate expected rowCount 
	EXEC tSQLt.AssertEqualsString 1, @rowCount; 

	--evaluate Batch attribute
	set @batch = ( select Batch from utility.Event_Log) 
	EXEC tSQLt.AssertEqualsString 1 , @batch;  

	--evaluate Severity attribute
	set @severity = (select Severity from utility.Event_Log) 
	EXEC tSQLt.AssertEqualsString 0, @severity;  

    --evaluate Message attribute
	set @message = (select Message from utility.Event_Log) 
	EXEC tSQLt.AssertEqualsString 'Batch load succeeded', @message;  

	 --evaluate Message_type attribute
	set @messageType = (select Message_type from utility.Event_Log) 
	EXEC tSQLt.AssertEqualsString 'success', @messageType;  

end 

   --exec tsqlt.Run @TestName = '[testEventLog].[Test01 - Successful ETL]'