


CREATE PROCEDURE [load].[Dim_Vessel_SP]
AS
	Declare @MMSI nvarchar(50), @myCursor Cursor   
	
	Set @myCursor = CURSOR FOR select MMSI from AIS_Stage.transform.Dim_Vessel where MMSI not in (select MMSI from AIS_EDW.edw.Dim_Vessel)
	
	Open @myCursor   
	FETCH NEXT FROM @myCursor into @MMSI
	
	while (@@FETCH_STATUS = 0)
		BEGIN  
			INSERT INTO AIS_EDW.edw.Dim_Vessel
				(MMSI,
				Name, 
				DateCreated)
				--ValidFrom,
				--ValidTo) 
			(SELECT 
				MMSI,
				Vessel_Name,
				DateCreated
				FROM AIS_Stage.transform.Dim_Vessel where MMSI = @MMSI )
			
			Fetch next from @myCursor into @MMSI	
			END  
  
		Close @myCursor   
		DEALLOCATE @myCursor