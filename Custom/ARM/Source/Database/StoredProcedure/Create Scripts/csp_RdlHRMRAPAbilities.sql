/****** Object:  StoredProcedure [dbo].[csp_RdlHRMRAPAbilities]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlHRMRAPAbilities]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RdlHRMRAPAbilities]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlHRMRAPAbilities]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create PROCEDURE [dbo].[csp_RdlHRMRAPAbilities]                              
@DocumentVersionId  int                       
 AS                             
Begin                 
                   
/*********************************************************************/                                                                                                                                      
/* Stored Procedure: dbo.[csp_RdlHRMRAPAbilities]                */                                                                                                                                      
/* Copyright: 2008 Streamline Healthcare Solutions,  LLC             */                                                                                                                                      
/* Creation Date:  21 July,2010                                       */                                                                                                                                      
/*                                                                   */                                                                                                                                      
/* Purpose:  Get Data for CustomHRMAssessments Pages */                                                                                                                                    
/*                                                                   */                                                                                                                                    
/* Input Parameters:  @DocumentVersionId             */                                                                                                                                    
/*                                                                   */                                                                                                                                      
/* Output Parameters:   None                   */                                                                                                                                      
/*                                                                   */                                                                                                                                      
/* Return:  0=success, otherwise an error number                     */                                                                                                                                      
/*                                                                   */                                                                                                                                      
/* Called By:                                                        */                                                                                                                                      
/*                                                                   */                                                                                                                                      
/* Calls:                                                            */                       
/* */                                                
/* Data Modifications:                   */                                                      
/*      */                                                                                     
/* Updates:               */                                                                              
/*   Date     Author            Purpose                             */                                                         
/*   Jitender  Kumar Kamboj */                                                                 
/*                                                                                        
*/                         
/*********************************************************************/                
               
              
                     
 ---CustomHRMAssessmentRAPScores---                                   
select                           
 rq.RAPDomain,                
 rq.RAPQuestionNumber,                
 rq.RAPQuestionText,                
 rs.RAPAssessedValue,        
 rs.AddToNeedsList,
 l.RAPLevelDescription          
             
from dbo.CustomHRMRAPQuestions as rq                
join dbo.CustomHRMAssessmentRAPScores as rs on rs.HRMRAPQuestionId = rq.HRMRAPQuestionId             left Join dbo.CustomHRMRAPLevels as l on l.HRMRAPQuestionId = rs.HRMRAPQuestionId and rs.RAPAssessedValue = l.RAPLevelValue                               
where rs.DocumentVersionId=@DocumentVersionId         
and rq.RAPDomain = ''Current Abilities''        
and isnull(rs.RecordDeleted, ''N'') <> ''Y''                 
order by 1,                  
 rq.RAPQuestionNumber                   
                     
                  
    --Checking For Errors                              
  If (@@error!=0)                              
  Begin                              
   RAISERROR  20006   ''[csp_RdlHRMRAPAbilities] : An Error Occured''                               
   Return                              
   End                              
                       
                            
                  
End
' 
END
GO
