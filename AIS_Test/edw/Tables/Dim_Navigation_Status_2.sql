CREATE TABLE [edw].[Dim_Navigation_Status] (
    [Navigation_Status_Key]         INT            NOT NULL,
    [Navigation_Status_Description] NVARCHAR (500) NULL,
    CONSTRAINT [PK_Dim_Navigation_Status] PRIMARY KEY CLUSTERED ([Navigation_Status_Key] ASC)
);

