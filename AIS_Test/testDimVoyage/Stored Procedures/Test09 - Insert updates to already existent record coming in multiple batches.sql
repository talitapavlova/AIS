

/******
	Change log: 
		2020-04-10	Stored procedure created for testing stored procedures targetting Dim_Voyage

	Test09 - Insert updates to already existent record coming in mutliple batches.
		     The test performs the ETL targeting Dim_Voyage as well as other dependent stored procedures. 
			 The source file contains updates regarding voyage information of already existent record, coming in several batches, on consecutive timestamps
			 The test verifies if the Voyage record is updated with the correct information. 
			 
*/

CREATE PROCEDURE [testDimVoyage].[Test09 - Insert updates to already existent record coming in multiple batches]
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
	values ( '370424000', '2020-03-26 16:55:41.0000000', '2020-03-26 16:55:41.0000000', null, null, null, 1, 'Aarhus' , 1, 1, 1)

/*ACT*/
	-- ETL for Dim_Vessel to insert the following CSV. file records, consisting of 1 record in Dim_Vessel
	execute [extract].[AIS_Data_CSV]'C:\AIS\Tests\test_DimVoyage\Test8_01.csv'
	execute [archive].[AIS_Data_AddToArchive]
	execute [load].[Dim_Vessel_L]	
	execute [load].[Dim_Voyage_L]
	execute utility.Add_Batch 1
	truncate table extract.AIS_Data

    execute [extract].[AIS_Data_CSV]'C:\AIS\Tests\test_DimVoyage\Test8_02.csv'
	execute [archive].[AIS_Data_AddToArchive]
	execute [load].[Dim_Vessel_L]	
	execute [load].[Dim_Voyage_L]
	execute utility.Add_Batch 1
	truncate table extract.AIS_Data

    execute [extract].[AIS_Data_CSV]'C:\AIS\Tests\test_DimVoyage\Test8_03.csv'
	execute [archive].[AIS_Data_AddToArchive]
	execute [load].[Dim_Vessel_L]	
	execute [load].[Dim_Voyage_L]
	execute utility.Add_Batch 1
	truncate table extract.AIS_Data

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

    insert into expected values ( 1, '370424000', '2020-03-26 16:55:41.0000000', '2020-05-08 10:13:07.0000000', 3, 3, 3 , 3, 'Aarhus' , 1, 4, 1)

	-- set rowCount for Dim_Voyage
	set @rowCount_DimVoyage= (select count(*) from edw.Dim_Voyage )


/*ASSERT*/ 

  -- evaluate if the expected table matches the actual table
	 EXEC tSQLt.AssertEqualsTable 'expected', 'edw.Dim_Voyage';
 
end 

   --exec tsqlt.Run @TestName = '[testDimVoyage].[Test09 - Insert updates to already existent record coming in multiple batches]'