/****** Object:  StoredProcedure [dbo].[csp_GetTextForDiagnosticAssessmentType]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetTextForDiagnosticAssessmentType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_GetTextForDiagnosticAssessmentType]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetTextForDiagnosticAssessmentType]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [dbo].[csp_GetTextForDiagnosticAssessmentType]   
(  
@ClientId int,  
@AssessmentType char(1),  
@DocumentVersionId int  
)  
  
As  
/*********************************************************************/                                                                                                                                                        
/* Stored Procedure: csp_GetTextForDiagnosticAssessmentType               */                                                                                                                                                        
/* Copyright: 2009 Streamline Healthcare Solutions,  LLC             */                                                                                                                                                        
/* Creation Date:  11 July,2011                                       */                                                                                                                                                        
/*                                                                   */                                                                                                                                                        
/* Purpose: To Set messageText for popup on Initial/Update  */                                                                                                                                                      
/*                                                                   */                                                                                                                                                      
/* Input Parameters:  @ClientId ,@AssessmentType, @DocumentVersionId  */                                                                                                                                                      
/*                                                                   */                                                                                                                                                        
/* Output Parameters:   None                   */                                                                                                                                                        
/*                                                                   */                                                                                                                                                        
/* Return:  0=success, otherwise an error number                     */                                                                                                                                                        
/*                                                                   */                               
/* Called By:  DiagnosticAssessment      */       
/* */                       
/* Calls:         */                                         
/*                         */                                           
/* Data Modifications:                   */                                                                        
/*      */                                                                                                       
/* Updates:               */                                                                                                
/*   Date			Author      Purpose                                */                                                                           
/*   11 July,2011	Minakshi	To Set messageText for popup on Initial/Update */                                                                                   
/*                                                                                                        
*/                                                                                                                             
/*********************************************************************/                                                                                 
                                                                             
  
BEGIN  
 BEGIN TRY  
  BEGIN  
  
 Declare @AssessmentTypeText varchar(500)  
         
--Set pop up text              
 set @AssessmentTypeText= 
	Case 
	When @AssessmentType = ''U'' Then ''You have selected "Update";  Information from the previously signed DA will be copied to this one.  Updates to the MSE and Diagnostic Impression sections are required.''   
    When @AssessmentType in (''I'') then ''You have selected "Initial". A blank assessment will be created for this client.''  
    END  
Select  ''UpdateAsseeementType'' AS TableName,@AssessmentTypeText as ''UpdateAsseeementTypeText''    
END  
 END TRY  
   
 BEGIN CATCH  
 DECLARE @Error varchar(8000)                                                                                                                                 
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                          
                  
 + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''[csp_GetTextForDiagnosticAssessmentType]'')                                                                                                                 
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
