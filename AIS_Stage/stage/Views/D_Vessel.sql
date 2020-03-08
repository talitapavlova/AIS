/*
Change log: 
	2020-02-27	NP	View created
	2020-03-05	NP	Added example temp tables 
*/

CREATE VIEW [stage].[D_Vessel] as

WITH 
temp_VesselInfo as(
SELECT 
	1 as ID,
	getdate() as ValidFrom,
	getdate() as ValidTo

),

temp_VesselTransform as(
SELECT
	ID,
	ValidFrom,
	ValidTo
FROM temp_VesselInfo
)

SELECT 
	ID,
	ValidFrom,
	ValidTo
FROM temp_VesselTransform
GO

