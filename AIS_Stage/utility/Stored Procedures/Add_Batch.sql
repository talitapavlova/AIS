


CREATE PROCEDURE [utility].[Add_Batch] (@continuous smallint)
AS
BEGIN

INSERT INTO utility.Batch (
	Batch,
	TotalRows,
	IsContinuousData,
	IsHistoricalData,
	MinReceivedTime,
	MaxReceivedTime,
	DateCreated )
SELECT DISTINCT
	Batch,
	count(*),
	@continuous,
	ABS(@continuous - 1),
	MIN(ReceivedTime),
	MAX(ReceivedTime),
	GETDATE()		
FROM extract.AIS_Data
GROUP BY Batch

END