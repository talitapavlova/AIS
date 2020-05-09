




-- Run All tests

CREATE    PROCEDURE [test].[Run all the tests]
AS
	EXEC tSQLt.Run '[testDimVessel]'
	EXEC tSQLt.Run '[testBatch]'