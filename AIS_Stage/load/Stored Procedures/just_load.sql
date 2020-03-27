



CREATE PROCEDURE [load].[just_load]
@countr int = 0
AS
set @countr = (select count(*) as cnt from AIS_EDW.edw.Dim_Vessel where MMSI in (select MMSI from transform.Dim_Vessel))
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
		 FROM transform.Dim_Vessel)
END