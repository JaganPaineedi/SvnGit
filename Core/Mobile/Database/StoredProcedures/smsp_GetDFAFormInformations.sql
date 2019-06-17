/****** Object:  StoredProcedure [dbo].[smsp_GetDFAFormInformations]    Script Date: 10/25/2016 7:48:17 PM ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[smsp_GetDFAFormInformations]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[smsp_GetDFAFormInformations]
GO

/****** Object:  StoredProcedure [dbo].[smsp_GetDFAFormInformations]    Script Date: 10/25/2016 7:48:17 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[smsp_GetDFAFormInformations]
AS
-- =============================================      
-- Author:  Pradeep      
-- Create date: Jan 18, 2017      
-- Description: Retrieves data for Mobile Note and Custom Fields
/* History
   Mar 02 2017		Pradeep			CustomFields instance is renamed
   Mar 20 2017		Pradeep			Get only documentcodes which has MobileAssociatedNoteId configured
   Mar 27 2017		Pradeep			Removed StaffProcedures from getting the note templates.
*/
-- =============================================      
BEGIN
	BEGIN TRY
		CREATE TABLE #DFAForms (
			DocumentCodeId INT
			,MobileFormHTML VARCHAR(MAX)
			,TableName VARCHAR(100)
			,IsCustomService CHAR(1)
			)

		-- Note Teamplates
		INSERT INTO #DFAForms
		SELECT DISTINCT DC.DocumentCodeId
			,REPLACE(REPLACE(REPLACE(F.MobileFormHTML, '##ControllerName##', 'customNoteController'), 'serviceNote.' + F.TableName, 'serviceNote.' + LOWER(LEFT(F.TableName, 1)) + SUBSTRING(F.TableName, 2, LEN(F.TableName))), '##ID##', 'noteDocument')
			,F.TableName
			,'N'
		FROM ProcedureCodes PC 			
		JOIN DocumentCodes DC ON DC.DocumentCodeId = PC.MobileAssociatedNoteId
		JOIN FormCollections FC ON FC.FormCollectionId = DC.FormCollectionId
		JOIN FormCollectionForms FCF ON FCF.FormCollectionId = FC.FormCollectionId
		JOIN Forms F ON F.FormId = FCF.FormId
			AND F.Mobile = 'Y'
			AND PC.Mobile = 'Y'
			AND DC.Mobile = 'Y'

		-- Custom Field (ServiceNote:ScreenId = 29)
		IF EXISTS (
				SELECT 1
				FROM Screens S
				JOIN Forms F ON F.FormId = S.CustomFieldFormId
					AND F.Active = 'Y'
					AND F.Mobile = 'Y'
				WHERE ScreenId = 29
					AND Active = 'Y'
					AND ISNULL(S.RecordDeleted, 'N') = 'N'
					AND ISNULL(F.RecordDeleted, 'N') = 'N'
				)
		BEGIN
			INSERT INTO #DFAForms
			SELECT NULL
				,REPLACE(REPLACE(REPLACE(F.MobileFormHTML, '##ControllerName##', 'customServicesController'), 'serviceNote.' + F.TableName, 'cf.' + F.TableName), '##ID##', 'customfield')
				,F.TableName
				,'Y'
			FROM Screens S
			JOIN Forms F ON F.FormID = S.CustomFieldFormId
				AND F.Active = 'Y'
				AND F.Mobile = 'Y'
			WHERE ScreenId = 29
				AND Active = 'Y'
				AND ISNULL(S.RecordDeleted, 'N') = 'N'
				AND ISNULL(F.RecordDeleted, 'N') = 'N'
		END

		SELECT DocumentCodeId
			,MobileFormHTML
			,TableName
			,IsCustomService
		FROM #DFAForms
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'smsp_GetDFAFormInformations') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                                        
				16
				,-- Severity.                                                                                        
				1 -- State.                                                                                        
				);
	END CATCH
END
GO


