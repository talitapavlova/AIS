CREATE TABLE [edw].[Dim_Voyage] (
    [Voyage_Key]       INT             IDENTITY (1, 1) NOT NULL,
    [MMSI]             CHAR (9)        NOT NULL,
    [Start_Timestamp]  DATETIME2 (7)   NULL,
    [Update_Timestamp] DATETIME2 (7)   NULL,
    [ETA_month]        INT             NULL,
    [ETA_day]          INT             NULL,
    [ETA_hour]         INT             NULL,
    [ETA_minute]       INT             NULL,
    [Destination]      NVARCHAR (2000) NULL,
    [Batch_Created]    INT             NULL,
    [Batch_Updated]    INT             NULL,
    [Is_Current]       INT             NULL,
    CONSTRAINT [PK_Voyage] PRIMARY KEY CLUSTERED ([Voyage_Key] ASC)
);

