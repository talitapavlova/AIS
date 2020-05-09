


/*
Change log: 
	2020-05-08	NP	Stored procedure created
*/

CREATE PROCEDURE [etl].[Run_ETL] (@continuous smallint)
AS

BEGIN TRY
	BEGIN TRANSACTION
		EXEC extract.AIS_Data_CSV
		EXEC load.Dim_Vessel_L
		EXEC load.Dim_Voyage_L
		EXEC load.Fact_Route_L

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

		EXEC archive.AIS_Data_AddToArchive

		TRUNCATE table extract.AIS_Data
	COMMIT
END TRY

BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRAN
END CATCH