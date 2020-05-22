




/******
	Change log: 
		2020-04-24	Stored procedure created for testing the ETL targeting the Fact_Route table


	Test06 - Insert route info for different destinations of the same vessel, coming in the different batches
	  	     The test performs the ETL targeting Fact_route, as well as other dependent stored procedures. 
			 The source files contains updates regarding the destination attribute targeting similar vessel coming in different batches. More other updates follow, providing info concerning the route details of each specific destinations.
			 The test verifies if the Fact_Route is cross-refferencing the correct Dim_voyage record,by assessing if the expected values match the actual Fact_Route
			 
			 
*/

CREATE PROCEDURE [testFactRoute].[Test06 - Insert route info for different destinations of the same vessel, coming in the different batches]
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
	-- run ETL 3 times, simulating 3 loads
	execute [etl].Run_ETL 1,'C:\AIS\Tests\test_FactRoute\Test6_01.csv'
	execute [etl].Run_ETL 1,'C:\AIS\Tests\test_FactRoute\Test6_02.csv'
    execute [etl].Run_ETL 1,'C:\AIS\Tests\test_FactRoute\Test6_03.csv'

	
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

    insert into expected values ( 1, 20200508, 111129, -1,-1,-1, 1, null,null,null,null,null,null,null, 4.70, 1)
	insert into expected values ( 1, 20200508, 111230, 58328080, 11133830, 0, 1, 0, 0.50, 330.00, 285, 1, 0, 0, null,1)
	insert into expected values ( 1, 20200508, 111331, 58338080, 11134830, 15, 1, -127, 0.56, 114.00, 100, 1,0,0, null, 1)
	insert into expected values ( 1, 20200508, 111429, -1,-1,-1, 2, null,null,null,null,null,null,null, 4.70, 2)
	insert into expected values ( 1, 20200508, 111433, 58329080, 11135830, -1, 2, null, 0.64, 15.10, 511, 0, null, 0, null, 2)	
	insert into expected values ( 1, 20200508, 111530, 58328080, 11133830, 0, 2, 0, 0.60, 330.00, 285, 1, 0, 0, null,3)
	insert into expected values ( 1, 20200508, 111531, 58338080, 11134830, 15, 2, -127, 0.66, 114.00, 100, 1, 0, 0, null,3)

	-- set rowCount 
	set @rowCount= (select count(*) from edw.Fact_Route )


/*ASSERT*/ 
	 -- evaluate expected rowCount 
	EXEC tSQLt.AssertEqualsString 7, @rowCount; 

  -- evaluate if the expected table matches the actual table
	 EXEC tSQLt.AssertEqualsTable 'expected', 'edw.Fact_Route';


end 

   --exec tsqlt.Run @TestName = '[testFactRoute].[Test06 - Insert route info for different destinations of the same vessel, coming in the different batches]'