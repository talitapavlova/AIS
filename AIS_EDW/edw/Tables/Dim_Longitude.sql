CREATE TABLE [edw].[Dim_Longitude] (
    [Longitude_Key]            INT             NOT NULL,
    [Longitude_Value]          DECIMAL (10, 6) NULL,
    [Longitude_Degree]         INT             NULL,
    [Longitude_Decimal_Degree] INT             NULL,
    [Longitude_Min]            INT             NULL,
    [Longitude_Sec]            DECIMAL (5, 3)  NULL,
    [Longitude_Direction]      VARCHAR (4)     NULL,
    [DateCreated]              DATETIME2 (7)   CONSTRAINT [DF_Dim_Longitude_DateCreated] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_Dim_Longitude] PRIMARY KEY CLUSTERED ([Longitude_Key] ASC)
);



