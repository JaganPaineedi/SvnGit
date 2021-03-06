/****** Object:  StoredProcedure [dbo].[csp_RdlCustomDocumentMapToEmploymentObjectivesCoaching]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlCustomDocumentMapToEmploymentObjectivesCoaching]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RdlCustomDocumentMapToEmploymentObjectivesCoaching]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlCustomDocumentMapToEmploymentObjectivesCoaching]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_RdlCustomDocumentMapToEmploymentObjectivesCoaching]                            
@DocumentVersionId  int                     
 AS                           
Begin               
                 
/*********************************************************************/                                                                                                                                    
/* Stored Procedure: dbo.[csp_RdlCustomDocumentMapToEmploymentObjectivesCoaching]                */                                                                                                                                    
/* Copyright: 2008 Streamline Healthcare Solutions,  LLC             */                                                                                                                                    
/* Creation Date:  04 Aug,2011                                       */                                                                                                                                    
/* Created By: Jagdeep Hundal                                                                  */                                                                                                                                    
/* Purpose:  Get Data from MapToEmploymentObjectives */                                                                                                                                  
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
/*********************************************************************/              
                   
   SELECT  CDMTEO.[EmploymentObjectiveId]
          ,CDMTEO.[DocumentVersionId]
          ,CONVERT(VARCHAR(8),CDMTEO.ObjectiveTargetDate,1) as ObjectiveTargetDate 
          ,CDMTEO.[ObjectiveText]                  
  FROM CustomDocumentMapToEmploymentObjectives   CDMTEO                       
  where CDMTEO.DocumentVersionId=@DocumentVersionId and IsNull(CDMTEO.RecordDeleted,''N'')=''N''         
  and CDMTEO.ObjectiveType=''C''               
    --Checking For Errors                            
  If (@@error!=0)                            
  Begin                            
   RAISERROR  20006   ''csp_RdlCustomDocumentMapToEmploymentObjectivesCoaching : An Error Occured''                             
   Return                            
   End                            
End  
  
  ' 
END
GO
