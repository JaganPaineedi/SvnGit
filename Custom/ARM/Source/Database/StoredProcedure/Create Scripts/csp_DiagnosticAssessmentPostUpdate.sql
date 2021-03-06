/****** Object:  StoredProcedure [dbo].[csp_DiagnosticAssessmentPostUpdate]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_DiagnosticAssessmentPostUpdate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_DiagnosticAssessmentPostUpdate]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_DiagnosticAssessmentPostUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'               
CREATE  PROCEDURE  [dbo].[csp_DiagnosticAssessmentPostUpdate]  --839433,25175,''JSCOBY''          
 @DocumentVersionId int,  
 @ClientId int,                    
 @UserCode varchar(50)   
AS                 
/*********************************************************************/                                                            
/* Stored Procedure: csp_DiagnosticAssessmentPostUpdate                */                                                            
/* Copyright: 2009 Streamline Healthcare Solutions,  LLC             */                                                            
/* Creation Date:    14/July /2011                                         */                                                            
/*                                                                   */                                                            
/* Purpose:  Used to copy the assessment needs into CustomTP needs  */                                                           
/*                                                                   */                                                          
/* Input Parameters:   @DocumentVersionId , @ClientId,@UserCode      */                                                          
/*                                                                   */                                                            
/* Output Parameters:   None                */                                                            
/*                                                                   */                                                            
/* Return:  0=success, otherwise an error number                     */                                                            
/*                                                                   */                                                            
/* Called By:CopyAssessmentNeedsPostUpdate Function in cs     */                                                            
/*                                                                   */                                                            
/* Calls:  DiagnosticAssessment.cs                                   */                                                            
/*                                                                   */                                                            
/* Data Modifications:                                               */                                                            
/*                                                                   */                                                            
/* Updates:                                                          */                                                            
/*  Date          Author          Purpose                            */                                                            
/* 14/July/2011   Minakshi        Created                            */                                                         
/*  22-Feb-2012   Maninder		  Modified(only NeedName needs to be checked for existance : Task#3 in	SCPhase3Development 	)				*/	                                                        
/* 06-June-2012   Jagdeep         Added check CustomDocumentAssessmentNeeds.RecordDeleted */

/*********************************************************************/                          
    
BEGIN                   
      
BEGIN TRY      
--Copy Assessment Needs into CustomTPNeeds         
--INSERT INTO CustomTPNeeds(ClientId,NeedText,CreatedBy)  
--SELECT DISTINCT @ClientID,
--case when NeedDescription is null then NeedName else NeedDescription end,@UserCode FROM CustomDocumentAssessmentNeeds  
--WHERE NeedStatus=6530 AND DocumentVersionId=@DocumentVersionId AND 
--case when NeedDescription is null then NeedName else NeedDescription end 
--not in (SELECT NeedText From CustomTPNeeds Where ClientId =@ClientID and 
--ISNULL(RecordDeleted,''N'')=''N'')   
INSERT INTO CustomTPNeeds(ClientId,NeedText,CreatedBy)  
SELECT DISTINCT @ClientID, NeedName,@UserCode FROM CustomDocumentAssessmentNeeds  
WHERE NeedStatus=6530 AND DocumentVersionId=@DocumentVersionId AND ISNULL(CustomDocumentAssessmentNeeds.RecordDeleted,''N'')=''N'' AND NeedName not in (SELECT NeedText From CustomTPNeeds Where ClientId =@ClientID and 
ISNULL(RecordDeleted,''N'')=''N'')   
       
                   
END TRY                    
BEGIN CATCH                                                                                                                                                                  
  DECLARE @Error varchar(8000)                                                                                                         
  SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                         
                       
   + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_DiagnosticAssessmentPostUpdate'')                                                                                                          
   + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****ERROR_SEVERITY='' + Convert(varchar,ERROR_SEVERITY())                                                                                                                                                     
   
   + ''*****ERROR_STATE='' + Convert(varchar,ERROR_STATE())                                                                                                        
  RAISERROR (@Error /* Message text*/,  16 /*Severity*/,   1/*State*/   )                                                                                                          
END CATCH                 
END 

' 
END
GO
