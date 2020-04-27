


/*
Change log: 
	2020-04-10	NP	Stored procedure created; Unknowns for Dim_Vessel
*/

CREATE   PROCEDURE [utility].[Add_Unknowns]
AS

/*
Insert unknown values into Dim_Vessel
*/
SET IDENTITY_INSERT edw.Dim_Vessel ON
INSERT INTO edw.Dim_Vessel (
	Vessel_Key,
	MMSI,
	Vessel_Name,
	MID,
	MID_Number,
	IMO,
	Call_Sign,
	Ship_Type,
	Dimension_To_Bow,
	Dimension_To_Stern,
	Length, 
	Dimension_To_Port,
	Dimension_To_Starboard,
	Beam,
	Position_Type_Fix,
	BatchCreated,
	BatchUpdated,
	Valid_From, 
	Valid_To) 
VALUES ( 
	-1,	
	'Unknown',
	'Unknown',
	'Unknown',
	-1,
	'Unknown',
	'Unknown',
	-1,
	-1,
	-1,
	-1, 
	-1,
	-1,
	-1,
	-1,
	-1,
	-1,
	NULL,
	NULL
)
SET IDENTITY_INSERT edw.Dim_Vessel OFF