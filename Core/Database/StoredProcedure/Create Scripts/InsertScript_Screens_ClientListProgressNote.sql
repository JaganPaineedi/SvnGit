
DECLARE @OfficeTabId INT
DECLARE @CustomStart INT
DECLARE @DefaultOrder INT
DECLARE @IsCustom VARCHAR(1)
Declare @screenToolBarUrl Varchar(500)
DECLARE @ListScreenId INT
DECLARE @ListScreenName VARCHAR(64)
DECLARE @ListScreenDesc VARCHAR(64)
DECLARE @ListScreenType INT
DECLARE @ListScreenURL VARCHAR(200)
DECLARE @bannerId INT
DECLARE @DetailScreenId INT
DECLARE @DetailScreenType INT
DECLARE @DetailScreenDesc VARCHAR(64)
DECLARE @DetailScreenURL VARCHAR(200)
DECLARE @DetailScreenPostUpdateSP VARCHAR(64)
DECLARE @TableList Varchar(200)
DECLARE @DocumentName Varchar(64)
DECLARE @DocumentDesc Varchar(64)
DECLARE @DocumentType Int
DECLARE @IsServiceNode Varchar(2)
DECLARE @RequireSignature Varchar(2)
DECLARE @ViewDocumentRDL Varchar(64)
DECLARE @StoredProcedure Varchar(64)
DECLARE @InitializationStoredProcedure Varchar(64)
DECLARE @ValidationStoredProcedureUpdate Varchar(64)
DECLARE @ValidationStoredProcedureComplete Varchar(64)
DECLARE @HelpURL Varchar(200)



DECLARE @PopUpScreenId INT
DECLARE @PopUpScreenName VARCHAR(64)
DECLARE @PopUpScreenDesc VARCHAR(64)
DECLARE @PopUpScreenType INT
DECLARE @PopUpScreenURL VARCHAR(200)


DECLARE @PopUpSecondScreenId INT
DECLARE @PopUpSecondScreenName VARCHAR(64)
DECLARE @PopUpSecondScreenDesc VARCHAR(64)
DECLARE @PopUpSecondScreenType INT
DECLARE @PopUpSecondScreenURL VARCHAR(200)
Set @DocumentName = 'Progress Note'
Set @DocumentDesc = 'Progress Note'
Set @DocumentType = 10
Set @IsServiceNode = 'N'
Set @TableList = 'DocumentProgressNotes,NoteEMCodeOptions'
Set @RequireSignature = 'Y'
SET @bannerId=10581
SET @ViewDocumentRDL = 'PCProgressNotes'
SET @StoredProcedure = 'ssp_GetClientProgressNote'
SET @screenToolBarUrl=null

/*
	Please change these variables for supporting a new page/document/widget
	Screen Types:
	    None:               0,
        Detail:             5761,
        List:               5762,
        Document:           5763,
        Summary:            5764,
        Custom:             5765,
        ExternalScreen:     5766
*/

SET @OfficeTabId = 2
SET @ListScreenId = 754
SET @ListScreenName = 'Client Progress Notes'
SET @ListScreenDesc = 'Client Progress Notes '
SET @ListScreenType = 5762
SET @ListScreenURL = '/ActivityPages/Client/ListPages/PrimaryCare/ProgressNotes/ClientProgressNote.ascx'

SET @DetailScreenId = 755
SET @DetailScreenType = 5763
SET @DetailScreenDesc = 'Progress Notes'
SET @DetailScreenURL = '/ActivityPages/Client/Detail//PrimaryCare/ProgressNotes/ClientProgressNoteDetail.ascx'
--SET @DetailScreenPostUpdateSP = 'ssp_PostUpdateClientAccounts'
SET @InitializationStoredProcedure='ssp_InitClientProgressNote'
SET @IsCustom = 'N'
SET @DefaultOrder = 1


SET @PopUpScreenId = 757
SET @PopUpScreenName = 'Select Diagnosis'
SET @PopUpScreenDesc = 'Select Diagnosis'
SET @PopUpScreenType = 5765
SET @PopUpScreenURL = 'ActivityPages\Client\Custom\PrimaryCare\ProgressNote\SelectDiagnosis.ascx'

SET @PopUpSecondScreenId = 760
SET @PopUpSecondScreenName = 'ICD Codes'
SET @PopUpSecondScreenDesc = 'ICD Codes'
SET @PopUpSecondScreenType = 5765
SET @PopUpSecondScreenURL = 'ActivityPages\Client\Custom\PrimaryCare\ProgressNote\SelectICDCode.ascx'
/*
	Delete previous records before create new
*/
--DELETE FROM Banners WHERE ScreenId=@ListScreenId

--DELETE FROM ScreenPermissionControls WHERE ScreenId=@ListScreenId
--Delete From StaffClientAccess where ScreenId =@ListScreenId
--DELETE FROM StaffScreenFilters WHERE ScreenId = @ListScreenId
--DELETE FROM UnsavedChanges WHERE ScreenId = @ListScreenId
--DELETE FROM Screens WHERE ScreenId=@ListScreenId
--DELETE FROM Screens WHERE ScreenId=@PopUpScreenId
--DELETE FROM Screens WHERE ScreenId=@PopUpSecondScreenId


--IF @DetailScreenId > 0 
--BEGIN
--	--DELETE FROM ScreenPermissionControls WHERE ScreenId=@DetailScreenId
--	--Delete From StaffClientAccess where ScreenId =@DetailScreenId
--	--DELETE FROM StaffScreenFilters WHERE ScreenId = @DetailScreenId
--	--DELETE FROM UnsavedChanges WHERE ScreenId = @DetailScreenId
--	--DELETE FROM Banners where ScreenId = @DetailScreenId
--	--DELETE FROM Screens WHERE ScreenId=@DetailScreenId
--END
/*
	Add to screens table
*/
DECLARE @DocumentCodeId Int
Set @DocumentCodeId =300
--SELECT @DocumentCodeId = Max(DocumentCodeId) FROM DocumentCodes WHERE DocumentName=@DocumentName
--Delete DocumentCodes where DocumentCodeId=@DocumentCodeId
IF Not Exists(Select DocumentCodeId From DocumentCodes Where DocumentCodeId=@DocumentCodeId)
BEGIN
SET IDENTITY_INSERT DocumentCodes ON

	INSERT  INTO  DocumentCodes
		(DocumentCodeId,DocumentName, DocumentDescription, DocumentType, 
		ServiceNote, RequiresSignature,
		ViewDocumentURL,
		ViewDocumentRDL,
		StoredProcedure,
		--InitializationStoredProcedure,
		TableList,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Active)
	VALUES     
		(@DocumentCodeId,@DocumentName,@DocumentDesc,@DocumentType,
		@IsServiceNode,@RequireSignature,
		@ViewDocumentRDL,
		@ViewDocumentRDL,
		@StoredProcedure,
		--@InitializationStoredProcedure,
		@TableList,'Msuma',GETDATE(),'Msuma',GETDATE(),'Y'
		)
		SET IDENTITY_INSERT DocumentCodes OFF
END
ELSE
BEGIN
		UPDATE DocumentCodes SET DocumentName=@DocumentName,DocumentDescription=@DocumentDesc,DocumentType=@DocumentType,ServiceNote=@IsServiceNode,RequiresSignature=@RequireSignature,
		ViewDocumentURL=@ViewDocumentRDL,StoredProcedure=@StoredProcedure,TableList=@TableList where documentcodeid=@DocumentCodeId
END
--	SELECT @DocumentCodeId = Max(DocumentCodeId) FROM DocumentCodes WHERE DocumentName=@DocumentName

IF Not Exists(Select ScreenId From Screens Where ScreenId=@ListScreenId)
BEGIN
SET IDENTITY_INSERT Screens ON
INSERT INTO Screens
	(ScreenId, ScreenName, ScreenType, ScreenURL,TabId)
VALUES     
	(@ListScreenId,@ListScreenDesc,@ListScreenType,@ListScreenURL,@OfficeTabId)
SET IDENTITY_INSERT Screens OFF
end

IF Not Exists(Select ScreenId From Screens Where ScreenId=@PopUpScreenId)
BEGIN
SET IDENTITY_INSERT Screens ON
INSERT INTO Screens
	(ScreenId, ScreenName, ScreenType, ScreenURL,TabId)
VALUES     
	(@PopUpScreenId,@PopUpScreenDesc,@PopUpScreenType,@PopUpScreenURL,@OfficeTabId)
SET IDENTITY_INSERT Screens OFF
end
IF Not Exists(Select ScreenId From Screens Where ScreenId=@PopUpSecondScreenId)
BEGIN
SET IDENTITY_INSERT Screens ON
INSERT INTO Screens
	(ScreenId, ScreenName, ScreenType, ScreenURL,TabId)
VALUES     
	(@PopUpSecondScreenId,@PopUpSecondScreenDesc,@PopUpSecondScreenType,@PopUpSecondScreenURL,@OfficeTabId)
SET IDENTITY_INSERT Screens OFF
end
/*
	Add to Banners
*/
IF Not Exists(Select BannerId From Banners Where BannerId=@bannerId)
begin
SET IDENTITY_INSERT Banners ON

INSERT  INTO  Banners
	(BannerId,BannerName, DisplayAs, DefaultOrder, Custom, TabId, ScreenId)
VALUES     
	(@bannerId,@ListScreenName, @ListScreenDesc, @DefaultOrder, @IsCustom, @OfficeTabId, @ListScreenId)
SET IDENTITY_INSERT Banners OFF
	end
/*
    If screen with the specified name doesnt exist already, create it.
*/
IF Not Exists(Select ScreenId From Screens Where ScreenId=@DetailScreenId)  
BEGIN
	SET IDENTITY_INSERT Screens ON
	INSERT INTO Screens
		(ScreenId, ScreenName, ScreenType, ScreenURL,DocumentCodeId,TabId,InitializationStoredProcedure,ScreenToolbarUrl,HelpURL)
	VALUES     
		(@DetailScreenId, @DetailScreenDesc, @DetailScreenType, @DetailScreenURL,@DocumentCodeId , @OfficeTabId,@InitializationStoredProcedure,@screenToolBarUrl,@HelpURL)
	SET IDENTITY_INSERT Screens OFF
END
ELSE
BEGIN
	update screens SET ScreenToolbarUrl=@screenToolBarUrl,HelpURL=@HelpURL,DocumentCodeId=@DocumentCodeId Where ScreenId=@DetailScreenId
END



