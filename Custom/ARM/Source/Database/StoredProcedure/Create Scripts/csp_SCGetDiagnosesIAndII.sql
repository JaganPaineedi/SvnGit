/****** Object:  StoredProcedure [dbo].[csp_SCGetDiagnosesIAndII]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetDiagnosesIAndII]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetDiagnosesIAndII]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetDiagnosesIAndII]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_SCGetDiagnosesIAndII]                                
(                                        
  @DocumentVersionId INT              
)                                        
                     
AS                              
/***************************************************************************/                                     
/* Stored Procedure: [csp_SCGetDiagnosesIAndII] */                                                                                     
/* Copyright: 2006 Streamline SmartCare               */                                                                                              
/* Creation Date:  March 17,2009                 */                                                                                              
/* Purpose: Gets Data [csp_SCGetDiagnosesIAndII] */                                                                                             
/* Input Parameters: @DocumentVersionId                                  */                                                                                            
/* Output Parameters:                   */                                                                                              
/* Return:  0=success, otherwise an error number                           */                               
/* Purpose to fetch the all columns of DiagnosesIAndII Table  */                                                                                    
/* Calls:                                                                  */                                                    
/* Data Modifications:                                                     */                                                    
/* Updates:                                                                */                                                    
/* Date       Author        Purpose        */                                                    
/* 17/03/2009               Umesh Sharma   Created        */                                                    
/***************************************************************************/                                        
                              
BEGIN                                                       
                 
 BEGIN TRY                              
   BEGIN                                 
                               
  --DiagnosesIAndII            
   SELECT            
   D.DocumentVersionId            
   ,D.DiagnosisId            
   ,0 as DocumentId            
   ,0 as Version          
   ,D.Axis            
   ,D.DSMCode            
   ,D.DSMNumber            
   ,D.DiagnosisType            
   ,D.RuleOut            
   ,D.Billable            
   ,D.Severity            
   ,D.DSMVersion            
   ,D.DiagnosisOrder            
   ,D.Specifier            
   ,D.CreatedBy            
   ,D.CreatedDate            
   ,D.ModifiedBy            
   ,D.ModifiedDate            
   ,D.RecordDeleted            
   ,D.DeletedDate            
   ,D.DeletedBy            
   ,ISNULL(DSM.DSMDescription,'''') AS  DSMDescription          
   FROM DiagnosesIAndII  D            
   left outer join DiagnosisDSMDescriptions DSM on  DSM.DSMCode = D.DSMCode            
   and DSM.DSMNumber = D.DSMNumber          
   WHERE               
   DocumentVersionId=@DocumentVersionId   AND ISNULL(RecordDeleted,''N'')=''N''                                        
   END                                
 END TRY                              
 BEGIN CATCH                                                                             
  DECLARE @Error varchar(8000)                                                 
   SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                               
   + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_SCGetDiagnosesIAndII'')                                                     
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
