




CREATE PROCEDURE [load].[Dim_Vessel_SP]
@countr int = 0
AS
set @countr = (select count(*) from AIS_EDW.edw.Dim_Vessel where MMSI = (select MMSI from stage.D_Vessel))
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
			Draught, 
			DateCreated 	
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
			Width_, 
			Length_,
			Draugth_ , 
			DateCreated_ 	
		 FROM stage.VIEW_DimVessel)
END