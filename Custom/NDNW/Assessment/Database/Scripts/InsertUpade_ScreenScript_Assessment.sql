DECLARE @BANNERID INT

SET IDENTITY_INSERT DocumentCodes ON
IF not exists (select DocumentName from DocumentCodes where DocumentCodeId =10018) 
	BEGIN
		INSERT INTO DocumentCodes(DocumentCodeId,DocumentName,DocumentDescription,DocumentType,Active,OnlyAvailableOnline,ViewDocumentURL,ViewDocumentRDL,StoredProcedure,TableList,RequiresSignature,InitializationProcess,ViewStoredProcedure,DiagnosisDocument)
		Values(10018,'Assessment','Assessment',10,'Y','N','RDLAssessment','RDLAssessment','csp_GetDataForCustomHRMAssessments','CustomHRMAssessments,CustomSubstanceUseAssessments,CustomSubstanceUseHistory2,CustomHRMAssessmentLevelOfCareOptions,CustomOtherRiskFactors,CustomHRMAssessmentSupports2,CustomMentalStatuses2,CustomDocumentCRAFFTs,CustomDispositions,CustomServiceDispositions,CustomProviderServices,CustomASAMPlacements,CustomDocumentAssessmentSubstanceUses,CustomHRMAssessmentMedications,DocumentFamilyHistory,CustomDocumentSafetyCrisisPlans,CustomSupportContacts,CustomSafetyCrisisPlanReviews,CustomCrisisPlanMedicalProviders,CustomCrisisPlanNetworkProviders,DocumentDiagnosisCodes,DocumentDiagnosis,DocumentDiagnosisFactors,CarePlanNeeds,CarePlanDomains,CarePlanDomainNeeds,CustomDocumentGambling','Y',5849,'csp_RDLCustomHRMAssessments','Y')
	END
ELSE
	UPDATE DocumentCodes SET 
	DocumentName='Assessment',
	DocumentDescription='Assessment',
	DocumentType=10,
	Active='Y',
	OnlyAvailableOnline='N',
	ViewDocumentURL='RDLAssessment',
	ViewDocumentRDL='RDLAssessment',
	StoredProcedure='csp_GetDataForCustomHRMAssessments',
	TableList='CustomHRMAssessments,CustomSubstanceUseAssessments,CustomSubstanceUseHistory2,CustomHRMAssessmentLevelOfCareOptions,CustomOtherRiskFactors,CustomHRMAssessmentSupports2,CustomMentalStatuses2,CustomDocumentCRAFFTs,CustomDispositions,CustomServiceDispositions,CustomProviderServices,CustomASAMPlacements,CustomDocumentAssessmentSubstanceUses,CustomHRMAssessmentMedications,DocumentFamilyHistory,CustomDocumentSafetyCrisisPlans,CustomSupportContacts,CustomSafetyCrisisPlanReviews,CustomCrisisPlanMedicalProviders,CustomCrisisPlanNetworkProviders,DocumentDiagnosisCodes,DocumentDiagnosis,DocumentDiagnosisFactors,CarePlanNeeds,CarePlanDomains,CarePlanDomainNeeds,CustomDocumentGambling',
	RequiresSignature='Y',
	InitializationProcess=5849,
	ViewStoredProcedure='csp_RDLCustomHRMAssessments',
	DiagnosisDocument='Y'
	WHERE DocumentCodeId =10018	
SET IDENTITY_INSERT DocumentCodes OFF	
	
	

SET IDENTITY_INSERT Screens on
	If not exists (select [ScreenName] from Screens where [ScreenId] = 10018 )
	begin
		INSERT INTO [dbo].[Screens]([ScreenId],[ScreenName],[ScreenType],[ScreenURL],[ScreenToolbarURL],[TabId],[InitializationStoredProcedure],[DocumentCodeId],[ValidationStoredProcedureComplete],[PostUpdateStoredProcedure]  )
		VALUES(10018,'Assessment',5763,'/Custom/Assessment/WebPages/HRMAssessment.ascx',Null,2,'csp_InitCustomHRMAssessmentsStandardInitialization',10018,'csp_validateCustomHRMAssessmentNew',NULL    )
	End

	ELSE
		update Screens set
		ScreenName='Assessment',
		ScreenType=5763,
		ScreenURL='/Custom/Assessment/WebPages/HRMAssessment.ascx',
		TabId=2,
		InitializationStoredProcedure='csp_InitCustomHRMAssessmentsStandardInitialization',
		DocumentCodeId=10018,
		ValidationStoredProcedureComplete='csp_validateCustomHRMAssessmentNew',
		PostUpdateStoredProcedure=NULL
		where ScreenId=10018
SET IDENTITY_INSERT Screens off

IF NOT EXISTS (SELECT * FROM screens WHERE ScreenId = 10057) BEGIN SET IDENTITY_INSERT dbo.Screens ON 
	INSERT INTO screens(screenid, ScreenName, ScreenType, screenurl, TabId,DocumentCodeId) 
	values(10057,'Custom HRMOtherRiskFactorsLookup Popup',5765,'/Custom/Assessment/WebPages/HRMOtherRiskFactors.ascx',2,NULL)
SET IDENTITY_INSERT dbo.Screens OFF  END
ELSE
	BEGIN
		UPDATE Screens SET ScreenName='Custom HRMOtherRiskFactorsLookup Popup',ScreenType=5765,ScreenURL='/Custom/Assessment/WebPages/HRMOtherRiskFactors.ascx',TabId=2,DocumentCodeId=NULL WHERE ScreenId=10057
	END

IF NOT EXISTS (SELECT * FROM screens WHERE ScreenId = 10053) BEGIN SET IDENTITY_INSERT dbo.Screens ON 
	INSERT INTO screens(screenid, ScreenName, ScreenType, screenurl, TabId,DocumentCodeId) 
	values(10053,'Guardian Information',5761,'/Custom/Assessment/WebPages/HRMGuardianInformation.ascx',2,NULL)
SET IDENTITY_INSERT dbo.Screens OFF  END
ELSE
	BEGIN
		UPDATE Screens SET ScreenName='Guardian Information',ScreenType=5761,ScreenURL='/Custom/Assessment/WebPages/HRMGuardianInformation.ascx',TabId=2,DocumentCodeId=NULL WHERE ScreenId=10053
	END

SET IDENTITY_INSERT Screens on
	If not exists (select [ScreenName] from Screens where [ScreenName] = 'ASAM' and [ScreenId] = 10690 )
	begin
		INSERT INTO [dbo].[Screens]([ScreenId],[ScreenName],[ScreenType],[ScreenURL],[ScreenToolbarURL],[TabId],[InitializationStoredProcedure],[DocumentCodeId])
		VALUES(10690,'ASAM',5761,'/Custom/Assessment/WebPages/ASAMPopUp.ascx',Null,2,NULL,NULL )
	End

	ELSE
		update Screens set
		ScreenName='ASAM',
		ScreenType=5761,
		ScreenURL='/Custom/Assessment/WebPages/ASAMPopUp.ascx',
		TabId=2,
		InitializationStoredProcedure=NUll,
		DocumentCodeId=NULL
		where ScreenId=10690
		
SET IDENTITY_INSERT Screens off
IF not exists (select Bannerid from banners where BannerName = 'Assessment')
	BEGIN
		INSERT INTO banners(BannerName,DisplayAs,Active,DefaultOrder,Custom,TabId ,ScreenId,ScreenParameters)
		Values('Assessment' ,'Assessment' ,'Y' ,40 ,'N' ,2  ,10018 ,NULL )
	END
ELSE
	UPDATE Banners SET 
	BannerName='Assessment',
	DisplayAs='Assessment',
	Active='Y',
	DefaultOrder=40,
	TabId=2,
	ScreenId=10018
	WHERE BannerName Like 'Assessment'
SELECT @BANNERID=BannerId from Banners where ScreenId=10018	
IF not exists (select ScreenId from DocumentNavigations where ScreenId =10018)
	BEGIN
		INSERT INTO DocumentNavigations(NavigationName,DisplayAs,Active,ParentDocumentNavigationId,BannerId,ScreenId)
		Values('Assessment' ,'Assessment' ,'Y' ,NULL ,@BANNERID ,10018)
	END
ELSE
	UPDATE DocumentNavigations SET 
	NavigationName='Assessment',
	DisplayAs='Assessment',
	Active='Y',
	ParentDocumentNavigationId=NULL,
	BannerId=@BANNERID,
	ScreenId=10018
	WHERE ScreenId =10018