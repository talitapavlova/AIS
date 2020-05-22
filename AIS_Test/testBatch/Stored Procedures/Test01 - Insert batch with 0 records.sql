
/* Change log: 
		2020-04-13	Stored procedure created for testing stored procedures targetting utility.Batch

	Test Description:
		The test performs the stored procedure targeting utility.Batch table. However, since the SP is dependent on the extract_AIS_Data_CSV this is also oincluded.
		The test is executed in a scenario where the source file contains 0 records.   
		The test verifies if the utility.Batch table holds 0 records.

*/

CREATE PROCEDURE [testBatch].[Test01 - Insert batch with 0 records]
AS
BEGIN

/*ARRANGE*/

  DECLARE @rowCount int

  -- truncate tables to have accurate test results 
  truncate table edw.Dim_Vessel
  truncate table archive.AIS_Data_archive
  truncate table extract.AIS_Data
  truncate table utility.Batch

/*ACT*/
  --execute ETL's stored procedures
	execute [extract].[AIS_Data_CSV] 'C:\AIS\Tests\test_Batch\Test1.csv'   
	execute utility.Add_Batch 1

/*ASSERT*/  
   set @rowCount= (select count(*) from utility.Batch )
   -- evaluate the actual table (Dim_Vessel) using rowCount for Dim_Vessel
   EXEC tSQLt.AssertEqualsString 0, @rowCount;  

end 

 -- exec tsqlt.Run @TestName = '[testBatch].[Test01 - Insert batch with 0 records]'