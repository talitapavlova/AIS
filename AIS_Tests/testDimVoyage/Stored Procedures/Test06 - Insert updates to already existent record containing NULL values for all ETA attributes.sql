



/******
	Change log: 
		2020-04-10	Stored procedure created for testing stored procedures targetting Dim_Voyage

	Test06 - Insert updates to already existent record containing NULL values for all ETA attributes
		     The test performs the ETL targeting Dim_Voyage as well as other dependent stored procedures. 
			 The source file contains updates regarding voyage information of already existent record. 
			 The already existent record contains only Destination information (Destination = Aarhus, while all ETA values are NULL)
			 The test verifies if the Voyage record is updated with teh correct information. 
	
	 CSV content:
			~MMSI|AIS Message Type|Longitude|Latitude|MID Number|MID|Navigation Status|Rate of Turn (ROT)|Speed Over Ground (SOG)|Position Accuracy|Course Over Ground (COG)|True Heading (HDG)|Manoeuvre Indicator|RAIM Flag|Repeat Indicator|Received Time UTC-Unix|Vessel Name|IMO Number|Call Sign|Ship Type|Dimension to Bow|Dimension to Stern|Length|Dimension to Port|Dimension to Starboard|Beam|Position Type Fix|ETA month|ETA day|ETA hour|ETA minute|Draught|Destination
			370424000|5|7.625225|56.562680|370|Panama (Republic of)|0|-11|12,3|1|209,7|209|0|0|0|08-05-2020 10:11:07|ANTIGUA|9783071|SMPA@@@|70|54|146|200|17|15|32|15|4|3|2|1|6,5|LANDSKRONA@@@@@@@@@@
*/	 


CREATE    PROCEDURE [testDimVoyage].[Test06 - Insert updates to already existent record containing NULL values for all ETA attributes]
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

   --Prepare Dim_Vessel to be pre-populated with a records, simulting a previous execution of the ETL
	insert into edw.Dim_Vessel 
	values ('370424000','ANTIGUA','9783071',	'SMPA@@@',	70,	'Cargo, all ships of this type' ,   'Panama (Republic of)',	370, 54, 146, 200,  17,15, 32, 15, 1, NULL,  '2020-03-26 16:55:41.0000000',	'9999-12-31 00:00:00.0000000')

   --Prepare utility.Batch table to be pre-populated with 1 records, simulting a previous execution of the ETL
    insert into utility.Batch
	values (1,10,1,0,'2020-03-26 16:55:41.0000000',	'2020-03-26 16:55:41.0000000', GETDATE())

   --Prepare Dim_Voyage table to be pre-populated with 1 records, simulting a previous execution of the ETL
    insert into edw.Dim_Voyage
	values ( '370424000', '2020-03-26 16:55:41.0000000', '2020-03-26 16:55:41.0000000', null, null, null, null, 'Aarhus' , 1, 1, 1)

/*ACT*/
	-- ETL for Dim_Vessel to insert the following CSV. file records, consisting of 1 record in Dim_Vessel
	execute [extract].[AIS_Data_CSV]'C:\AIS\Tests\test_DimVoyage\Test6.csv'
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

    insert into expected values ( 1, '370424000', '2020-03-26 16:55:41.0000000', '2020-05-08 10:11:07.0000000', 4, null, 2 , 1, 'Aarhus' , 1, 2, 1)

	-- set rowCount for Dim_Voyage
	set @rowCount_DimVoyage= (select count(*) from edw.Dim_Voyage )


/*ASSERT*/ 
	 -- evaluate expected rowCount for Dim_Voyage
	EXEC tSQLt.AssertEqualsString 1, @rowCount_DimVoyage; 

    -- evaluate if the expected table matches the actual table
	 EXEC tSQLt.AssertEqualsTable 'expected', 'edw.Dim_Voyage';
 
end 

   --exec tsqlt.Run @TestName = '[testDimVoyage].[Test06 - Insert updates to already existent record containing NULL values for all ETA attributes]'