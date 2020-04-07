



/******
	Test01: Insert one record into Dim_Vessel

	- Dim_Vessel
		- no content


	
	- CSV content:
		- MMSI		|		Vessel Name		|		Latitude		|		Longitude		|		Speed Over Ground (SOG)		|		Course Over Ground (COG)	|		Received Time UTC		|	MID
		220142000	|	FN 321 LINE DALGAARD|		57° 47,567' N	|		10° 38,911' E	|				8,8					|			124,5					|		26-03-2020 17:23:17		|	Denmark

*****/

CREATE      PROCEDURE [test].[Test01: Insert one record into Dim_Vessel]
AS
BEGIN
  IF OBJECT_ID('expected') IS NOT NULL DROP TABLE expected;
  

  -- truncate tables to have accurate test results 
  truncate table edw.Dim_Vessel
  truncate table dbo.AIS_Data

  -- ETL for Dim_Vessel records
  execute [extract].[AIS_Data_CSV]
  execute [load].[Dim_Vessel_L]

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
	values ( NULL,	'220142000',	'Denmark',	NULL,	NULL,	NULL,	'FN 321 LINE DALGAARD',	 NULL,	NULL,	NULL,	NULL,	NULL,	convert(varchar, GETDATE(), 0),	'9999-12-31 00:00:00.0000000',	NULL)
  
  -- evaluate the actual table (Dim_Vessel) and the expected table
  EXEC tSQLt.AssertEqualsTable 'expected', 'edw.Dim_Vessel';
  
end

-- exec tsqlt.Run @TestName = '[test].[Test01: Insert non existent records into Dim_Vessel]'