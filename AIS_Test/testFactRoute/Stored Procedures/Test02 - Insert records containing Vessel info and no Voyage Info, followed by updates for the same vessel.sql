




/******
	Change log: 
			2020-04-24	Stored procedure created for testing the ETL targeting the Fact_Route table

	Test02 - Insert records containing both Vessel and Voyage Info(message type 5, 24 or 19), followed by route updates(message type 1, 3, 18).
		     The test performs the ETL targeting Fact_route, as well as other dependent stored procedures. 
			 The source file contains a message of type24 providing only Vessel information and no Voyage data. 
			 The other messages are of differnt types(3,1,18) holding dynamic information about the route of the vessel.
			 The test verifies if Fact_Route cross-references the relevant vessel but no voyage record and moreover verifies if the correct updates are inserted, 
			 by assessing if the expected values match the actual Fact_Route
			 
*/

CREATE    PROCEDURE [testFactRoute].[Test02 - Insert records containing Vessel info and no Voyage Info, followed by updates for the same vessel]
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
	-- ETL for Dim_Vessel to insert the following CSV. file records, consisting of 10 already existing record in Dim_Vessel, where first 4 contain no updates and the next 6 contain few updates 
	execute [etl].Run_ETL 1, 'C:\AIS\Tests\test_FactRoute\Test2.csv'	

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

    insert into expected values (  1, 20200508, 111114, -1,-1,-1, -1, null,null,null,null,null,null,null, null, 1)
	insert into expected values ( -1, 20200508, 111230, 58328080, 11133830, 0, -1,   0,   0.50, 330.00, 285, 1, 0, 0, null,1)
	insert into expected values ( -1, 20200508, 111331, 58338080, 11134830, 15, -1, -127, 1.70, 114.00, 100, 1,0,0, null, 1)
	insert into expected values ( -1, 20200508, 111433, 58329080, 11135830, -1, -1, null, 5.40, 15.10, 511, 0, null, 0, null, 1)
	
	-- set rowCount for Dim_Voyage
	set @rowCount= (select count(*) from edw.Fact_Route )


/*ASSERT*/ 
	 -- evaluate expected rowCount 
	EXEC tSQLt.AssertEqualsString 4, @rowCount; 

  -- evaluate if the expected table matches the actual table
	 EXEC tSQLt.AssertEqualsTable 'expected', 'edw.Fact_Route';


end 

   --exec tsqlt.Run @TestName = '[testFactRoute].[Test02 - Insert records containing Vessel info and no Voyage Info, followed by updates for the same vessel]'