-- =============================================   
-- Author:    Vijay 
-- Create date: Jul 27, 2018
-- What:Updating PostUpdateStoredProcedure column value 
-- Why:Engineering Improvement Initiatives- NBL(I)  - Task# 590 
-- =============================================     

--To Update the Episode Start Post Update Procedure - Treatment Episode Details - ScreenId = 1223
IF EXISTS (SELECT 1 FROM dbo.SCREENS WHERE ScreenId = 1223)
BEGIN
	UPDATE Screens SET PostUpdateStoredProcedure = 'ssp_QueOnEpisodeStartEvent', ModifiedBy = 'EI#590' WHERE Code='21787F00-493C-4472-8CA4-55C90F69B0E9'
END


--Client Information(C) - ScreenId = 969
IF EXISTS (SELECT 1 FROM dbo.SCREENS WHERE ScreenId = 969)
BEGIN
	UPDATE Screens SET PostUpdateStoredProcedure = 'ssp_PostUpdateClientEpisodeStart', ModifiedBy = 'EI#590' WHERE Code = 'EBE5E772-9B16-40C5-ACA1-A85D8786F374'
END


--Registration Document - ScreenId = 10500
--We are using ScreeName because of ScreenId is different for few customers[MFS-10684]
IF EXISTS (SELECT 1 FROM dbo.SCREENS WHERE ScreenName = 'Registration Document')
BEGIN
	UPDATE Screens SET PostUpdateStoredProcedure = 'ssp_PostUpdateRegistrationDocumentEpisodeStart', ModifiedBy = 'EI#590' WHERE Code = '0D3F4ED7-F309-4DA1-8831-82274ADAB661'
END


--Admission Document[ for NDNW] - ScreenId = 10500
IF EXISTS (SELECT 1 FROM dbo.SCREENS WHERE ScreenName = 'Admission Document')
BEGIN
	UPDATE Screens SET PostUpdateStoredProcedure = 'ssp_PostUpdateRegistrationDocumentEpisodeStart', ModifiedBy = 'EI#590' WHERE Code = '0D3F4ED7-F309-4DA1-8831-82274ADAB661'
END


--To Update the Program Discharge, Requested and Enrollment Post Update Procedure - Program Assignment Details - ScreenId = 302
IF EXISTS (SELECT 1 FROM dbo.SCREENS WHERE ScreenId = 302)
BEGIN
	UPDATE Screens SET PostUpdateStoredProcedure = 'ssp_PostUpdateProgramAssignmentDetail', ModifiedBy = 'EI#590' WHERE Code = 'A3A19310-4572-4558-ADA1-1105559C94CC'
END