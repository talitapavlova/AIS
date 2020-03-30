CREATE TABLE [edw].[Fact_Route] (
    [Date_Key]    INT           NOT NULL,
    [Time_Key]    INT           NOT NULL,
    [Vessel_Key]  INT           NOT NULL,
    [DateCreated] DATETIME2 (7) CONSTRAINT [DateCreated_Fact_Route] DEFAULT (getdate()) NULL
);

