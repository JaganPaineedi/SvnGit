/****** Object:  StoredProcedure [dbo].[csp_InitCustomMSTAssessmentStandardInitialization]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomMSTAssessmentStandardInitialization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomMSTAssessmentStandardInitialization]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomMSTAssessmentStandardInitialization]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_InitCustomMSTAssessmentStandardInitialization]        
(                          
 @ClientID int,    
 @StaffID int,  
 @CustomParameters xml                          
)                                                  
As                    
                                                           
 /*********************************************************************/                                                              
 /* Stored Procedure: [csp_InitCustomMSTAssessmentStandardInitialization]                 */                                                     
                                                     
 /* Copyright: 2006 Streamline SmartCare*/                                                              
                                                     
 /* Creation Date:  14/Jan/2008                                    */                                                              
 /*                                                                   */                                                              
 /* Purpose: To Initialize */                                                             
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
                                                     
 /*       Date              Author                  Purpose             */                                                              
 /*       14/Jan/2008        Rishu Chopra          To Retrieve Data      */    
 /*       18/Nov/2009        Pradeep          Made changes According to Data Model 3.1 */                                                                
 /*********************************************************************/                                                               
                       
Begin                                              
    
Begin try
if exists(Select 1 from CustomMSTAssessments c
			Join DocumentVersions dv on dv.DocumentVErsionId=c.DocumentVersionId and ISNULL(dv.RecordDeleted,''N'')=''N''  
			Join Documents d on d.DocumentId=dv.DocumentId and ISNULL(d.RecordDeleted,''N'')=''N''                                    
			where d.ClientId=@ClientID                                                
			and D.Status=22 and IsNull(C.RecordDeleted,''N'')=''N'' 
			)                               
BEGIN      
                    
	SELECT     TOP (1) ''CustomMSTAssessments'' AS TableName, C.DocumentVersionId, C.Genogram, C.ReasonForReferral, C.Participant1, C.Goal1, C.Participant2, C.Goal2, 
						  C.Participant3, C.Goal3, C.Participant4, C.Goal4, C.Participant5, C.Goal5, C.Participant6, C.Goal6, C.Participant7, C.Goal7, C.Participant8, C.Goal8, 
						  C.SytemicStrengthIndividual, C.SytemicWeaknessIndividual, C.SytemicStrengthFamily, C.SytemicWeaknessFamily, C.SytemicStrengthSchool, 
						  C.SytemicWeaknessSchool, C.SytemicStengthPeers, C.SytemicWeaknessPeers, C.SytemicStengthCommunity, C.SytemicWeaknessCommunity, C.CreatedBy, 
						  C.CreatedDate, C.ModifiedBy, C.ModifiedDate
	FROM         CustomMSTAssessments AS C INNER JOIN
						  DocumentVersions AS DV ON C.DocumentVersionId = DV.DocumentVersionId INNER JOIN
						  Documents AS D ON DV.DocumentId = D.DocumentId
	WHERE     (D.ClientId = @ClientID) AND (D.Status = 22) AND (ISNULL(C.RecordDeleted, ''N'') = ''N'') AND (ISNULL(D.RecordDeleted, ''N'') = ''N'')
	ORDER BY D.EffectiveDate DESC, D.ModifiedDate DESC  ,DV.DocumentVersionId DESC                            
END                              
else                              
BEGIN                              
Select TOP 1 ''CustomMSTAssessments'' AS TableName,-1 as ''DocumentVersionId'',                  
          
'''' as CreatedBy,                
getdate() as CreatedDate,                
'''' as ModifiedBy,                
getdate() as ModifiedDate                  
from systemconfigurations s left outer join CustomMSTAssessments                                                                  
on s.Databaseversion = -1 
END                             
end try                                              
                                                                                       
BEGIN CATCH  
DECLARE @Error varchar(8000)                                               
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                             
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_InitCustomMSTAssessmentStandardInitialization'')                                                                             
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
