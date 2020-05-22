




/******
	Change log: 
		2020-05-21	Stored procedure created for testing the ETL status comprised in the utility.Event_Log table

	Test02 - Unsuccessful ETL
			 The source file contains 1000 records. However, data types from the source file do not match the target type.
			 The test verifies if the ETL has corresponding unsuccessful statsus by evaluating the fields in the Event_Log table. 
			 Moreevr, it ensures that no database objects are populated*/

CREATE PROCEDURE [testEventLog].[Test02 - Unsuccessful ETL]
AS
BEGIN 

/*ARRANGE*/ 
  DECLARE @rowCountDimVessel int, @rowCountDimVoyage int, @rowCountFactRoute int, @rowCountBatch int, @rowCountEvent int;
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
	 
/*ACT and ASSERT for better visualization*/
	
	-- ETL for Dim_Vessel to insert the following CSV. file records, consisting of 1 record in Dim_Vessel
	execute etl.Run_ETL 1, 'C:\AIS\Tests\test_ErrorLog\Test2.csv'

	--evaluate Batch attribute
	set @batch = ( select Batch from utility.Event_Log) 
	EXEC tSQLt.AssertEqualsString 1 , @batch;  

	--evaluate Severity attribute
	set @severity = (select Severity from utility.Event_Log) 
	EXEC tSQLt.AssertEqualsString 16, @severity;  

    --evaluate Message attribute
	set @message = (select Message from utility.Event_Log) 
	EXEC tSQLt.AssertEqualsString 'String or binary data would be truncated in table ''AIS_Test.extract.AIS_Data'', column ''MMSI''. Truncated value: ''2*****654''.', @message;  

	 --evaluate Message_type attribute
	set @messageType = (select Message_type from utility.Event_Log) 
	EXEC tSQLt.AssertEqualsString 'error', @messageType;  
		
	-- evaluate expected rowCount for all the database objects. Expected none of them to be populated
	set @rowCountBatch = (select count(*) from utility.Batch)
	EXEC tSQLt.AssertEqualsString 0, @rowCountBatch;
	set @rowCountDimVoyage = (select count(*) from edw.Dim_Voyage)
	EXEC tSQLt.AssertEqualsString 0, @rowCountDimVoyage;
	set @rowCountDimVessel = (select count(*) from edw.Dim_Vessel)
	EXEC tSQLt.AssertEqualsString 0, @rowCountDimVessel;
	set @rowCountFactRoute = (select count(*) from edw.Fact_Route)
	EXEC tSQLt.AssertEqualsString 0, @rowCountFactRoute;
	set @rowCountEvent = (select count(*) from utility.Event_Log)
	EXEC tSQLt.AssertEqualsString 1, @rowCountEvent;

 
end 

   --exec tsqlt.Run @TestName = '[testEventLog].[Test02 - Unsuccessful ETL]'