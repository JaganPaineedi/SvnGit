/****** Object:  StoredProcedure [dbo].[csp_InitCustomAIMSStandardInitialization]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomAIMSStandardInitialization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomAIMSStandardInitialization]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomAIMSStandardInitialization]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_InitCustomAIMSStandardInitialization]                                                         
(                                          
 @ClientID int,    
 @StaffID int,  
 @CustomParameters xml                                          
)                                                                  
As                                                                    
                                                                           
 /*********************************************************************/                                                                              
 /* Stored Procedure: [csp_InitCustomAIMSStandardInitialization]               */                                                                     
                                                                     
 /* Copyright: 2007 Streamline SmartCare*/                                                                              
                                                                     
 /* Creation Date:  8/September/2007                                    */                                                                              
 /*                                                                   */                                                                              
 /* Purpose: Gets Fields of CustomAIMS last signed Document Corresponding to clientd */                                                                             
 /*                                                                   */                                                                            
 /* Input Parameters:  */                                                                            
 /*                                                                   */                                                                               
 /* Output Parameters:                                */                                                                              
 /*                                                                   */                                                                              
 /* Return:   */                                                                              
 /*                                                                   */                                                                              
 /* Called By:CustomDocuments Class Of DataService    */                                                                    
 /*      */                                                                    
                                                                     
 /*                                                                   */                                                                              
 /* Calls:                                                            */                                                                              
 /*                                                                   */                                                                              
 /* Data Modifications:                                               */                                                                              
 /*                                                                   */                                                                              
 /*   Updates:                                                          */                                                                              
                                                                     
 /*       Date              Author                  Purpose                                    */                                                                              
 /*       14/Jan/2008       Sonia Dhamija          To Retrieve Data      */         
 /*       Sept10,2009       Pradeep                Added documentVerssionId in select statement for CustomAIMS table   */      
 /*       Sept11,2009       Pradeep             Made changes as per database  SCWebVenture3.0 */    
 /*       Nov18,2009         Ankesh                Made changes as paer dataModel SCWebVenture3.0  */                                                                                                                                                          
 /*********************************************************************/                                                 
Begin                                              
    
Begin try
if(exists(SELECT    *
	FROM         CustomAIMS AS C INNER JOIN
						  DocumentVersions AS DV ON C.DocumentVersionId = DV.DocumentVersionId INNER JOIN
						  Documents AS D ON DV.DocumentId = D.DocumentId
	WHERE     (D.ClientId = @ClientID) AND (D.Status = 22) AND (ISNULL(C.RecordDeleted, ''N'') = ''N'') AND (ISNULL(D.RecordDeleted, ''N'') = ''N'') ))                           
BEGIN                            
	SELECT     TOP (1) ''CustomAIMS'' AS TableName, C.DocumentVersionId, C.TotalScore, C.DentalStatusWearDentures, C.DentalStatusCurrentProblems, 
						  C.GlobalJudgementAwareness, C.GlobalJudgementIncapacitation, C.GlobalJudgementSeverity, C.FacialOralMovementsMuscles, C.FacialOralMovementsLips, 
						  C.FacialOralMovementsJaw, C.FacialOralMovementsTongue, C.ExtremityMovementsUpper, C.ExtremityMovementsLower, C.ExtremityMovementsTrunk, C.Rater, 
						  C.ClientInformed, C.Method, C.Comments, C.CreatedBy, C.CreatedDate, C.ModifiedBy, C.ModifiedDate
	FROM         CustomAIMS AS C INNER JOIN
						  DocumentVersions AS DV ON C.DocumentVersionId = DV.DocumentVersionId INNER JOIN
						  Documents AS D ON DV.DocumentId = D.DocumentId
	WHERE     (D.ClientId = @ClientID) AND (D.Status = 22) AND (ISNULL(C.RecordDeleted, ''N'') = ''N'') AND (ISNULL(D.RecordDeleted, ''N'') = ''N'')
	ORDER BY D.EffectiveDate DESC, D.ModifiedDate DESC   ,DV.DocumentVersionId DESC                        
END                            
else                            
BEGIN                            
	SELECT     TOP (1) ''CustomAIMS'' AS TableName, - 1 AS ''DocumentVersionId'', 0 AS TotalScore, ''Y'' AS DentalStatusWearDentures, ''Y'' AS DentalStatusCurrentProblems, 
						  0 AS GlobalJudgementAwareness, 0 AS GlobalJudgementIncapacitation, 0 AS GlobalJudgementSeverity, 0 AS FacialOralMovementsMuscles, 
						  0 AS FacialOralMovementsLips, 0 AS FacialOralMovementsJaw, 0 AS FacialOralMovementsTongue, 0 AS ExtremityMovementsUpper, 0 AS ExtremityMovementsLower,
						   0 AS ExtremityMovementsTrunk, '''' AS Rater, ''Y'' AS ClientInformed, 0 AS Method, '''' AS Comments, '''' AS CreatedBy, GETDATE() AS CreatedDate, '''' AS ModifiedBy, 
						  GETDATE() AS ModifiedDate
	FROM         SystemConfigurations AS s LEFT OUTER JOIN
						  CustomAIMS ON s.DatabaseVersion = - 1
END                          
end try                                              
                                                                                       
BEGIN CATCH  
DECLARE @Error varchar(8000)                                               
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                             
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_InitCustomAIMSStandardInitialization'')                                                                             
    + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                                                                              
    + ''*****'' + Convert(varchar,ERROR_STATE())                          
 RAISERROR                                                                             
 (                                               
  @Error, -- Message text.                                                                            
  16, -- Severity.                                                                            
  1 -- State.                                                                            
 );                                                                          
END CATCH                         
END
' 
END
GO
