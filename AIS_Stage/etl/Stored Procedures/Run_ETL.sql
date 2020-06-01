





/*
Change log: 
	2020-05-08	NP	Stored procedure created
	2020-05-18	NP	Added the event log table logic with added error loging
*/

CREATE PROCEDURE [etl].[Run_ETL] (@continuous smallint, @File nvarchar(200) = 'C:\AIS\output_in_use.csv')
AS

BEGIN
DECLARE 
	@batch int = (SELECT ISNULL(1, MAX(Batch)) FROM utility.Batch),
	@ErrorMessage  nvarchar(4000), 
    @ErrorSeverity int;

BEGIN TRY
	BEGIN TRANSACTION
		EXEC extract.AIS_Data_CSV @File
		EXEC archive.AIS_Data_AddToArchive
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
		FROM archive.AIS_Data_archive
		WHERE Batch > @batch
		GROUP BY Batch

		TRUNCATE table extract.AIS_Data

		INSERT INTO utility.Event_Log (
			Batch,
			Severity,
			Message,
			Message_type
			)
		VALUES (
			@batch + 1,
			0,
			'Batch load succeeded',
			'success' )

	COMMIT
END TRY

BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRAN

		SELECT 
			@ErrorMessage = ERROR_MESSAGE(), 
			@ErrorSeverity = ERROR_SEVERITY()

		INSERT INTO utility.Event_Log (
			Batch,
			Severity,
			Message,
			Message_type
			)
		VALUES (
			@batch + 1,
			@ErrorSeverity,
			@ErrorMessage,
			'error' );
	THROW;

END CATCH
END