CREATE TABLE [utility].[Batch] (
    [Batch]            INT           NOT NULL,
    [TotalRows]        INT           NOT NULL,
    [IsContinuousData] TINYINT       NULL,
    [IsHistoricalData] TINYINT       NULL,
    [MinReceivedTime]  DATETIME2 (7) NULL,
    [MaxReceivedTime]  DATETIME2 (7) NULL,
    [DateCreated]      DATETIME2 (7) NULL
);

