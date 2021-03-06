/****** Object:  StoredProcedure [dbo].[csp_GetTextForAssessmentType]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetTextForAssessmentType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_GetTextForAssessmentType]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetTextForAssessmentType]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'  
  
CREATE PROCEDURE [dbo].[csp_GetTextForAssessmentType]   
(  
@ClientId int,  
@AssessmentType char(1),  
@DocumentVersionId int  
)  
  
As  
/*********************************************************************/                                                                                                                                                        
/* Stored Procedure: dbo.CSP_UpdateAsseeementType                */                                                                                                                                                        
/* Copyright: 2008 Streamline Healthcare Solutions,  LLC             */                                                                                                                                                        
/* Creation Date:  7 July,2011                                       */                                                                                                                                                        
/*                                                                   */                                                                                                                                                        
/* Purpose:  Get Data for Update Assessment Type Pages */                                                                                                                                                      
/*                                                                   */                                                                                                                                                      
/* Input Parameters:  @ClientId             */                                                                                                                                                      
/*                                                                   */                                                                                                                                                        
/* Output Parameters:   None                   */                                                                                                                                                        
/*                                                                   */                                                                                                                                                        
/* Return:  0=success, otherwise an error number                     */                                                                                                                                                        
/*                                                                   */                               
/* Called By:        */       
/* */                       
/* Calls:         */                                         
/*                         */                                           
/* Data Modifications:                   */                                                                        
/*      */                                                                                                       
/* Updates:               */                                                                                                
/*   Date     Author            Purpose                             */                                                                           
/*     */                                                                                   
/*                                                                                                        
*/                                                                                                                             
/*********************************************************************/                                                                                 
                                                                             
  
BEGIN  
 BEGIN TRY  
  BEGIN  
  
 Declare @UpdateAsseeementType varchar(500)  
  set @UpdateAsseeementType= ''You have selected ''''Update''''; An ''''Annual'''' is due ___ and will still be required even if you complete an ''''Update''''   
         Assessment at this time.  Click ''''OK'''' to continue with an ''''Update'''' Assessment or ''''Cancel'''' to change to an ''''Annual'''' Assessment''    
  
Select  ''UpdateAsseeementType'' AS TableName,@UpdateAsseeementType as ''UpdateAsseeementTypeText''    
END  
 END TRY  
   
 BEGIN CATCH  
 DECLARE @Error varchar(8000)                                                                                                                                 
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                          
                  
 + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''[csp_GetTextForAssessmentType]'')                                                                                                                 
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
