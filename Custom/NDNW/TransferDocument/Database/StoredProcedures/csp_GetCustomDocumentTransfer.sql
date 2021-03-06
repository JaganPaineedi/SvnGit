

/****** Object:  StoredProcedure [dbo].[csp_GetCustomDocumentTransfer]    Script Date: 11/18/2011 16:25:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetCustomDocumentTransfer]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_GetCustomDocumentTransfer]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetCustomDocumentTransfer]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_GetCustomDocumentTransfer]      
(
	@DocumentVersionId INT = NULL
)
AS  
/******************************************************************************                        
**  Name: [csp_GetCustomDocumentTransfer]                        
**  Desc:      
*******************************************************************************                        
**  Change History                        
*******************************************************************************                        
**  Date:          Author:          Description:                        
**  
*******************************************************************************/ 
	SELECT  [DocumentVersionId]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[ModifiedBy]
      ,[ModifiedDate]
      ,[RecordDeleted]
      ,[DeletedBy]
      ,[DeletedDate]
      ,[TransferStatus]
      ,[TransferringStaff]
      ,[AssessedNeedForTransfer]
      ,[ReceivingStaff]
      ,[ReceivingProgram]
      ,[ClientParticpatedWithTransfer]
      ,[TransferSentDate]
      ,[ReceivingComment]
      ,[ReceivingAction]
      ,[ReceivingActionDate]
    FROM [dbo].[CustomDocumentTransfers]
	WHERE
		[DocumentVersionId] = @DocumentVersionId
		
	SELECT TOP 1000 [TransferServiceId]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[ModifiedBy]
      ,[ModifiedDate]
      ,[RecordDeleted]
      ,[DeletedBy]
      ,[DeletedDate]
      ,[DocumentVersionId]
      ,[AuthorizationCodeId],
       (SELECT DisplayAs FROM AuthorizationCodes WHERE AuthorizationCodeId = [CustomTransferServices].AuthorizationCodeId) AS AuthorizationCodeIdText
	FROM [dbo].[CustomTransferServices]
	WHERE
		DocumentVersionId = @DocumentVersionId
' 
END
GO
