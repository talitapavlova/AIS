






/****** Test00 - Insert from .csv containing 0 records */

CREATE      PROCEDURE [test].[Test00 - Insert from .csv containing 0 records]
AS
BEGIN
 
  DECLARE @rowCount_Dim_Vessel int
  
  IF OBJECT_ID('expected') IS NOT NULL DROP TABLE expected;
 
  -- truncate tables to have accurate test results 
  truncate table edw.Dim_Vessel
  truncate table dbo.AIS_Data

	-- ETL for Dim_Vessel to insert the following CSV. file records
	execute [extract].[AIS_Data_CSV]
	execute [load].[Dim_Vessel_L]
	
	/*   
		CSV content:
		- MMSI		|	Vessel Name								|		Latitude		|		Longitude		|		Speed Over Ground (SOG)		|		Course Over Ground (COG)	|		Received Time UTC		|	MID
	
		(no content)
	
	*/

 
 -- set rowCount for Dim_Vessel
 set @rowCount_Dim_Vessel= (select count(*) from edw.Dim_Vessel )
 
 -- evaluate if expected rowCount for Dim_Vessel is 2
 EXEC tSQLt.AssertEqualsString 0, @rowCount_Dim_Vessel;  
 
end 

   --exec tsqlt.Run @TestName = '[test].[Test00 - Insert from .csv containing 0 records]'