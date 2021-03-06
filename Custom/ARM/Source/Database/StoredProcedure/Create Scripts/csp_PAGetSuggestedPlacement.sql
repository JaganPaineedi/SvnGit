/****** Object:  StoredProcedure [dbo].[csp_PAGetSuggestedPlacement]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PAGetSuggestedPlacement]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_PAGetSuggestedPlacement]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PAGetSuggestedPlacement]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE  [dbo].[csp_PAGetSuggestedPlacement]                         
(                           
  @Dimension1LevelOfCare int,  
  @Dimension2LevelOfCare int,  
  @Dimension3LevelOfCare int                               
)                              
                              
As                              
                                      
Begin                                      
/*********************************************************************/                                        
/* Stored Procedure: dbo.[csp_PAGetSuggestedPlacement]                */                               
                              
/* Copyright: 2009 Streamline Healthcare Solutions           */                                        
                              
/* Creation Date:  20 Mar 2010                                   */                                        
/*                                                                   */             
/*  Author: Jitender Kumar                                                                 */             
/*                                                                   */                                        
/* Purpose: Get Suggested Placement for ASAM Document      */                                       
/*                                                                   */                                      
/* Input Parameters: @Dimension1LevelOfCare, @Dimension2LevelOfCare, @Dimension3LevelOfCare*/                                      
/*                                                                   */                                         
/* Output Parameters:                                */                                        
/*                                                                   */                                        
/* Return:   */                                        
/*                                                                   */                                        
/* Called By:  Method in Documents Class Of DataService  in "Always Online Application"    */                                        
                              
                                     
                                    
 BEGIN TRY                                                   
             
 /*CustomASAMPlacements Table*/            
 select top 1 isnull(LevelOfCareName,'''') as SuggestedPlacementName, isnull(ASAMLevelOfCareId,'''') as SuggestedPlacement from CustomASAMLevelOfCares   
 where  (ASAMLevelOfcareId = @Dimension1LevelOfCare or               
 ASAMLevelOfcareId = @Dimension2LevelOfCare or ASAMLevelOfcareId = @Dimension3LevelOfCare)                       
 and ISNull(RecordDeleted,''N'')=''N''   
                     
  END TRY                            
                              
  BEGIN CATCH                                                  
  DECLARE @Error varchar(8000)                                                                                     
  set @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                    
  + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_PAGetSuggestedPlacement'')                                                                                     
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
