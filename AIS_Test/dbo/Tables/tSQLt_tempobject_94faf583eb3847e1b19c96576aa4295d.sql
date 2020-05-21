CREATE TABLE [dbo].[tSQLt_tempobject_94faf583eb3847e1b19c96576aa4295d] (
    [RC_tSQLt_tempobject_94faf583eb3847e1b19c96576aa4295d] VARCHAR (1)     NOT NULL,
    [Voyage_Key]                                           INT             NULL,
    [MMSI]                                                 CHAR (9)        NULL,
    [Start_Timestamp]                                      DATETIME2 (7)   NULL,
    [Update_Timestamp]                                     DATETIME2 (7)   NULL,
    [ETA_month]                                            INT             NULL,
    [ETA_day]                                              INT             NULL,
    [ETA_hour]                                             INT             NULL,
    [ETA_minute]                                           INT             NULL,
    [Destination]                                          NVARCHAR (2000) NULL,
    [Batch_Created]                                        INT             NULL,
    [Batch_Updated]                                        INT             NULL,
    [Is_Current]                                           INT             NULL
);

