/****** Object:  StoredProcedure [dbo].[csp_UtilCreateDocumentCodeScreenAndBanner]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_UtilCreateDocumentCodeScreenAndBanner]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_UtilCreateDocumentCodeScreenAndBanner]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_UtilCreateDocumentCodeScreenAndBanner]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[csp_UtilCreateDocumentCodeScreenAndBanner]
-- Utility stored procedure to create new documentcodes and screens.  Not used by the smartcare application.
-- Log:
--		2012.03.27 - T. Remisoski - Created.
--
	@DocumentName varchar(100),
	@ScreenId int,
	@DocumentCodeId int,
	@ParentBannerId int,
	@DocumentRDL varchar(200),
	@TableList varchar(1000),
	@GetDataStoredProcedure varchar(250),
	@InitializationStoreProcedure varchar(250),
	@ValidationStoredProcedure varchar(250),
	@PostUpdateStoredProcedure varchar(250),
	@ViewStoredProcedure varchar(250),
	@ScreenURL varchar(1000)	-- ex: /ActivityPages/Client/Detail/Documents/DocumentLetters.ascx
as

begin try
begin tran

if exists(select * from dbo.Screens where ScreenId = @ScreenId)
	raiserror(''Screen Id already exists.  Cannot create.'', 16, 1)

if exists(select * from dbo.DocumentCodes where DocumentCodeId = @DocumentCodeId)
	raiserror(''Document Code Id already exists.  Cannot create.'', 16, 1)

set identity_insert dbo.DocumentCodes on
insert into dbo.DocumentCodes
        (
        DocumentCodeId,
         DocumentName,
         DocumentDescription,
         DocumentType,
         Active,
         ServiceNote,
         PatientConsent,
         OnlyAvailableOnline,
         ViewDocumentURL,
         ViewDocumentRDL,
         StoredProcedure,
         TableList,
         RequiresSignature,
         ViewOnlyDocument,
         InitializationStoredProcedure,
         FormCollectionId,
         ValidationStoredProcedure,
         ViewStoredProcedure,
         MetadataFormId,
         TextTemplate,
         RequiresLicensedSignature,
         ReviewFormId,
         MedicationReconciliationDocument
        )
values  (
		@DocumentCodeid,
         @DocumentName, -- DocumentName - varchar(100)
         @DocumentName, -- DocumentDescription - varchar(250)
         10, -- DocumentType - type_GlobalCode
         ''Y'', -- Active - type_Active
         ''N'', -- ServiceNote - type_YOrN
         ''N'', -- PatientConsent - type_YOrN
         ''N'', -- OnlyAvailableOnline - type_YOrN
         @DocumentRDL, -- ViewDocumentURL - varchar(1000)
         @DocumentRDL, -- ViewDocumentRDL - text
         @GetDataStoredProcedure, -- StoredProcedure - varchar(100)
         @TableList, -- TableList - varchar(1000)
         ''Y'', -- RequiresSignature - type_YOrN
         ''N'', -- ViewOnlyDocument - type_YOrN
         @InitializationStoreProcedure, -- InitializationStoredProcedure - varchar(100)
         null, -- FormCollectionId - int
         @ValidationStoredProcedure, -- ValidationStoredProcedure - varchar(100)
         @ViewStoredProcedure, -- ViewStoredProcedure - varchar(100)
         null, -- MetadataFormId - int
         null, -- TextTemplate - type_Comment2
         ''N'', -- RequiresLicensedSignature - type_YOrN
         null, -- ReviewFormId - int
         ''N''  -- MedicationReconciliationDocument - type_YOrN
        )

set identity_insert dbo.DocumentCodes off


set identity_insert dbo.Screens on
insert into dbo.Screens
        (
        ScreenId,
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
         PrimaryKeyName
        )
values  (
		@ScreenId,
         @DocumentName, -- ScreenName - varchar(100)
         5763, -- ScreenType - type_GlobalCode
         @ScreenURL, -- ScreenURL - varchar(200)
         null, -- ScreenToolbarURL - varchar(200)
         2, -- TabId - int
         @InitializationStoreProcedure, -- InitializationStoredProcedure - varchar(100)
         null, -- ValidationStoredProcedureUpdate - varchar(100)
         @ValidationStoredProcedure, -- ValidationStoredProcedureComplete - varchar(100)
         null, -- WarningStoredProcedureComplete - varchar(100)
         @PostUpdateStoredProcedure, -- PostUpdateStoredProcedure - varchar(100)
         null, -- RefreshPermissionsAfterUpdate - type_YOrN
         @DocumentCodeId, -- DocumentCodeId - int
         null, -- CustomFieldFormId - int
         null, -- HelpURL - varchar(1000)
         null, -- MessageReferenceType - type_GlobalCode
         null  -- PrimaryKeyName - varchar(100)
        )
set identity_insert dbo.Screens off

-- Create a new Banner

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
         100, -- DefaultOrder - int
         ''N'', -- Custom - type_YOrN
         2, -- TabId - int
         @ParentBannerId, -- ParentBannerId - int
         @ScreenId, -- ScreenId - int
         null  -- ScreenParameters - varchar(200)
        )
        
select * from dbo.Banners where ScreenId = @ScreenId
select * from dbo.Screens where ScreenId = @ScreenId
select * from dbo.DocumentCodes where DocumentCodeId = @DocumentCodeId

commit tran
end try
begin catch
if @@TRANCOUNT > 0 rollback tran
declare @error_message nvarchar(4000)
set @error_message = ERROR_MESSAGE()
raiserror (@error_message, 16, 1)
end catch

' 
END
GO
