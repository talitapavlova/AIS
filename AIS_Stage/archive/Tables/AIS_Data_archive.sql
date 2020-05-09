﻿CREATE TABLE [archive].[AIS_Data_archive] (
    [MMSI]                   NVARCHAR (9)    NULL,
    [Message_Type]           TINYINT         NULL,
    [Longitude]              DECIMAL (10, 6) NULL,
    [Latitude]               DECIMAL (10, 6) NULL,
    [MID_Number]             INT             NULL,
    [MID]                    NVARCHAR (200)  NULL,
    [Navigation_Status]      TINYINT         NULL,
    [Rate_Of_Turn_ROT]       INT             NULL,
    [Speed_Over_Ground_SOG]  DECIMAL (10, 2) NULL,
    [Position_Accuracy]      TINYINT         NULL,
    [Course_Over_Ground_COG] DECIMAL (10, 2) NULL,
    [True_Heading_HDG]       INT             NULL,
    [Manoeuvre_Indicator]    TINYINT         NULL,
    [RAIM_Flag]              TINYINT         NULL,
    [ReceivedTime]           DATETIME2 (7)   NULL,
    [Vessel_Name]            NVARCHAR (200)  NULL,
    [IMO]                    NVARCHAR (20)   NULL,
    [Call_Sign]              NVARCHAR (10)   NULL,
    [Ship_Type]              INT             NULL,
    [Dimension_To_Bow]       INT             NULL,
    [Dimension_To_Stern]     INT             NULL,
    [Length]                 INT             NULL,
    [Dimension_To_Port]      INT             NULL,
    [Dimension_To_Starboard] INT             NULL,
    [Beam]                   INT             NULL,
    [Position_Type_Fix]      TINYINT         NULL,
    [ETA_month]              TINYINT         NULL,
    [ETA_day]                TINYINT         NULL,
    [ETA_hour]               TINYINT         NULL,
    [ETA_minute]             TINYINT         NULL,
    [ETA_Draught]            DECIMAL (6, 2)  NULL,
    [Destination]            NVARCHAR (20)   NULL,
    [Batch]                  INT             NULL
);





