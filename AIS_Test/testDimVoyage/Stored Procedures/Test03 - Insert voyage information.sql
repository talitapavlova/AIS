﻿
/******
	Change log: 
		2020-04-10	Stored procedure created for testing stored procedures targetting Dim_Voyage

	 Test03 - Insert voyage information
		     The test performs the ETL targeting Dim_Voyage as well as other dependent stored procedures. 
			 The source file contains information regarding all the fields related to voyage information.
			 The test verifies that a record had been inserted in Dim_voyage once the ETL is executed, as well as checks for the expected values.
			 
	CSV content:
			~MMSI|AIS Message Type|Longitude|Latitude|MID Number|MID|Navigation Status|Rate of Turn (ROT)|Speed Over Ground (SOG)|Position Accuracy|Course Over Ground (COG)|True Heading (HDG)|Manoeuvre Indicator|RAIM Flag|Repeat Indicator|Received Time UTC-Unix|Vessel Name|IMO Number|Call Sign|Ship Type|Dimension to Bow|Dimension to Stern|Length|Dimension to Port|Dimension to Starboard|Beam|Position Type Fix|ETA month|ETA day|ETA hour|ETA minute|Draught|Destination
			370424000|5|7.625225|56.562680|370|Panama (Republic of)|0|-11|12,3|1|209,7|209|0|0|0|08-05-2020 11:11:05|ANTIGUA|9783071|SMPA@@@|69|54|146|200|17|15|32|15|04|28|17|00|6,5|LANDSKRONA@@@@@@@@@@
******/

CREATE   PROCEDURE [testDimVoyage].[Test03 - Insert voyage information]
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
	execute [extract].[AIS_Data_CSV]'C:\AIS\Tests\test_DimVoyage\Test3.csv'
	execute [archive].[AIS_Data_AddToArchive]
	execute [load].[Dim_Vessel_L]	
	execute [load].[Dim_Voyage_L]
	execute utility.Add_Batch 1


	create table expected (
	[Voyage_Key] [int] NOT NULL,
	[MMSI] [char](9) NOT NULL,
	[Start_Timestamp] [datetime2](7) NULL,
	[Update_Timestamp] [datetime2](7) NULL,
	[ETA_month] [int] NULL,
	[ETA_day] [int] NULL,
	[ETA_hour] [int] NULL,
	[ETA_minute] [int] NULL,
	[Destination] [nvarchar](2000) NULL,
	[Batch_Created] [int] NULL,
	[Batch_Updated] [int] NULL,
	[Is_Current] [int] NULL,
  )

    insert into expected values ( 1, '370424000', '2020-05-08 11:11:05.0000000', '2020-05-08 11:11:05.0000000', 4, 28, 17, 0, 'LANDSKRONA' , 1, 1, 1)

	-- set rowCount for Dim_Voyage
	set @rowCount_DimVoyage= (select count(*) from edw.Dim_Voyage )


/*ASSERT*/ 
	 -- evaluate expected rowCount for Dim_Voyage
	EXEC tSQLt.AssertEqualsString 1, @rowCount_DimVoyage; 

  -- evaluate if the expected table matches the actual table
	 EXEC tSQLt.AssertEqualsTable 'expected', 'edw.Dim_Voyage';
 
end 

   --exec tsqlt.Run @TestName = '[testDimVoyage].[Test03 - Insert voyage information]'