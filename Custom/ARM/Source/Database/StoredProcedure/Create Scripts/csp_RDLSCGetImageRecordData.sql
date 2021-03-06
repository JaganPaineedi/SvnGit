/****** Object:  StoredProcedure [dbo].[csp_RDLSCGetImageRecordData]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSCGetImageRecordData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLSCGetImageRecordData]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSCGetImageRecordData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE  PROCEDURE  [dbo].[csp_RDLSCGetImageRecordData]         
@ImageRecordId int          
As            
            
      
Begin                    
/*********************************************************************/                      
/* Stored Procedure: dbo.ssp_SCGetScannedMedicalRecordData      */            
                                                    
            
/* Copyright: 2007 Streamlin Healthcare Solutions           */                      
            
/* Creation Date:  24/12/2008                                   */                      
/*                                                                   */                      
/* Purpose: */                     
/*                                                                   */                    
/* Input Parameters: */                    
/*                                                                   */                       
/* Output Parameters:                                */                      
/*                                                                   */                      
/* Return:   */                      
/*                                                                   */                      
/* Called By: */                      
            
/*                                                                   */                      
/* Calls:                                                            */                      
/*                                                                   */                      
/* Data Modifications:                                               */                      
/*                                                                   */                      
/*   Updates:                                                          */                      
            
/*       Date              Author                  Purpose                                    */                      
/* 24/12/2008              Vikas Vyas              Created                                    */                      
/*********************************************************************/                       
        
    select ImageRecordItemId from ImageRecordItems      
    where ImageRecordId=  @ImageRecordId and Isnull(RecordDeleted,''N'')<>''Y''      
    order by ItemNumber Asc   
     
IF (@@error!=0)                        
 BEGIN                        
        RAISERROR  2001  ''ssp_SCGetScannedMedicalRecordData  : An Error Occured''                        
        RETURN                        
 END             
            
        
         
              
End
' 
END
GO
