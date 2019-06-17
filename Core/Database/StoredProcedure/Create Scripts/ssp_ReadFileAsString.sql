IF OBJECT_ID('ssp_ReadFileAsString', 'P') IS NOT NULL
	DROP PROCEDURE ssp_ReadFileAsString

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_ReadFileAsString] (
	@Filename VARCHAR(250)
	,@FileText VARCHAR(max) OUTPUT
	)
AS
/******************************************************************************                         
**  Name: ssp_ReadFileAsString    
**  Desc: Reads a text file and returns the contents in a VARCHAR field    
**                      
**  Return values: @FileText VARCHAR(MAX)                     
**                                            
**                                    
**  Example:	EXEC ssp_ReadFileAsString	@FileName = 'X:\MyFolder\My Phone List.txt', @FileText = @FileText OUTPUT
**                       
**                      
**  Created By:    
**  Date:  21 DEC 2017   
*******************************************************************************                      
**  Change History                      
*******************************************************************************                      
**  Date:		Author:				Description:                      
**  --------	--------			-------------------------------------------     
**  12/21/2017	MJensen				Created  
**									Create from function dbo.ssf_ReadFileAsString.  Proc required because function does not destroy handles properly
									Thresholds Enhancements Task #1036  
**	01/09/2018	MJensen				Updated to throw error rather than returning message.            
*******************************************************************************/
SET @FileText = ''

DECLARE @objFileSystem INT
	,@objTextStream INT
	,@objErrorObject INT
	,@strErrorMessage VARCHAR(1000)
	,@Command VARCHAR(1000)
	,@Chunk VARCHAR(8000)
	,@hr INT = 0
	,@YesOrNo INT
	,@CreateFile VARCHAR(5) = 'False'
	,@Mode INT = 1 -- for reading only
	,@Format INT = - 2 -- System Default format 

SELECT @strErrorMessage = 'opening the File System Object'

EXECUTE @hr = sp_OACreate 'Scripting.FileSystemObject'
	,@objFileSystem OUT

IF @HR = 0
	SELECT @objErrorObject = @objFileSystem
		,@strErrorMessage = 'Opening file "' + @filename + '"'
		,@command = @filename

IF @HR = 0
	EXECUTE @hr = sp_OAMethod @objFileSystem
		,'OpenTextFile'
		,@objTextStream OUT
		,@command
		,@Mode
		,@CreateFile
		,@Format

WHILE @hr = 0
BEGIN
	IF @HR = 0
		SELECT @objErrorObject = @objTextStream
			,@strErrorMessage = 'finding out if there is more to read in "' + @filename + '"'

	IF @HR = 0
		EXECUTE @hr = sp_OAGetProperty @objTextStream
			,'AtEndOfStream'
			,@YesOrNo OUTPUT

	IF @YesOrNo <> 0
		BREAK

	IF @HR = 0
		SELECT @objErrorObject = @objTextStream
			,@strErrorMessage = 'reading from the input file "' + @filename + '"'

	IF @HR = 0
		EXECUTE @hr = sp_OAMethod @objTextStream
			,'Read'
			,@chunk OUTPUT
			,4000

	SELECT @FileText = @FileText + @chunk
END

IF @HR = 0
	SELECT @objErrorObject = @objTextStream
		,@strErrorMessage = 'closing the input file "' + @filename + '"'

IF @HR = 0
	EXECUTE @hr = sp_OAMethod @objTextStream
		,'Close'

IF @HR = 0
	EXECUTE @hr = sp_OADestroy @objTextStream

IF @HR = 0
	EXECUTE @hr = sp_OADestroy @objFileSystem

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

	SELECT @strErrorMessage = 'Error while ' + COALESCE(@strErrorMessage, 'doing something') + ', ' + COALESCE(@Description, '')

	RAISERROR (
			@strErrorMessage
			,-- Message text.  
			16
			,-- Severity.  
			1 -- State.  
			);
END
GO

