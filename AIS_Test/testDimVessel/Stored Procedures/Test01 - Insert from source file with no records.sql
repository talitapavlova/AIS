


/*
    Change log: 
	2020-03-25	Stored procedure created for testing stored procedures targeting Dim_Vessel
	

	Test Description:
		Test01 - Insert from source file with no records
			The test perfoms the SPs targeting Dim_Vessel one time, where the source file contains no record. 
			The test verifies the exepected result by assesing the number of rows in Dim_Vessel after the ETL process had been executed 

	Set-up:
		- Dim_Vessel
			- no content
		- CSV content:
			- no content


*/

CREATE PROCEDURE [testDimVessel].[Test01 - Insert from source file with no records]
AS
BEGIN

--ARRANGE 
    DECLARE @rowCount_Dim_Vessel int
  
    IF OBJECT_ID('expected') IS NOT NULL DROP TABLE expected;

    -- truncate tables to have accurate test results 
    truncate table edw.Dim_Vessel
	truncate table archive.AIS_Data_archive
    truncate table extract.AIS_data

--ACT
	-- run SP for Dim_Vessel, including SPs in relationship of dependency to it
	execute [extract].[AIS_Data_CSV] 'C:\AIS\Tests\test_DimVessel\Test1.csv'
	execute [archive].[AIS_Data_AddToArchive]
	execute [load].[Dim_Vessel_L]
 

--ASSERT	
   -- set rowCount for Dim_Vessel
	 set @rowCount_Dim_Vessel= (select count(*) from edw.Dim_Vessel )
   -- evaluate if expected rowCount for Dim_Vessel is 0
	 EXEC tSQLt.AssertEqualsString 0, @rowCount_Dim_Vessel;  

 
end 
--exec tsqlt.Run @TestName = '[testDimVessel].[Test01 - Insert from .csv containing 0 records]'