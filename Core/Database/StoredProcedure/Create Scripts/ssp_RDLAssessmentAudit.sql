Create PROCEDURE [dbo].[ssp_RDLAssessmentAudit]     
 @DocumentVersionId as int            
AS       
/************************************************************************/                                                                
/* Stored Procedure: ssp_RDLAssessmentAudit      */                                                       
/*        */                                                                
/* Creation Date:  18-04-2018          */                                                                
/*                  */                                                                
/* Purpose: Gets Data for ssp_RDLAssessmentAudit     */                                                               
/* Input Parameters: DocumentVersionId        */                                                              
/* Output Parameters:             */                                                                
/* Purpose: Use For Rdl Report           */                                                      
/* Calls:                */                                                                
/*                  */                                                                
/* Author:Pradeep Y            */           
/*********************************************************************/               
BEGIN Try            
BEGIN  
DECLARE @ScoreDisplay Int 
SELECT @ScoreDisplay=SUBSTRING(Score, 1,  NULLIF(CHARINDEX('(', Score) - 1, -1)) from DocumentAssessmentAudits where  (DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,'N') <> 'Y' )             
  SELECT   
    DAA.DocumentVersionId,  
    DAA.DeclinesToAnswer,  
    dbo.ssf_GetGlobalCodeNameById(DAA.ContainingAlcohol) AS 'ContainingAlcohol',  
    dbo.ssf_GetGlobalCodeNameById(DAA.DrinkingAlcohol) AS 'DrinkingAlcohol',  
    dbo.ssf_GetGlobalCodeNameById(DAA.DrinkOnOccasion) AS 'DrinkOnOccasion',  
    dbo.ssf_GetGlobalCodeNameById(DAA.PastYearFoundMoreThanOnce) AS 'MoreThanOnce',  
    dbo.ssf_GetGlobalCodeNameById(DAA.LastYearFailedToDo) AS 'LastYearFailedToDo',  
    dbo.ssf_GetGlobalCodeNameById(DAA.HeavyDrinkingSession) AS 'HeavyDrinkingSession',  
    dbo.ssf_GetGlobalCodeNameById(DAA.FeltGuiltyAfterDrinking) AS 'FeltGuiltyAfterDrinking',  
    dbo.ssf_GetGlobalCodeNameById(DAA.InjuredBecauseOfDrinking) AS 'InjuredBecauseOfDrinking',  
    dbo.ssf_GetGlobalCodeNameById(DAA.RelativeSuggestedToQuit) AS 'RelativeSuggestedToQuit',  
    dbo.ssf_GetGlobalCodeNameById(DAA.UnableToRemember ) AS 'UnableToRememberHappened' ,
    DAA.Score,
    DAA.Comments,
    CASE 
		WHEN @ScoreDisplay IN (0,1,2,3,4,5,6,7)
			THEN '0-7 Alcohol use likely not a focus of treatment'
		WHEN @ScoreDisplay >=8
			THEN '8+ Indication of hazardous and harmful alcohol use'
		END AS ScoreDisplay
  
  FROM DocumentAssessmentAudits DAA where  (DAA.DocumentVersionId=@DocumentVersionId  
  AND ISNULL(DAA.RecordDeleted,'N') <> 'Y' )   
 END                                                                     
 END TRY   
--Checking For Errors      
 BEGIN CATCH                                 
   DECLARE @Error varchar(8000)                                                                                                               
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                    
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_RDLAssessmentAudit')                                                                                                            
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(varchar,ERROR_SEVERITY())                                                                                                                                                     
  
    
          
   + '*****ERROR_STATE=' + Convert(varchar,ERROR_STATE())                                                                                                          
   RAISERROR (@Error /* Message text*/,  16 /*Severity*/,   1/*State*/   )                   
                                                                                                              
 END CATCH         
 
 GO       