
CREATE PROCEDURE dbo.SP_Dim_Vessel
AS
BEGIN 

-- Insert Unknown members

INSERT INTO AIS_EDW.edw.Dim_Vessel
	(
	ValidFrom,
	ValidTo)
(SELECT 
	
	ValidFrom,
	ValidTo
FROM stage.D_Vessel)

END

