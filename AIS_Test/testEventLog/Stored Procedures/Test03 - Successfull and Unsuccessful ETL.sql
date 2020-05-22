



/******
	Change log: 
		2020-05-21	Stored procedure created for testing the ETL status comprised in the utility.Event_Log table

	Successful and Unsuccessful ETL
				The test execute the ETL process 3 times. 
				Source file content  as following: 
					First src. file contains 10 valid records, second file contains 1000 records(where the last one has invalid dataypes) and the third file contains 20 valid records.
				The test verifies if the DW is populated only from the first and third file. The ETL transaction corresponding to the second  source file should fail, as the source does not match the targett data type.
			    The test evaluates the existence of DW objects by evaluating the rowcount of each table.*/

CREATE PROCEDURE [testEventLog].[Test03 - Successfull and Unsuccessful ETL]
AS
BEGIN 

/*ARRANGE*/ 
  DECLARE @rowCountDimVessel int, @rowCountDimVoyage int, @rowCountFactRoute int, @rowCountBatch int, @rowCountEvent int;
  DECLARE @rowCount_error int, @rowCount_success int

  IF OBJECT_ID('expected') IS NOT NULL DROP TABLE expected;
 
   --truncate tables to have accurate test results 
	truncate table edw.Dim_Vessel
	truncate table edw.Dim_Voyage
	truncate table edw.Fact_Route
	truncate table archive.AIS_Data_archive
	truncate table extract.AIS_Data
	truncate table utility.Batch
	truncate table utility.Event_Log
	 
/*ACT and ASSERT for better visualization*/
	
	-- ETL for Dim_Vessel to insert the following CSV. file records, consisting of 1 record in Dim_Vessel
	execute etl.Run_ETL 1, 'C:\AIS\Tests\test_ErrorLog\Test1.csv'
	execute etl.Run_ETL 2, 'C:\AIS\Tests\test_ErrorLog\Test2.csv'
	execute etl.Run_ETL 3, 'C:\AIS\Tests\test_ErrorLog\Test3.csv'

	-- evaluate expected rowCount for all the database objects. Expected none of them to be populated
	set @rowCountBatch = (select count(*) from utility.Batch)
	EXEC tSQLt.AssertEqualsString 2, @rowCountBatch;
	
	set @rowCountDimVoyage = (select count(*) from edw.Dim_Voyage)
	EXEC tSQLt.AssertEqualsString 15, @rowCountDimVoyage;
	
	set @rowCountDimVessel = (select count(*) from edw.Dim_Vessel)
	EXEC tSQLt.AssertEqualsString 10, @rowCountDimVessel;
	
	set @rowCountFactRoute = (select count(*) from edw.Fact_Route)
	EXEC tSQLt.AssertEqualsString 30, @rowCountFactRoute;
	
	set @rowCountEvent = (select count(*) from utility.Event_Log)
	EXEC tSQLt.AssertEqualsString 3, @rowCountEvent;

	--evaluate expected rowCount in Event_Log for Message_Type = 'error'
	set @rowCount_error = (select count(*) from utility.Event_Log where Message_type = 'error')
	EXEC tSQLt.AssertEqualsString 1, @rowCount_error;

	--evaluate expected rowCount in Event_Log for Message_Type = 'success'
	set @rowCount_success = (select count(*) from utility.Event_Log where Message_type = 'success')
	EXEC tSQLt.AssertEqualsString 2, @rowCount_success;

 
end 

   --exec tsqlt.Run @TestName = '[testEventLog].[Test03 - Successfull and Unsuccessful ETL]'