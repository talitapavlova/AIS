


/******
	Change log: 
		2020-04-10	Stored procedure created for testing stored procedures targetting Dim_Voyage

	Test10 - Insert voyage information coming in multiple rows for similar timestamp
		     The test performs the ETL targeting Dim_Voyage as well as other dependent stored procedures. 
			 The source file contains information regarding the fields related to voyage information, coming in multiple rows for similar timestamps.
			 The test verifies that 0 record is inserted, since it can not be established which would be the correct one. 
			 (To be noted, the rule is valid when Destination information is provided for all ETA cases - recall Test04)
	
	CSV content:
			~MMSI|AIS Message Type|Longitude|Latitude|MID Number|MID|Navigation Status|Rate of Turn (ROT)|Speed Over Ground (SOG)|Position Accuracy|Course Over Ground (COG)|True Heading (HDG)|Manoeuvre Indicator|RAIM Flag|Repeat Indicator|Received Time UTC-Unix|Vessel Name|IMO Number|Call Sign|Ship Type|Dimension to Bow|Dimension to Stern|Length|Dimension to Port|Dimension to Starboard|Beam|Position Type Fix|ETA month|ETA day|ETA hour|ETA minute|Draught|Destination
			370424000|5|7.625225|56.562680|370|Panama (Republic of)|0|-11|12,3|1|209,7|209|0|0|0|08-05-2020 10:11:05|ANTIGUA|9783071|SMPA@@@|69|54|146|200|17|15|32|15|||||6,5|
			370424000|5|7.625225|56.562680|370|Panama (Republic of)|0|-11|12,3|1|209,7|209|0|0|0|08-05-2020 10:11:05|ANTIGUA|9783071|SMPA@@@|69|54|146|200|17|15|32|15||28|||6,5|LANDSKRONA@@@@@@@@@@
			370424000|5|7.625225|56.562680|370|Panama (Republic of)|0|-11|12,3|1|209,7|209|0|0|0|08-05-2020 10:11:05|ANTIGUA|9783071|SMPA@@@|69|54|146|200|17|15|32|15|04||||6,5|LANDSKRONA@@@@@@@@@@
			370424000|5|7.625225|56.562680|370|Panama (Republic of)|0|-11|12,3|1|209,7|209|0|0|0|08-05-2020 10:11:05|ANTIGUA|9783071|SMPA@@@|69|54|146|200|17|15|32|15|04|28||24|6,5|LANDSKRONA@@@@@@@@@@
*/

CREATE PROCEDURE [testDimVoyage].[Test10 - Insert voyage information coming in multiple rows for similar timestamp]
AS
BEGIN
/*ARRANGE*/ 
  DECLARE @rowCount_DimVoyage int

  IF OBJECT_ID('expected') IS NOT NULL DROP TABLE expected;
 
  -- truncate tables to have accurate test results 
	truncate table edw.Dim_Vessel
	truncate table edw.Dim_Voyage
	truncate table archive.AIS_Data_archive
	truncate table extract.AIS_Data
	truncate table utility.Batch

/*ACT*/
	-- ETL for Dim_Vessel to insert the following CSV. file records, consisting of 1 record in Dim_Vessel
	execute [extract].[AIS_Data_CSV]'C:\AIS\Tests\test_DimVoyage\Test10.csv'
	execute [archive].[AIS_Data_AddToArchive]
	execute [load].[Dim_Vessel_L]	
	execute [load].[Dim_Voyage_L]
	execute utility.Add_Batch 1

	-- set rowCount for Dim_Voyage
	set @rowCount_DimVoyage= (select count(*) from edw.Dim_Voyage )


/*ASSERT*/ 
	 -- evaluate expected rowCount for Dim_Voyage
	EXEC tSQLt.AssertEqualsString 0, @rowCount_DimVoyage; 

end 

   --exec tsqlt.Run @TestName = '[testDimVoyage].[Test10 - Insert voyage information coming in multiple rows for similar timestamp]'