



/******
	Change log: 
		2020-04-10	Stored procedure created for testing stored procedures targetting Dim_Voyage

	Test11 - Insert vessel with two destination in same batch
		     The test performs the ETL targeting Dim_Voyage as well as other dependent stored procedures. 
			 The source file contains information regarding a specific vessel whose destination details update in the same batch.
			 The test verifies if two records exits for the same vessel. The validity of the two records is verifyed by checking the Is_Current attribute. 
		
	CSV content:
			~MMSI|AIS Message Type|Longitude|Latitude|MID Number|MID|Navigation Status|Rate of Turn (ROT)|Speed Over Ground (SOG)|Position Accuracy|Course Over Ground (COG)|True Heading (HDG)|Manoeuvre Indicator|RAIM Flag|Repeat Indicator|Received Time UTC-Unix|Vessel Name|IMO Number|Call Sign|Ship Type|Dimension to Bow|Dimension to Stern|Length|Dimension to Port|Dimension to Starboard|Beam|Position Type Fix|ETA month|ETA day|ETA hour|ETA minute|Draught|Destination
			370424000|5|7.625225|56.562680|370|Panama (Republic of)|0|-11|12,3|1|209,7|209|0|0|0|08-05-2020 10:11:05|ANTIGUA|9783071|SMPA@@@|69|54|146|200|17|15|32|15|2|2|2|2|6,5|Aarhus
			370424000|5|7.625225|56.562680|370|Panama (Republic of)|0|-11|12,3|1|209,7|209|0|0|0|08-05-2020 10:11:06|ANTIGUA|9783071|SMPA@@@|69|54|146|200|17|15|32|15||2|2||6,5|Aarhus
			370424000|5|7.625225|56.562680|370|Panama (Republic of)|0|-11|12,3|1|209,7|209|0|0|0|08-05-2020 10:11:07|ANTIGUA|9783071|SMPA@@@|69|54|146|200|17|15|32|15|3|3|3|3|6,5|LANDSKRONA@@@@@@@@@@
			370424000|5|7.625225|56.562680|370|Panama (Republic of)|0|-11|12,3|1|209,7|209|0|0|0|08-05-2020 10:11:08|ANTIGUA|9783071|SMPA@@@|69|54|146|200|17|15|32|15|3|3|3||6,5|LANDSKRONA@@@@@@@@@@
*/

CREATE   PROCEDURE [testDimVoyage].[Test11 - Insert vessel with two destinations in same batch]
AS
BEGIN
/*ARRANGE*/ 
  DECLARE @rowCount_DimVoyage int;
  DECLARE @oldRec_IsCurrent int, @newRec_IsCurrent int;

  IF OBJECT_ID('expected') IS NOT NULL DROP TABLE expected;
 
  -- truncate tables to have accurate test results 
	truncate table edw.Dim_Vessel
	truncate table edw.Dim_Voyage
	truncate table archive.AIS_Data_archive
	truncate table extract.AIS_Data
	truncate table utility.Batch

/*ACT*/
	-- ETL for Dim_Vessel to insert the following CSV. file records, consisting of 1 record in Dim_Vessel
	execute [extract].[AIS_Data_CSV]'C:\AIS\Tests\test_DimVoyage\Test11.csv'
	execute [archive].[AIS_Data_AddToArchive]
	execute [load].[Dim_Vessel_L]	
	execute [load].[Dim_Voyage_L]
	execute utility.Add_Batch 1

	-- set rowCount for Dim_Voyage
	set @rowCount_DimVoyage= (select count(*) from edw.Dim_Voyage )

/*ASSERT*/ 
	 -- evaluate expected rowCount for Dim_Voyage
	EXEC tSQLt.AssertEqualsString 2, @rowCount_DimVoyage; 

	set @oldRec_IsCurrent = (select Is_Current from edw.Dim_Voyage where Update_Timestamp = '2020-05-08 10:11:06.0000000')
	EXEC tSQLt.AssertEqualsString 0, @oldRec_IsCurrent; 

	set @newRec_IsCurrent = (select Is_Current from edw.Dim_Voyage where Update_Timestamp = '2020-05-08 10:11:08.0000000')
	EXEC tSQLt.AssertEqualsString 1, @newRec_IsCurrent; 

end 

   --exec tsqlt.Run @TestName = '[testDimVoyage].[Test11 - Insert vessel with two destinations in same batch]'