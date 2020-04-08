

-- Test04 - Insert one already existing records containg update(s).

CREATE    PROCEDURE [test].[Test04 - Insert one already existing records containg update(s). ]
AS
BEGIN
 DECLARE @rowCount_Dim_Vessel int
   
   IF OBJECT_ID('expected') IS NOT NULL DROP TABLE expected;
 
  -- truncate tables to have accurate test results 
  truncate table edw.Dim_Vessel
  truncate table dbo.AIS_Data

  --Prepare Dim_Vessel 
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


	-- ETL for Dim_Vessel to insert the follwoing CSV. file records
	execute [extract].[AIS_Data_CSV]
	execute [load].[Dim_Vessel_L]
	
	/*   CSV content:
		- MMSI		|	Vessel Name								|		Latitude		|		Longitude		|		Speed Over Ground (SOG)		|		Course Over Ground (COG)	|		Received Time UTC		|	MID
		211141000	|	Updated_Name BIANCA RAMBOW				|		56° 11,576' N	|		7° 42,886' E	|				16,2				|			27,0					|		26-03-2020 17:23:18		|	Spain

	*/

 
 -- set rowCount for Dim_Vessel
 set @rowCount_Dim_Vessel= (select count(*) from edw.Dim_Vessel )
 
 -- evaluate if expected rowCount for Dim_Vessel is 2
 EXEC tSQLt.AssertEqualsString 11, @rowCount_Dim_Vessel;  
 
end 

 -- exec tsqlt.Run @TestName = '[test].[Test04 - Insert one already existing records containg update(s). ]'