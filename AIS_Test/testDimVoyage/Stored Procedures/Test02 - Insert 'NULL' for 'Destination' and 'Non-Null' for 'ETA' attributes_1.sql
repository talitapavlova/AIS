

/******
	Change log: 
		2020-04-10	Stored procedure created for testing stored procedures targetting Dim_Voyage

	[Test02 - Insert 'NULL' for 'Destination' and 'Non-Null' for ETA attributes]
		     The test performs the ETL targeting Dim_Voyage as well as other dependent stored procedures. 
			 The source file contains no information regarding the destination atribute of a vessel(Null field), although information on the differet ETA attributes is provided.
			 The test verifies that no records had been inserted in Dim_voyage once the ETL is executed
	
	CSV content
		~MMSI|AIS Message Type|Longitude|Latitude|MID Number|MID|Navigation Status|Rate of Turn (ROT)|Speed Over Ground (SOG)|Position Accuracy|Course Over Ground (COG)|True Heading (HDG)|Manoeuvre Indicator|RAIM Flag|Repeat Indicator|Received Time UTC-Unix|Vessel Name|IMO Number|Call Sign|Ship Type|Dimension to Bow|Dimension to Stern|Length|Dimension to Port|Dimension to Starboard|Beam|Position Type Fix|ETA month|ETA day|ETA hour|ETA minute|Draught|Destination
		370424000|3|7.625225|56.562680|370|Panama (Republic of)|0|-11|12,3|1|209,7|209|0|0|0|08-05-2020 11:11:05|ANTIGUA||||||||||||||||
			 
*/

CREATE PROCEDURE [testDimVoyage].[Test02 - Insert 'NULL' for 'Destination' and 'Non-Null' for 'ETA' attributes]
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
	-- ETL for Dim_Vessel to insert the following CSV. file records, consisting of 10 already existing record in Dim_Vessel, where first 4 contain no updates and the next 6 contain few updates 
	execute [extract].[AIS_Data_CSV]'C:\AIS\Tests\test_DimVoyage\Test1_01.csv'
	execute [archive].[AIS_Data_AddToArchive]
	execute [load].[Dim_Vessel_L]	
	execute [load].[Dim_Voyage_L]
	execute utility.Add_Batch 1
	truncate table extract.AIS_Data

	-- set rowCount for Dim_Voyage
	set @rowCount_DimVoyage= (select count(*) from edw.Dim_Voyage )

/*ASSES*/ 
	 -- evaluate expected rowCount for Dim_Voyage
	EXEC tSQLt.AssertEqualsString 0, @rowCount_DimVoyage; 

end 

   --exec tsqlt.Run @TestName = '[testDimVoyage].[Test02 - Insert ''NULL'' for ''Destination'' and ''Non-Null'' for ''ETA'' attributes]'