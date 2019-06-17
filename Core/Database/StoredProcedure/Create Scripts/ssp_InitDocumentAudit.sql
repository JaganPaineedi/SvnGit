Create PROCEDURE [dbo].[ssp_InitDocumentAudit] (
	@ClientID INT
	,@StaffID INT
	,@CustomParameters XML
	)
AS
/******************************************************************************                                                
**  File: ssp_InitDocumentAudit                                            
**  Name: ssp_InitDocumentAudit                                             
**  Called by:                                                 
**  Parameters:                            
**  Auth:  Pradeep Y                              
**  Date:  Apr 17 2018
*******************************************************************************                                                
**  Change History                                          
*******************************************************************************                                          

--*******************************************************************************/
BEGIN
	BEGIN TRY

-------------------------------------------------------------------------
-- To get Initial latest DocumentVersionId  
--------------------------------------------------------------------------
	  
  DECLARE @LatestDocumentVersionID int 
    
    
		SET @LatestDocumentVersionID = (  
		SELECT TOP 1 CurrentDocumentVersionId  
		FROM DocumentAssessmentAudits CDA  
		INNER JOIN Documents Doc ON CDA.DocumentVersionId = Doc.CurrentDocumentVersionId  
		WHERE Doc.ClientId = @ClientID
		AND Doc.[Status] = 22  
		AND ISNULL(CDA.RecordDeleted, 'N') = 'N'  
		AND ISNULL(Doc.RecordDeleted, 'N') = 'N'  
		ORDER BY Doc.EffectiveDate DESC  
		,Doc.ModifiedDate DESC  
    )   

		     IF(@LatestDocumentVersionID>0)
				BEGIN	
						--DocumentAssessmentAudits                                   
			 		SELECT 'DocumentAssessmentAudits' AS TableName,
						  -1 AS 'DocumentVersionId', 
						  CreatedBy,
						  CreatedDate,
						  ModifiedBy,
						  ModifiedDate,
						  RecordDeleted,
						  DeletedBy,
						  DeletedDate,
						  DeclinesToAnswer,
						  ContainingAlcohol,
						  DrinkingAlcohol,
						  DrinkOnOccasion,
						  PastYearFoundMoreThanOnce,
						  LastYearFailedToDo,
						  HeavyDrinkingSession,
						  FeltGuiltyAfterDrinking,
						  UnableToRemember,
						  InjuredBecauseOfDrinking,
						  RelativeSuggestedToQuit,
						  Score,
						  Comments
						FROM DocumentAssessmentAudits WHERE DocumentVersionId = @LatestDocumentVersionID 
							AND ISNULL(RecordDeleted, 'N') = 'N'  
				END
			ELSE
				BEGIN 
						--DocumentAssessmentAudits
					SELECT 'DocumentAssessmentAudits' AS TableName
						,- 1 AS 'DocumentVersionId'
						,CDAA.CreatedBy
						,CDAA.CreatedDate
						,CDAA.ModifiedBy
						,CDAA.ModifiedDate
						,CDAA.RecordDeleted
						,CDAA.DeletedDate
						,CDAA.DeletedBy
					FROM systemconfigurations SC
					LEFT JOIN DocumentAssessmentAudits CDAA  ON SC.DatabaseVersion = - 1
				END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'csp_InitDocumentAudit') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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
