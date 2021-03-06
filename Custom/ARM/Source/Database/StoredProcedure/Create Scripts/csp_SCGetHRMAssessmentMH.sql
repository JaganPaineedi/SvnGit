/****** Object:  StoredProcedure [dbo].[csp_SCGetHRMAssessmentMH]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetHRMAssessmentMH]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetHRMAssessmentMH]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetHRMAssessmentMH]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create PROCEDURE  [dbo].[csp_SCGetHRMAssessmentMH]   
                                                   
As                                                
 /****************************************************************************/                                                              
 /* Stored Procedure:csp_SCGetHRMAssessmentMH                            */                                                     
 /* Copyright: 2006 Streamlin Healthcare Solutions                           */                   
 /* Author: Gurpreet                                                      */                                                             
 /* Creation Date:  May 7,2010                                              */                                                              
 /* Purpose: Gets Data for HRM Rap Questions                                 */                                                             
 /* Input Parameters: None                     */                                                            
 /* Output Parameters:None                                                   */                                                              
 /* Return:                                                                  */                                                              
 /* Calls:                                                                   */                  
 /* Called From:     */       
       
                   
                                                               
BEGIN                                  
    BEGIN TRY                                      
                                                    
                                                                       
   -- For CustomHRMRAPQuestions table                               
   SELECT [HRMRAPQuestionId]              
      ,[RAPDomain]              
      ,[RAPQuestionNumber]                    
      ,[RAPQuestionText]              
      ,[RAPQuestionHelpText]          
      ,[RAPAllowedValues]              
      ,[AssociatedHRMNeedId]              
                     
      FROM CustomHRMRAPQuestions                      
   WHERE ISNull(RecordDeleted,''N'')=''N''  
   
 END TRY                                  
 BEGIN CATCH                                  
    DECLARE @Error varchar(8000)                                                                     
   set @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                    
   + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''[csp_SCGetHRMAssessmentMH]'')                                                                     
   + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****ERROR_SEVERITY='' + Convert(varchar,ERROR_SEVERITY())                                                                    
   + ''*****ERROR_STATE='' + Convert(varchar,ERROR_STATE())                                                                    
   RAISERROR                                                                     
   (                               
   @Error, -- Message text.                                                                     
   16, -- Severity.                                  
   1 -- State.                                                                     
   )                                  
 END CATCH                                                
End
' 
END
GO
