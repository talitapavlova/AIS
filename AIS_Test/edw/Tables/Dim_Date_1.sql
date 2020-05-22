﻿CREATE TABLE [edw].[Dim_Date] (
    [Date_Key]            INT           NOT NULL,
    [Date]                DATE          NOT NULL,
    [Year]                INT           NOT NULL,
    [Quarter]             INT           NOT NULL,
    [Month]               INT           NOT NULL,
    [Month_Name]          NVARCHAR (10) NOT NULL,
    [Month_ShortName]     NVARCHAR (3)  NOT NULL,
    [Week]                INT           NOT NULL,
    [Day]                 INT           NOT NULL,
    [DayOfYear]           INT           NOT NULL,
    [DayOfWeek]           INT           NOT NULL,
    [DayOfWeek_Name]      NVARCHAR (10) NOT NULL,
    [DayOfWeek_ShortName] NVARCHAR (3)  NOT NULL,
    [DateCreated]         DATETIME2 (7) CONSTRAINT [DateCreated_Dim_Date] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_Date] PRIMARY KEY CLUSTERED ([Date_Key] ASC)
);

