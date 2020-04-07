






/****** Test05:  Insert already existing records containing updates for 6 records and no updates for the other 4 */

CREATE      PROCEDURE [test].[Test05 - Insert already existing records containing updates for 6 records and no updates for the other 4]
AS
BEGIN
 
  DECLARE @rowCount_Dim_Vessel int
  
  IF OBJECT_ID('expected') IS NOT NULL DROP TABLE expected;
 
  -- truncate tables to have accurate test results 
  truncate table edw.Dim_Vessel
  truncate table dbo.AIS_Data

  --Prepare Dim_Vessel to already - contain following values
	insert into edw.Dim_Vessel 
	values ( NULL, '211141000', 'Germany (Federal Republic of)', NULL, NULL, NULL, 'BIANCA RAMBOW',	NULL,	NULL,	NULL,	NULL,	NULL,	convert(varchar, GETDATE(), 0),	'9999-12-31 00:00:00.0000000' ,	NULL)
 
	insert into  edw.Dim_Vessel  
	values ( NULL,	'212499000',	'Cyprus (Republic of)',	NULL,	NULL,	NULL,	'NILS DACKE',	NULL,	NULL,	NULL,	NULL,	NULL,	convert(varchar, GETDATE(), 0),	'9999-12-31 00:00:00.0000000',	NULL)
 
	insert into  edw.Dim_Vessel  
	values( NULL,	'219006061',	'Denmark',	NULL,	NULL,	NULL,	'QUALYT[?',	NULL,	NULL,	NULL,	NULL,	NULL,	convert(varchar, GETDATE(), 0),	'9999-12-31 00:00:00.0000000',	NULL)
 
	insert into  edw.Dim_Vessel  
	values ( NULL,	'219023588',	'Denmark',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	convert(varchar, GETDATE(), 0),	'9999-12-31 00:00:00.0000000',	NULL)
 
	insert into  edw.Dim_Vessel  
	values ( NULL,	'219461000',	'Denmark',	NULL,	NULL,	NULL,	'ARGONAUT',	NULL,	NULL,	NULL,	NULL,	NULL,	convert(varchar, GETDATE(), 0),	'9999-12-31 00:00:00.0000000',	NULL)
 
	insert into  edw.Dim_Vessel  
	values ( NULL,	'220142000',	'Denmark',	NULL,	NULL,	NULL,	'FN 321 LINE DALGAARD',	 NULL,	NULL,	NULL,	NULL,	NULL,	convert(varchar, GETDATE(), 0),	'9999-12-31 00:00:00.0000000',	NULL)
 
	insert into  edw.Dim_Vessel  
	values ( NULL,	'220461000',	'Denmark',	NULL,	NULL,	NULL,	'ISAFOLD',	NULL,	NULL,	NULL,	NULL,	NULL,	convert(varchar, GETDATE(), 0),	'9999-12-31 00:00:00.0000000',	NULL)
 
	insert into  edw.Dim_Vessel  
	values ( NULL,	'265805860',	'Sweden',	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	convert(varchar, GETDATE(), 0),	'9999-12-31 00:00:00.0000000',	NULL)
 
	insert into  edw.Dim_Vessel  
	values ( NULL,	'265829480',	'Sweden',	NULL,	NULL,	NULL,	'WESTERO:AV HONQ',	NULL,	NULL,	NULL,	NULL,	NULL,	convert(varchar, GETDATE(), 0),	'9999-12-31 00:00:00.0000000',	NULL)
 
	insert into  edw.Dim_Vessel  
	values ( NULL,	'355289000',	'Panama (Republic of)',	NULL,	NULL,	NULL,	'MSC SUEZ',	NULL,	NULL,	NULL,	NULL,	NULL,	convert(varchar, GETDATE(), 0),	'9999-12-31 00:00:00.0000000',	NULL)	
	
	/*  Dim_Vessel contains the following records
	--	Vessel_Key		MMSI			MID								IMO			Type_of_mobile		Call_Sign		Vessel_Name				Ship_type		Width		Length		Draught		Recieved_Time			Valid_From							Valid_To							DateCreated
	--	NULL			211141000		Germany (Federal Republic of)	NULL		NULL				NULL			BIANCA RAMBOW			NULL			NULL		NULL		NULL		NULL					2020-04-07 12:24:00.0000000			9999-12-31 00:00:00.0000000			NULL
	--	NULL			212499000		Cyprus (Republic of)			NULL		NULL				NULL			NILS DACKE				NULL			NULL		NULL		NULL		NULL					2020-04-07 12:24:00.0000000			9999-12-31 00:00:00.0000000			NULL
	--	NULL			219006061		Denmark							NULL		NULL				NULL			QUALYT[?				NULL			NULL		NULL		NULL		NULL					2020-04-07 12:24:00.0000000			9999-12-31 00:00:00.0000000			NULL
	--	NULL			219023588		Denmark							NULL		NULL				NULL			NULL					NULL			NULL		NULL		NULL		NULL					2020-04-07 12:24:00.0000000			9999-12-31 00:00:00.0000000			NULL
	--	NULL			219461000		Denmark							NULL		NULL				NULL			ARGONAUT				NULL			NULL		NULL		NULL		NULL					2020-04-07 12:24:00.0000000			9999-12-31 00:00:00.0000000			NULL
	--	NULL			220142000		Denmark							NULL		NULL				NULL			FN 321 LINE DALGAARD	NULL			NULL		NULL		NULL		NULL					2020-04-07 12:24:00.0000000			9999-12-31 00:00:00.0000000			NULL
	--	NULL			220461000		Denmark							NULL		NULL				NULL			ISAFOLD					NULL			NULL		NULL		NULL		NULL					2020-04-07 12:24:00.0000000			9999-12-31 00:00:00.0000000			NULL
	--	NULL			265805860		Sweden							NULL		NULL				NULL			NULL					NULL			NULL		NULL		NULL		NULL					2020-04-07 12:24:00.0000000			9999-12-31 00:00:00.0000000			NULL
	--	NULL			265829480		Sweden							NULL		NULL				NULL			WESTERO:AV HONQ			NULL			NULL		NULL		NULL		NULL					2020-04-07 12:24:00.0000000			9999-12-31 00:00:00.0000000			NULL
	--	NULL			355289000		Panama (Republic of)			NULL		NULL				NULL			MSC SUEZ				NULL			NULL		NULL		NULL		NULL					2020-04-07 12:24:00.0000000			9999-12-31 00:00:00.0000000			NULL
	*/


	-- ETL for Dim_Vessel to insert the following CSV. file records
	execute [extract].[AIS_Data_CSV]
	execute [load].[Dim_Vessel_L]
	
	/*   CSV content:
		- MMSI		|	Vessel Name								|		Latitude		|		Longitude		|		Speed Over Ground (SOG)		|		Course Over Ground (COG)	|		Received Time UTC		|	MID
		220142000	|	Updated_TestName FN 321 LINE DALGAARD	|		57° 47,567' N	|		10° 38,911' E	|				8,8					|			124,5					|		26-03-2020 17:23:17		|	Denmark
		265805860	|	Updated_TestName 						|		56° 26,348' N	|		12° 35,750' E	|				28,1				|			338,7					|		26-03-2020 17:23:17		|	Sweden
		219006061	|	Updated_TestName QUALYT[?				|		56° 34,793' N	|		7° 43,335' E	|				4,1					|			0,7						|		26-03-2020 17:23:17		|	Denmark
		220461000	|	Updated_TestName ISAFOLD				|		57° 35,647' N	|		9° 58,524' E	|				0,0					|			120,4					|		26-03-2020 17:23:17		|	Denmark
		265829480	|	Updated_TestName WESTERO:AV HONQ		|		57° 35,644' N	|		9° 57,481' E	|				0,0					|			237,1					|		26-03-2020 17:23:17		|	Sweden
		219023588	|	Updated_TestName 						|		57° 24,990' N	|		8° 14,253' E	|				3,2					|			203,5					|		26-03-2020 17:23:17		|	Denmark
		355289000	|	MSC SUEZ								|		54° 32,733' N	|		11° 17,236' E	|				14,9				|			119,7					|		26-03-2020 17:23:17		|	Panama (Republic of)
		212499000	|	NILS DACKE								|		54° 59,182' N	|		13° 27,884' E	|				15,3				|			329,5					|		26-03-2020 17:23:18		|	Cyprus (Republic of)
		219461000	|	ARGONAUT								|		55° 35,590' N	|		12° 30,096'	E	|				7,1					|			11,9					|		26-03-2020 17:23:18		|	Denmark
		211141000	|	BIANCA RAMBOW							|		56° 11,576' N	|		7° 42,886' E	|				16,2				|			27,0					|		26-03-2020 17:23:18		|	Germany (Federal Republic of)

	*/

 
 -- set rowCount for Dim_Vessel
 set @rowCount_Dim_Vessel= (select count(*) from edw.Dim_Vessel )
 
 -- evaluate if expected rowCount for Dim_Vessel is 2
 EXEC tSQLt.AssertEqualsString 16, @rowCount_Dim_Vessel;  
 
end 

   --exec tsqlt.Run @TestName = '[test].[Test05 - Insert already existing records containing updates for 6 records and no updates for the other 4]'