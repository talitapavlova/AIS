CREATE TABLE [extract].[AIS_Data] (
    [MMSI]                   NVARCHAR (9)    NULL,
    [AIS_Message_Type]       NVARCHAR (9)    NULL,
    [Latitude]               DECIMAL (8, 6)  NULL,
    [Longitude]              DECIMAL (8, 6)  NULL,
    [MID_Number]             INT             NULL,
    [MID]                    NVARCHAR (100)  NULL,
    [Navigation Status]      DECIMAL (10, 2) NULL,
    [ROT]                    DECIMAL (10, 2) NULL,
    [SOG]                    DECIMAL (10, 2) NULL,
    [Position_Accuracy]      INT             NULL,
    [COG]                    DECIMAL (10, 2) NULL,
    [HDG]                    NVARCHAR (100)  NULL,
    [Manoeuvre_Indicator]    NVARCHAR (100)  NULL,
    [RAIM_Flag]              NVARCHAR (100)  NULL,
    [Repeat_Indicator]       NVARCHAR (100)  NULL,
    [ReceivedTime]           DATETIME2 (7)   NULL,
    [Vessel_Name]            NVARCHAR (100)  NULL,
    [IMO_Number]             NVARCHAR (100)  NULL,
    [Call_Sign]              NVARCHAR (100)  NULL,
    [Ship_Type]              NVARCHAR (100)  NULL,
    [Dimension_to_Bow]       DECIMAL (10, 2) NULL,
    [Dimension_to_Stern]     DECIMAL (10, 2) NULL,
    [Length]                 DECIMAL (10, 2) NULL,
    [Dimension_to_Port]      DECIMAL (10, 2) NULL,
    [Dimension_to_Starboard] DECIMAL (10, 2) NULL,
    [BEAM]                   DECIMAL (10, 2) NULL,
    [Position_Type_Fix]      DECIMAL (10, 2) NULL,
    [ETA_month]              NVARCHAR (100)  NULL,
    [ETA_day]                NVARCHAR (100)  NULL,
    [ETA_hour]               NVARCHAR (100)  NULL,
    [ETA_minute]             NVARCHAR (100)  NULL,
    [Draught]                NVARCHAR (100)  NULL,
    [Destination]            NVARCHAR (100)  NULL,
    [Batch]                  INT             NULL
);





