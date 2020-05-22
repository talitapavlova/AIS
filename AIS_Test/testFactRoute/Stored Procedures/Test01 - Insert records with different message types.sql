

/******
	Change log: 
		2020-04-24	Stored procedure created for testing the ETL targeting the Fact_Route table

	Test01 - Insert records with different message types
			 The source file contains messages of various types, where:
			 -> message type 24 - provides static info regarding Vessel
			 -> message type 5 - provides static info on Vessel and semi-dinamic info regarding Voyage
			 -> message types (1,3,18) - providing dynamic info about the route of a vessel. 
			
			 The test verifies if the Fact_Route loads all types of messages by assessing the number of rows after executying the ETL*/

CREATE PROCEDURE [testFactRoute].[Test01 - Insert records with different message types]
AS
BEGIN
/*ARRANGE*/ 
  DECLARE @rowCount int;

  IF OBJECT_ID('expected') IS NOT NULL DROP TABLE expected;
 
   --truncate tables to have accurate test results 
	truncate table edw.Dim_Vessel
	truncate table edw.Dim_Voyage
	truncate table edw.Fact_Route
	truncate table archive.AIS_Data_archive
	truncate table extract.AIS_Data
	truncate table utility.Batch

/*ACT*/
	-- ETL for Dim_Vessel to insert the following CSV. file records, consisting of 1 record in Dim_Vessel
	execute [etl].Run_ETL 1, 'C:\AIS\Tests\test_FactRoute\Test1.csv'
	
    -- set total_rowCount 
	set @rowCount= (select count(*) from edw.Fact_Route )


/*ASSERT*/ 
	 -- evaluate expected rowCount for Dim_Voyage
	EXEC tSQLt.AssertEqualsString 6,@rowCount; 


end 

   --exec tsqlt.Run @TestName = '[testFactRoute].[Test01 - Insert records with different message types]'