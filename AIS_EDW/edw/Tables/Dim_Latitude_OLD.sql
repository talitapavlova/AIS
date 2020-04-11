CREATE TABLE [edw].[Dim_Latitude_OLD] (
    [Latitude_Key]            DECIMAL (8, 6) NOT NULL,
    [Latitude_Degree]         INT            NULL,
    [Latitude_Decimal_Degree] INT            NULL,
    [Latitude_Min]            INT            NULL,
    [Latitude_Sec]            DECIMAL (8, 6) NULL,
    [Latitude_Direction]      VARCHAR (4)    NULL,
    [DateCreated]             DATETIME2 (7)  CONSTRAINT [DF_Dim_Latitude_DateCreated_OLD] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_Dim_Latitude_OLD] PRIMARY KEY CLUSTERED ([Latitude_Key] ASC)
);

