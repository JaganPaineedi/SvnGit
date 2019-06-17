
/****** Object:  StoredProcedure [dbo].[csp_RdlHRMOtherRiskFactors]    Script Date: 02/03/2015 12:50:27 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlHRMOtherRiskFactors]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RdlHRMOtherRiskFactors]
GO


/****** Object:  StoredProcedure [dbo].[csp_RdlHRMOtherRiskFactors]    Script Date: 02/03/2015 12:50:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
CREATE PROCEDURE [dbo].[csp_RdlHRMOtherRiskFactors]                        
@DocumentVersionId  int                 
 AS                       
Begin           
             
/*********************************************************************/                                                                                                                                
/* Stored Procedure: dbo.[csp_RdlHRMOtherRiskFactors]                */                                                                                                                                
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
         
        
   ---CustomOtherRiskFactors---                                
 SELECT [OtherRiskFactorId]                                                           
      ,[DocumentVersionId]                                                                                
      ,[OtherRiskFactor]                                                                                                                                              
      ,GlobalCodes.CodeName               
                                                                                             
  FROM GlobalCodes join CustomOtherRiskFactors c                                                                                
  on GlobalCodes.GlobalCodeId = c.OtherRiskFactor                                                                          
  WHERE DocumentVersionId=@DocumentVersionId               
  AND ISNULL(GlobalCodes.RecordDeleted,'N')='N'  AND ISNULL(c.RecordDeleted,'N')='N'          
    order by CodeName         
            
    --Checking For Errors                        
  If (@@error!=0)                        
  Begin                        
   RAISERROR  20006   'csp_RdlHRMOtherRiskFactors : An Error Occured'                         
   Return                        
   End                        
                 
                      
            
End  
GO


