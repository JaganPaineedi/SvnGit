IF OBJECT_ID('ssp_WriteStringToFile', 'P') IS NOT NULL
	DROP PROCEDURE ssp_WriteStringToFile
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE ssp_WriteStringToFile (
	@FileText VARCHAR(max)
	,@DirectoryPath VARCHAR(255)
	,@Filename VARCHAR(100)
	)
AS
/******************************************************************************                         
**  Name: ssp_WriteStringToFile    
**  Desc: Creates a text file and writes the contents of a string to it.   
**                      
**                     
**                                                                           
**  Example:	EXEC ssp_WriteStringToFile @FileText = @FileText, @DirectoryPath = 'c:\My Folder' @FileName = 'MyFile.txt' , @ReturnMessage = @ReturnMessage OutPut
**                       
**                      
**  Created   
**  Date:  21 DEC 2017   
*******************************************************************************                      
**  Change History                      
*******************************************************************************                      
**  Date:		Author:				Description:                      
**  --------	--------			-------------------------------------------     
**  12/21/2017	MJensen				Created  
**									Create from function dbo.ssf_WriteStringToFile.  Proc required because function does not destroy handles properly
									Thresholds Enhancements Task #1037   
**	01/09/2017	MJensen				Updated to throw error rather than return message   Thresholds Enhancements #1037
*******************************************************************************/
BEGIN
	DECLARE @objFileSystem INT
		,@objTextStream INT
		,@objErrorObject INT
		,@strErrorMessage VARCHAR(1000)
		,@Command VARCHAR(1000)
		,@hr INT
		,@fileAndPath VARCHAR(255)
		,@OverWrite VARCHAR(5) = 'FALSE'
		,@Unicode VARCHAR(5) = 'FALSE' -- ASCII

	SELECT @strErrorMessage = 'opening the File System Object'

	EXECUTE @hr = sp_OACreate 'Scripting.FileSystemObject'
		,@objFileSystem OUT

	--strip off trailing slash if exists
	IF SUBSTRING(@DirectoryPath, LEN(@DirectoryPath), 1) = '\'
	BEGIN
		SET @DirectoryPath = SUBSTRING(@DirectoryPath, 1, LEN(@DirectoryPath) - 1)
	END

	SELECT @FileAndPath = @DirectoryPath + '\' + @filename

	IF @HR = 0
		SELECT @objErrorObject = @objFileSystem
			,@strErrorMessage = 'Creating file "' + @FileAndPath + '"'

	IF @HR = 0
		EXECUTE @hr = sp_OAMethod @objFileSystem
			,'CreateTextFile'
			,@objTextStream OUT
			,@FileAndPath
			,@OverWrite
			,@Unicode

	IF @HR = 0
		SELECT @objErrorObject = @objTextStream
			,@strErrorMessage = 'writing to the file "' + @FileAndPath + '"'

	IF @HR = 0
		EXECUTE @hr = sp_OAMethod @objTextStream
			,'Write'
			,NULL
			,@FileText

	IF @HR = 0
		SELECT @objErrorObject = @objTextStream
			,@strErrorMessage = 'closing the file "' + @FileAndPath + '"'

	IF @HR = 0
		EXECUTE @hr = sp_OAMethod @objTextStream
			,'Close'

	IF @HR = 0
		EXECUTE @HR = sp_OADestroy @objTextStream

	IF @HR = 0
		EXECUTE @HR = sp_OADestroy @objFileSystem

	IF @hr <> 0
	BEGIN
		DECLARE @Source VARCHAR(255)
			,@Description VARCHAR(255)
			,@Helpfile VARCHAR(255)
			,@HelpID INT

		EXECUTE sp_OAGetErrorInfo @objErrorObject
			,@source OUTPUT
			,@Description OUTPUT
			,@Helpfile OUTPUT
			,@HelpID OUTPUT

		SELECT @strErrorMessage = 'Error while ' + coalesce(@strErrorMessage, 'doing something') + ', ' + coalesce(@Description, '')

		
		RAISERROR (
				@strErrorMessage
				,-- Message text.  
				16
				,-- Severity.  
				1 -- State.  
				);
	END
END
GO

