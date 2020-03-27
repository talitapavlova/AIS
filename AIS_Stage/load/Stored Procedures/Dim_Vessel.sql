



CREATE PROCEDURE [load].[Dim_Vessel]
AS
	Declare @MMSI nvarchar(50), @myCursor Cursor   
	Set @myCursor = CURSOR FOR select MMSI from AIS_Stage.transform.Dim_Vessel where MMSI not in (select MMSI from AIS_EDW.edw.Dim_Vessel)
	Open @myCursor   
	FETCH NEXT FROM @myCursor into @MMSI
	while (@@FETCH_STATUS = 0)
		BEGIN  
			INSERT INTO AIS_EDW.edw.Dim_Vessel
				(MMSI,
				IMO, 
				Type_of_mobile, 
				Call_Sign, 
				Name, 
				Ship_type, 
				Width, 
				Length, 
				Draught	
				-- ValidFrom,
				-- ValidTo
				) 
			SELECT 
				MMSI,
				IMO, 
				Type_of_mobile, 
				Call_Sign, 
				Name, 
				Ship_type, 
				Width, 
				Length,
				Draugth
				--select cast ('0001-01-01' as datetime),
				--select cast ('9999-12-31' as datetime)
           FROM AIS_Stage.transform.Dim_Vessel where MMSI = @MMSI 
			
			Fetch next from @myCursor into @MMSI	
			END  
  
		Close @myCursor   
		DEALLOCATE @myCursor  

 --else
	--begin
	--	Declare @MMSI nvarchar(50), @IMO nvarchar(50)    
	--	Declare myCursor CURSOR FOR select MMSI from AIS_EDW.edw.Dim_Vessel where MMSI = '219015425' --  where MMSI in (select MMSI from AIS_Stage.transform.Dim_Vessel)
	--	Open myCursor    
		
	--	while(@@FETCH_STATUS=0)  
	--	BEGIN  
  
	--	Set @MMSI = (select MMSI from AIS_Stage.transform.Dim_Vessel  where MMSI = '219015425' )  
	--		BEGIN  
	--		update AIS_EDW.edw.Dim_Vessel  set [ValidTo]=GETDATE()  where @MMSI=MMSI
	--			INSERT INTO AIS_EDW.edw.Dim_Vessel
	--				(MMSI
	--				--IMO, 
	--				--Type_of_mobile, 
	--				--Call_Sign, 
	--				--Name, 
	--				--Ship_type, 
	--				--Width, 
	--				--Length, 
	--				--Draught
	--				--DateCreated 	
	--				--ValidFrom,
	--				--ValidTo, 
	--				 ) 
	--			( SELECT 
	--				MMSI 
	--				--IMO, 
	--				--Type_of_mobile, 
	--				--Call_Sign, 
	--				--Name, 
	--				--Ship_type, 
	--				--Width, 
	--				--Length,
	--				--Draugth 
	--				--DateCreated
	--			 FROM transform.Dim_Vessel)
	--	END  
  
	--	Fetch next from myCursor into @MMSI  
	--	END  
  
	--	Close myCursor   
	--	DEALLOCATE myCursor  
	--	end