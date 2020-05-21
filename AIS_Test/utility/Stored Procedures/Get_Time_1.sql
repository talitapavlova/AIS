


/*
Change log: 
	2020-03-27	NP	Stored procedure created
	2020-03-30	NP	Altered to include seconds
*/

CREATE PROCEDURE [utility].[Get_Time] AS

BEGIN
DECLARE 
	@hour int = 0,
	@minute int = 0,
	@second int = 0

SET NOCOUNT ON;
TRUNCATE table utility.Time_Info

WHILE(@hour<= 23 ) 
	BEGIN 
		WHILE(@minute <= 59) 
			BEGIN 
				WHILE(@second <= 59)
					BEGIN
						INSERT into utility.Time_Info(
							Time_Key,
							Time,
							Hour,
							Minute,
							Second
						) VALUES (
							@hour * 10000 + @minute * 100 + @second,
							CONVERT(TIME,(RIGHT(CONCAT('0',cast(@hour as varchar(10))),2) +
								+':'+RIGHT(CONCAT('0',cast(@minute as varchar(10))),2) +
								+':'+RIGHT(CONCAT('0',cast(@second as varchar(10))),2))),
							@hour,
							@minute,
							@second
						) 
					SET @second = @second + 1 
					END   --end loop seconds
			SET @minute = @minute + 1 
			SET @second = 0
			END   --end loop minutes
	SET @hour = @hour + 1 
	SET @minute = 0 
	SET @second = 0
END  --end loop hours

TRUNCATE TABLE [edw].[Dim_Time]

/*
Insert unkown values into [edw].[Dim_Time]
*/
INSERT into [edw].[Dim_Time](
	Time_Key,
	Time,
	Hour,
	Minute,
	Second
) VALUES (
	-1,
	Null,
	-1,
	-1,
	-1
) 

/*
Insert [utility].[Time_Info] into [edw].[Dim_Time]
*/
INSERT into [edw].[Dim_Time](
	Time_Key,
	Time,
	Hour,
	Minute, 
	Second
) SELECT
	Time_Key,
	Time,
	Hour,
	Minute,
	Second
FROM utility.Time_Info 

END