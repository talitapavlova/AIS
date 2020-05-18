






/*
Change log: 
	2020-04-10	SI	Stored procedure created
	2020-04-11	NP	Added Latitude_key as integer
*/

CREATE  PROCEDURE [utility].[Get_Latitude] AS
BEGIN

/***** Denmark's border, including the water bodies, ranges from 53.000000 degrees to 59.000000 degrees Latitude, 
		where i.eg: 53 represents the degrees and .000000 represents the decimal degrees value. 
		The decimal degree value can be further translated into minutes and seconds *****/
DECLARE 
	@danish_min_latitude_degree_point int = 53,
	@danish_max_latitude_degree_point int = 60,

	@danish_min_latitude_decimal_degree_point int = 0,
	@danish_max_latitude_decimal_degree_point int = 999999,

	@decimal_degree_point_as_nvarchar nvarchar(6),
	@decimal_degree_point_calculated decimal(8,6)

SET NOCOUNT ON;
TRUNCATE table utility.Latitude_Info

WHILE(@danish_min_latitude_degree_point< @danish_max_latitude_degree_point) 
	BEGIN 
		WHILE(@danish_min_latitude_decimal_degree_point <= @danish_max_latitude_decimal_degree_point) 
		BEGIN	
			SET @decimal_degree_point_as_nvarchar = RIGHT(CONCAT('000000',cast(@danish_min_latitude_decimal_degree_point as varchar(6))),6)
			SET @decimal_degree_point_calculated = CAST('0.' + @decimal_degree_point_as_nvarchar as decimal(8,6))
				
			INSERT into utility.Latitude_Info(
				Latitude_Key,
				Latitude_Value,
				Latitude_Degree,
				Latitude_Decimal_Degree,
				Latitude_Min,
				Latitude_Sec,
				Latitude_Direction) 
			VALUES (
				@danish_min_latitude_degree_point * 1000000 + @danish_min_latitude_decimal_degree_point,
				CONVERT(decimal (10,6), CONVERT(varchar(10), @danish_min_latitude_degree_point) + '.' +  @decimal_degree_point_as_nvarchar), --concatinate the degrees with the deciaml degrees and add '.' in between them
				@danish_min_latitude_degree_point,
				@danish_min_latitude_decimal_degree_point,
				@decimal_degree_point_calculated * 60, --transform the decimal degree into minutes
				CAST('0.' + PARSENAME(@decimal_degree_point_calculated * 60, 1) as decimal(8,6)) * 60,  --transform the decimal degree into seconds
				CASE WHEN @danish_min_latitude_degree_point > 0 THEN 'N' ELSE 'S' END  --when the degree value is positive, the latitude position is encountered in the Northern Hemisphere; else in the Southern Hemisphere
				) 
		SET @danish_min_latitude_decimal_degree_point = @danish_min_latitude_decimal_degree_point + 1 	
	END   --end loop for decimal_degrees
		
SET @danish_min_latitude_degree_point = @danish_min_latitude_degree_point + 1 
SET	@danish_min_latitude_decimal_degree_point = 0	

END   --end loop for degrees

/*
Insert unkown values into [edw].[Dim_Latitude]
*/
TRUNCATE TABLE [AIS_EDW].[edw].[Dim_Latitude]
INSERT INTO [AIS_EDW].[edw].[Dim_Latitude](
		Latitude_Key,
		Latitude_Value,
		Latitude_Degree,
		Latitude_Decimal_Degree,
		Latitude_Min,
		Latitude_Sec,
		Latitude_Direction
) VALUES (
	-1,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL
) 

/*
Insert [utility].[Latitude_Info] into [edw].[Dim_Latitude]
*/
INSERT INTO [AIS_EDW].[edw].[Dim_Latitude](
		Latitude_Key,
		Latitude_Value,
		Latitude_Degree,
		Latitude_Decimal_Degree,
		Latitude_Min,
		Latitude_Sec,
		Latitude_Direction
) SELECT
	    Latitude_Key,
		Latitude_Value,
		Latitude_Degree,
		Latitude_Decimal_Degree,
		Latitude_Min,
		Latitude_Sec,
		Latitude_Direction
FROM utility.Latitude_Info 

END