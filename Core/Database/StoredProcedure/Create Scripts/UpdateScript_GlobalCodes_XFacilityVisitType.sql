IF EXISTS (SELECT GlobalCodeId FROM GlobalCodes WHERE Category='XFacilityVisitType')
BEGIN
	UPDATE GlobalCodes SET  ExternalCode1='O' WHERE CODE='URGENTCARE' AND Category='XFacilityVisitType'
	UPDATE GlobalCodes SET  ExternalCode1='E' WHERE CODE='EMERGENCYCARE' AND Category='XFacilityVisitType'
	UPDATE GlobalCodes SET  ExternalCode1='I' WHERE CODE='INPATIENTCARE' AND Category='XFacilityVisitType'
END