/****** Object:  StoredProcedure [dbo].[csp_RdlHRMCAFAS]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlHRMCAFAS]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RdlHRMCAFAS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlHRMCAFAS]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_RdlHRMCAFAS]                            
@DocumentVersionId  int                     
 AS                           
Begin               
                 
/*********************************************************************/                                                                                                                                    
/* Stored Procedure: dbo.[csp_RdlHRMCAFAS]                */                                                                                                                                    
/* Copyright: 2008 Streamline Healthcare Solutions,  LLC             */                                                                                                                                    
/* Creation Date:  27 July,2010                                       */                                                                                                                                    
/* Created By: Jitender Kumar Kamboj                                                                  */                                                                                                                                    
/* Purpose:  Get Data for HRM CAFAS document */                                                                                                                                  
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
/*      */                                                               
/*                                                                                      
*/                       
/*********************************************************************/              
             
            
                   
---CustomCAFAS2---                                                                                                
  SELECT [DocumentVersionId]             
      ,[CAFASDate]                                                                                                
      ,[RaterClinician]                                                        
      ,[CAFASInterval]                                                    
      ,[SchoolPerformance]                                                                                                
      ,[SchoolPerformanceComment]                                                                                                
      ,[HomePerformance]                                                               
      ,[HomePerfomanceComment]                                                                    
      ,[CommunityPerformance]                                                                                                
      ,[CommunityPerformanceComment]                                                                                                
      ,[BehaviorTowardsOther]                                                                                                
      ,[BehaviorTowardsOtherComment]                                       
      ,[MoodsEmotion]                                                                                                
      ,[MoodsEmotionComment]                                                                                                
      ,[SelfHarmfulBehavior]                                                                                        
      ,[SelfHarmfulBehaviorComment]                                                                                                
      ,[SubstanceUse]                              
      ,[SubstanceUseComment]                                                                
      ,[Thinkng]                                                                                             
      ,[ThinkngComment]              
      ,[YouthTotalScore]                                                                                                
      ,[PrimaryFamilyMaterialNeeds]                                                    
      ,[PrimaryFamilyMaterialNeedsComment]                                                                                                
      ,[PrimaryFamilySocialSupport]                                                                            
      ,[PrimaryFamilySocialSupportComment]                                                                                                
      ,[NonCustodialMaterialNeeds]                                   
      ,[NonCustodialMaterialNeedsComment]                                                                                                
      ,[NonCustodialSocialSupport]                                                                                                
      ,[NonCustodialSocialSupportComment]                                                                                                
      ,[SurrogateMaterialNeeds]                                                                                                
      ,[SurrogateMaterialNeedsComment]                                                                                                
      ,[SurrogateSocialSupport]                                                                                                
      ,[SurrogateSocialSupportComment]                                                                                                
                                                                      
  FROM CustomCAFAS2                   
  WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,''N'')=''N''                                  
    
                   
                
    --Checking For Errors                            
  If (@@error!=0)                            
  Begin                            
   RAISERROR  20006   ''csp_RdlHRMCAFAS : An Error Occured''                             
   Return                            
   End                            
                     
                          
                
End
' 
END
GO
