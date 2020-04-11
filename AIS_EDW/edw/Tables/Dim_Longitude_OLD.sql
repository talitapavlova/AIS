CREATE TABLE [edw].[Dim_Longitude_OLD] (
    [Longitude_Key]            DECIMAL (8, 6) NOT NULL,
    [Longitude_Degree]         INT            NULL,
    [Longitude_Decimal_Degree] INT            NULL,
    [Longitude_Min]            INT            NULL,
    [Longitude_Sec]            DECIMAL (8, 6) NULL,
    [Longitude_Direction]      VARCHAR (4)    NULL,
    [DateCreated]              DATETIME2 (7)  CONSTRAINT [DF_Dim_Longitude_DateCreated_OLD] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_Dim_Longitude_OLD] PRIMARY KEY CLUSTERED ([Longitude_Key] ASC)
);

