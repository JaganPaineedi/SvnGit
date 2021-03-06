/****** Object:  StoredProcedure [dbo].[csp_GetCustomDocumentTransfer]    Script Date: 06/19/2013 17:49:44 ******/
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
**  20-june-2012   RohitK    AuthorizationCodeName field Change into DisplayAs aginst task no:81(Services Drop-Downs) Harbor Go Live Issues 
**  29-Apr -2013   Veena     Added LevelofCare for ARM Customization
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
      ,[LevelofCare]
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
       (SELECT DisplayAs FROM AuthorizationCodes WHERE AuthorizationCodeId = [CustomDocumentTransferServices].AuthorizationCodeId) AS AuthorizationCodeIdText
	FROM [dbo].[CustomDocumentTransferServices]
	WHERE
		DocumentVersionId = @DocumentVersionId
' 
END
GO
