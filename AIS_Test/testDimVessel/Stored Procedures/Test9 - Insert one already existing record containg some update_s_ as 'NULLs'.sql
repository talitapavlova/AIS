
/*	
Change log: 
		2020-03-25	Stored procedure created for testing stored procedures targetting Dim_Vessel
		2020-04-10	Stored procedure updated for testing the effect of the stored procedures utility.Add_Batch on Dim_Vessel. The update consists of:
						-add execution of utility.Batch SP;
						-check if the record contains the correct batch number by closly checking the values of [BatchCreated] and [BatchUpdated] attributes. 

Test 9 -  Insert one already existing record containg some update(s) as 'NULLs'. New inserted record should keep old values
			The test performs the ETL targeting Dim_Vessel, where the source file contains a record having updated values for a record that already exists in Dim_Vessel. 
			The record already existing in Dim_vessel contains not-null values for all of the attrributes, except MID_Number. The record in the source file contains updates for the MID_Number, while all the other attributes related to Dim_vessel are NULL values.
			The test ensure that the old record is terminated, while new record is update only regarding MID_Number. The old values should be kept
			*It is assumed the same behavior for any other attribute, instead of MID_Number
			UPDATE: Furthermore, it is verified if the record contains the correct batch number, when Add_Batch SP is included 
*/
CREATE    PROCEDURE [testDimVessel].[Test9 - Insert one already existing record containg some update(s) as 'NULLs']
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

    DECLARE @batchCreatedold int, @batchUpdatedold int
    DECLARE @batchCreatedvalid int, @batchUpdatedvalid int
 
 IF OBJECT_ID('expected') IS NOT NULL DROP TABLE expected;
 
	-- truncate tables to have accurate test results 
	truncate table edw.Dim_Vessel
	truncate table extract.AIS_Data
	truncate table utility.Batch

     --Prepare Dim_Vessel to be pre-populated with a records, simulting a previous execution of the ETL
	insert into edw.Dim_Vessel 
	values ('211789180','SKANDI CONSTRUCTOR','9431642',	'C6ZH8 ',	70, 'Bahamas (Commonwealth of the)',	null, 42, 78, 120,  13,11, 24, 1, 1, NULL,  '2020-03-26 16:55:41.0000000',	'9999-12-31 00:00:00.0000000')

	--Prepare utility.Batch table to be pre-populated with 1 records, simulting a previous execution of the ETL
    insert into utility.Batch
	values (1,1,1,0,'2020-03-26 16:55:41.0000000',	'2020-03-26 16:55:41.0000000', GETDATE())

/*ACT and ASSERT for better visualization*/
	
	-- ETL for Dim_Vessel to insert the following CSV. file records, consisting of an already existing record in Dim_Vessel (where MMSI = 211789180) containing updates
	execute [extract].[AIS_Data_CSV]'C:\AIS\Tests\Test9_1.csv'
	execute utility.Add_Batch 1
	execute [load].[Dim_Vessel_L]	
	truncate table extract.AIS_Data
	/*  CSV content:
			~MMSI|AIS Message Type|Longitude|Latitude|MID Number|MID|Navigation Status|Rate of Turn (ROT)|Speed Over Ground (SOG)|Position Accuracy|Course Over Ground (COG)|True Heading (HDG)|Manoeuvre Indicator|RAIM Flag|Repeat Indicator|Received Time UTC-Unix|Vessel Name|IMO Number|Call Sign|Ship Type|Dimension to Bow|Dimension to Stern|Length|Dimension to Port|Dimension to Starboard|Beam|Position Type Fix|ETA month|ETA day|ETA hour|ETA minute|Draught|Destination
			211789180|5|6.979007|56.625840|311||0|-5|19,7|1|250,1|249|0|0|0|26-03-2020 16:55:47|||||||||||||||||SE GOT>DK FDH>SE GOT
	*/

	-- Extra measurement, for checking if there is a slowly changing dimension for MMSI = 211789180
	set @rowCount_Dim_Vessel= (select count(*) from edw.Dim_Vessel where MMSI = '211789180')
	EXEC tSQLt.AssertEqualsString 2, @rowCount_Dim_Vessel; 
 	
	-- Checking for Vessel_Name
	set @oldName = ( select Vessel_Name from edw.Dim_Vessel where MMSI = '211789180' and  Valid_To = '2020-03-26 16:55:47.0000000')
	EXEC tSQLt.AssertEqualsString 'SKANDI CONSTRUCTOR' , @oldName;  
	set @updatedName = (select Vessel_Name from edw.Dim_Vessel where MMSI = '211789180' and Valid_To = '9999-12-31 00:00:00.0000000')
	EXEC tSQLt.AssertEqualsString 'SKANDI CONSTRUCTOR', @updatedName;  

	-- Checking for IMO
	set @oldIMO = ( select IMO from edw.Dim_Vessel where MMSI = '211789180' and  Valid_To = '2020-03-26 16:55:47.0000000')
	EXEC tSQLt.AssertEqualsString 9431642 , @oldIMO;  
	set @updatedIMO = (select IMO from edw.Dim_Vessel where MMSI = '211789180' and Valid_To = '9999-12-31 00:00:00.0000000')
	EXEC tSQLt.AssertEqualsString 9431642 , @updatedIMO;  

	-- Checking for CallSign
	set @oldCallSign = ( select Call_Sign from edw.Dim_Vessel where MMSI = '211789180' and  Valid_To = '2020-03-26 16:55:47.0000000')
	EXEC tSQLt.AssertEqualsString 'C6ZH8' , @oldCallSign;  
	set @updatedCallSign= (select Call_Sign from edw.Dim_Vessel where MMSI = '211789180' and Valid_To = '9999-12-31 00:00:00.0000000')
	EXEC tSQLt.AssertEqualsString 'C6ZH8' , @updatedCallSign;  

	-- Checking for MID
	set @oldMID = ( select MID from edw.Dim_Vessel where MMSI = '211789180' and  Valid_To = '2020-03-26 16:55:47.0000000')
	EXEC tSQLt.AssertEqualsString 'Bahamas (Commonwealth of the)' , @oldMID;  
	set @updatedMID = (select MID from edw.Dim_Vessel where MMSI = '211789180' and Valid_To = '9999-12-31 00:00:00.0000000')
	EXEC tSQLt.AssertEqualsString 'Bahamas (Commonwealth of the)', @updatedMID;  

	-- Checking for MID_Number
	set @oldMID_N = ( select MID_Number from edw.Dim_Vessel where MMSI = '211789180' and  Valid_To = '2020-03-26 16:55:47.0000000')
	EXEC tSQLt.AssertEqualsString null , @oldMID_N;  
	set @updatedMID_N = (select MID_Number from edw.Dim_Vessel where MMSI = '211789180' and Valid_To = '9999-12-31 00:00:00.0000000')
	EXEC tSQLt.AssertEqualsString 205, @updatedMID_N;  

	-- Checking for Dimension_To_Bow
	set @oldDimToB = ( select Dimension_To_Bow from edw.Dim_Vessel where MMSI = '211789180' and  Valid_To = '2020-03-26 16:55:47.0000000')
	EXEC tSQLt.AssertEqualsString 42 , @oldDimToB;  
	set @updatedDimToB = (select Dimension_To_Bow from edw.Dim_Vessel where MMSI = '211789180' and Valid_To = '9999-12-31 00:00:00.0000000')
	EXEC tSQLt.AssertEqualsString 42, @updatedDimToB; 

	-- Checking for Dimension_To_Stern
	set @oldDimToStern = ( select Dimension_To_Stern from edw.Dim_Vessel where MMSI = '211789180' and  Valid_To = '2020-03-26 16:55:47.0000000')
	EXEC tSQLt.AssertEqualsString 78 , @oldDimToStern;  
	set @updatedDimToStern = (select Dimension_To_Stern from edw.Dim_Vessel where MMSI = '211789180' and Valid_To = '9999-12-31 00:00:00.0000000')
	EXEC tSQLt.AssertEqualsString 78, @updatedDimToStern; 

	-- Checking for Length
	set @oldLength = ( select Length from edw.Dim_Vessel where MMSI = '211789180' and  Valid_To = '2020-03-26 16:55:47.0000000')
	EXEC tSQLt.AssertEqualsString 120 , @oldLength;  
	set @updatedLength = (select Length from edw.Dim_Vessel where MMSI = '211789180' and Valid_To = '9999-12-31 00:00:00.0000000')
	EXEC tSQLt.AssertEqualsString 120, @updatedLength; 

	-- Checking for Dimension_To_Port
	set @oldDimToPort = ( select Dimension_To_Port from edw.Dim_Vessel where MMSI = '211789180' and  Valid_To = '2020-03-26 16:55:47.0000000')
	EXEC tSQLt.AssertEqualsString 13 , @oldDimToPort;  
	set @updatedDimToPort = (select Dimension_To_Port from edw.Dim_Vessel where MMSI = '211789180' and Valid_To = '9999-12-31 00:00:00.0000000')
	EXEC tSQLt.AssertEqualsString 13, @updatedDimToPort; 

		-- Checking for Dimension_To_Starboard
	set @oldDimToStarboard = ( select Dimension_To_Starboard from edw.Dim_Vessel where MMSI = '211789180' and  Valid_To = '2020-03-26 16:55:47.0000000')
	EXEC tSQLt.AssertEqualsString 11 , @oldDimToStarboard;  
	set @updatedDimToStarboard = (select Dimension_To_Starboard from edw.Dim_Vessel where MMSI = '211789180' and Valid_To = '9999-12-31 00:00:00.0000000')
	EXEC tSQLt.AssertEqualsString 11 , @updatedDimToStarboard;  
	
	-- Checking for Beam
	set @oldBeam = ( select Beam from edw.Dim_Vessel where MMSI = '211789180' and  Valid_To = '2020-03-26 16:55:47.0000000')
	EXEC tSQLt.AssertEqualsString 24 , @oldBeam;  
	set @updatedBeam = (select Beam from edw.Dim_Vessel where MMSI = '211789180' and Valid_To = '9999-12-31 00:00:00.0000000')
	EXEC tSQLt.AssertEqualsString 24 , @updatedBeam;  

	 --evaluate the record (of Dim_Vessel) where MMSI=205769000 contains the correct Batch information*/	
	 -- Checking if the old record reffers to the correct batch number for BatchCreated attribute 
	set @batchCreatedold = ( select BatchCreated from edw.Dim_Vessel where MMSI = '211789180' and  Valid_To = '2020-03-26 16:55:47.0000000')
	EXEC tSQLt.AssertEqualsString 1 , @batchCreatedold;  
	
    -- Checking if the old record reffers to the correct batch numbers for BatchUpdated attribute 
	set @batchUpdatedold= (select BatchUpdated from edw.Dim_Vessel where MMSI = '211789180' and  Valid_To = '2020-03-26 16:55:47.0000000')
	EXEC tSQLt.AssertEqualsString 2, @batchUpdatedold;  

	-- Checking if the new record reffers to the correct batch numbers for BatchCreated attribute 
	set @batchCreatedvalid = (select BatchCreated from edw.Dim_Vessel where MMSI = '211789180' and  Valid_To = '9999-12-31 00:00:00.0000000')
	EXEC tSQLt.AssertEqualsString 2, @batchCreatedvalid;  
	 
	 -- Checking if the old record reffers to the correct batch numbers for BatchUpdated attribute 
	set @batchUpdatedvalid= (select BatchUpdated from edw.Dim_Vessel where MMSI = '211789180' and  Valid_To = '9999-12-31 00:00:00.0000000')
	EXEC tSQLt.AssertEqualsString null, @batchUpdatedvalid;  
 
end
  --exec tsqlt.Run @TestName = '[testDimVessel].[Test9 - Insert one already existing record containg some update(s) as ''NULLs'']'