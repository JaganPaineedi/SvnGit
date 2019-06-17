/********************************************************************************                                                   
--  
-- Copyright: Streamline Healthcare Solutions  
-- "Data Portability ExportData PopUp"
-- Purpose: Script to add entries in Screens table for Task #28.1 - Meaningful Use - Stage 3. 
--  
-- Author:  Vijay
-- Date:    17-07-2017
--  
-- *****History****  
--
*********************************************************************************/
DECLARE @DocumentCodeId INT
DECLARE @ScreenId INT
DECLARE @ScreenType INT
DECLARE @Active CHAR(1)
DECLARE @ScreenName VARCHAR(64)
DECLARE @ScreenURL VARCHAR(200)
DECLARE @DetailScreenPostUpdateSP VARCHAR(64)
DECLARE @InitializationStoredProcedure VARCHAR(64)
DECLARE @PostUpdateStoredProcedure VARCHAR(64)
DECLARE @TabId INT
DECLARE @NewValidationStoredProcedure VARCHAR(64)
DECLARE @ValidationStoredProcedure VARCHAR(64)

SET @DocumentCodeId = NULL
SET @ScreenId = 1235
SET @ScreenType = 5765
SET @Active = 'Y'
SET @ScreenName = 'ExportData PopUp'
SET @ScreenURL = '/ActivityPages/Office/ListPages/ExportData.ascx'
SET @InitializationStoredProcedure = ''
SET @PostUpdateStoredProcedure = NULL 
SET @TabId = 1
set @NewValidationStoredProcedure = null;
set @ValidationStoredProcedure = Null;

IF NOT EXISTS (
		SELECT ScreenId
		FROM Screens
		WHERE ScreenId = @ScreenId
		)
BEGIN
	SET IDENTITY_INSERT Screens ON

	INSERT INTO [Screens] (
		ScreenId
		,[ScreenName]
		,[ScreenType]
		,[ScreenURL]
		,[TabId]
		,[DocumentCodeId]
		,[InitializationStoredProcedure]
		,[ValidationStoredProcedureComplete]
		,[PostUpdateStoredProcedure]
		)
	VALUES (
		@ScreenId
		,@ScreenName
		,@ScreenType
		,@ScreenURL
		,@TabId
		,@DocumentCodeId
		,@InitializationStoredProcedure
		,@ValidationStoredProcedure
		,@PostUpdateStoredProcedure
		)

	SET IDENTITY_INSERT Screens OFF
END
ELSE
BEGIN
	UPDATE screens
	SET screenname = @ScreenName
		,screentype = @ScreenType
		,screenurl = @ScreenURL
		,tabid = @TabId
		,DocumentCodeId = @DocumentCodeId
		,InitializationStoredProcedure = @InitializationStoredProcedure
		,ValidationStoredProcedureComplete = @ValidationStoredProcedure
		,PostUpdateStoredProcedure = @PostUpdateStoredProcedure
	WHERE screenid = @ScreenId
END

