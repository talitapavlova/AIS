

/****** Test1 - Insert from .csv containing 0 records */
------Assemble
-------Act
-------Assert ...
-------Assert...

CREATE   PROCEDURE [testDimVessel].[Test1 - Insert from .csv containing 0 records]
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
	
	/*   
		CSV content:
		
		MMSI	|	AIS Message Type	|	Longitude	|	Latitude	|	MID Number	|	MID	|	Navigation Status	|	Rate of Turn (ROT)	|	Speed Over Ground (SOG)	|	Position Accuracy	|	Course Over Ground (COG)	|	True Heading (HDG)	|	Manoeuvre Indicator	|	RAIM Flag	|	Repeat Indicator	|	Received Time UTC-Unix	|	Vessel Name	|	IMO Number	|	Call Sign	|	Ship Type	|	Dimension to Bow	|	Dimension to Stern	|	Length	|	Dimension to Port	|	Dimension to Starboard	|	Beam	|	Position Type Fix	|	ETA month	|	ETA day	|	ETA hour	|	ETA minute	|	Draught	|	Destination
		(no content)
	
	*/

 
 -- set rowCount for Dim_Vessel
 set @rowCount_Dim_Vessel= (select count(*) from edw.Dim_Vessel )
 
 -- evaluate if expected rowCount for Dim_Vessel is 2
 EXEC tSQLt.AssertEqualsString 0, @rowCount_Dim_Vessel;  
 
end 

   --exec tsqlt.Run @TestName = '[test].[Test1 - Insert from .csv containing 0 records]'