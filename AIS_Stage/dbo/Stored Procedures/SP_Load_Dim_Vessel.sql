


CREATE PROCEDURE [dbo].[SP_Load_Dim_Vessel]
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
			Cast(MMSI as char), 
			Cast(IMO as char), 
			Type_of_mobile, 
			Call_Sign, 
			Name, 
			Ship_type, 
			Cast(Width as decimal(18,0)), 
			Cast(Length as decimal(18,0)),
			Cast(Draught as decimal(18,0)), 
			Cast(Timestamp as datetime2(7)) 	
		 FROM stage.VIEW_DimVessel)
END