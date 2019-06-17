IF object_id('ssp_JobImportERFiles', 'P') IS NOT NULL
	DROP PROCEDURE [dbo].[ssp_JobImportERFiles]
GO

/****** Object:  StoredProcedure [dbo].[ssp_JobImportERFiles]    Script Date: 11/15/2017 4:09:35 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_JobImportERFiles] @UserId INT = NULL
	/*********************************************************************
-- Stored Procedure: dbo.ssp_JobImportERFiles
-- Creation Date:    10/6/2017
--
-- Purpose:  Retreive er files from folder & import into Smartcare 
--
-- Updates:
--   Date   Author		Purpose
-- History
06OCT2017	MJensen		Created
*********************************************************************/
AS
BEGIN TRY
	DECLARE @DirCommand VARCHAR(4000)
		,@ErSenderId INT
		,@SenderId INT
		,@ApplyAdjustments type_YOrN
		,@ApplyBalanceTransfers type_YOrN
		,@ImportDirectoryPath VARCHAR(200)
		,@ImportFilesBackupDirectory VARCHAR(200)
		,@ImportFileId INT
		,@ImportFileName VARCHAR(250)
		,@FileText VARCHAR(MAX)
		,@UserCode VARCHAR(30)
		,@FileName VARCHAR(250);

	SELECT @UserCode = UserCode
	FROM Staff
	WHERE StaffId = @UserId

	CREATE TABLE #ImportFiles (
		ImportFileId INT IDENTITY
		,ImportFileName VARCHAR(250)
		)

	-- Import files for each sender separately
	DECLARE Sender_Cursor CURSOR
	FOR
	SELECT ERSenderId
		,SenderId
		,ImportDirectoryPath
		,ImportFilesBackupDirectory
		,ApplyAdjustments
		,ApplyBalanceTransfers
	FROM ERSenders
	WHERE ImportDirectoryPath IS NOT NULL
		AND Isnull(RecordDeleted, 'N') = 'N'
		AND Active = 'Y'

	OPEN Sender_Cursor

	FETCH NEXT
	FROM Sender_Cursor
	INTO @ErSenderId
		,@SenderId
		,@ImportDirectoryPath
		,@ImportFilesBackupDirectory
		,@ApplyAdjustments
		,@ApplyBalanceTransfers

	WHILE @@FETCH_STATUS = 0
	BEGIN
		TRUNCATE TABLE #ImportFiles

		SET @ImportDirectoryPath = LTRIM(RTRIM(@ImportDirectoryPath))

		IF SUBSTRING(@ImportDirectoryPath, LEN(@ImportDirectoryPath), 1) != '\'
		BEGIN
			SET @ImportDirectoryPath = @ImportDirectoryPath + '\'
		END

		SET @ImportFilesBackupDirectory = LTRIM(RTRIM(@ImportFilesBackupDirectory))

		IF SUBSTRING(@ImportFilesBackupDirectory, LEN(@ImportFilesBackupDirectory), 1) != '\'
		BEGIN
			SET @ImportFilesBackupDirectory = @ImportFilesBackupDirectory + '\'
		END

		-- Get list of files in directory
		SET @DirCommand = 'dir "' + @ImportDirectoryPath + '" /b /a:-d'

		INSERT INTO #ImportFiles (ImportFileName)
		EXEC master..xp_cmdshell @DirCommand;

		-- Remove files already imported
		DELETE
		FROM #ImportFiles
		FROM #ImportFiles imp
		JOIN ERFiles e ON imp.ImportFileName = e.FileName
			AND @ErSenderId = e.ERSenderId

		-- Remove blank file names
		DELETE
		FROM #ImportFiles
		WHERE ImportFileName IS NULL
			OR ImportFileName = 'File Not Found'
			OR ImportFileName = ''

		DECLARE File_Cursor CURSOR
		FOR
		SELECT ImportFileId
			,ImportFileName
		FROM #ImportFiles

		OPEN File_Cursor

		FETCH NEXT
		FROM File_Cursor
		INTO @ImportFileId
			,@ImportFileName

		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @FileText = NULL
			SET @FileName = @ImportDirectoryPath + @ImportFileName
			EXEC ssp_ReadFileAsString @FileName = @FileName, @FileText = @FileText OUTPUT

			IF @FileText IS NOT NULL
			BEGIN
				INSERT INTO ERFiles (
					FileName
					,ImportDate
					,FileText
					,ERSenderId
					,ApplyAdjustments
					,ApplyTransfers
					,TotalPayments
					,Processed
					,DoNotProcess
					,Processing
					,ProcessingStartTime
					,CreatedBy
					,CreatedDate
					,ModifiedBy
					,ModifiedDate
					,RecordDeleted
					,DeletedDate
					,DeletedBy
					)
				VALUES (
					@ImportFileName
					,GETDATE()
					,@FileText
					,@ErSenderId
					,@ApplyAdjustments
					,@ApplyBalanceTransfers
					,NULL
					,'N'
					,'N'
					,'N'
					,NULL
					,@UserCode
					,GETDATE()
					,@UserCode
					,GETDATE()
					,NULL
					,NULL
					,NULL
					)

				-- Move file to backup directory
				IF @ImportFilesBackupDirectory IS NOT NULL
					AND LEN(@ImportFilesBackupDirectory) > 0
				BEGIN
					SET @DirCommand = 'Move "' + @ImportDirectoryPath + @ImportFileName + '" "' + @ImportFilesBackupDirectory + '"'

					EXEC master..xp_cmdshell @DirCommand;
				END
			END

			FETCH NEXT
			FROM File_Cursor
			INTO @ImportFileId
				,@ImportFileName
		END

		CLOSE File_Cursor

		DEALLOCATE File_Cursor

		FETCH NEXT
		FROM Sender_Cursor
		INTO @ErSenderId
			,@SenderId
			,@ImportDirectoryPath
			,@ImportFilesBackupDirectory
			,@ApplyAdjustments
			,@ApplyBalanceTransfers
	END

	CLOSE Sender_Cursor

	DEALLOCATE Sender_Cursor
END TRY

BEGIN CATCH
	DECLARE @Error VARCHAR(8000)

	SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_JobImportERFiles ') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

	RAISERROR (
			@Error
			,-- Message text.                                          
			16
			,-- Severity.                                          
			1 -- State.                                          
			);
END CATCH
GO

