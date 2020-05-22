


-- Run All tests

CREATE       PROCEDURE [test].[Run all the tests]
AS
	EXEC tSQLt.Run '[testDimVessel]'
	EXEC tSQLt.Run '[testBatch]'
	EXEC tSQLt.Run '[testDimVoyage]'
	EXEC tSQLt.Run '[testFactRoute]'