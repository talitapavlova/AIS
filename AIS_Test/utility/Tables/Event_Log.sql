CREATE TABLE [utility].[Event_Log] (
    [Batch]        INT             NOT NULL,
    [Severity]     INT             NULL,
    [Message]      NVARCHAR (2000) NULL,
    [Message_type] NVARCHAR (200)  NULL,
    [DateCreated]  DATETIME2 (7)   CONSTRAINT [DateCreated_Event_Log] DEFAULT (getdate()) NULL
);

