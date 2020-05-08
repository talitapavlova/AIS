





/* Test1 - Insert new record
The test performs the ETL targeting Dim_Vessel first time, where the source file contains one record. The utility.Add_Batch stored procedure and truncate extract.AIS_Data are executed along each time the ETL is scheduled.  
The test verifies that newly inserted record in Dim_Vessel, will refer to the correct batch number. The test also follows the utility.Batch table, if holding the expected values.

*/

CREATE    PROCEDURE [testBatch].[Test1 - Insert new record]
AS
BEGIN

/*ARRANGE*/

  DECLARE @batchCreated int, @batchUpdated int; 
  
  IF OBJECT_ID('expected') IS NOT NULL DROP TABLE expected;
 
  -- truncate tables to have accurate test results 
	truncate table edw.Dim_Vessel
	truncate table extract.AIS_Data
	truncate table utility.Batch

/*ACT*/
  --execute ETL's stored procedures
	execute [extract].[AIS_Data_CSV] 'C:\AIS\Tests\test_Batch\Test01.csv'   
	execute utility.Add_Batch 1
	execute [load].[Dim_Vessel_L]
	truncate table extract.AIS_Data
	--select * from utility.Batch
	/*   CSV content:
			~MMSI|AIS Message Type|Longitude|Latitude|MID Number|MID|Navigation Status|Rate of Turn (ROT)|Speed Over Ground (SOG)|Position Accuracy|Course Over Ground (COG)|True Heading (HDG)|Manoeuvre Indicator|RAIM Flag|Repeat Indicator|Received Time UTC-Unix|Vessel Name|IMO Number|Call Sign|Ship Type|Dimension to Bow|Dimension to Stern|Length|Dimension to Port|Dimension to Starboard|Beam|Position Type Fix|ETA month|ETA day|ETA hour|ETA minute|Draught|Destination
			265410000|5|||265|Sweden|||||||||0|26-03-2020 16:00:00|STENA JUTLANDICA||||||||||||||||SE GOT>DK FDH>SE GOT
	*/
	create table expected (
	[Batch] [int] NOT NULL,
	[TotalRows] [int] NOT NULL,
	[IsContinuousData] [tinyint] NULL,
	[IsHistoricalData] [tinyint] NULL,
	[MinReceivedTime] [datetime2](7) NULL,
	[MaxReceivedTime] [datetime2](7) NULL,
	[DateCreated] [datetime2](7) NULL)

  --values expected to be in utility.Batch after performing one time the ETL 
	insert into expected
	values (1,1,1,0,'2020-03-26 16:55:41.0000000',	'2020-03-26 16:55:41.0000000', GETDATE())
  
 /*ASSERT*/ 
	
	-- Checking for BatchCreated attribute in Dim_Vessel, after performing ETL
	set @batchCreated = ( select BatchCreated from edw.Dim_Vessel where MMSI = '265410000')
	EXEC tSQLt.AssertEqualsString 1 , @batchCreated;  
	
	
	set @batchUpdated = (select BatchUpdated from edw.Dim_Vessel where MMSI = '265410000')
	EXEC tSQLt.AssertEqualsString null, @batchUpdated;  
 
end 

 -- exec tsqlt.Run @TestName = '[testBatch].[Test1 - Insert new record]'