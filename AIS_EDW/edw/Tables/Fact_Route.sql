CREATE TABLE [edw].[Fact_Route] (
    [Date_Key]   INT             NOT NULL,
    [Time_Key]   INT             NOT NULL,
    [Vessel_Key] INT             NOT NULL,
    [SOG]        NUMERIC (10, 2) NULL,
    [COG]        NUMERIC (10, 2) NULL,
    [Latitude]   DECIMAL (8, 6)  NOT NULL,
    [Longitude]  DECIMAL (8, 6)  NOT NULL,
    [Batch]      INT             NULL
);





