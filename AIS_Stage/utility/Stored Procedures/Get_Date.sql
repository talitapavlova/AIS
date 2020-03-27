﻿

CREATE PROCEDURE [utility].[Get_Date] AS
DECLARE
	@StartYear nvarchar(4) = '2000',
	@EndYear nvarchar(4) = '2051'

BEGIN
SET NOCOUNT ON;
SET DATEFIRST 1;
TRUNCATE TABLE utility.Date_Info;

/* 
A recursive temporary table that produces all dates between @StartYear 1/1 and @EndYear-1 12/31
*/
WITH 
Dates AS
(
	SELECT CAST(@StartYear AS DateTime) Date

	UNION ALL

	SELECT (Date + 1) AS Date
	FROM Dates
	WHERE Date < CAST(@EndYear AS DateTime) - 1
)
--select * from Dates OPTION (MAXRECURSION 0)
/*
Week 1 is defined as the week with the first Thursday in the Year (In Denmark)
-- The weeks can be found by counting the thursdays in a year so we find
-- the thursday in the week for a particular date */
INSERT INTO [utility].[Date_Info] (
	DateKey,
	Date,
	Year,
	QuarterOfYear,
	MonthOfYear,
	MonthOfYear_Name,
	MonthOfYear_ShortName,
	WeekOfYear,
	Day,
	DayOfYear,
	DayOfWeek,
	DayOfWeek_Name,
	DayOfWeek_ShortName
) SELECT
	YEAR(Date) * 10000 + MONTH(Date) * 100 + DAY(Date), -- [DateKey]
	CAST(Date AS Date),		-- [Date]
	YEAR(Date),
	DATEPART(Quarter, Date),
	MONTH(Date),
	CASE MONTH(Date) 
		WHEN 1 THEN 'January'
		WHEN 2 THEN 'February'
		WHEN 3 THEN 'March'
		WHEN 4 THEN 'April'
		WHEN 5 THEN 'May'
		WHEN 6 THEN 'June'
		WHEN 7 THEN 'July'
		WHEN 8 THEN 'August'
		WHEN 9 THEN 'September'
		WHEN 10 THEN 'Oktober'
		WHEN 11 THEN 'November'
		WHEN 12 THEN 'December'
	END,
	CASE MONTH(Date) 
		WHEN 1 THEN 'Jan'
		WHEN 2 THEN 'Feb'
		WHEN 3 THEN 'Mar'
		WHEN 4 THEN 'Apr'
		WHEN 5 THEN 'May'
		WHEN 6 THEN 'Jun'
		WHEN 7 THEN 'Jul'
		WHEN 8 THEN 'Aug'
		WHEN 9 THEN 'Sep'
		WHEN 10 THEN 'Okt'
		WHEN 11 THEN 'Nov'
		WHEN 12 THEN 'Dec'
	END,
	DATEPART(WEEK, Date),
	DATEPART(DAY, Date),
	DATEPART(DAYOFYEAR, Date),
	DATEPART(Weekday, Date),
	CASE DATEPART(Weekday, Date)
		WHEN 1 THEN 'Monday'
		WHEN 2 THEN 'Tuesday'
		WHEN 3 THEN 'Wednesday'
		WHEN 4 THEN 'Thursday'
		WHEN 5 THEN 'Friday'
		WHEN 6 THEN 'Saturday'
		WHEN 7 THEN 'Sunday'
	END,
	CASE DATEPART(Weekday, Date)
		WHEN 1 THEN 'Mon'
		WHEN 2 THEN 'Tue'
		WHEN 3 THEN 'Wed'
		WHEN 4 THEN 'Thu'
		WHEN 5 THEN 'Fre'
		WHEN 6 THEN 'Sat'
		WHEN 7 THEN 'Sun'
	END
FROM Dates 
OPTION (MAXRECURSION 0)

TRUNCATE TABLE AIS_EDW.edw.Dim_Date

/*
Insert unknown values into Dim_Date
*/
INSERT INTO AIS_EDW.edw.Dim_Date(
	DateKey,
	Date,
	Year ,
	QuarterOfYear,
	MonthOfYear,
	MonthOfYear_Name,
	MonthOfYear_ShortName,
	WeekOfYear,
	Day,
	DayOfYear,
	DayOfWeek,
	DayOfWeek_Name,
	DayOfWeek_ShortName
) VALUES
(
	-1,							-- [DateKey]
	CAST('1900-01-01' AS Date),	-- [Date]
	-1,							-- [Year]
	-1,							-- [QuarterOfYear]
	-1,							-- [Month]
	'NA',						-- [MonthOfYear_Name]
	'NA',						-- [MonthOfYear_ShortName]
	-1,							-- [WeekOfYear]
	-1,							-- [Day] 
	-1,							-- [DayOfYear]
	-1,							-- [DayOfWeek]
	'NA',						-- [DayOfWeek_Name]
	'NA'						-- [DayOfWeek_ShortName]
)

INSERT INTO AIS_EDW.edw.Dim_Date(
	DateKey,
	Date,
	Year ,
	QuarterOfYear,
	MonthOfYear,
	MonthOfYear_Name,
	MonthOfYear_ShortName,
	WeekOfYear,
	Day,
	DayOfYear,
	DayOfWeek,
	DayOfWeek_Name,
	DayOfWeek_ShortName
) SELECT
	DateKey,
	Date,
	Year ,
	QuarterOfYear,
	MonthOfYear,
	MonthOfYear_Name,
	MonthOfYear_ShortName,
	WeekOfYear,
	Day,
	DayOfYear,
	DayOfWeek,
	DayOfWeek_Name,
	DayOfWeek_ShortName
FROM utility.Date_Info

END