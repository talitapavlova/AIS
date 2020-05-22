CREATE TABLE [edw].[Dim_Time] (
    [Time_Key]    INT           NOT NULL,
    [Time]        TIME (7)      NULL,
    [Hour]        INT           NULL,
    [Minute]      INT           NULL,
    [Second]      INT           NULL,
    [DateCreated] DATETIME2 (7) CONSTRAINT [DF_Dim_Time_DateCreated] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_Time] PRIMARY KEY CLUSTERED ([Time_Key] ASC)
);

