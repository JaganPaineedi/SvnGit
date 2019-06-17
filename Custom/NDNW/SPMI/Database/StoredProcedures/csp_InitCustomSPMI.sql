IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomSPMI]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomSPMI]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_InitCustomSPMI] 
 (
	@ClientID INT
	,@StaffID INT
	,@CustomParameters XML
	)
AS
-- =============================================    
-- Author      : Anto.G 
-- Date        : 27/APRIL/2015  
-- Purpose     : Initializing SP Created.	
-- =============================================   
BEGIN
	BEGIN TRY
	DECLARE @LatestDocumentVersionID INT
	
	
	--SELECT TOP 1 @LatestDocumentVersionID = CurrentDocumentVersionId
	--FROM CustomDocumentSPMIs CDSA
	--INNER JOIN Documents Doc ON CDSA.DocumentVersionId = Doc.CurrentDocumentVersionId
	--WHERE Doc.ClientId = @ClientID
	--	AND Doc.[Status] = 22
	--	AND ISNULL(CDSA.RecordDeleted, 'N') = 'N'
	--	AND ISNULL(Doc.RecordDeleted, 'N') = 'N'
	--ORDER BY Doc.EffectiveDate DESC
	--	,Doc.ModifiedDate DESC
	
	SET @LatestDocumentVersionId = - 1
	
		
	
SELECT 'CustomDocumentSPMIs' AS TableName
		,- 1 AS DocumentVersionId
		,'' AS CreatedBy
		,GETDATE() AS CreatedDate
		,'' AS ModifiedBy
		,GETDATE() AS ModifiedDate,
		RecordDeleted,
		DeletedBy,
		DeletedDate,
		Schizophrenia,
		MajorDepression,
		Anxiety,
		Personality,
		Individual
	
	FROM systemconfigurations s
	LEFT OUTER JOIN CustomDocumentSPMIs  ON DocumentVersionId = @LatestDocumentVersionID
		
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'csp_InitCustomSPMI') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                                                  
				16
				,-- Severity.                                                                                                  
				1 -- State.                                                                                                  
				);
	END CATCH
END

