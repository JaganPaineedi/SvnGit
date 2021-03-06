/****** Object:  StoredProcedure [dbo].[csp_SCDocumentToBeInitializedOrNot]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCDocumentToBeInitializedOrNot]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCDocumentToBeInitializedOrNot]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCDocumentToBeInitializedOrNot]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'Create PROCEDURE [dbo].[csp_SCDocumentToBeInitializedOrNot]                                                                                        
(                                                                                        
   @DocumentCodeId as int                                         
)                                                                                        
AS        
/*********************************************************************/                                                                                          
/* Stored Procedure: dbo.[[csp_SCDocumentToBeInitializedOrNot]]           */                                                                                          
/* Copyright: 2006 Streamline Healthcare Solutions,  LLC             */                                                                                          
/* Creation Date:    01/15/2008                                      */                                                                                          
/*                                                                   */                                                                                          
/* Purpose:    */                                                                                        
/*                                                                   */                                                                                        
/* Input Parameters:@DocumentCodeId              */                                                                                        
/*                                                                   */                                                                                          
/* Output Parameters:        */                                                                                          
/*                                                                   */                                                                                          
/* Return:  0=success, otherwise an error number                     */                                                                                          
/*                                                                   */                                                                                          
/* Called By:                                                        */                                                                                          
/*                                                                   */                                                                                          
/* Calls:                                                            */                                                                                          
/*                                                                   */                                                                                          
/* Data Modifications:                                               */                                                                                          
/*                                                                   */                                                                                          
/* Updates:                                                          */                                                                                          
/*  Date     Author               Purpose                            */                                                                                          
/* 29/05/09  Sonia Dhamija  Created (for Custom  Documents Initialization) */   
/*********************************************************************/                                   
                         
BEGIN TRAN                                         
                                 
Select ToBeInitialized
from DocumentCodes
where DocumentCodeId=@DocumentCodeId
and ISNULL(RecordDeleted,''N'')<>''Y''


COMMIT TRAN                                                                 
Return  (0)                                                                                       
                                                                                       
error:                                      
 rollback tran                                                                                          
 RAISERROR(''Unable To execute [csp_SCDocumentToBeInitializedOrNot] . Contact tech support.'', 16, 1)
' 
END
GO
