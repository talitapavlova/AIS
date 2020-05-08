

/*	
	Change log: 
		2020-03-25	Stored procedure created for testing stored procedures targetting Dim_Vessel
		2020-04-10	Stored procedure updated for testing the effect of the stored procedures utility.Add_Batch on Dim_Vessel. The update consists of:
						-add execution of utility.Batch SP;
						-check if the record contains the correct batch number by closly checking the values of [BatchCreated] and [BatchUpdated] attributes. 

Test8 - Insert one already existing record containg all update(s) as 'NULLs'. No record updated, nor new inserts happen
		The test performs the ETL targeting Dim_Vessel, where the source file contains a record having updated values for a record that already exists in Dim_Vessel. The updates are all NULL values.
		The test verifies the number of rows in Dim_Vessel after the ETL process had been executed. No record updated, nor new inserts should happen.
	    UPDATE: Furthermore, it is verified if the record contains the correct batch number, when Add_Batch SP is included 

*/


CREATE   PROCEDURE [testDimVessel].[Test8 - Insert one already existing record containg all updates as 'NULLs']
AS
BEGIN

/*ARRANGE*/    
  DECLARE @rowCount_Dim_Vessel int  
  DECLARE @batchCreated int, @batchUpdated int

  IF OBJECT_ID('expected') IS NOT NULL DROP TABLE expected;
 
	-- truncate tables to have accurate test results 
	truncate table edw.Dim_Vessel
	truncate table extract.AIS_Data
	truncate table utility.Batch
	
    --Prepare Dim_Vessel to be pre-populated with a records, simulting a previous execution of the ETL
	insert into edw.Dim_Vessel 
	values ('211789180','SKANDI CONSTRUCTOR','9431642',	'C6ZH8 ',	70,	   'Bahamas (Commonwealth of the)',	311, 42, 78, 120,  13,11, 24, 1, 1, NULL,  '2020-03-26 16:55:41.0000000',	'9999-12-31 00:00:00.0000000')

	--Prepare utility.Batch table to be pre-populated with 1 records, simulting a previous execution of the ETL
    insert into utility.Batch
	values (1,1,1,0,'2020-03-26 16:55:41.0000000',	'2020-03-26 16:55:41.0000000', GETDATE())

/*ACT*/	
	-- ETL for Dim_Vessel to insert the following CSV. file records, consisting of an already existing record in Dim_Vessel (where MMSI = 211789180) with updates
	execute [extract].[AIS_Data_CSV]'C:\AIS\Tests\Test9.csv'
	execute utility.Add_Batch 1
	execute [load].[Dim_Vessel_L]	
	truncate table extract.AIS_Data

	/*  CSV content:
			~MMSI|AIS Message Type|Longitude|Latitude|MID Number|MID|Navigation Status|Rate of Turn (ROT)|Speed Over Ground (SOG)|Position Accuracy|Course Over Ground (COG)|True Heading (HDG)|Manoeuvre Indicator|RAIM Flag|Repeat Indicator|Received Time UTC-Unix|Vessel Name|IMO Number|Call Sign|Ship Type|Dimension to Bow|Dimension to Stern|Length|Dimension to Port|Dimension to Starboard|Beam|Position Type Fix|ETA month|ETA day|ETA hour|ETA minute|Draught|Destination
			211789180|5|6.979007|56.625840||||||||||||26-03-2020 16:55:47|||||||||||||||||SE GOT>DK FDH>SE GOT*/

	-- Extra measurement, for checking if there is a slowly changing dimension for MMSI = 211789180
	set @rowCount_Dim_Vessel= (select count(*) from edw.Dim_Vessel where MMSI = '211789180')

/*ASSERT*/
	-- evaluate if expected rowCount for Dim_Vessel is 1  
	EXEC tSQLt.AssertEqualsString 1, @rowCount_Dim_Vessel; 
 	
  --evaluate the actual record (of Dim_Vessel) contains the correct Batch information*/	
    -- checking for old record's BatchCreated and BatchUpdated attributes
	set @batchCreated = ( select BatchCreated from edw.Dim_Vessel where MMSI = '211789180' )
	EXEC tSQLt.AssertEqualsString 1 , @batchCreated;  
	
	set @batchUpdated = (select BatchUpdated from edw.Dim_Vessel where MMSI = '211789180')
	EXEC tSQLt.AssertEqualsString null, @batchUpdated; 	 

end
  --exec tsqlt.Run @TestName = '[testDimVessel].[Test8 - Insert one already existing record containg all updates as ''NULLs'']'