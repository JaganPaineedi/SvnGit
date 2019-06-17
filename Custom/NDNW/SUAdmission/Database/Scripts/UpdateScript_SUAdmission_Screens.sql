
IF EXISTS(SELECT ValidationStoredProcedureUpdate,PostUpdateStoredProcedure from Screens  where ScreenId = 3 and ScreenName='Client Information')
BEGIN
update Screens set ValidationStoredProcedureUpdate = 'csp_ValidateClientInformation',PostUpdateStoredProcedure = 'csp_PostUpdateClientInformation' where ScreenId = 3 and ScreenName='Client Information'
END

IF EXISTS(SELECT ValidationStoredProcedureUpdate,PostUpdateStoredProcedure from Screens  where ScreenId = 370 and ScreenName='Client Information (Admin)')
BEGIN
update Screens set ValidationStoredProcedureUpdate = 'csp_ValidateClientInformation',PostUpdateStoredProcedure = 'csp_PostUpdateClientInformation' where ScreenId = 370 and ScreenName='Client Information (Admin)'
END

IF EXISTS(SELECT ScreenName from Screens  where ScreenId = 46222)
BEGIN
update Screens set ScreenName  = 'SU Admission' where ScreenId = 46222
END


IF EXISTS(SELECT DocumentName,DocumentDescription from DocumentCodes  where DocumentCodeId = 46222)
BEGIN
update DocumentCodes set DocumentName = 'SU Admission',DocumentDescription  = 'SU Admission' where DocumentCodeId = 46222
END


IF EXISTS(SELECT BannerName,DisplayAs from Banners  where ScreenId = 46222)
BEGIN
update Banners set BannerName = 'SU Admission',DisplayAs = 'SU Admission' where ScreenId = 46222
END


IF EXISTS(SELECT BannerName,DisplayAs from Banners  where ScreenId = 46222)
BEGIN
update Banners set BannerName = 'SU Admission',DisplayAs = 'SU Admission' where ScreenId = 46222
END


IF EXISTS(SELECT NewValidationStoredProcedure from DocumentCodes  where DocumentCodeId = 46222)
BEGIN
update DocumentCodes set NewValidationStoredProcedure = 'csp_ValidateCustomDocumentSignSUAdmissions' where DocumentCodeId = 46222
END



IF EXISTS(SELECT CustomFieldFormId from Screens  where ScreenId = 3 AND CustomFieldFormId IS NOT NULL)
BEGIN
Update Screens set CustomFieldFormId = 100 where ScreenId = 3
END


