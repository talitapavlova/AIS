CREATE TABLE [edw].[Fact_Route] (
    [Vessel_Key]             INT             NOT NULL,
    [Date_Key]               INT             NOT NULL,
    [Time_Key]               INT             NOT NULL,
    [Latitude_Key]           INT             NOT NULL,
    [Longitude_Key]          INT             NOT NULL,
    [Navigation_Status_Key]  INT             NOT NULL,
    [Voyage_Key]             INT             NOT NULL,
    [Rate_Of_Turn_ROT]       INT             NULL,
    [Speed_Over_Ground_SOG]  DECIMAL (10, 2) NULL,
    [Course_Over_Ground_COG] DECIMAL (10, 2) NULL,
    [True_Heading_HDG]       INT             NULL,
    [Position_Accuracy]      TINYINT         NULL,
    [Manoeuvre_Indicator]    TINYINT         NULL,
    [RAIM_Flag]              TINYINT         NULL,
    [Draught]                DECIMAL (6, 2)  NULL,
    [Batch]                  INT             NULL
);

