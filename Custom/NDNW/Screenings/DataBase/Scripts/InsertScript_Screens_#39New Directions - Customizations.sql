---------------------------------------------------------------------------------------------
--Author : Shruthi.S
--Date   : 05/05/2015
--Purpose: Screen entry for Screening document.Ref : #39 New Directions - Customizations .
---------------------------------------------------------------------------------------------


    

------------DocumentCodes entry----------------------------------

if not exists(Select 1 from DocumentCodes where DocumentCodeId=60007)
	Begin
	Set identity_insert DocumentCodes on
		Insert Into DocumentCodes
		(
		DocumentCodeId,
		DocumentName,
		DocumentDescription,
		DocumentType,
		Active,
		ServiceNote,
		OnlyAvailableOnline,
		TableList,
		RequiresSignature,
		FormCollectionId,
		AllowEditingByNonAuthors,
		DiagnosisDocument,
		StoredProcedure,
		InitializationStoredProcedure,
		ViewStoredProcedure,
		ViewDocumentRDL,
		ViewDocumentURL)
		Values(
		60007,
		'Screening',
		'Screening',
		10,
		'Y',
		'N',
		'Y',
		'CustomDocumentSubstanceAbuseScreenings,CustomDocumentMentalHealthScreenings,CustomDocumentTraumaticBrainInjuryScreenings,CustomDocumentOutComesScreenings',
		'Y',
		NULL,
		NULL,
		NULL,
		'csp_GetDataForCustomScreening',
		NULL,'csp_RDLCustomScreening',
		'RDLCustomScreening',
		'RDLCustomScreening')
    Set identity_insert DocumentCodes off
    End
    Else
    Begin
    Update DocumentCodes 
    Set DocumentName= 'Screening',
		DocumentDescription = 'Screening',
		DocumentType = 10,
		Active='Y',
		ServiceNote='N',
		OnlyAvailableOnline = 'Y',
		TableList='CustomDocumentSubstanceAbuseScreenings,CustomDocumentMentalHealthScreenings,CustomDocumentTraumaticBrainInjuryScreenings,CustomDocumentOutComesScreenings',
		RequiresSignature = 'Y',
		StoredProcedure = 'csp_GetDataForCustomScreening',
		ViewStoredProcedure='csp_RDLCustomScreening',
		ViewDocumentRDL = 'RDLCustomScreening',
		ViewDocumentURL = 'RDLCustomScreening',
		NewValidationStoredProcedure = NULL 
    where DocumentCodeId = 60007
	End
GO

----------------Screens entry----------------------

if not exists(Select 1 from Screens where ScreenId=60007)
	Begin
		Set identity_insert Screens on
            Insert Into Screens 
            (
            ScreenId,
            ScreenName,
            ScreenType,
            ScreenURL,
            TabId,
            DocumentCodeId,
            KeyPhraseCategory,
            ValidationStoredProcedureComplete,
            InitializationStoredProcedure) 
            Values 
            (60007,
            'Screening',
            5763,
            '/Custom/Screenings/WebPages/ScreeningsMain.ascx',
            2,
            60007,
            NULL,
            'csp_validateCustomScreening',
            'csp_InitCustomScreeningStandardInitialization')
		set identity_insert Screens off
	End
	Else 
	Begin
	Update Screens 
	Set 
	ScreenName = 'Screening',
	ScreenType = 5763,
	ScreenURL ='/Custom/Screenings/WebPages/ScreeningsMain.ascx', 
	TabId = 2,
	DocumentCodeId  = 60007,
	ValidationStoredProcedureComplete= 'csp_validateCustomScreening',
	InitializationStoredProcedure = 'csp_InitCustomScreeningStandardInitialization'
	Where ScreenId = 60007
	End
GO


--------------------Banners entry----------------------
if not exists(Select 1 from Banners where BannerName='Screening' and ScreenId=60007)
	Begin

	Insert Into Banners
	(
		BannerName,
		DisplayAs,
		ParentBannerId,
		ScreenId,
		Active,
		DefaultOrder,
		Custom,
		TabId
	)
	Values
    (
		'Screening',
		'Screening',
		21,
		60007,
		'Y',
		11,
		'N',
		2
	)
	
    End
    else
    Begin
    Update Banners
    set 
		BannerName='Screening',
		DisplayAs='Screening',
		ParentBannerId=21,
		ScreenId= 60007,
		Active='Y',
		DefaultOrder=11,
		Custom='N',
		TabId=2
    where BannerName='Screening' and ScreenId=60007
    END 
Go   

---To get the bannerid for documentnavigations

Declare @BannerId  INT
select  @BannerId = BannerId from Banners where BannerName='Screening' and ScreenId=60007


----------DocumentNavigations entry---------------


if not exists(Select 1 from DocumentNavigations where NavigationName='Screening' and ScreenId=60007)
	Begin
	
		Insert into DocumentNavigations
		(
			NavigationName,
			DisplayAs,
			Active,
			BannerId,
			ScreenId
		)
		values
		(
			'Screening',
			'Screening',
			'Y',
			@BannerId,
			60007
		)

	END
else
begin
Update DocumentNavigations
set
	NavigationName='Screening',
	DisplayAs='Screening',
	Active='Y',
	ScreenId = 60007,
	BannerId=@BannerId
Where NavigationName = 'Screening' and ScreenId=60007

end
Go





