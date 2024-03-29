/****** Object:  StoredProcedure [dbo].[csp_RdlHRMServiceLookup]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlHRMServiceLookup]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RdlHRMServiceLookup]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlHRMServiceLookup]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_RdlHRMServiceLookup]                      
@DocumentVersionId  int               
 AS                     
Begin         
           
/*********************************************************************/                                                                                                                              
/* Stored Procedure: dbo.[csp_RdlHRMServiceLookup]                */                                                                                                                              
/* Copyright: 2008 Streamline Healthcare Solutions,  LLC             */                                                                                                                              
/* Creation Date:  20 July,2010                                       */                                                                                                                              
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
/*   Jitender Kumar Kamboj  */                                                         
/*                                                                                
*/                                                                                                   
/*********************************************************************/        
       
      
             
 -- CustomHRMAssessmentLevelOfCareOptions   
 SELECT             
  HRMAssessmentLevelOfCareOptionId            
 ,DocumentVersionId            
 ,CHALOCO.HRMLevelOfCareOptionId            
 ,OptionSelected        
,CHLOCO.ServiceChoiceLabel            
          
FROM  CustomHRMLevelOfCareOptions  CHLOCO          
join  CustomHRMAssessmentLevelOfCareOptions CHALOCO        
ON  CHALOCO.HRMLevelOfCareOptionId = CHLOCO.HRMLevelOfCareOptionId        
 Where DocumentVersionId = @DocumentVersionId        
and OptionSelected is null         
 and ISNULL(CHALOCO.RecordDeleted,''N'')=''N''          
  and ISNULL(CHALOCO.RecordDeleted,''N'')=''N''        
  order by ServiceChoiceLabel              
             
          
    --Checking For Errors                      
  If (@@error!=0)                      
  Begin                      
   RAISERROR  20006   ''csp_RdlHRMServiceLookup : An Error Occured''                       
   Return                      
   End                      
               
                    
          
End
' 
END
GO
