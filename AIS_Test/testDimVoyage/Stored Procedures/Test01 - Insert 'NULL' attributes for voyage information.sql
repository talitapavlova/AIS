


/****
	Change log: 
		2020-04-10	Stored procedure created for testing stored procedures targetting Dim_Voyage

	Test Description:
		[Test01 - Insert 'NULL' voyage information]
		     The test performs the ETL targeting Dim_Voyage as well as other dependent stored procedures. 
			 The source file contains no information regarding the voyage information of a vessel (Specifically, source data contains message of type 24 with Null fields for ETAs and Destination fields).
			 The test verifies that no records had been inserted in Dim_voyage once the ETL is executed
	CSV content
		~MMSI|AIS Message Type|Longitude|Latitude|MID Number|MID|Navigation Status|Rate of Turn (ROT)|Speed Over Ground (SOG)|Position Accuracy|Course Over Ground (COG)|True Heading (HDG)|Manoeuvre Indicator|RAIM Flag|Repeat Indicator|Received Time UTC-Unix|Vessel Name|IMO Number|Call Sign|Ship Type|Dimension to Bow|Dimension to Stern|Length|Dimension to Port|Dimension to Starboard|Beam|Position Type Fix|ETA month|ETA day|ETA hour|ETA minute|Draught|Destination
		370424000|24|7.625225|56.562680|370|Panama (Republic of)|0|-11|12,3|1|209,7|209|0|0|0|08-05-2020 11:11:05|ANTIGUA||||||||||||||||
		
*/

CREATE PROCEDURE [testDimVoyage].[Test01 - Insert 'NULL' attributes for voyage information]
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
	-- run relevant SPs 
	execute [extract].[AIS_Data_CSV]'C:\AIS\Tests\test_DimVoyage\Test1.csv'
	execute [archive].[AIS_Data_AddToArchive]
	execute [load].[Dim_Vessel_L]	
	execute [load].[Dim_Voyage_L]
	execute utility.Add_Batch 1
	truncate table extract.AIS_Data

/*ASSES*/ 
	-- set rowCount for Dim_Voyage
	set @rowCount_DimVoyage= (select count(*) from edw.Dim_Voyage )
    -- evaluate expected rowCount for Dim_Voyage
	EXEC tSQLt.AssertEqualsString 0, @rowCount_DimVoyage; 
end 

   --exec tsqlt.Run @TestName = '[testDimVoyage].[Test01 - Insert 'NULL' attributes for voyage information]'