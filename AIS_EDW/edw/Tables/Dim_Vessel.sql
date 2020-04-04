CREATE TABLE [edw].[Dim_Vessel] (
    [Vessel_Key]     INT             IDENTITY (1, 1) NOT NULL,
    [MMSI]           CHAR (9)        NULL,
    [MID]            NVARCHAR (100)  NULL,
    [IMO]            CHAR (10)       NULL,
    [Type_of_mobile] NVARCHAR (20)   NULL,
    [Call_Sign]      NVARCHAR (20)   NULL,
    [Vessel_Name]    NVARCHAR (100)  NULL,
    [Ship_type]      NVARCHAR (50)   NULL,
    [Width]          DECIMAL (10, 2) NULL,
    [Length]         DECIMAL (10, 2) NULL,
    [Draught]        DECIMAL (10, 2) NULL,
    [BatchCreated]   INT             NULL,
    [BatchUpdated]   INT             NULL,
    [Valid_From]     DATETIME2 (7)   NULL,
    [Valid_To]       DATETIME2 (7)   NULL,
    CONSTRAINT [PK_Vessel] PRIMARY KEY CLUSTERED ([Vessel_Key] ASC)
);



















