CREATE TABLE [edw].[Dim_Vessel] (
    [Vessel_Key]     INT             NULL,
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
    [Recieved_Time]  DATETIME2 (7)   NULL,
    [Valid_From]     DATETIME2 (7)   NULL,
    [Valid_To]       DATETIME2 (7)   NULL,
    [DateCreated]    DATETIME2 (7)   NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'tSQLt.FakeTable_OrgTableName', @value = N'tSQLt_tempobject_2bd2232f039f452980f04f9d405bb2a8', @level0type = N'SCHEMA', @level0name = N'edw', @level1type = N'TABLE', @level1name = N'Dim_Vessel';

