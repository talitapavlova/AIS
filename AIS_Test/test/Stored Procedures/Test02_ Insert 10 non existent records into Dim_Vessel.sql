



/******
	Test02: Insert 10 non existent records into Dim_Vessel

	- Dim_Vessel
		- no content


	
	- CSV content:
		- MMSI		|		Vessel Name		|		Latitude		|		Longitude		|		Speed Over Ground (SOG)		|		Course Over Ground (COG)	|		Received Time UTC		|	MID
		220142000	|	FN 321 LINE DALGAARD|		57° 47,567' N	|		10° 38,911' E	|				8,8					|			124,5					|		26-03-2020 17:23:17		|	Denmark
		265805860	|						|		56° 26,348' N	|		12° 35,750' E	|				28,1				|			338,7					|		26-03-2020 17:23:17		|	Sweden
		219006061	|	QUALYT[?			|		56° 34,793' N	|		7° 43,335' E	|				4,1					|			0,7						|		26-03-2020 17:23:17		|	Denmark
		220461000	|	ISAFOLD				|		57° 35,647' N	|		9° 58,524' E	|				0,0					|			120,4					|		26-03-2020 17:23:17		|	Denmark
		265829480	|	WESTERO:AV HONQ		|		57° 35,644' N	|		9° 57,481' E	|				0,0					|			237,1					|		26-03-2020 17:23:17		|	Sweden
		219023588	|						|		57° 24,990' N	|		8° 14,253' E	|				3,2					|			203,5					|		26-03-2020 17:23:17		|	Denmark
		355289000	|	MSC SUEZ			|		54° 32,733' N	|		11° 17,236' E	|				14,9				|			119,7					|		26-03-2020 17:23:17		|	Panama (Republic of)
		212499000	|	NILS DACKE			|		54° 59,182' N	|		13° 27,884' E	|				15,3				|			329,5					|		26-03-2020 17:23:18		|	Cyprus (Republic of)
		219461000	|	ARGONAUT			|		55° 35,590' N	|		12° 30,096'	E	|				7,1					|			11,9					|		26-03-2020 17:23:18		|	Denmark
		211141000	|	BIANCA RAMBOW		|		56° 11,576' N	|		7° 42,886' E	|				16,2				|			27,0					|		26-03-2020 17:23:18		|	Germany (Federal Republic of)


*****/

CREATE       PROCEDURE [test].[Test02: Insert 10 non existent records into Dim_Vessel]
AS
BEGIN

  DECLARE @rowCount_Dim_Vessel int

  IF OBJECT_ID('expected') IS NOT NULL DROP TABLE expected;

  -- truncate tables to have accurate test results 
  truncate table edw.Dim_Vessel
  truncate table dbo.AIS_Data

  -- ETL for Dim_Vessel records
  execute [extract].[AIS_Data_CSV]
  execute [load].[Dim_Vessel_L]



  /* METHOD 1 of testing - using table's records values */
  --create table expected, having the same structure as Dim_Vessel
  create table expected (
  [Vessel_Key] [int] NULL,
	[MMSI] [char](9) NULL,
	[MID] [nvarchar](100) NULL,
	[IMO] [char](10) NULL,
	[Type_of_mobile] [nvarchar](20) NULL,
	[Call_Sign] [nvarchar](20) NULL,
	[Vessel_Name] [nvarchar](100) NULL,
	[Ship_type] [nvarchar](50) NULL,
	[Width] [decimal](10, 2) NULL,
	[Length] [decimal](10, 2) NULL,
	[Draught] [decimal](10, 2) NULL,
	[Recieved_Time] [datetime2](7) NULL,
	[Valid_From] [datetime2](7) NULL,
	[Valid_To] [datetime2](7) NULL,
	[DateCreated] [datetime2](7) NULL
  )

  --values expected to be in Dim_Vessel after inserting the values from the CSV. file 
	insert into expected 
	values ( NULL, '211141000', 'Germany (Federal Republic of)', NULL, NULL, NULL, 'BIANCA RAMBOW',	NULL,	NULL,	NULL,	NULL,	NULL,	convert(varchar, GETDATE(), 0),	'9999-12-31 00:00:00.0000000' ,	NULL)
 
	insert into expected 
	values ( NULL,	'212499000',	'Cyprus (Republic of)',	NULL,	NULL,	NULL,	'NILS DACKE',	NULL,	NULL,	NULL,	NULL,	NULL,	convert(varchar, GETDATE(), 0),	'9999-12-31 00:00:00.0000000',	NULL)
 
	insert into expected 
	values( NULL,	'219006061',	'Denmark',	NULL,	NULL,	NULL,	'QUALYT[?',	NULL,	NULL,	NULL,	NULL,	NULL,	convert(varchar, GETDATE(), 0),	'9999-12-31 00:00:00.0000000',	NULL)
 
	insert into expected 
	values ( NULL,	'219023588',	'Denmark',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	convert(varchar, GETDATE(), 0),	'9999-12-31 00:00:00.0000000',	NULL)
 
	insert into expected 
	values ( NULL,	'219461000',	'Denmark',	NULL,	NULL,	NULL,	'ARGONAUT',	NULL,	NULL,	NULL,	NULL,	NULL,	convert(varchar, GETDATE(), 0),	'9999-12-31 00:00:00.0000000',	NULL)
 
	insert into expected 
	values ( NULL,	'220142000',	'Denmark',	NULL,	NULL,	NULL,	'FN 321 LINE DALGAARD',	 NULL,	NULL,	NULL,	NULL,	NULL,	convert(varchar, GETDATE(), 0),	'9999-12-31 00:00:00.0000000',	NULL)
 
	insert into expected 
	values ( NULL,	'220461000',	'Denmark',	NULL,	NULL,	NULL,	'ISAFOLD',	NULL,	NULL,	NULL,	NULL,	NULL,	convert(varchar, GETDATE(), 0),	'9999-12-31 00:00:00.0000000',	NULL)
 
	insert into expected 
	values ( NULL,	'265805860',	'Sweden',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	convert(varchar, GETDATE(), 0),	'9999-12-31 00:00:00.0000000',	NULL)
 
	insert into expected 
	values ( NULL,	'265829480',	'Sweden',	NULL,	NULL,	NULL,	'WESTERO:AV HONQ',	NULL,	NULL,	NULL,	NULL,	NULL,	convert(varchar, GETDATE(), 0),	'9999-12-31 00:00:00.0000000',	NULL)
 
	insert into expected 
	values ( NULL,	'355289000',	'Panama (Republic of)',	NULL,	NULL,	NULL,	'MSC SUEZ',	NULL,	NULL,	NULL,	NULL,	NULL,	convert(varchar, GETDATE(), 0),	'9999-12-31 00:00:00.0000000',	NULL)
  
  -- evaluate the actual table (Dim_Vessel) and the expected table
  EXEC tSQLt.AssertEqualsTable 'expected', 'edw.Dim_Vessel';
  


  
 /* METHOD 2 of testing - using row count */
 
 -- set rowCount for Dim_Vessel
 set @rowCount_Dim_Vessel= (select count(*) from edw.Dim_Vessel )
 
 -- evaluate if expected rowCount for Dim_Vessel is 2
 EXEC tSQLt.AssertEqualsString 10, @rowCount_Dim_Vessel;  



end

-- exec tsqlt.Run @TestName = '[test].[Test02: Insert 10 non existent records into Dim_Vessel]'