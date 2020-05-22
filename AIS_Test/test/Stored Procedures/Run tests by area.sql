CREATE PROCEDURE [test].[Run tests by area]
AS
	EXEC tSQLt.Run '[testDimVessel]'
	EXEC tSQLt.Run '[testBatch]'
	EXEC tSQLt.Run '[testDimVoyage]'
	EXEC tSQLt.Run '[testFactRoute]'
	EXEC tSQLt.Run '[testEventLog]'