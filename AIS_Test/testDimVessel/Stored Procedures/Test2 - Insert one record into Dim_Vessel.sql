









/******
	Test2: Insert one record into Dim_Vessel

	- Dim_Vessel
		- no content

	- CSV content:
			~MMSI|AIS Message Type|Longitude|Latitude|MID Number|MID|Navigation Status|Rate of Turn (ROT)|Speed Over Ground (SOG)|Position Accuracy|Course Over Ground (COG)|True Heading (HDG)|Manoeuvre Indicator|RAIM Flag|Repeat Indicator|Received Time UTC-Unix|Vessel Name|IMO Number|Call Sign|Ship Type|Dimension to Bow|Dimension to Stern|Length|Dimension to Port|Dimension to Starboard|Beam|Position Type Fix|ETA month|ETA day|ETA hour|ETA minute|Draught|Destination
			311055900|5|||311|Bahamas (Commonwealth of the)|||||||||0|26-03-2020 16:55:41|SKANDI CONSTRUCTOR|9431642|C6ZH8  |70|42|78|120|13|11|24|1|03|21|12|34|5,5|ODENSE 

*****/

CREATE     PROCEDURE [testDimVessel].[Test2 - Insert one record into Dim_Vessel]
AS
BEGIN
  IF OBJECT_ID('expected') IS NOT NULL DROP TABLE expected;
  

  -- truncate tables to have accurate test results 
  truncate table edw.Dim_Vessel
  truncate table extract.AIS_Data
  truncate table utility.Batch

  -- ETL for Dim_Vessel records
  execute [extract].[AIS_Data_CSV]'C:\AIS\Tests\Test2.csv'
  execute [load].[Dim_Vessel_L]

  --create table expected, having the same structure as Dim_Vessel
  create table expected (
	[Vessel_Key] [int] IDENTITY(1,1) NOT NULL,
	[MMSI] [char](9) NOT NULL,
	[Vessel_Name] [nvarchar](200) NULL,
	[IMO] [nvarchar](10) NULL,
	[Call_Sign] [nvarchar](10) NULL,
	[Ship_Type] [int] NULL,
	[MID] [nvarchar](100) NULL,
	[MID_Number] [int] NULL,
	[Dimension_To_Bow] [int] NULL,
	[Dimension_To_Stern] [int] NULL,
	[Length] [int] NULL,
	[Dimension_To_Port] [int] NULL,
	[Dimension_To_Starboard] [int] NULL,
	[Beam] [int] NULL,
	[Position_Type_Fix] [int] NULL,
	[BatchCreated] [int] NULL,
	[BatchUpdated] [int] NULL,
	[Valid_From] [datetime2](7) NULL,
	[Valid_To] [datetime2](7) NULL,
  )

  --values expected to be in Dim_Vessel after inserting the values from the CSV. file 
	insert into expected
	values ('311055900','SKANDI CONSTRUCTOR',	'9431642',	'C6ZH8 ',	70,	   'Bahamas (Commonwealth of the)',	311, 42, 78, 120,  13,11, 24, 1, 1, NULL,  '2020-03-26 16:55:41.0000000',	'9999-12-31 00:00:00.0000000')
  
  -- evaluate the actual table (Dim_Vessel) and the expected table
  EXEC tSQLt.AssertEqualsTable 'expected', 'edw.Dim_Vessel';
  
end

-- exec tsqlt.Run @TestName = '[testDimVessel].[Test2 - Insert one record into Dim_Vessel]'