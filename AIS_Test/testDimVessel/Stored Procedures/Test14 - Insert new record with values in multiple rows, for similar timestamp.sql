
/******
	Change log: 
		2020-04-10	Stored procedure created for testing the effect of the stored procedures utility.Add_Batch on Dim_Vessel. 
	
	Test Description:
		Test14 - Insert new record with values in multiple rows, for similar timestamp 
			The following test execute the ETL process using a csv. file containg several rows for the same MMSI, each holding different updates for SIMILAR timestamp.
			The test verifies if Dim_Vessel contains only a record after the execution of the procedure.

	Set-up:
		Dim_Vessel prepopulated with the following records:
			-no content
			
		utility.Batch prepopulated with the following record:
			-no content

		CSV content:
			~MMSI|AIS Message Type|Longitude|Latitude|MID Number|MID|Navigation Status|Rate of Turn (ROT)|Speed Over Ground (SOG)|Position Accuracy|Course Over Ground (COG)|True Heading (HDG)|Manoeuvre Indicator|RAIM Flag|Repeat Indicator|Received Time UTC-Unix|Vessel Name|IMO Number|Call Sign|Ship Type|Dimension to Bow|Dimension to Stern|Length|Dimension to Port|Dimension to Starboard|Beam|Position Type Fix|ETA month|ETA day|ETA hour|ETA minute|Draught|Destination
			219013485|5|||311|Bahamas (Commonwealth of the)|||||||||0|26-03-2020 16:50:32|SKANDI CONSTRUCTOR||||||||||||||||
			219013485|5|||311|Bahamas (Commonwealth of the)|||||||||0|26-03-2020 16:50:32|SKANDI CONSTRUCTOR|9431642|3|70|||||||||||34|5,5|ODENSE 		
			219013485|5|||311|Bahamas (Commonwealth of the)|||||||||0|26-03-2020 16:50:32|SKANDI CONSTRUCTOR|9431642|3|70|42|78|120|13|11|24|1|03|21|12|34|5,5|ODENSE 

*/
CREATE PROCEDURE [testDimVessel].[Test14 - Insert new record with values in multiple rows, for similar timestamp]
AS
BEGIN

/*ARRANGE*/ 
	DECLARE @rowCount_Dim_Vessel int
	DECLARE @batchCreated int, @batchUpdated int

	IF OBJECT_ID('expected') IS NOT NULL DROP TABLE expected;
 
	-- truncate tables to have accurate test results 
	 truncate table edw.Dim_Vessel
	 truncate table archive.AIS_Data_archive
	 truncate table extract.AIS_Data
	 truncate table utility.Batch

/*ACT*/
	--run relevant SPs
	execute [extract].[AIS_Data_CSV] 'C:\AIS\Tests\test_DimVessel\Test14.csv' 
	execute [archive].[AIS_Data_AddToArchive]
	execute [load].[Dim_Vessel_L]	
	execute utility.Add_Batch 1
	truncate table extract.AIS_Data

/*ASSERT*/
	set @rowCount_Dim_Vessel= (select count(*) from edw.Dim_Vessel where MMSI = '219013485')
   	-- evaluate if Dim_vessel only contains a records 
	EXEC tSQLt.AssertEqualsString 1, @rowCount_Dim_Vessel; 

 
end 
 -- exec tsqlt.Run @TestName = '[testDimVessel].[Test14 - Insert new record with values in multiple rows, for similar timestamp]'