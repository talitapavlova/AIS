






-- Test06 - Insert already existing record containg update(s). Follow the records behavior and check for values

CREATE      PROCEDURE [test].[Test06 - Insert already existing record containg update(s). Follow the records behavior and check for values]
AS
BEGIN
  DECLARE @rowCount_Dim_Vessel int

  DECLARE @oldName varchar(100);
  DECLARE @updatedName varchar(100);

  DECLARE @oldMID varchar(100);
  DECLARE @updatedMID varchar(100);


 IF OBJECT_ID('expected') IS NOT NULL DROP TABLE expected;
 
	-- truncate tables to have accurate test results 
	truncate table edw.Dim_Vessel
	truncate table dbo.AIS_Data

   --Prepare Dim_Vessel to already contain the following value
	insert into edw.Dim_Vessel 
	values ( NULL, '211141000', 'Germany (Federal Republic of)', NULL, NULL, NULL, 'BIANCA RAMBOW',	NULL,	NULL,	NULL,	NULL,	NULL,	convert(varchar, GETDATE(), 0),	'9999-12-31 00:00:00.0000000' ,	NULL)
 
	insert into  edw.Dim_Vessel  
	values ( NULL,	'212499000',	'Cyprus (Republic of)',	NULL,	NULL,	NULL,	'NILS DACKE',	NULL,	NULL,	NULL,	NULL,	NULL,	convert(varchar, GETDATE(), 0),	'9999-12-31 00:00:00.0000000',	NULL)
 
	insert into  edw.Dim_Vessel  
	values ( NULL,	'219461000',	'Denmark',	NULL,	NULL,	NULL,	'ARGONAUT',	NULL,	NULL,	NULL,	NULL,	NULL,	convert(varchar, GETDATE(), 0),	'9999-12-31 00:00:00.0000000',	NULL)
 
	insert into  edw.Dim_Vessel  
	values ( NULL,	'355289000',	'Panama (Republic of)',	NULL,	NULL,	NULL,	'MSC SUEZ',	NULL,	NULL,	NULL,	NULL,	NULL,	convert(varchar, GETDATE(), 0),	'9999-12-31 00:00:00.0000000',	NULL)	

	/*  Dim_Vessel contains the following record:
	
	Vessel_Key			MMSI			MID								IMO			Type_of_mobile		Call_Sign		Vessel_Name				Ship_type		Width		Length		Draught		Recieved_Time			Valid_From							Valid_To							DateCreated
	--	NULL			211141000		Germany (Federal Republic of)	NULL		NULL				NULL			BIANCA RAMBOW			NULL			NULL		NULL		NULL		NULL					2020-04-07 12:24:00.0000000			9999-12-31 00:00:00.0000000			NULL
	--	NULL			212499000		Cyprus (Republic of)			NULL		NULL				NULL			NILS DACKE				NULL			NULL		NULL		NULL		NULL					2020-04-07 12:24:00.0000000			9999-12-31 00:00:00.0000000			NULL	
	--	NULL			219461000		Denmark							NULL		NULL				NULL			ARGONAUT				NULL			NULL		NULL		NULL		NULL					2020-04-07 12:24:00.0000000			9999-12-31 00:00:00.0000000			NULL	
	--	NULL			355289000		Panama (Republic of)			NULL		NULL				NULL			MSC SUEZ				NULL			NULL		NULL		NULL		NULL					2020-04-07 12:24:00.0000000			9999-12-31 00:00:00.0000000			NULL	
	*/

   -- ETL for Dim_Vessel to insert the following CSV. file records
	execute [extract].[AIS_Data_CSV]
	execute [load].[Dim_Vessel_L]
	
	/*   CSV content:
		- MMSI		|	Vessel Name								|		Latitude		|		Longitude		|		Speed Over Ground (SOG)		|		Course Over Ground (COG)	|		Received Time UTC		|	MID
		211141000	|	Updated_Name BIANCA RAMBOW				|		56° 11,576' N	|		7° 42,886' E	|				16,2				|			27,0					|		26-03-2020 17:23:18		|	Spain

	*/

	set @rowCount_Dim_Vessel= (select count(*) from edw.Dim_Vessel where MMSI = '355289000')
	EXEC tSQLt.AssertEqualsString 2, @rowCount_Dim_Vessel; 
 	
	-- The date will never be the same. Find a solution
	--set @oldName = ( select Vessel_Name from edw.Dim_Vessel where MMSI = '355289000' and  Valid_To = CONVERT(varchar, getdate(), 0))
	--EXEC tSQLt.AssertEqualsString 'MSC SUEZ' , @oldName;  
	
	set @updatedName = (select Vessel_Name from edw.Dim_Vessel where MMSI = '355289000' and Valid_To = '9999-12-31 00:00:00.0000000')
	EXEC tSQLt.AssertEqualsString 'Test Update MSC SUEZ', @updatedName;  


	-- The date will never be the same. Find a solution
	--set @oldMID = ( select Vessel_Name from edw.Dim_Vessel where MMSI = '355289000' and  Valid_To = CONVERT(varchar, getdate(), 0))
	--EXEC tSQLt.AssertEqualsString 'Panama (Republic of)' , @oldMID;  
	
	set @updatedMID = (select MID from edw.Dim_Vessel where MMSI = '355289000' and Valid_To = '9999-12-31 00:00:00.0000000')
	EXEC tSQLt.AssertEqualsString 'Test Update Panama (Republic of)', @updatedMID;  

    

end
  --exec tsqlt.Run @TestName = '[test].[Test06 - Insert already existing record containg update(s). Follow the records behavior and check for values]'