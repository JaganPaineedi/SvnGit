--Core Global Code Ref : #73 Network180-Customizations.
--Insert script GlobalCodeCategories BatchClaimEntryStatus, Screens, Banners & ScreenPermissionControls

IF NOT EXISTS(SELECT Category FROM GlobalCodeCategories WHERE CATEGORY='BatchClaimStatus')
BEGIN
	INSERT INTO GlobalCodeCategories(Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,UserDefinedCategory,HasSubcodes) 
	VALUES('BatchClaimStatus','BatchClaimStatus','Y','N','N','Y','Y','N')
END

IF NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='BatchClaimStatus' AND Code='SHOWALLCLAIMLINES')
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[SortOrder])
	VALUES('BatchClaimStatus','Show all claim lines','SHOWALLCLAIMLINES','Y','N',1)
END

IF NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='BatchClaimStatus' AND Code='SHOWCLAIMSWITHWARNING')
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[SortOrder])
	VALUES('BatchClaimStatus','Show claims with warning','SHOWCLAIMSWITHWARNING','Y','N',1)
END

IF NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='BatchClaimStatus' AND Code='SHOWVALIDSUBMITTEDCLAIMS')
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[SortOrder])
	VALUES('BatchClaimStatus','Show valid/submitted claims','SHOWVALIDSUBMITTEDCLAIMS','Y','N',1)
END

IF NOT EXISTS(SELECT Category FROM GlobalCodeCategories WHERE CATEGORY='BatchClaimSortBy')
BEGIN
	INSERT INTO GlobalCodeCategories(Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,UserDefinedCategory,HasSubcodes) 
	VALUES('BatchClaimSortBy','BatchClaimSortBy','Y','N','N','Y','Y','N')
END

IF NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='BatchClaimSortBy' AND Code='CLIENTNAMEDATEBILLINGCODE')
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[SortOrder])
	VALUES('BatchClaimSortBy','Client Name – Date – Billing Code','CLIENTNAMEDATEBILLINGCODE','Y','N',1)
END

IF NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='BatchClaimSortBy' AND Code='CLIENTNAMEBILLINGCODEDATE')
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[SortOrder])
	VALUES('BatchClaimSortBy','Client Name – Billing Code – Date','CLIENTNAMEBILLINGCODEDATE','Y','N',1)
END

IF NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='BatchClaimSortBy' AND Code='BILLINGCODEDATECLIENTNAME')
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[SortOrder])
	VALUES('BatchClaimSortBy','Billing Code – Date – Client Name','BILLINGCODEDATECLIENTNAME','Y','N',1)
END

IF NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='BatchClaimSortBy' AND Code='BILLINGCODECLIENTNAMEDATE')
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[SortOrder])
	VALUES('BatchClaimSortBy','Billing Code – Client Name – Date','BILLINGCODECLIENTNAMEDATE','Y','N',1)
END

IF NOT EXISTS(SELECT Category FROM GlobalCodeCategories WHERE CATEGORY='BatchClaimOtherFiltr')
BEGIN
	INSERT INTO GlobalCodeCategories(Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,UserDefinedCategory,HasSubcodes) 
	VALUES('BatchClaimOtherFiltr','BatchClaimOtherFiltr','Y','N','N','Y','Y','N')
END

IF NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='BatchClaimOtherFiltr' AND Code='OTHER')
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[SortOrder])
	VALUES('BatchClaimOtherFiltr','Other','OTHER','Y','N',1)
END


IF NOT EXISTS(SELECT Category FROM GlobalCodeCategories WHERE CATEGORY='BatchClaimBtchStatus')
BEGIN
	INSERT INTO GlobalCodeCategories(Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,UserDefinedCategory,HasSubcodes) 
	VALUES('BatchClaimBtchStatus','BatchClaimBtchStatus','Y','N','N','Y','Y','N')
END

IF NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='BatchClaimBtchStatus' AND Code='VALID')
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[SortOrder])
	VALUES('BatchClaimBtchStatus','Valid','VALID','Y','N',1)
END

IF NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='BatchClaimBtchStatus' AND Code='WARNING')
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[SortOrder])
	VALUES('BatchClaimBtchStatus','Warning','WARNING','Y','N',2)
END

IF NOT EXISTS(SELECT Category FROM GlobalCodes WHERE Category='BatchClaimBtchStatus' AND Code='SUBMITTED')
BEGIN	
	INSERT INTO [dbo].GlobalCodes([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[SortOrder])
	VALUES('BatchClaimBtchStatus','Submitted','SUBMITTED','Y','N',3)
END


--------------------------------------------------------------------
--Author : Shruthi.S
--Date   : 02/08/2016
--Purpose : Added screen entry for Batch Claim Entry screen.Ref : #73 Network 180 - Customizations.
--------------------------------------------------------------------
SET IDENTITY_INSERT [SCREENS] ON
GO

IF NOT EXISTS (
		SELECT [SCREENNAME]
		FROM SCREENS
		WHERE [SCREENNAME] = 'Batch Claim Direct Entry'
			AND [SCREENID] = 1198
		)
BEGIN
	INSERT INTO [DBO].[SCREENS] (
		[SCREENID]
		,[SCREENNAME]
		,[SCREENTYPE]
		,[SCREENURL]
		,[TABID]
		,[ScreenToolbarURL]
		)
	VALUES (
		1198
		,'Batch Claim Direct Entry'
		,5762
		,'Modules/CareManagement/ActivityPages/Office/ListPages/BatchClaimDirectEntry.ascx'
		,1
		,'ScreenToolBars/BatchClaimToolBar.ascx'
		)
END

IF NOT EXISTS (
		SELECT [SCREENNAME]
		FROM SCREENS
		WHERE [SCREENNAME] = 'Upload New Claims'
			AND [SCREENID] = 1199
		)
BEGIN
	INSERT INTO [DBO].[SCREENS] (
		[SCREENID]
		,[SCREENNAME]
		,[SCREENTYPE]
		,[SCREENURL]
		,[TABID]
		)
	VALUES (
		1199
		,'Upload New Claims'
		,5765
		,'Modules/CareManagement/ActivityPages/Office/Custom/UploadNewClaims.ascx'
		,1
		)
END
GO

IF NOT EXISTS (
		SELECT [SCREENNAME]
		FROM SCREENS
		WHERE [SCREENNAME] = 'Batch Claim Uploads'
			AND [SCREENID] = 1200
		)
BEGIN
	INSERT INTO [DBO].[SCREENS] (
		[SCREENID]
		,[SCREENNAME]
		,[SCREENTYPE]
		,[SCREENURL]
		,[TABID]
		,[ScreenToolbarURL]
		)
	VALUES (
		1200
		,'Batch Claim Uploads'
		,5762
		,'Modules/CareManagement/ActivityPages/Office/ListPages/BatchClaimUploads.ascx'
		,1
		,'ScreenToolBars/BatchClaimUploadToolBar.ascx'
		)
END
GO

SET IDENTITY_INSERT [SCREENS] OFF
GO

IF NOT EXISTS (
		SELECT BANNERNAME
		FROM BANNERS
		WHERE BANNERNAME = 'Batch Claim Uploads'
		)
BEGIN
	INSERT INTO BANNERS (
		BANNERNAME
		,DISPLAYAS
		,ACTIVE
		,DEFAULTORDER
		,CUSTOM
		,TABID
		,SCREENID
		)
	VALUES (
		'Batch Claim Uploads'
		,'Batch Claim Uploads'
		,'Y'
		,1
		,'N'
		,1
		,1200
		)
END

---Screen Permission Controls entry for export button.
IF NOT EXISTS (
		SELECT *
		FROM screenpermissioncontrols
		WHERE screenid = 1198
			AND ControlName = 'ButtonExport'
		)
BEGIN
	INSERT INTO screenpermissioncontrols (
		screenid
		,controlname
		,displayas
		,active
		)
	VALUES (
		1198
		,'ButtonExport'
		,'Export'
		,'Y'
		)
END

IF NOT EXISTS (
		SELECT *
		FROM screenpermissioncontrols
		WHERE screenid = 1200
			AND ControlName = 'ButtonExport'
		)
BEGIN
	INSERT INTO screenpermissioncontrols (
		screenid
		,controlname
		,displayas
		,active
		)
	VALUES (
		1200
		,'ButtonExport'
		,'Export'
		,'Y'
		)
END