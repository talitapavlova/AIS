

/******
	Change log: 
		2020-03-25	SP for testing SPs targeting Dim_Vessel
		2020-04-10	SP updated for testing the effect of the SPs utility.Add_Batch on Dim_Vessel. The update consists of:
						-add execution of utility.Batch SP;
						-check if the type2 sowly changing dimension's records contains the correct batch number by closly checking the values of 
					     [BatchCreated] and [BatchUpdated] attributes. 

	Test Description:
		[Test11 - Insert from source file containing new records combined with updates for already existing ones]
		     The test performs the SPs targeting Dim_Vessel, where the source file contains (10) records, 
		     where 4 of them are complete new, and the other 6 contain updates for already existing records in Dim_Vessel.  
		     The test checks if the outcome of the ETL process is as expected, by assessing the number of rows in Dim_Vessel after the ETL process had been executed.
			 UPDATE: Furthermore, it is verified if the record contains the correct batch number, when Add_Batch is included.
	
	Set-up:
	   Dim_Vessel prepopulated with the following records:
			Vessel_Key | MMSI |	IMO | Call_Sign | Ship_type | Ship_type_Description | MID | MID_Number | Dim_To_Bow | Dim_To_Stern | Length | Dim_to_Port | Dim_To_Starboard | Beam | Pos_type_fix | BatchCreated | BatchUpdated | Valid_From | Valid_To
			1	205769000	NULL	NULL	NULL	NULL	-1	Belgium	205	NULL	NULL	NULL	NULL	NULL	NULL	NULL	1	NULL	2020-03-26 16:55:41.0000000	9999-12-31 00:00:00.0000000
			2	211789180	IRIS	NULL	NULL	NULL	-1	Germany (Federal Republic of)	211	NULL	NULL	NULL	NULL	NULL	NULL	NULL	1	NULL	2020-03-26 16:55:41.0000000	9999-12-31 00:00:00.0000000
			3	219006916	RI322 SINNE FRIHED	NULL	NULL	NULL	-1	Denmark	219	NULL	NULL	NULL	NULL	NULL	NULL	NULL	1	NULL	2020-03-26 16:55:41.0000000	9999-12-31 00:00:00.0000000
			4	219013485	TOVE KAJGAARD	NULL	NULL	NULL	-1	Denmark	219	NULL	NULL	NULL	NULL	NULL	NULL	NULL	1	NULL	2020-03-26 16:55:41.0000000	9999-12-31 00:00:00.0000000
			5	219330000	NEPTUN AS 202	NULL	NULL	NULL	-1	Denmark	219	NULL	NULL	NULL	NULL	NULL	NULL	NULL	1	NULL	2020-03-26 16:55:41.0000000	9999-12-31 00:00:00.0000000
			6	220334000	STINE FN396	NULL	NULL	NULL	-1	Denmark	220	NULL	NULL	NULL	NULL	NULL	NULL	NULL	1	NULL	2020-03-26 16:55:41.0000000	9999-12-31 00:00:00.0000000
			7	222530728	BJORNSHOLM	NULL	NULL	NULL	-1	not in use	222	NULL	NULL	NULL	NULL	NULL	NULL	NULL	1	NULL	2020-03-26 16:55:41.0000000	9999-12-31 00:00:00.0000000
			8	244813000	BIT FORCE	NULL	NULL	NULL	-1	Netherlands (Kingdom of the)	244	NULL	NULL	NULL	NULL	NULL	NULL	NULL	1	NULL	2020-03-26 16:55:41.0000000	9999-12-31 00:00:00.0000000
			9	259896000	NULL	NULL	NULL	NULL	-1	Norway	259	NULL	NULL	NULL	NULL	NULL	NULL	NULL	1	NULL	2020-03-26 16:55:40.0000000	9999-12-31 00:00:00.0000000
			10	311055900	SKANDI CONSTRUCTOR	9431642	C6ZH8 	70	Cargo, all ships of this type	Bahamas (Commonwealth of the)	311	42	78	120	13	11	24	1	1	NULL	2020-03-26 16:55:41.0000000	9999-12-31 00:00:00.0000000
			
		utility.Batch prepopulated with the following record:
			Batch | TotalRows | IsContinuousData | IsHistoricalData | MinReceivedTime | MaxReceivedTime | DateCreated
			1	10	1	0	2020-03-26 15:55:41.0000000	2020-03-26 16:05:41.0000000	2020-05-20 13:03:13.4666667

		CSV content:
			~MMSI|AIS Message Type|Longitude|Latitude|MID Number|MID|Navigation Status|Rate of Turn (ROT)|Speed Over Ground (SOG)|Position Accuracy|Course Over Ground (COG)|True Heading (HDG)|Manoeuvre Indicator|RAIM Flag|Repeat Indicator|Received Time UTC-Unix|Vessel Name|IMO Number|Call Sign|Ship Type|Dimension to Bow|Dimension to Stern|Length|Dimension to Port|Dimension to Starboard|Beam|Position Type Fix|ETA month|ETA day|ETA hour|ETA minute|Draught|Destination
			244813000|5|8.597500|57.854670|244|Netherlands (Kingdom of the)|0|7|13,6|0|68,0|66|0|0|0|26-03-2020 16:55:41|BIT FORCE||||||||||||||||
			219006916|5|8.127717|56.001370|219|Denmark|15|-128|0,0|0|254,7|511|0|0|0|26-03-2020 16:55:41|RI322 SINNE FRIHED||||||||||||||||
			219330000|5|11.739600|56.325370|219|Denmark|7|0|10,7|1|282,6|281|0|0|0|26-03-2020 16:55:41|NEPTUN AS 202||||||||||||||||
			205769000|5|6.599771|55.815250|205|Belgium|0|0|13,8|0|210,1|206|0|0|0|26-03-2020 16:55:41|||||||||||||||||
			219013485|5|||311|Bahamas (Commonwealth of the)|||||||||0|26-03-2020 16:55:41|SKANDI CONSTRUCTOR|9431642|C6ZH8  |70|42|78|120|13|11|24|1|03|21|12|34|5,5|ODENSE 
			211789180|5|6.979007|56.625840|211|Germany (Federal Republic of)|0|-5|19,7|1|250,1|249|0|0|0|26-03-2020 16:55:47|STENA JUTLANDICA|9125944|SEAN@@@|64|30|153|183|28|5|33|1|03|26|18|15|6|SE GOT>DK FDH>SE GOT
			220334000|5|11.126950|57.321250|220|Denmark|7|0|0,0|0|239,6|155|0|0|0|26-03-2020 16:55:41|DELIA|9234317|V2AB4@@|70|73|16|89|7|5|12|0|03|30|05|00|4,7|NOGLO@@@@@@@@@@@@@@@
			259896000|5|12.050940|54.408540|259|Norway|0|0|12,7|0|90,1|90|0|0|0|26-03-2020 16:55:40|ADVANTAGE POINT|9327384|V7TL5@@|80|149|34|183|22|5|27|1|03|26|23|00|6,9|SE GOT@@@@@@@@@@@@@@
			222530728|5|12.311000|56.126280|222|not in use|0|-128|0,1|0|226,0|511|0|0|0|26-03-2020 16:55:49|SOE BONDE SILLERSLEV|0|OXNS|30|8|7|15|2|3|5|15|00|00|24|60|1|LIMFJORDEN
			311055900|5|||311|Bahamas (Commonwealth of the)|||||||||0|26-03-2020 16:55:49|FEGGESUND|9640918|OZMW|60|20|14|34|5|6|11|1|00|00|00|00|5|CROSSING  
*/

CREATE   PROCEDURE [testDimVessel].[Test11 - Insert from source file containing new records combined with updates for already existing ones]
AS
BEGIN

/*ARRANGE*/ 
  DECLARE @rowCount_Dim_Vessel int
  DECLARE @numberRecNotAffected int, @numberValidRec int,  @numberNonValidRec int; 

  IF OBJECT_ID('expected') IS NOT NULL DROP TABLE expected;
 
  -- truncate tables to have accurate test results 
  truncate table edw.Dim_Vessel
  truncate table archive.AIS_Data_archive
  truncate table extract.AIS_Data
  truncate table utility.Batch

 --Prepare Dim_Vessel to be pre-populated with 10 records, simulting a previous execution of the ETL
	insert into edw.Dim_Vessel 
	values ('205769000', null, null, null, null, -1, 'Belgium',205, null, null, null, null, null, null, null, 1, NULL,  '2020-03-26 16:55:41.0000000',	'9999-12-31 00:00:00.0000000')
	insert into edw.Dim_Vessel 
	values ('211789180','IRIS' ,null, null, null, -1, 'Germany (Federal Republic of)',211, null,null,null,null,null,null,null, 1, NULL,  '2020-03-26 16:55:41.0000000',	'9999-12-31 00:00:00.0000000')
	insert into edw.Dim_Vessel 
	values ('219006916', 'RI322 SINNE FRIHED', null, null, null, -1, 'Denmark',	219, null,null,null,null,null,null,null, 1, NULL,  '2020-03-26 16:55:41.0000000',	'9999-12-31 00:00:00.0000000')
	insert into edw.Dim_Vessel 
	values ('219013485','TOVE KAJGAARD',null, null, null,  -1, 'Denmark',	219, null,null,null,null,null,null,null, 1, NULL,  '2020-03-26 16:55:41.0000000',	'9999-12-31 00:00:00.0000000')
	insert into edw.Dim_Vessel 
	values ('219330000','NEPTUN AS 202',null, null, null, -1, 'Denmark',	219, null,null,null,null,null,null,null, 1, NULL,  '2020-03-26 16:55:41.0000000',	'9999-12-31 00:00:00.0000000')
	insert into edw.Dim_Vessel 
	values ('220334000', 'STINE FN396',	null, null, null,  -1, 'Denmark',	220, null,null,null,null,null,null,null, 1, NULL,  '2020-03-26 16:55:41.0000000',	'9999-12-31 00:00:00.0000000')
	insert into edw.Dim_Vessel 
	values ('222530728','BJORNSHOLM', null, null, null,  -1, 'not in use',	222, null,null,null,null,null,null,null, 1, NULL,  '2020-03-26 16:55:41.0000000',	'9999-12-31 00:00:00.0000000')
	insert into edw.Dim_Vessel 
	values ('244813000','BIT FORCE', null, null, null,  -1, 'Netherlands (Kingdom of the)',	244, null,null,null,null,null,null,null, 1, NULL,  '2020-03-26 16:55:41.0000000',	'9999-12-31 00:00:00.0000000')
	insert into edw.Dim_Vessel 
	values ('259896000', null,	null,null,null,  -1, 'Norway',	259,null,null,null,null,null,null,null, 1, NULL,  '2020-03-26 16:55:40.0000000',	'9999-12-31 00:00:00.0000000')
	insert into edw.Dim_Vessel 
	values ('311055900','SKANDI CONSTRUCTOR','9431642',	'C6ZH8 ',	70, 'Cargo, all ships of this type' ,  'Bahamas (Commonwealth of the)',	311, 42, 78, 120,  13,11, 24, 1, 1, NULL,  '2020-03-26 16:55:41.0000000',	'9999-12-31 00:00:00.0000000')

    --Prepare utility.Batch table to be pre-populated with 1 records, simulting a previous execution of the ETL
    insert into utility.Batch
	values (1,10,1,0,'2020-03-26 15:55:41.0000000',	'2020-03-26 16:05:41.0000000', GETDATE())


/*ACT and ASSERT combined, for better visualization*/
	
	-- run relevant SPs 
	execute [extract].[AIS_Data_CSV]'C:\AIS\Tests\test_DimVessel\Test11.csv'
	execute [archive].[AIS_Data_AddToArchive]
	execute [load].[Dim_Vessel_L]	
	execute utility.Add_Batch 1
	truncate table extract.AIS_Data


	 -- set rowCount for Dim_Vessel
	 set @rowCount_Dim_Vessel= (select count(*) from edw.Dim_Vessel )
	 -- evaluate if expected rowCount for Dim_Vessel is 2
	 EXEC tSQLt.AssertEqualsString 16, @rowCount_Dim_Vessel;  
	  
	-- set rowCount for the number of records that are not updated. *The records cross-refference [BatchCreated]=1 and [BatchUpdated]=null
	set @numberRecNotAffected= (select count(*) from edw.Dim_Vessel where BatchCreated=1 and BatchUpdated is null )
	-- evaluate if expected rowCount is 4
	EXEC tSQLt.AssertEqualsString 4, @numberRecNotAffected;
		
	-- set rowCount for the number of records that are updated and are no longer valid. *The records cross-refference [BatchCreated]=1 and [BatchUpdated]=2
	set @numberNonValidRec= (select count(*) from edw.Dim_Vessel where BatchCreated=1 and BatchUpdated=2 )	  
    --evaluate if expected rowCount is 6
    EXEC tSQLt.AssertEqualsString 6, @numberNonValidRec; 

	-- set rowCount for the number of records that are updated and are now valid. *The records cross-refference [BatchCreated]=1 and [BatchUpdated]=null
	 set @numberValidRec= (select count(*) from edw.Dim_Vessel where BatchCreated=2 and BatchUpdated is null )	 
    -- evaluate if expected rowCount is 6
    EXEC tSQLt.AssertEqualsString 6, @numberValidRec;  


end 

   --exec tsqlt.Run @TestName = '[testDimVessel].[Test11 - Insert from source file containing new records combined with updates for already existing ones]'