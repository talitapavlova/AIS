


CREATE PROCEDURE [load].[Add_Batch] (@c smallint, @timestamp datetime2 OUTPUT)
AS
BEGIN

SELECT  @timestamp = getdate()

INSERT INTO utility.Batch (
	Batch,
	IsContinuousData,
	IsHistoricalData,
	DateCreated )
SELECT 	
	ISNULL(MAX(Batch) + 1, 1),
	@c,
	CASE 
		WHEN @c = 1 THEN 0
		ELSE 1
	END,
	@timestamp			
FROM utility.Batch

END