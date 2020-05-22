


/*
Change log: 
	2020-03-26	NP	Stored procedure created
	2020-04-08	NP	Updated SP for correct week number
*/


CREATE   PROCEDURE [utility].[Get_Date] AS

BEGIN
DECLARE
	@StartYear nvarchar(4) = '2000',
	@EndYear nvarchar(4) = '2051'

SET NOCOUNT ON;
SET DATEFIRST 1;
TRUNCATE TABLE utility.Date_Info;

/* 
A recursive temporary table that produces all dates between @StartYear 1/1 and @EndYear-1 12/31
*/
WITH 
Dates AS
(
SELECT 
	CAST(@StartYear AS DateTime) Date

UNION ALL

SELECT 
	(Date + 1) AS Date
FROM Dates
WHERE Date < CAST(@EndYear AS DateTime) - 1
)
,

/*
Extracting date properties with the build in SQL functions
*/
DateInfo AS
(
SELECT
	YEAR(Date) * 10000 + MONTH(Date) * 100 + DAY(Date) AS DateKey,
	CAST(Date AS Date) AS Date,				
	YEAR(Date) AS Year,
	DATEPART(Quarter, Date) AS Quarter,
	MONTH(Date) AS Month,
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
	END AS Month_Name, 
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
	END AS Month_ShortName,
	DATEPART(WEEK, Date) AS Week,
	DATEPART(DAY, Date) AS Day,
	DATEPART(DAYOFYEAR, Date) AS DayOfYear,
	DATEPART(Weekday, Date) AS DayOfWeek,
	CASE DATEPART(Weekday, Date)	
		WHEN 1 THEN 'Monday'
		WHEN 2 THEN 'Tuesday'
		WHEN 3 THEN 'Wednesday'
		WHEN 4 THEN 'Thursday'
		WHEN 5 THEN 'Friday'
		WHEN 6 THEN 'Saturday'
		WHEN 7 THEN 'Sunday'
	END AS DayOfWeek_Name,
	CASE DATEPART(Weekday, Date)
		WHEN 1 THEN 'Mon'
		WHEN 2 THEN 'Tue'
		WHEN 3 THEN 'Wed'
		WHEN 4 THEN 'Thu'
		WHEN 5 THEN 'Fre'
		WHEN 6 THEN 'Sat'
		WHEN 7 THEN 'Sun'
	END	AS DayOfWeek_ShortName
FROM Dates
)
, 

/*
Table with years where first week of the year contains Thursday
*/
WeeksInfo AS (
SELECT 
	Year
FROM DateInfo
WHERE Week = 1
	AND DayOfWeek = 4
)

/*
Populating [utility].[Date_Info] table
Correcting the week number - Week 1 is defined as the week with the first Thursday in the Year (In Denmark)
*/
INSERT INTO utility.Date_Info (
	DateKey,
	Date,
	Year ,
	Quarter,
	Month,
	Month_Name,
	Month_ShortName,
	Week,
	Day,
	DayOfYear,
	DayOfWeek,
	DayOfWeek_Name,
	DayOfWeek_ShortName
) SELECT
	DateKey,
	Date,
	a.Year ,
	Quarter,
	Month,
	Month_Name,
	Month_ShortName,
	CASE 
		WHEN b.Year IS NULL THEN 
			CASE 
				WHEN Week - 1 != 0 THEN Week - 1
				ELSE 52
			END
		ELSE Week
	END,
	Day,
	DayOfYear,
	DayOfWeek,
	DayOfWeek_Name,
	DayOfWeek_ShortName
FROM DateInfo a
LEFT JOIN WeeksInfo b ON a.Year = b.Year
OPTION (MAXRECURSION 0)

TRUNCATE TABLE edw.Dim_Date

/*
Insert unknown values into [edw].[Dim_Date]
*/
INSERT INTO edw.Dim_Date(
	Date_Key,
	Date,
	Year ,
	Quarter,
	Month,
	Month_Name,
	Month_ShortName,
	Week,
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
	-1,							-- [Quarter]
	-1,							-- [Month]
	'NA',						-- [Month_Name]
	'NA',						-- [Month_ShortName]
	-1,							-- [Week]
	-1,							-- [Day] 
	-1,							-- [DayOfYear]
	-1,							-- [DayOfWeek]
	'NA',						-- [DayOfWeek_Name]
	'NA'						-- [DayOfWeek_ShortName]
)

/*
Insert [utility].[Date_Info] into [edw].[Dim_Date]
*/
INSERT INTO edw.Dim_Date(
	Date_Key,
	Date,
	Year ,
	Quarter,
	Month,
	Month_Name,
	Month_ShortName,
	Week,
	Day,
	DayOfYear,
	DayOfWeek,
	DayOfWeek_Name,
	DayOfWeek_ShortName
) SELECT
	DateKey,
	Date,
	Year ,
	Quarter,
	Month,
	Month_Name,
	Month_ShortName,
	Week,
	Day,
	DayOfYear,
	DayOfWeek,
	DayOfWeek_Name,
	DayOfWeek_ShortName
FROM utility.Date_Info

END