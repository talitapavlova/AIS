CREATE TABLE [edw].[Dim_Vessel] (
    [Vessel_Key]     INT           IDENTITY (1, 1) NOT NULL,
    [MMSI]           CHAR (9)      NULL,
    [IMO]            CHAR (10)     NULL,
    [Type_of_mobile] NVARCHAR (20) NULL,
    [Call_Sign]      NVARCHAR (20) NULL,
    [Name]           NVARCHAR (50) NULL,
    [Ship_type]      NVARCHAR (50) NULL,
    [Width]          DECIMAL (18)  NULL,
    [Length]         DECIMAL (18)  NULL,
    [Draught]        DECIMAL (18)  NULL,
    [DateCreated]    DATETIME2 (7) CONSTRAINT [DF_Vessel] DEFAULT (getdate()) NULL,
    [ValidFrom]      DATE          NULL,
    [ValidTo]        DATE          NULL,
    CONSTRAINT [PK_Vessel] PRIMARY KEY CLUSTERED ([Vessel_Key] ASC)
);









