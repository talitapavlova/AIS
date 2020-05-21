
/******
	Change log: 
		2020-03-25	SP created for testing SPs targeting Dim_Vessel
		2020-04-10	SP updated for testing the effect of the SPs utility.Add_Batch on Dim_Vessel. The update consists of:
				- add execution of utility.Batch SP;
				-check if the type2 sowly changing dimension's records contains the correct batch number by closly checking the values of [BatchCreated] and [BatchUpdated] attributes. 

	Test Description:
		[Test06 - Insert updates to an already existing record. Check by row attributes]
				The test performs the SPs targeting Dim_Vessel, where the source file contains a record having updated values for one that already exists in Dim_Vessel. 
				The test follows the record's behavior and checks for each attribute's value of the old and the new valid record.
				UPDATE: Furthermore, it is verified if the record contains the correct batch number, when Add_Batch SP is included.

	Set-up:
		Dim_Vessel prepopulated with the following records:
				Vessel_Key | MMSI |	IMO | Call_Sign | Ship_type | Ship_type_Description | MID | MID_Number | Dim_To_Bow | Dim_To_Stern | Length | Dim_to_Port | Dim_To_Starboard | Beam | Pos_type_fix | BatchCreated | BatchUpdated | Valid_From | Valid_To
				1	211789180	NULL	NULL	NULL	NULL	-1	Germany (Federal Republic of)	211	NULL	NULL	NULL	NULL	NULL	NULL	NULL	1	NULL	2020-03-26 16:55:41.0000000	9999-12-31 00:00:00.0000000
		
		utility.Batch prepopulated with the following record:
				Batch | TotalRows | IsContinuousData | IsHistoricalData | MinReceivedTime | MaxReceivedTime | DateCreated
				1	10	1	0	2020-03-26 15:55:41.0000000	2020-03-26 16:05:41.0000000	2020-05-20 12:17:30.7500000

		- CSV content:
				~MMSI|AIS Message Type|Longitude|Latitude|MID Number|MID|Navigation Status|Rate of Turn (ROT)|Speed Over Ground (SOG)|Position Accuracy|Course Over Ground (COG)|True Heading (HDG)|Manoeuvre Indicator|RAIM Flag|Repeat Indicator|Received Time UTC-Unix|Vessel Name|IMO Number|Call Sign|Ship Type|Dimension to Bow|Dimension to Stern|Length|Dimension to Port|Dimension to Starboard|Beam|Position Type Fix|ETA month|ETA day|ETA hour|ETA minute|Draught|Destination
				211789180|5|6.979007|56.625840|211|Germany (Federal Republic of)|0|-5|19,7|1|250,1|249|0|0|0|26-03-2020 16:55:47|STENA JUTLANDICA|9125944|SEAN@@@|64|30|153|183|28|5|33|1|03|26|18|15|6|SE GOT>DK FDH>SE GOT
******/

CREATE PROCEDURE [testDimVessel].[Test06 - Insert updates to an already existing record. Check by row attributes]
AS
BEGIN
/*ARRANGE*/  
  
  DECLARE @rowCount_Dim_Vessel int

  DECLARE @oldName varchar(100), @updatedName varchar(100);  
  DECLARE @oldIMO varchar(100), @updatedIMO varchar(100);
  DECLARE @oldCallSign varchar(100), @updatedCallSign varchar(100);
  DECLARE @oldMID varchar(100), @updatedMID varchar(100);
  DECLARE @oldMID_N int, @updatedMID_N int;
  DECLARE @oldShipType int, @updatedShipType int;
  DECLARE @oldDimToB int, @updatedDimToB int;
  DECLARE @oldDimToStern int, @updatedDimToStern int;
  DECLARE @oldLength int, @updatedLength int;
  DECLARE @oldDimToPort int, @updatedDimToPort int;
  DECLARE @oldDimToStarboard int, @updatedDimToStarboard int;
  DECLARE @oldBeam int,@updatedBeam int; 
  DECLARE @oldPosType int, @updatedPosType int;
  
  DECLARE @batchCreated_oldRec int, @batchUpdated_oldRec int; 
  DECLARE @batchCreated_newRec int, @batchUpdated_newRec int; 
    
  IF OBJECT_ID('expected') IS NOT NULL DROP TABLE expected;
 
  -- truncate tables to have accurate test results 
  truncate table edw.Dim_Vessel
  truncate table archive.AIS_Data_archive
  truncate table extract.AIS_Data
  truncate table utility.Batch

  --Prepare Dim_Vessel to be pre-populated with 1 records, simulting a previous execution of the ETL
  insert into edw.Dim_Vessel 
	values ('211789180', null ,null, null, null, -1, 'Germany (Federal Republic of)',211, null,null,null,null,null,null,null, 1, NULL,  '2020-03-26 16:55:41.0000000',	'9999-12-31 00:00:00.0000000')

  --Prepare utility.Batch table to be pre-populated with 1 records, simulting a previous execution of the ETL
  insert into utility.Batch
	values (1,10,1,0,'2020-03-26 15:55:41.0000000',	'2020-03-26 16:05:41.0000000', GETDATE())


/*ACT and ASSERT combined, for better visualization*/

	-- run SPs for Dim_Vessel including the ones related to it
	execute [extract].[AIS_Data_CSV]'C:\AIS\Tests\test_DimVessel\Test6.csv'
	execute [archive].[AIS_Data_AddToArchive]
	execute [load].[Dim_Vessel_L]	
	execute utility.Add_Batch 1
	truncate table extract.AIS_Data
	
	-- Checking for Vessel_Name
	set @oldName = ( select Vessel_Name from edw.Dim_Vessel where MMSI = '211789180' and  Valid_To = '2020-03-26 16:55:47.0000000')
	EXEC tSQLt.AssertEqualsString null , @oldName;  
	set @updatedName = (select Vessel_Name from edw.Dim_Vessel where MMSI = '211789180' and Valid_To = '9999-12-31 00:00:00.0000000')
	EXEC tSQLt.AssertEqualsString 'STENA JUTLANDICA', @updatedName;  

	-- Checking for IMO
	set @oldIMO = ( select IMO from edw.Dim_Vessel where MMSI = '211789180' and  Valid_To = '2020-03-26 16:55:47.0000000')
	EXEC tSQLt.AssertEqualsString null , @oldIMO;  
	set @updatedIMO = (select IMO from edw.Dim_Vessel where MMSI = '211789180' and Valid_To = '9999-12-31 00:00:00.0000000')
	EXEC tSQLt.AssertEqualsString 9125944 , @updatedIMO;  

	-- Checking for CallSign
	set @oldCallSign = ( select Call_Sign from edw.Dim_Vessel where MMSI = '211789180' and  Valid_To = '2020-03-26 16:55:47.0000000')
	EXEC tSQLt.AssertEqualsString null , @oldCallSign;  
	set @updatedCallSign= (select Call_Sign from edw.Dim_Vessel where MMSI = '211789180' and Valid_To = '9999-12-31 00:00:00.0000000')
	EXEC tSQLt.AssertEqualsString 'SEAN@@@' , @updatedCallSign;  

	-- Checking for MID
	set @oldMID = ( select MID from edw.Dim_Vessel where MMSI = '211789180' and  Valid_To = '2020-03-26 16:55:47.0000000')
	EXEC tSQLt.AssertEqualsString 'Germany (Federal Republic of)' , @oldMID;  
	set @updatedMID = (select MID from edw.Dim_Vessel where MMSI = '211789180' and Valid_To = '9999-12-31 00:00:00.0000000')
	EXEC tSQLt.AssertEqualsString 'Germany (Federal Republic of)', @updatedMID;  

	-- Checking for MID_Number
	set @oldMID_N = ( select MID_Number from edw.Dim_Vessel where MMSI = '211789180' and  Valid_To = '2020-03-26 16:55:47.0000000')
	EXEC tSQLt.AssertEqualsString 211 , @oldMID_N;  
	set @updatedMID_N = (select MID_Number from edw.Dim_Vessel where MMSI = '211789180' and Valid_To = '9999-12-31 00:00:00.0000000')
	EXEC tSQLt.AssertEqualsString 211, @updatedMID_N;  

	-- Checking for Dimension_To_Bow
	set @oldDimToB = ( select Dimension_To_Bow from edw.Dim_Vessel where MMSI = '211789180' and  Valid_To = '2020-03-26 16:55:47.0000000')
	EXEC tSQLt.AssertEqualsString null , @oldDimToB;  
	set @updatedDimToB = (select Dimension_To_Bow from edw.Dim_Vessel where MMSI = '211789180' and Valid_To = '9999-12-31 00:00:00.0000000')
	EXEC tSQLt.AssertEqualsString 30, @updatedDimToB; 

	-- Checking for Dimension_To_Stern
	set @oldDimToStern = ( select Dimension_To_Stern from edw.Dim_Vessel where MMSI = '211789180' and  Valid_To = '2020-03-26 16:55:47.0000000')
	EXEC tSQLt.AssertEqualsString null , @oldDimToStern;  
	set @updatedDimToStern = (select Dimension_To_Stern from edw.Dim_Vessel where MMSI = '211789180' and Valid_To = '9999-12-31 00:00:00.0000000')
	EXEC tSQLt.AssertEqualsString 153, @updatedDimToStern; 

	-- Checking for Length
	set @oldLength = ( select Length from edw.Dim_Vessel where MMSI = '211789180' and  Valid_To = '2020-03-26 16:55:47.0000000')
	EXEC tSQLt.AssertEqualsString null , @oldLength;  
	set @updatedLength = (select Length from edw.Dim_Vessel where MMSI = '211789180' and Valid_To = '9999-12-31 00:00:00.0000000')
	EXEC tSQLt.AssertEqualsString 183, @updatedLength; 

	-- Checking for Dimension_To_Port
	set @oldDimToPort = ( select Dimension_To_Port from edw.Dim_Vessel where MMSI = '211789180' and  Valid_To = '2020-03-26 16:55:47.0000000')
	EXEC tSQLt.AssertEqualsString null , @oldDimToPort;  
	set @updatedDimToPort = (select Dimension_To_Port from edw.Dim_Vessel where MMSI = '211789180' and Valid_To = '9999-12-31 00:00:00.0000000')
	EXEC tSQLt.AssertEqualsString 28, @updatedDimToPort; 

		-- Checking for Dimension_To_Starboard
	set @oldDimToStarboard = ( select Dimension_To_Starboard from edw.Dim_Vessel where MMSI = '211789180' and  Valid_To = '2020-03-26 16:55:47.0000000')
	EXEC tSQLt.AssertEqualsString null , @oldDimToStarboard;  
	set @updatedDimToStarboard = (select Dimension_To_Starboard from edw.Dim_Vessel where MMSI = '211789180' and Valid_To = '9999-12-31 00:00:00.0000000')
	EXEC tSQLt.AssertEqualsString 5 , @updatedDimToStarboard;  
	
	-- Checking for Beam
	set @oldBeam = ( select Beam from edw.Dim_Vessel where MMSI = '211789180' and  Valid_To = '2020-03-26 16:55:47.0000000')
	EXEC tSQLt.AssertEqualsString null , @oldBeam;  
	set @updatedBeam = (select Beam from edw.Dim_Vessel where MMSI = '211789180' and Valid_To = '9999-12-31 00:00:00.0000000')
	EXEC tSQLt.AssertEqualsString 33 , @updatedBeam;  

	 -- Checking if the old record reffers to the correct batch number for BatchCreated attribute 
	set @batchCreated_oldRec = ( select BatchCreated from edw.Dim_Vessel where MMSI = '211789180' and  Valid_To = '2020-03-26 16:55:47.0000000')
	EXEC tSQLt.AssertEqualsString 1 , @batchCreated_oldRec;  

	-- Checking if the old record reffers to the correct batch number for BatchUpdated attribute 
	set @batchUpdated_oldRec = ( select BatchUpdated from edw.Dim_Vessel where MMSI = '211789180' and  Valid_To = '2020-03-26 16:55:47.0000000')
	EXEC tSQLt.AssertEqualsString 2 , @batchUpdated_oldRec;  
			
	-- Checking if the new record reffers to the correct batch numbers for BatchCreated attribute 
	set @batchCreated_newRec = (select BatchCreated from edw.Dim_Vessel where MMSI = '211789180' and  Valid_To = '9999-12-31 00:00:00.0000000')
	EXEC tSQLt.AssertEqualsString 2, @batchCreated_newRec;  
 
	-- Checking if the new record reffers to the correct batch numbers for BatchUpdated attribute 
	set @batchUpdated_newRec = (select BatchUpdated from edw.Dim_Vessel where MMSI = '211789180' and  Valid_To = '9999-12-31 00:00:00.0000000')
	EXEC tSQLt.AssertEqualsString null, @batchUpdated_newRec;  


end
  --exec tsqlt.Run @TestName = '[testDimVessel].[Test06 - Insert updates to an already existing record. Check by row attributes]'