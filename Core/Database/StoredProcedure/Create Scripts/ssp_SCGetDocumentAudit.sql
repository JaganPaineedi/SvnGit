/******************************************************************************                                                
**  File: ssp_SCGetDocumentAudit                                            
**  Name: ssp_SCGetDocumentAudit                        
**  Desc: To Get Document Assessment                                                  
**  Called by:                                                 
**  Parameters:                            
**  Auth:  Pradeep Y                              
**  Date:  Apr 17 2016
*******************************************************************************                                                
**  Change History                                          
*******************************************************************************                                          

--*******************************************************************************/                                   
CREATE PROCEDURE  [dbo].[ssp_SCGetDocumentAudit]                                                                   
(                                                                                                                                                           
  @DocumentVersionId int                                                                           
)                                                                              
As                                                                          
BEGIN                                                            
   BEGIN TRY   
		 --DocumentAssessmentAudits                                   
		SELECT
		  DocumentVersionId,
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
		FROM DocumentAssessmentAudits
		WHERE (ISNULL(RecordDeleted, 'N') = 'N')
		AND (DocumentVersionId = @DocumentVersionId)
 END TRY                                        
                                                           
 BEGIN CATCH                                                            
   DECLARE @Error varchar(8000)                                                                                               
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                              
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'[ssp_SCGetDocumentAudit]')                                                                                               
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(varchar,ERROR_SEVERITY())                                                                                              
   + '*****ERROR_STATE=' + Convert(varchar,ERROR_STATE())                                                                                              
   RAISERROR (@Error /* Message text*/,  16 /*Severity*/,   1/*State*/   )                                                            
 END CATCH                                          
End 

GO
