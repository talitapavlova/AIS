CREATE TABLE [dbo].[AIS_Data] (
    [MMSI]                        NVARCHAR (9)    NULL,
    [Vessel_Name]                 NVARCHAR (100)  NULL,
    [Latitude_Degree]             NVARCHAR (100)  NULL,
    [Latitde_MinutesSeconds]      NVARCHAR (100)  NULL,
    [Latitude_CardinalDirection]  NVARCHAR (1)    NULL,
    [Longitude_Degree]            NVARCHAR (100)  NULL,
    [Longitude_MinutesSeconds]    NVARCHAR (100)  NULL,
    [Longitude_CardinalDirection] NVARCHAR (1)    NULL,
    [SOG]                         DECIMAL (10, 2) NULL,
    [COG]                         DECIMAL (10, 2) NULL,
    [RecievedTime]                DATETIME2 (7)   NULL,
    [MID]                         NVARCHAR (100)  NULL,
    [DateCreated]                 DATETIME2 (7)   NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'tSQLt.FakeTable_OrgTableName', @value = N'tSQLt_tempobject_54ce959fd0cf4473b7ba4cc35413dac0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'AIS_Data';

