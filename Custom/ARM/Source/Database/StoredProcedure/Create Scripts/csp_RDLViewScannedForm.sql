/****** Object:  StoredProcedure [dbo].[csp_RDLViewScannedForm]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLViewScannedForm]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLViewScannedForm]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLViewScannedForm]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'Create  Procedure [dbo].[csp_RDLViewScannedForm]         
@ImageRecordId int
AS
/*********************************************************************/                        
/* Stored Procedure: [csp_RDLViewScannedForm]      */              
                                                      
              
/* Copyright: 2007 Streamlin Healthcare Solutions           */                        
              
/* Creation Date:  18/09/2010                                   */                        
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
              
/*       Date              Author                          Purpose                                    */                        
/* 18/09/2010              Ashwani Kumar Angrish            Created                                    */                        
/*********************************************************************/                                 
IF (@ImageRecordId <> 0)
BEGIN
Select [ImageRecordId]
      ,[ScannedOrUploaded]
      ,[DocumentVersionId]
      ,[ImageServerId]
      ,[ClientId]
      ,[AssociatedId]
      ,[AssociatedWith]
      ,[RecordDescription]
      ,[EffectiveDate]
      ,[NumberOfItems]
      ,[AssociatedWithDocumentId]
      ,[AppealId]
      ,[StaffId]
      ,[EventId]
      ,[ProviderId]
      ,[TaskId]
      ,[ScannedBy]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[ModifiedBy]
      ,[ModifiedDate]
      ,[RecordDeleted]
      ,[DeletedDate]
      ,[DeletedBy]
From ImageRecords r
Where r.ImageRecordId = @ImageRecordId
and Isnull(RecordDeleted,''N'')<>''Y''      


END
ELSE
BEGIN
Select null, null
END
' 
END
GO
