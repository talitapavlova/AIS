

CREATE PROCEDURE [utility].[Add_Batch] (@continuous smallint)
AS
BEGIN

INSERT INTO utility.Batch (
	Batch,
	TotalRows,
	IsContinuousData,
	IsHistoricalData,
	DateCreated )
SELECT DISTINCT
	Batch,
	count(*),
	@continuous,
	CASE 
		WHEN @continuous = 1 THEN 0
		ELSE 1
	END,
	MAX(RecievedTime)		
FROM extract.AIS_Data
GROUP BY Batch

END