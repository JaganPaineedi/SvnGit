/*************************************************************************************                                                   
-- Purpose: To update DateOfService and EndDateOfService for Attendance Group Services.
--  
-- Author:  Akwinass
-- Date:    29-MAR-2016
--  
-- *****History****  
**************************************************************************************/
UPDATE S SET S.DateOfService = S.DateTimeIn,
S.EndDateOfService = S.DateTimeOut,
S.ModifiedBy = '829.05WoodsCustomizationsFIX',
S.ModifiedDate = GETDATE()
FROM Services S
WHERE S.GroupServiceId IS NOT NULL
	AND isnull(S.RecordDeleted, 'N') = 'N'
	AND S.DateTimeIn IS NOT NULL
	AND S.DateTimeOut IS NOT NULL
	AND S.DateOfService <> S.DateTimeIn
	AND S.EndDateOfService <> S.DateTimeOut
	AND EXISTS(SELECT * FROM Groups G WHERE isnull(G.UsesAttendanceFunctions, 'N') = 'Y' and isnull(G.RecordDeleted, 'N') = 'N' AND G.GroupId IN (SELECT GroupId FROM GroupServices GS WHERE GS.GroupServiceId = S.GroupServiceId AND isnull(GS.RecordDeleted, 'N') = 'N'))
	

UPDATE S SET S.Unit = [dbo].[ssf_SCCalculateAttendanceUnits](S.DateOfService, S.EndDateOfService, S.Unit, S.UnitType)
FROM Services S	
WHERE S.ModifiedBy = '829.05WoodsCustomizationsFIX'

UPDATE S SET S.ProcedureRateId = (SELECT TOP 1 ProcedureRateId FROM [dbo].ssf_PMServiceCalculateCharge(S.ClientId, S.DateOfService, S.ClinicianId, S.ProcedureCodeId, S.Unit, S.ProgramId, S.LocationId))
,S.Charge =(SELECT TOP 1 Charge FROM [dbo].ssf_PMServiceCalculateCharge(S.ClientId, S.DateOfService, S.ClinicianId, S.ProcedureCodeId, S.Unit, S.ProgramId, S.LocationId))
FROM Services S	
WHERE S.ModifiedBy = '829.05WoodsCustomizationsFIX'