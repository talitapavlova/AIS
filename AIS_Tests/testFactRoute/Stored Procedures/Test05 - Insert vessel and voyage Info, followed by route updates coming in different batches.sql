




/******
	Change log: 
		2020-04-10	Stored procedure created for testing stored procedures targetting Dim_Voyage

      Test05 - Insert vessel and voyage Info, followed by route updates coming in different batches
	  	     The test performs the ETL targeting Fact_route, as well as other dependent stored procedures. 
			 The source files contains updates regarding the voyage info targeting similar vessel coming in different batches.
			 The test verifies if the Fact_Route is cross-refferencing the correct vessel and voyage dimensions, by assessing if the expected values match the actual Fact_Route
			 
*/

CREATE   PROCEDURE [testFactRoute].[Test05 - Insert vessel and voyage Info, followed by route updates coming in different batches]
AS
BEGIN
/*ARRANGE*/ 
  DECLARE @rowCount int

  IF OBJECT_ID('expected') IS NOT NULL DROP TABLE expected;
 
  -- truncate tables to have accurate test results 
	truncate table edw.Dim_Vessel
	truncate table edw.Dim_Voyage
	truncate table edw.Fact_Route
	truncate table archive.AIS_Data_archive
	truncate table extract.AIS_Data
	truncate table utility.Batch

/*ACT*/
	-- ETL executed 3 times, simulating 3 loads
	execute [etl].Run_ETL 1, 'C:\AIS\Tests\test_FactRoute\Test5_01.csv'	
	execute [etl].Run_ETL 1,'C:\AIS\Tests\test_FactRoute\Test5_02.csv'
	execute [etl].Run_ETL 1, 'C:\AIS\Tests\test_FactRoute\Test5_03.csv'

	create table expected (
	[Vessel_Key] [int] NOT NULL,
	[Date_Key] [int] NOT NULL,
	[Time_Key] [int] NOT NULL,
	[Latitude_Key] [int] NOT NULL,
	[Longitude_Key] [int] NOT NULL,
	[Navigation_Status_Key] [int] NOT NULL,
	[Voyage_Key] [int] NOT NULL,
	[Rate_Of_Turn_ROT] [int] NULL,
	[Speed_Over_Ground_SOG] [decimal](10, 2) NULL,
	[Course_Over_Ground_COG] [decimal](10, 2) NULL,
	[True_Heading_HDG] [int] NULL,
	[Position_Accuracy] [tinyint] NULL,
	[Manoeuvre_Indicator] [tinyint] NULL,
	[RAIM_Flag] [tinyint] NULL,
	[Draught] [decimal](6, 2) NULL,
	[Batch] [int] NULL
  )

    insert into expected values ( 1, 20200508, 111129, -1,-1,-1,1, null,null,null,null,null,null,null, 4.70, 1)
	insert into expected values ( 1, 20200508, 111130, 58328081, 11133830, 0, 1, 0, 0.51, 330.00, 285, 1, 0, 0, null,2)
	insert into expected values ( 1, 20200508, 111230, 58328071, 11133890, 0, 1, 0, 0.50, 336.00, 285, 1, 0, 0, null,2)	
	insert into expected values ( 1, 20200508, 111231, 58328082, 11133930, 2, 1, 22, 0.53, 335.00, 286, 1, 0, 0, null,3)
	insert into expected values ( 1, 20200508, 111331, 58328023, 11133950, 2, 1, 22, 0.54, 332.00, 287, 1, 0, 0, null,3)
	insert into expected values ( 1, 20200508, 111431, 58328032, 11133932, 2, 1, 22, 0.52, 333.00, 283, 1, 0, 0, null,3)
	insert into expected values ( 1, 20200508, 111531, 58328023, 11133952, 2, 1, 22, 0.50, 322.00, 283, 1, 0, 0, null,3)
	-- set rowCount for Dim_Voyage
	set @rowCount= (select count(*) from edw.Fact_Route )


/*ASSERT*/ 
	 -- evaluate expected rowCount 
	EXEC tSQLt.AssertEqualsString 7, @rowCount; 

  -- evaluate if the expected table matches the actual table
	 EXEC tSQLt.AssertEqualsTable 'expected', 'edw.Fact_Route';


end 

   --exec tsqlt.Run @TestName = '[testFactRoute].[Test05 - Insert vessel and voyage Info, followed by route updates coming in different batches]'