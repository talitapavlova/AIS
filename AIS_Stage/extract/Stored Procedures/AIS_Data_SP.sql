




CREATE PROCEDURE [extract].[AIS_Data_SP]
AS
BEGIN 
	BULK INSERT AIS_Stage.dbo.Extract_Data FROM 'C:\DummyData\375.csv'
		with
			(
				
					FIRSTROW = 2,
					FIELDTERMINATOR = '|',  --CSV field delimiter
					ROWTERMINATOR = '\n',   --Use to shift the control to next row
					TABLOCK,
					CODEPAGE = 'ACP'
			)  
END