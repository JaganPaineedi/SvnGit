/****** Object:  StoredProcedure [dbo].[csp_UtilityCreateScannedForm]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_UtilityCreateScannedForm]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_UtilityCreateScannedForm]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_UtilityCreateScannedForm]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE procedure [dbo].[csp_UtilityCreateScannedForm]
	@DocumentName varchar(100),
	@ParentBannerId int,
	@ParentDocumentNavigationId int,
	@MetaDataFormId int,
	@ReviewFormId int,
	@RequiresSignature char(1)

as

begin try
begin tran

declare @DocumentCodeId int, @BannerId int, @ScreenId int


--set @DocumentCodeId = 1000144
--set @DocumentName = ''Other External Document''
--set @ParentBannerId = 856
--set @ReviewFormId = null
--set @RequiresSignature = ''N''

select @DocumentCodeId = DocumentCodeId
from dbo.DocumentCodes 
where 
	DocumentName = @DocumentName and DocumentType = 17 and ISNULL(RecordDeleted, ''N'') <> ''Y''

if not @DocumentCodeId is not null
begin


	insert into dbo.DocumentCodes
			(
			 DocumentName,
			 DocumentDescription,
			 DocumentType,
			 Active,
			 ServiceNote,
			 PatientConsent,
			 OnlyAvailableOnline,
			 ViewDocumentURL,
			 ViewDocumentRDL,
			 RequiresSignature,
			 MetadataFormId,
			 ReviewFormId,
			 TableList,
			 ViewOnlyDocument
			)
	values  (
			 @DocumentName, -- DocumentName - varchar(100)
			 @DocumentName, -- DocumentDescription - varchar(250)
			 17, -- DocumentType - type_GlobalCode
			 ''Y'', -- Active - type_Active
			 ''N'', -- ServiceNote - type_YOrN
			 ''N'', -- PatientConsent - type_YOrN
			 ''N'', -- OnlyAvailableOnline - type_YOrN
			 ''RDLScannedForms'', -- ViewDocumentURL - varchar(1000)
			 ''RDLScannedForms'', -- ViewDocumentRDL - text
			 @RequiresSignature, -- RequiresSignature - type_YOrN
			 @MetaDataFormId, -- MetadataFormId - int
			 @ReviewFormId, -- ReviewFormId - int
			 ''ImageRecords'',
			 case when @RequiresSignature = ''N'' then ''Y'' end
			)
	
	set @DocumentCodeId = SCOPE_IDENTITY()

end
else
begin
	update dbo.DocumentCodes set
			 DocumentName = @DocumentName,
			 DocumentDescription = @DocumentName,
			 DocumentType = 17,
			 Active = ''Y'',
			 ServiceNote = ''N'',
			 PatientConsent = ''N'',
			 OnlyAvailableOnline = ''N'',
			 ViewDocumentURL = ''RDLScannedForms'',
			 ViewDocumentRDL = ''RDLScannedForms'',
			 RequiresSignature = @RequiresSignature,
			 MetadataFormId = @MetaDataFormId,
			 ReviewFormId = @ReviewFormId,
			 TableList = ''ImageRecords''
	where DocumentCodeId = @DocumentCodeId
	
end

--select * from dbo.DocumentCodes where ViewDocumentRDL is not null and DocumentType <> 17
--select * from dbo.DocumentCodesRDLSubReports

if @ReviewFormId is not null
begin
	insert into dbo.DocumentCodesRDLSubReports
			(
			 DocumentCodeId,
			 SubReportName,
			 SubReportDescription,
			 SubReportURL,
			 SubReportRDL,
			 SubReportOrder,
			 StoredProcedure,
			 Active
			)
	values  (
			 @DocumentCodeId, -- DocumentCodeId - int
			 ''RDLLabResults'', -- SubReportName - varchar(100)
			 ''RDLLabResults'', -- SubReportDescription - varchar(250)
			 ''RDLLabResults'', -- SubReportURL - varchar(1000)
			 ''RDLLabResults'', -- SubReportRDL - text
			 1, -- SubReportOrder - int
			 ''csp_RDLLabResults'', -- StoredProcedure - varchar(100)
			 ''Y'' -- Active - type_Active
			)
end

if not exists (select * from dbo.Screens where DocumentCodeId = @DocumentCodeId)
begin
	insert into dbo.Screens 
			(
			 ScreenName,
			 ScreenType,
			 ScreenURL,
			 ScreenToolbarURL,
			 TabId,
			 InitializationStoredProcedure,
			 ValidationStoredProcedureUpdate,
			 ValidationStoredProcedureComplete,
			 WarningStoredProcedureComplete,
			 PostUpdateStoredProcedure,
			 RefreshPermissionsAfterUpdate,
			 DocumentCodeId,
			 CustomFieldFormId,
			 HelpURL,
			 MessageReferenceType,
			 PrimaryKeyName,
			 WarningStoreProcedureUpdate
			)
	values  (
			 @DocumentName, -- ScreenName - varchar(100)
			 5763, -- ScreenType - type_GlobalCode
			 ''/ActivityPages/Client/Detail/Documents/ScannedMedicalRecord.ascx'', -- ScreenURL - varchar(200)
			 null, -- ScreenToolbarURL - varchar(200)
			 2, -- TabId - int
			 null, -- InitializationStoredProcedure - varchar(100)
			 null, -- ValidationStoredProcedureUpdate - varchar(100)
			 null, -- ValidationStoredProcedureComplete - varchar(100)
			 null, -- WarningStoredProcedureComplete - varchar(100)
			 null, -- PostUpdateStoredProcedure - varchar(100)
			 null, -- RefreshPermissionsAfterUpdate - type_YOrN
			 @DocumentCodeid, -- DocumentCodeId - int
			 null, -- CustomFieldFormId - int
			 null, -- HelpURL - varchar(1000)
			 null, -- MessageReferenceType - type_GlobalCode
			 null, -- PrimaryKeyName - varchar(100)
			 null  -- WarningStoreProcedureUpdate - varchar(100)
			)
	        
	set @ScreenId = SCOPE_IDENTITY()
end
else
begin
	select @ScreenId = ScreenId from dbo.Screens where DocumentCodeId = @DocumentCodeId
	update dbo.Screens set
			 ScreenName = @DocumentName,
			 ScreenType = 5763,
			 ScreenURL = ''/ActivityPages/Client/Detail/Documents/ScannedMedicalRecord.ascx'',
			 ScreenToolbarURL = null,
			 TabId = 2,
			 InitializationStoredProcedure = null,
			 ValidationStoredProcedureUpdate = null,
			 ValidationStoredProcedureComplete = null,
			 WarningStoredProcedureComplete = null,
			 PostUpdateStoredProcedure = null,
			 RefreshPermissionsAfterUpdate = null,
			 CustomFieldFormId = null,
			 HelpURL = null,
			 MessageReferenceType = null,
			 PrimaryKeyName = null,
			 WarningStoreProcedureUpdate = null
	where ScreenId = @ScreenId
end
	

if not exists (select * from dbo.Banners where ScreenId = @ScreenId)
begin
	insert into dbo.Banners 
			(
			 BannerName,
			 DisplayAs,
			 Active,
			 DefaultOrder,
			 Custom,
			 TabId,
			 ParentBannerId,
			 ScreenId,
			 ScreenParameters
			)
	values  (
			 @DocumentName, -- BannerName - varchar(100)
			 @DocumentName, -- DisplayAs - varchar(100)
			 ''Y'', -- Active - type_Active
			 1, -- DefaultOrder - int
			 ''N'', -- Custom - type_YOrN
			 2, -- TabId - int
			 @ParentBannerId, -- ParentBannerId - int
			 @ScreenId, -- ScreenId - int
			 null  -- ScreenParameters - varchar(200)
			)
			
	set @BannerId = SCOPE_IDENTITY()
end
else
begin
	select @BannerId = BannerId from dbo.Banners where ScreenId = @ScreenId
	
	update dbo.Banners set
		BannerName = @DocumentName,
		DisplayAs = @DocumentName,
		Active  = ''Y'',
		DefaultOrder = 1,
		Custom = ''N'',
		TabId = 2,
		ParentBannerId = @ParentBannerId,
		ScreenParameters = null
	where BannerId = @BannerId

end

if not exists (select * from dbo.DocumentNavigations where ScreenId = @ScreenId)
begin
	insert into dbo.DocumentNavigations
	        (
	         NavigationName,
	         DisplayAs,
	         Active,
	         ParentDocumentNavigationId,
	         BannerId,
	         ScreenId
	        )
	values  (
	         @DocumentName, -- NavigationName - varchar(100)
	         @DocumentName, -- DisplayAs - varchar(100)
	         ''Y'', -- Active - type_Active
	         @ParentDocumentNavigationId, -- ParentDocumentNavigationId - int
	         @BannerId, -- BannerId - int
	         @ScreenId -- ScreenId - int
	        )
end
else
begin
	update dbo.DocumentNavigations set
		NavigationName = @DocumentName,
		DisplayAs = @DocumentName,
		Active = ''Y'',
		ParentDocumentNavigationId = @ParentDocumentNavigationId,
		BannerId = @BannerId
	where ScreenId = @ScreenId
end

	

commit tran
end try
begin catch
if @@TRANCOUNT > 0 rollback tran
set identity_insert dbo.Screens off
set identity_insert dbo.DocumentCodes off

declare @error_message nvarchar(4000)
set @error_message = ERROR_MESSAGE()
raiserror (@error_message, 16, 1)
end catch

' 
END
GO
