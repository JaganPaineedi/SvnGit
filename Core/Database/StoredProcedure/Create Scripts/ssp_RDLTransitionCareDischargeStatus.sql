/****** Object:  StoredProcedure [dbo].[ssp_RDLTransitionCareDischargeStatus]     ******/
IF EXISTS (
		SELECT 1
		FROM INFORMATION_SCHEMA.ROUTINES
		WHERE SPECIFIC_SCHEMA = 'dbo'
			AND SPECIFIC_NAME = 'ssp_RDLTransitionCareDischargeStatus'
		)
	DROP PROCEDURE [dbo].[ssp_RDLTransitionCareDischargeStatus]
GO

/****** Object:  StoredProcedure [dbo].[ssp_RDLTransitionCareDischargeStatus]     ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_RDLTransitionCareDischargeStatus] @DocumentVersionId INT
AS
/******************************************************************************                                
**  File: ssp_RDLTransitionCareDischargeStatus.sql              
**  Name: ssp_RDLTransitionCareDischargeStatus  3368564            
**  Desc:               
**                                
**  Return values: <Return Values>                               
**                                 
**  Called by: <Code file that calls>                                  
**                                              
**  Parameters:   @DocumentVersionId                             
          
*******************************************************************************                                
**  Change History                                
*******************************************************************************                                
**  Date:  Author:    Description:                                
**  -------- --------   -------------------------------------------           
    
** 17/08/2017 Ravichandra   why: to get DischargeStatus     
         why: Meaningful Use - Stage 3 > Tasks #25.2 Transition of Care - PDF  
** 23/07/2018  Ravichandra		What:  casting to a date type for DischargedDate 
							    Why : KCMHSAS - Support  #1099 Summary of Care - issues (summary for all bugs)                
*******************************************************************************/
BEGIN
	SET NOCOUNT ON;

	DECLARE @FromDate DATE
		,@ToDate DATE
	DECLARE @TransitionType CHAR(1)
	DECLARE @ClientId INT

	BEGIN TRY
		SELECT TOP 1 @FromDate = cast(FromDate AS DATE)
			,@ToDate = cast(ToDate AS DATE)
			,@TransitionType = TransitionType
			,@ClientId = D.ClientId
		FROM TransitionOfCareDocuments T
		JOIN Documents D ON D.InProgressDocumentVersionId = T.DocumentVersionId
		WHERE ISNULL(T.RecordDeleted, 'N') = 'N'
			AND T.DocumentVersionId = @DocumentVersionId
			AND ISNULL(D.RecordDeleted, 'N') = 'N'

		IF @TransitionType <> 'I'
		BEGIN
			RETURN
		END

		SELECT CONVERT(VARCHAR(10), CIV.DischargedDate, 101) AS DischargedDate
			,dbo.ssf_GetGlobalCodeNameById(CIV.DischargeType) AS DischargeType
		FROM ClientInpatientVisits AS CIV
		--JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CIV.ClientInpatientVisitId      
		WHERE CIV.ClientId = @ClientId
		
		--23/07/2018  Ravichandra
			AND (
				@FromDate <= CAST(CIV.DischargedDate AS DATE)
				AND CAST(CIV.DischargedDate AS DATE) <= @ToDate
				)
			AND ISNULL(CIV.RecordDeleted, 'N') = 'N'
			--AND  ISNULL(BA.RecordDeleted, 'N') = 'N'       
			AND CIV.[Status] = 4984 --Discharged    
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLTransitionCareDischargeStatus') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                             
				16
				,-- Severity.                                                                 
				1 -- State.                                                                 
				);
	END CATCH
END
