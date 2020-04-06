CREATE TABLE [utility].[Batch] (
    [Batch]            INT           NOT NULL,
    [TotalRows]        INT           NOT NULL,
    [IsContinuousData] TINYINT       NULL,
    [IsHistoricalData] TINYINT       NULL,
    [DateCreated]      DATETIME2 (7) NULL
);



