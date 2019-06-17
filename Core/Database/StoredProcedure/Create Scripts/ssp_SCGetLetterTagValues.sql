/****** Object:  StoredProcedure [dbo].[ssp_SCGetLetterTagValues]    Script Date: 08/13/2015 16:12:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetLetterTagValues]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetLetterTagValues]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetLetterTagValues]    Script Date: 08/13/2015 16:12:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCGetLetterTagValues] (
	@ClientId INT = NULL
	,@LetterId INT = NULL
	,@TaggedFields VARCHAR(max) = NULL
	,@LetterTemplateId INT = 0
	)
AS
/*********************************************************************/
/* Stored Procedure: [ssp_SCGetLetterTagValues]               */
/* Creation Date:  27/AUG/2015                                    */
/* Purpose: To Get Letter Tag Values */
/* Input Parameters:   @ClientId,@LetterId,@TaggedFields,@LetterTemplateId*/
/*********************************************************************/
BEGIN TRY
	DECLARE @sItem VARCHAR(100)
	DECLARE @item VARCHAR(100)

	IF (SELECT CURSOR_STATUS('global', 'TagField')) >= 0
	BEGIN
		DEALLOCATE TagField
	END

	DECLARE TagField CURSOR
	FOR
	SELECT item
	FROM [dbo].[fnSplit](@TaggedFields, ',')

	OPEN TagField
	 
	FETCH TagField
	INTO @item

	CREATE TABLE #TEMP (TagValue VARCHAR(100))

	-- start the main processing loop.  
	WHILE @@Fetch_Status = 0
	BEGIN
		-- This is where you perform your detailed row-by-row  
		-- processing.  
		INSERT INTO #TEMP
		SELECT CASE @item
				WHEN '[Organization]'
					THEN (SELECT OrganizationName FROM SystemConfigurations)
				WHEN '[ClientID]'
					THEN (SELECT Convert(VARCHAR(100), @ClientId))
				WHEN '[ClientName]'
					THEN (SELECT TOP 1 LastName + ', ' + FirstName FROM Clients WHERE ClientId = @ClientId)
				WHEN '[DateReceived]'
					THEN (SELECT Convert(NVARCHAR(100), IsNull(CreatedDate, '')) FROM Letters WHERE LetterId = @LetterId)
				ELSE ''
				END

		-- Get the next row.   
		FETCH TagField
		INTO @item
	END

	CLOSE TagField

	DEALLOCATE TagField

	SELECT *
	FROM #TEMP

	DROP TABLE #TEMP

	RETURN
END TRY

BEGIN CATCH
	DECLARE @Error VARCHAR(8000)

	SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'csp_SCWebGetServiceNoteCustomDBTIndividualNote') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

	RAISERROR (
			@Error
			,-- Message text.      
			16
			,-- Severity.      
			1 -- State.      
			);
END CATCH

GO


