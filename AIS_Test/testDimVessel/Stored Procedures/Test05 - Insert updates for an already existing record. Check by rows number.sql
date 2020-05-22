


/******
	Change log: 
		2020-03-25	Stored procedure created for testing stored procedures targeting Dim_Vessel


	Test Description:
		Test05 - Insert updates for an already existing record. Check by rows number
			The test performs the ETL targeting Dim_Vessel, where the source file contains a record having updated values for a record that already exists in Dim_Vessel. 
			The test verifies the number of rows in Dim_Vessel after the SPs involved had been executed.
	Set-up:
		Dim_Vessel prepopulated with the following records:
			Vessel_Key | MMSI |	IMO | Call_Sign | Ship_type | Ship_type_Description | MID | MID_Number | Dim_To_Bow | Dim_To_Stern | Length | Dim_to_Port | Dim_To_Starboard | Beam | Pos_type_fix | BatchCreated | BatchUpdated | Valid_From | Valid_To
			1	219013485	TOVE KAJGAARD	NULL	NULL	NULL	-1	Denmark	219	NULL	NULL	NULL	NULL	NULL	NULL	NULL	1	NULL	2020-03-26 16:55:41.0000000	9999-12-31 00:00:00.0000000

		- CSV content:
			~MMSI|AIS Message Type|Longitude|Latitude|MID Number|MID|Navigation Status|Rate of Turn (ROT)|Speed Over Ground (SOG)|Position Accuracy|Course Over Ground (COG)|True Heading (HDG)|Manoeuvre Indicator|RAIM Flag|Repeat Indicator|Received Time UTC-Unix|Vessel Name|IMO Number|Call Sign|Ship Type|Dimension to Bow|Dimension to Stern|Length|Dimension to Port|Dimension to Starboard|Beam|Position Type Fix|ETA month|ETA day|ETA hour|ETA minute|Draught|Destination
			219013485|5|||311|Bahamas (Commonwealth of the)|||||||||0|26-03-2020 16:55:41|SKANDI CONSTRUCTOR|9431642|C6ZH8  |70|42|78|120|13|11|24|1|03|21|12|34|5,5|ODENSE 
*/

CREATE PROCEDURE [testDimVessel].[Test05 - Insert updates for an already existing record. Check by rows number]
AS
BEGIN
 DECLARE @rowCount_Dim_Vessel int
 
/*ARRANGE*/

   IF OBJECT_ID('expected') IS NOT NULL DROP TABLE expected;
 
  -- truncate tables to have accurate test results 
  truncate table edw.Dim_Vessel
  truncate table archive.AIS_Data_archive
  truncate table extract.AIS_Data
  truncate table utility.Batch

  --Prepare Dim_Vessel to be pre-populated with the record, simulating a previous ETL execution
	insert into edw.Dim_Vessel 
	values ('219013485','TOVE KAJGAARD',null, null, null, -1, 'Denmark',	219, null,null,null,null,null,null,null, 1, NULL,  '2020-03-26 16:55:41.0000000',	'9999-12-31 00:00:00.0000000')
	
 /*ACT*/

	-- run SPs targeting Dim_Vessel 
	execute [extract].[AIS_Data_CSV]'C:\AIS\Tests\test_DimVessel\Test5.csv'
	execute [archive].[AIS_Data_AddToArchive]
	execute [load].[Dim_Vessel_L]
	
  -- set rowCount for Dim_Vessel
 	set @rowCount_Dim_Vessel= (select count(*) from edw.Dim_Vessel )
 
 /*ASSEERT*/

 -- evaluate if expected rowCount for Dim_Vessel is 2
	EXEC tSQLt.AssertEqualsString 2, @rowCount_Dim_Vessel;  
 
end 

 -- exec tsqlt.Run @TestName = '[testDimVessel].[Test05 - Insert one already existing record containg updates. Check by rows number]'