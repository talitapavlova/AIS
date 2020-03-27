
CREATE PROCEDURE [load].[Dim_Vessel_SP]
@countr int = 0
AS
set @countr = (select count(*) as cnt from AIS_EDW.edw.Dim_Vessel where MMSI in (select MMSI from AIS_Stage.transform.Dim_Vessel))
 if (@countr = 0) 
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
			--DateCreated 	
			--ValidFrom,
			--ValidTo, 
			 ) 
		( SELECT 
			MMSI, 
			IMO, 
			Type_of_mobile, 
			Call_Sign, 
			Name, 
			Ship_type, 
			Width, 
			Length,
			Draugth 
			--DateCreated
		 FROM AIS_Stage.transform.Dim_Vessel)
END
 else
	begin
		Declare @MMSI nvarchar(50), @IMO nvarchar(50)    
		Declare myCursor CURSOR FOR select MMSI from AIS_EDW.edw.Dim_Vessel where MMSI in (select MMSI from AIS_Stage.transform.Dim_Vessel)
		Open myCursor    
		--Fetch next from ProductCursor into @ProductID  
  
		while(@@FETCH_STATUS=0)  
		BEGIN  
  
		Set @IMO = (select IMO from AIS_Stage.transform.Dim_Vessel)  
			BEGIN  
			update AIS_EDW.edw.Dim_Vessel   set [ValidTo]=GETDATE()  where @IMO=IMO
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
					--DateCreated 	
					--ValidFrom,
					--ValidTo, 
					 ) 
				( SELECT 
					MMSI, 
					IMO, 
					Type_of_mobile, 
					Call_Sign, 
					Name, 
					Ship_type, 
					Width, 
					Length,
					Draugth 
					--DateCreated
				 FROM transform.Dim_Vessel)
		END  
  
		Fetch next from myCursor into @MMSI  
		END  
  
		Close myCursor   
		DEALLOCATE myCursor  
		end