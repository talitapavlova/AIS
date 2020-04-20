CREATE TABLE [edw].[Dim_Ship_Type] (
    [Ship_Type_Code]        INT            NOT NULL,
    [Ship_Type_Description] NVARCHAR (500) NULL,
    CONSTRAINT [PK_Dim_Ship_Type] PRIMARY KEY CLUSTERED ([Ship_Type_Code] ASC)
);

