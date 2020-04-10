CREATE TABLE [edw].[Dim_Latitude] (
    [Latitude_Key]            DECIMAL (8, 6) NOT NULL,
    [Latitude_Degree]         INT            NULL,
    [Latitude_Decimal_Degree] INT            NULL,
    [Latitude_Min]            INT            NULL,
    [Latitude_Sec]            DECIMAL (8, 6) NULL,
    [Latitude_Direction]      VARCHAR (4)    NULL,
    [DateCreated]             DATETIME2 (7)  CONSTRAINT [DF_Dim_Latitude_DateCreated] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_Dim_Latitude] PRIMARY KEY CLUSTERED ([Latitude_Key] ASC)
);

