CREATE TABLE [dbo].[AIS_Data] (
    [MMSI]                         NVARCHAR (9)    NULL,
    [Vessel_Name]                  NVARCHAR (100)  NULL,
    [Latitude_Degree]              NVARCHAR (100)  NULL,
    [Latitde_MinutesSeconds]       NVARCHAR (100)  NULL,
    [Latitude_CardinalDirection]   NVARCHAR (1)    NULL,
    [Longitude_Degree]             NVARCHAR (100)  NULL,
    [Longitude_MinutesSeconds]     NVARCHAR (100)  NULL,
    [Longitude_CardinalDirection]  NVARCHAR (1)    NULL,
    [SOG]                          DECIMAL (10, 2) NULL,
    [COG]                          DECIMAL (10, 2) NULL,
    [RecievedTime]                 DATETIME2 (7)   NULL,
    [MID]                          NVARCHAR (100)  NULL,
    [DateCreated]                  DATETIME2 (7)   CONSTRAINT [DF_AIS_Data_DateCreated] DEFAULT (getdate()) NULL
);



