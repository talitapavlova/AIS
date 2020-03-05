CREATE TABLE [edw].[Dim_Vessel] (
    [Vessel_Key]  INT            IDENTITY (1, 1) NOT NULL,
    [ID]          NVARCHAR (256) NULL,
    [MMSI]        INT            NULL,
    [IMO]         INT            NULL,
    [ValidFrom]   DATE           NULL,
    [ValidTo]     DATE           NULL,
    [DateCreated] DATETIME2 (7)  CONSTRAINT [DF_Vessel] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_Vessel] PRIMARY KEY CLUSTERED ([Vessel_Key] ASC)
);



