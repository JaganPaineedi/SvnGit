
GO

/****** Object:  StoredProcedure [dbo].[ssp_RDLTransitionCareSummaryLevelofFunctioning]    Script Date: 06/09/2015 05:22:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLTransitionCareSummaryLevelofFunctioning]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLTransitionCareSummaryLevelofFunctioning]
GO


GO

/****** Object:  StoredProcedure [dbo].[ssp_RDLTransitionCareSummaryLevelofFunctioning]    Script Date: 06/09/2015 05:22:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_RDLTransitionCareSummaryLevelofFunctioning] (
	@ServiceId INT = NULL
	,@ClientId INT
	,@DocumentVersionId INT = NULL
	)
AS
/******************************************************************************                      
**  File: ssp_RDLTransitionCareSummaryLevelofFunctioning.sql    
**  Name: ssp_RDLTransitionCareSummaryLevelofFunctioning    
**  Desc:     
**                      
**  Return values: <Return Values>                     
**                       
**  Called by: <Code file that calls>                        
**                                    
**  Parameters:                      
**  Input   Output                      
**  ClientId      -----------                      
**                      
**  Created By: Veena S Mani    
**  Date:  Feb 25 2014    
*******************************************************************************                      
**  Change History                      
*******************************************************************************                      
**  Date:		Author:				Description:                      
**  --------	--------			-------------------------------------------     
**  19/05/2014   Veena S Mani		Created  
**  03/09/2014	 Revathi			 what: check RecordDeleted
									 why:task#36 MeaningfulUse                
*******************************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @LatestDiagnosesDocumentVersionID INT
		DECLARE @EffectiveDate DATETIME

		SELECT TOP 1 @LatestDiagnosesDocumentVersionID = ISNULL(d.CurrentDocumentVersionId, - 1)
			,@EffectiveDate = EffectiveDate
		FROM Documents d
		INNER JOIN DocumentCodes Dc ON Dc.DocumentCodeId = d.DocumentCodeId
		WHERE d.ClientId = @ClientId
			AND d.[Status] = 22
			AND Dc.DiagnosisDocument = 'Y'
			AND CAST(d.EffectiveDate AS DATE) <= CAST(GETDATE() AS DATE)
			AND ISNULL(d.RecordDeleted, 'N') = 'N'
			AND ISNULL(Dc.RecordDeleted, 'N') <> 'Y'
		ORDER BY d.EffectiveDate DESC
			,d.DocumentId DESC

		SELECT ISNULL(AxisV, '') AS AxisV
			,CASE WHEN AxisV IS NOT NULL
					THEN CONVERT(VARCHAR(12), @EffectiveDate, 101)
				ELSE NULL 
				END AS EffectiveDate
			,CASE WHEN AxisV IS NOT NULL
					THEN (SELECT charactercodeid
							FROM dbo.Ssf_recodevaluescurrent('TRANSITIONCARELEVELFUNCTIONING'))
				ELSE NULL
				END AS Source
		FROM DiagnosesV
		WHERE DocumentVersionId = @LatestDiagnosesDocumentVersionID
			AND AxisV IS NOT NULL
		AND ISNULL(RecordDeleted,'N')='N'	
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' 
		+ CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' 
		+ ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLTransitionCareSummaryLevelofFunctioning') + '*****' 
		+ CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' 
		+ CONVERT(VARCHAR, ERROR_STATE())

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

