CREATE TABLE [edw].[Dim_Vessel] (
    [Vessel_Key]             INT             IDENTITY (1, 1) NOT NULL,
    [MMSI]                   CHAR (9)        NOT NULL,
    [Vessel_Name]            NVARCHAR (200)  NULL,
    [IMO]                    NVARCHAR (10)   NULL,
    [Call_Sign]              NVARCHAR (10)   NULL,
    [Ship_Type]              INT             NULL,
    [Ship_Type_Description]  NVARCHAR (1000) NULL,
    [MID]                    NVARCHAR (100)  NULL,
    [MID_Number]             INT             NULL,
    [Dimension_To_Bow]       INT             NULL,
    [Dimension_To_Stern]     INT             NULL,
    [Length]                 INT             NULL,
    [Dimension_To_Port]      INT             NULL,
    [Dimension_To_Starboard] INT             NULL,
    [Beam]                   INT             NULL,
    [Position_Type_Fix]      INT             NULL,
    [BatchCreated]           INT             NULL,
    [BatchUpdated]           INT             NULL,
    [Valid_From]             DATETIME2 (7)   NULL,
    [Valid_To]               DATETIME2 (7)   NULL,
    CONSTRAINT [PK_Vessel] PRIMARY KEY CLUSTERED ([Vessel_Key] ASC)
);






GO


