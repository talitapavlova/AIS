CREATE TABLE [archive].[AIS_Data_archive] (
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
    [ReceivedTime]                DATETIME2 (7)   NULL,
    [MID]                         NVARCHAR (100)  NULL,
    [Batch]                       INT             NULL
);



