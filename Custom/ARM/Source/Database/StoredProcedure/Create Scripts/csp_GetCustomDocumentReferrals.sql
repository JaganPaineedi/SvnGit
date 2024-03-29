/****** Object:  StoredProcedure [dbo].[csp_GetCustomDocumentReferrals]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetCustomDocumentReferrals]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_GetCustomDocumentReferrals]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetCustomDocumentReferrals]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'  
CREATE PROCEDURE [dbo].[csp_GetCustomDocumentReferrals]      
(
	@DocumentVersionId INT = NULL
)
AS  
/******************************************************************************                        
**  Name: [csp_GetCustomDocumentReferrals]                        
**  Desc:      
*******************************************************************************                        
**  Change History                        
*******************************************************************************                        
**  Date:          Author:          Description:                        
**  20-june-2012   RohitK    AuthorizationCodeName field Change into DisplayAs aginst task no:81(Services Drop-Downs) Harbor Go Live Issues 
**  27-November-2015 Vijeta Sinha   A Renewed Mind - Support #221: Optimize Get Stored Procedure 
*******************************************************************************/  
	--SELECT     
	--	DocumentVersionId, RecordDeleted, DeletedBy, DeletedDate, ReferralStatus, 
	--	ReferringStaff, AssessedNeedForReferral, ReceivingStaff, ReceivingProgram, 
	--	ClientParticpatedWithReferral, RemoveClientFromCaseLoad, ReferralSentDate, 
	--	ReceivingComment, ReceivingAction, ReceivingActionDate,ModifiedBy,ModifiedDate
	select  DocumentVersionId,
CreatedBy,
CreatedDate,
ModifiedBy,
ModifiedDate,
RecordDeleted,
DeletedBy,
DeletedDate,
ReferralStatus,
ReferringStaff,
AssessedNeedForReferral,
ReceivingStaff,
ReceivingProgram,
ClientParticpatedWithReferral,
RemoveClientFromCaseLoad,
ReferralSentDate,
ReceivingComment,
ReceivingAction,
ReceivingActionDate 
	FROM 
		CustomDocumentReferrals 
	WHERE
		DocumentVersionId = @DocumentVersionId
		
	SELECT     
		ReferralServiceId, CreatedBy, CreatedDate, ModifiedBy,
		ModifiedDate, RecordDeleted, DeletedBy, DeletedDate,
		DocumentVersionId, AuthorizationCodeId, 
		(SELECT DisplayAs FROM AuthorizationCodes WHERE AuthorizationCodeId = CRS.AuthorizationCodeId) AS AuthorizationCodeIdText
	FROM 
		CustomDocumentReferralServices CRS 
	WHERE
		DocumentVersionId = @DocumentVersionId
' 
END
GO
