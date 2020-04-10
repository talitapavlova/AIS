




/*
Change log: 
	2020-03-27	NP	Stored procedure created
	2020-03-30	NP	Altered to include seconds
*/

CREATE     PROCEDURE [utility].[Get_Longitude] AS
BEGIN

/***** Denmark's border, including the water bodies, ranges from 3.000000 degrees to 17.000000 degrees Longitude, 
			   where i.eg: 3 represents the degrees and .000000 represents the decimal degrees value. 
			   The deciaml degree value can be further translated into minutes and seconds *****/
DECLARE 
	@danish_min_longitude_degree_point int = 3,
	@danish_max_longitude_degree_point int = 17,

	@danish_min_longitude_decimal_degree_point int = 0,
	@danish_max_longitude_decimal_degree_point int = 999999

SET NOCOUNT ON;
TRUNCATE table utility.Longitude_Info

WHILE(@danish_min_longitude_degree_point<= @danish_max_longitude_degree_point) 
	BEGIN 
		WHILE(@danish_min_longitude_decimal_degree_point <= @danish_max_longitude_decimal_degree_point) 
			BEGIN	
				INSERT into utility.Longitude_Info(
					Longitude_Key,
					Longitude_Degree,
					Longitude_Decimal_Degree,
					Longitude_Min,
					Longitude_Sec,
					Longitude_Direction
					) 
					VALUES (
				CONVERT(decimal (8,6), CONVERT(varchar(10), @danish_min_longitude_degree_point) + '.' +  RIGHT(CONCAT('000000',cast(@danish_min_longitude_decimal_degree_point as varchar(6))),6)), --concatinate the degrees with the deciaml degrees and add '.' in between them
					@danish_min_longitude_degree_point,
					RIGHT(CONCAT('000000',cast(@danish_min_longitude_decimal_degree_point as varchar(6))),6),
					cast('0.' +  RIGHT(CONCAT('000000',cast(@danish_min_longitude_decimal_degree_point as varchar(6))),6) as decimal(8,6)) * 60, --transform the decimal degree into minutes
					cast('0.' + parsename(cast('0.' +  RIGHT(CONCAT('000000',cast(@danish_min_longitude_decimal_degree_point as varchar(6))),6) as decimal(8,6)) * 60, 1) as decimal(8,6)) * 60, --transform the decimal degree into seconds
					CASE WHEN @danish_min_longitude_degree_point > 0 THEN 'E' ELSE 'W' END  --when the degree value is positive, the latitude position is encountered in the Eastern Hemisphere; else in the Western Hemisphere
					) 
			SET @danish_min_longitude_decimal_degree_point = @danish_min_longitude_decimal_degree_point + 1 		
		END   --end loop for decimal_degrees
		
	SET @danish_min_longitude_degree_point = @danish_min_longitude_degree_point + 1 
	SET	@danish_min_longitude_decimal_degree_point = 0	
	print( @danish_min_longitude_degree_point)
	print('In degrees loop' )

END   --end loop for degrees

/*
Insert unkown values into [edw].[Dim_Longitude]
*/
TRUNCATE TABLE [AIS_EDW].[edw].[Dim_Longitude]
INSERT into [AIS_EDW].[edw].[Dim_Longitude](
		Longitude_Key,
		Longitude_Degree,
		Longitude_Decimal_Degree,
		Longitude_Min,
		Longitude_Sec,
		Longitude_Direction
) VALUES (
	-1,
	Null,
	Null,
	Null,
	Null,
	Null
) 

/*
Insert [utility].[Longitude_Info] into [edw].[Dim_Longitude]
*/
INSERT into [AIS_EDW].[edw].[Dim_Longitude](
		Longitude_Key,
		Longitude_Degree,
		Longitude_Decimal_Degree,
		Longitude_Min,
		Longitude_Sec,
		Longitude_Direction
) SELECT
		Longitude_Key,
		Longitude_Degree,
		Longitude_Decimal_Degree,
		Longitude_Min,
		Longitude_Sec,
		Longitude_Direction
FROM utility.Longitude_Info 

END