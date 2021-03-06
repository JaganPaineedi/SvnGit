/****** Object:  StoredProcedure [dbo].[csp_getHarbourCustomConfiguration]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_getHarbourCustomConfiguration]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_getHarbourCustomConfiguration]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_getHarbourCustomConfiguration]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_getHarbourCustomConfiguration]                 
                                                                                
As                                                                                        
 /*********************************************************************/                                                                                            
 /* Stored Procedure: [csp_getHarbourCustomConfiguration]               */                                                                                   
 /* Creation Date:  28/Oct/2011                                    */                                                                                            
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
                                                                                   
 /*       Date              Author                  Purpose    */              
 /*  28/Oct/2011   Devinder     Creation  */                                                                                            
 /*********************************************************************/                       
Begin                              
Begin try       
select ReferralTransferReferenceURL from customconfigurations
END TRY                                                                          
BEGIN CATCH                      
DECLARE @Error varchar(8000)                                                                           
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                       
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_InitCustomDocumentPsychiatricEvaluationsInitialization'')                                                                                                         
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
