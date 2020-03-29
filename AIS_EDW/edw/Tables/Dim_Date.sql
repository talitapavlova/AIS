CREATE TABLE [edw].[Dim_Date] (
    [Date_Key]              INT           NOT NULL,
    [Date]                  DATE          NOT NULL,
    [Year]                  INT           NOT NULL,
    [QuarterOfYear]         INT           NOT NULL,
    [MonthOfYear]           INT           NOT NULL,
    [MonthOfYear_Name]      NVARCHAR (10) NOT NULL,
    [MonthOfYear_ShortName] NVARCHAR (3)  NOT NULL,
    [WeekOfYear]            INT           NOT NULL,
    [Day]                   INT           NOT NULL,
    [DayOfYear]             INT           NOT NULL,
    [DayOfWeek]             INT           NOT NULL,
    [DayOfWeek_Name]        NVARCHAR (10) NOT NULL,
    [DayOfWeek_ShortName]   NVARCHAR (3)  NOT NULL,
    [DateCreated]           DATETIME2 (7) CONSTRAINT [DateCreated_Dim_Date] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_Date] PRIMARY KEY CLUSTERED ([Date_Key] ASC)
);



