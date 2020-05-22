

/*	
	Change log: 
		2020-03-25	Stored procedure(SP) created for testing stored procedures targeting Dim_Vessel
		2020-04-10	Stored procedure cerated for testing the effect of the stored procedures utility.Add_Batch on Dim_Vessel. It consists of:
				-execute related procedures;
				-check the validity of type2 sowly changing dimension's records, by closly checking the values of [Valid_To] and [Valid_From] attributes. 

	Test Description:
		[Test07 - Insert updates for an already existing record. Check validity of record by date attributes]
				The test performs the SPs targeting Dim_Vessel and utility.Batch, where the source file contains updated values for a record that already exists in Dim_Vessel. 
				The test follows the record's behavior by checking the Valid_To and Valid_From attributes.
	Set-up:
		Dim_Vessel prepopulated with the following records:
				Vessel_Key | MMSI |	IMO | Call_Sign | Ship_type | Ship_type_Description | MID | MID_Number | Dim_To_Bow | Dim_To_Stern | Length | Dim_to_Port | Dim_To_Starboard | Beam | Pos_type_fix | BatchCreated | BatchUpdated | Valid_From | Valid_To
				1	211789180	NULL	9431642	333333	70	Cargo, all ships of this type	Germany (Federal Republic of)	211	78	89	99	87	11	22	1	1	NULL	2020-03-26 16:55:41.0000000	9999-12-31 00:00:00.0000000

		
		utility.Batch prepopulated with the following record:
			Batch | TotalRows | IsContinuousData | IsHistoricalData | MinReceivedTime | MaxReceivedTime | DateCreated
			1	200	1	0	2020-03-26 16:53:41.0000000	2020-03-26 16:55:41.0000000	2020-05-20 12:29:28.7266667

		CSV content:
			~MMSI|AIS Message Type|Longitude|Latitude|MID Number|MID|Navigation Status|Rate of Turn (ROT)|Speed Over Ground (SOG)|Position Accuracy|Course Over Ground (COG)|True Heading (HDG)|Manoeuvre Indicator|RAIM Flag|Repeat Indicator|Received Time UTC-Unix|Vessel Name|IMO Number|Call Sign|Ship Type|Dimension to Bow|Dimension to Stern|Length|Dimension to Port|Dimension to Starboard|Beam|Position Type Fix|ETA month|ETA day|ETA hour|ETA minute|Draught|Destination
			211789180|5|||311|Bahamas (Commonwealth of the)|||||||||0|26-03-2020 17:57:39|SKANDI CONSTRUCTOR|9431642|333333|70|42|78|120|13|11|24|1|03|21|12|34|5,5|ODENSE 

*/
CREATE PROCEDURE [testDimVessel].[Test07 - Insert updates for an already existing record. Check validity of record by date attributes]
AS
BEGIN

/*ARRANGE*/ 
    DECLARE @rowCount_Batch int;
    DECLARE @batchCreated_oldRec int, @batchUpdated_oldRec int, @batchCreated_newRec int, @batchUpdated_newRec int; 
    DECLARE @validTo_oldRec datetime2, @validFrom_oldRec datetime2, @validTo_newRec datetime2, @validFrom_newRec datetime2;
    DECLARE @maxReceivedTime_Batch1 dateTime2, @maxReceivedTime_Batch2 datetime2;

   -- truncate tables to have accurate test results 
    truncate table edw.Dim_Vessel
    truncate table archive.AIS_Data_archive
    truncate table extract.AIS_Data
    truncate table utility.Batch

   --Prepare Dim_Vessel to be pre-populated with 1 records, simulting a previous execution of the ETL
	insert into edw.Dim_Vessel 
	values ('211789180', null ,'9431642', '333333', 70, 'Cargo, all ships of this type', 'Germany (Federal Republic of)',211, 78 ,89,99,87,11,22,1, 1, NULL,  '2020-03-26 16:55:41.0000000',	'9999-12-31 00:00:00.0000000')

   --Prepare utility.Batch table to be pre-populated with 1 records, simulting a previous execution of the ETL
    insert into utility.Batch
	values (1,200,1,0,'2020-03-26 16:53:41.0000000', '2020-03-26 16:55:41.0000000', GETDATE())

/*ACT*/
	--step1: First execution of ETL, of non existent record
	execute [extract].[AIS_Data_CSV] 'C:\AIS\Tests\test_DimVessel\Test7.csv' 
	execute [archive].[AIS_Data_AddToArchive]
	execute [load].[Dim_Vessel_L]	
	execute utility.Add_Batch 1
	truncate table extract.AIS_Data

/*ASSERT*/
	-- Checking if each old record has the correct validity, by checking the Valid_to field
	set @validFrom_oldRec = ( select Valid_From from edw.Dim_Vessel where Vessel_Name is null)
	set @maxReceivedTime_Batch1  = (select MaxReceivedTime from utility.Batch where Batch = 1)
    EXEC tSQLt.AssertEqualsString @validFrom_oldRec , @maxReceivedTime_Batch1; 

	set @validTo_oldRec = ( select Valid_To from edw.Dim_Vessel where Vessel_Name is null)
	set @maxReceivedTime_Batch2  = (select MaxReceivedTime from utility.Batch where Batch = 2)
    EXEC tSQLt.AssertEqualsString @validTo_oldRec , @maxReceivedTime_Batch2; 

	-- Checking if each new record has the correct validity, by checking the Valid_From fields
	set @validFrom_newRec = ( select Valid_From from edw.Dim_Vessel where Vessel_Name = 'SKANDI CONSTRUCTOR')
    EXEC tSQLt.AssertEqualsString @validFrom_newRec , @maxReceivedTime_Batch2; 

	set @validTo_newRec = ( select Valid_To from edw.Dim_Vessel where Vessel_Name = 'SKANDI CONSTRUCTOR')
    EXEC tSQLt.AssertEqualsString '9999-12-31 00:00:00.0000000' , @validTo_newRec; 
  
  
end 
 -- exec tsqlt.Run @TestName = '[testDimVessel].[Test07 - Insert updates for an already existing record. Check validity of record by date attributes]'