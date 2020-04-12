



/****** Test7:  Insert already existing records containing updates for 6 records and no updates for the other 4 */

CREATE     PROCEDURE [testDimVessel].[Test7 - Insert already existing records containing no updates for 4 records and few updates for the other 6]
AS
BEGIN
 
  DECLARE @rowCount_Dim_Vessel int
  
  IF OBJECT_ID('expected') IS NOT NULL DROP TABLE expected;
 
  -- truncate tables to have accurate test results 
  truncate table edw.Dim_Vessel
  truncate table extract.AIS_Data
  truncate table utility.Batch

 --Prepare Dim_Vessel to be pre-populated with 10 records
	insert into edw.Dim_Vessel 
	values ('205769000', null, null, null, null, 'Belgium',205, null, null, null, null, null, null, null, 1, NULL,  '2020-03-26 16:55:41.0000000',	'9999-12-31 00:00:00.0000000')
	insert into edw.Dim_Vessel 
	values ('211789180','IRIS' ,null, null, null,'Germany (Federal Republic of)',211, null,null,null,null,null,null,null, 1, NULL,  '2020-03-26 16:55:41.0000000',	'9999-12-31 00:00:00.0000000')
	insert into edw.Dim_Vessel 
	values ('219006916', 'RI322 SINNE FRIHED', null, null, null,'Denmark',	219, null,null,null,null,null,null,null, 1, NULL,  '2020-03-26 16:55:41.0000000',	'9999-12-31 00:00:00.0000000')
	insert into edw.Dim_Vessel 
	values ('219013485','TOVE KAJGAARD',null, null, null, 'Denmark',	219, null,null,null,null,null,null,null, 1, NULL,  '2020-03-26 16:55:41.0000000',	'9999-12-31 00:00:00.0000000')
	insert into edw.Dim_Vessel 
	values ('219330000','NEPTUN AS 202',null, null, null,'Denmark',	219, null,null,null,null,null,null,null, 1, NULL,  '2020-03-26 16:55:41.0000000',	'9999-12-31 00:00:00.0000000')
	insert into edw.Dim_Vessel 
	values ('220334000', 'STINE FN396',	null, null, null, 'Denmark',	220, null,null,null,null,null,null,null, 1, NULL,  '2020-03-26 16:55:41.0000000',	'9999-12-31 00:00:00.0000000')
	insert into edw.Dim_Vessel 
	values ('222530728','BJORNSHOLM', null, null, null, 'not in use',	222, null,null,null,null,null,null,null, 1, NULL,  '2020-03-26 16:55:41.0000000',	'9999-12-31 00:00:00.0000000')
	insert into edw.Dim_Vessel 
	values ('244813000','BIT FORCE', null, null, null, 'Netherlands (Kingdom of the)',	244, null,null,null,null,null,null,null, 1, NULL,  '2020-03-26 16:55:41.0000000',	'9999-12-31 00:00:00.0000000')
	insert into edw.Dim_Vessel 
	values ('259896000', null,	null,null,null, 'Norway',	259,null,null,null,null,null,null,null, 1, NULL,  '2020-03-26 16:55:40.0000000',	'9999-12-31 00:00:00.0000000')
	insert into edw.Dim_Vessel 
	values ('311055900','SKANDI CONSTRUCTOR','9431642',	'C6ZH8 ',	70,	   'Bahamas (Commonwealth of the)',	311, 42, 78, 120,  13,11, 24, 1, 1, NULL,  '2020-03-26 16:55:41.0000000',	'9999-12-31 00:00:00.0000000')


	-- ETL for Dim_Vessel to insert the following CSV. file records, consisting of 10 already existing record in Dim_Vessel, where first 4 contain no updates and the next 6 contain few updates 
	execute [extract].[AIS_Data_CSV]'C:\AIS\Tests\Test7.csv'
	execute [load].[Dim_Vessel_L]
	
	/*   CSV content:
			~MMSI|AIS Message Type|Longitude|Latitude|MID Number|MID|Navigation Status|Rate of Turn (ROT)|Speed Over Ground (SOG)|Position Accuracy|Course Over Ground (COG)|True Heading (HDG)|Manoeuvre Indicator|RAIM Flag|Repeat Indicator|Received Time UTC-Unix|Vessel Name|IMO Number|Call Sign|Ship Type|Dimension to Bow|Dimension to Stern|Length|Dimension to Port|Dimension to Starboard|Beam|Position Type Fix|ETA month|ETA day|ETA hour|ETA minute|Draught|Destination
			244813000|5|8.597500|57.854670|244|Netherlands (Kingdom of the)|0|7|13,6|0|68,0|66|0|0|0|26-03-2020 16:55:41|BIT FORCE||||||||||||||||
			219006916|5|8.127717|56.001370|219|Denmark|15|-128|0,0|0|254,7|511|0|0|0|26-03-2020 16:55:41|RI322 SINNE FRIHED||||||||||||||||
			219330000|5|11.739600|56.325370|219|Denmark|7|0|10,7|1|282,6|281|0|0|0|26-03-2020 16:55:41|NEPTUN AS 202||||||||||||||||
			205769000|5|6.599771|55.815250|205|Belgium|0|0|13,8|0|210,1|206|0|0|0|26-03-2020 16:55:41|||||||||||||||||
			219013485|5|||311|Bahamas (Commonwealth of the)|||||||||0|26-03-2020 16:55:41|SKANDI CONSTRUCTOR|9431642|C6ZH8  |70|42|78|120|13|11|24|1|03|21|12|34|5,5|ODENSE 
			211789180|5|6.979007|56.625840|211|Germany (Federal Republic of)|0|-5|19,7|1|250,1|249|0|0|0|26-03-2020 16:55:47|STENA JUTLANDICA|9125944|SEAN@@@|64|30|153|183|28|5|33|1|03|26|18|15|6|SE GOT>DK FDH>SE GOT
			220334000|5|11.126950|57.321250|220|Denmark|7|0|0,0|0|239,6|155|0|0|0|26-03-2020 16:55:41|DELIA|9234317|V2AB4@@|70|73|16|89|7|5|12|0|03|30|05|00|4,7|NOGLO@@@@@@@@@@@@@@@
			259896000|5|12.050940|54.408540|259|Norway|0|0|12,7|0|90,1|90|0|0|0|26-03-2020 16:55:40|ADVANTAGE POINT|9327384|V7TL5@@|80|149|34|183|22|5|27|1|03|26|23|00|6,9|SE GOT@@@@@@@@@@@@@@
			222530728|5|12.311000|56.126280|222|not in use|0|-128|0,1|0|226,0|511|0|0|0|26-03-2020 16:55:49|SOE BONDE SILLERSLEV|0|OXNS   |30|8|7|15|2|3|5|15|00|00|24|60|1|LIMFJORDEN
			311055900|5|||311|Bahamas (Commonwealth of the)|||||||||0|26-03-2020 16:55:49|FEGGESUND|9640918|OZMW|60|20|14|34|5|6|11|1|00|00|00|00|5|CROSSING  		26-03-2020 17:23:18		|	Germany (Federal Republic of)

	*/

 
 -- set rowCount for Dim_Vessel
 set @rowCount_Dim_Vessel= (select count(*) from edw.Dim_Vessel )
 
 -- evaluate if expected rowCount for Dim_Vessel is 2
 EXEC tSQLt.AssertEqualsString 16, @rowCount_Dim_Vessel;  
 
end 

   --exec tsqlt.Run @TestName = '[testDimVessel].[Test7 - Insert already existing records containing no updates for 4 records and few updates for the other 6]'