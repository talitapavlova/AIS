


/*
Change log: 
	2020-02-27	NP	View created
*/

CREATE VIEW [stage].[D_Vessel] as

SELECT 
	1 as ID,
	getdate() as ValidFrom,
	getdate() as ValidTo