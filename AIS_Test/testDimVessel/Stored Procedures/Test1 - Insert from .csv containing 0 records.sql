



/*
    Change log: 
	2020-03-25	Stored procedure created for testing stored procedures targetting Dim_Vessel
	

	Test1 - Insert from .csv containing 0 records:
	The test perfoms the ETL targetting Dim_Vessel one time, where the source file contains no record. 
	The test verifies the exepected result by assesing the number of rows in Dim_Vessel afetr the ETL process had been executed 

*/

CREATE PROCEDURE [testDimVessel].[Test1 - Insert from .csv containing 0 records]
AS
BEGIN
 
  DECLARE @rowCount_Dim_Vessel int
  
    IF OBJECT_ID('expected') IS NOT NULL DROP TABLE expected;

    -- truncate tables to have accurate test results 
    truncate table edw.Dim_Vessel
    truncate table extract.AIS_data

	-- ETL for Dim_Vessel to insert the following CSV. file records
	execute [extract].[AIS_Data_CSV] 'C:\AIS\Tests\Test1.csv'
	execute [load].[Dim_Vessel_L]
 
	 -- set rowCount for Dim_Vessel
	 set @rowCount_Dim_Vessel= (select count(*) from edw.Dim_Vessel )
 
	 -- evaluate if expected rowCount for Dim_Vessel is 2
	 EXEC tSQLt.AssertEqualsString 0, @rowCount_Dim_Vessel;  
 
end 
   --exec tsqlt.Run @TestName = '[testDimVessel].[Test1 - Insert from .csv containing 0 records]'