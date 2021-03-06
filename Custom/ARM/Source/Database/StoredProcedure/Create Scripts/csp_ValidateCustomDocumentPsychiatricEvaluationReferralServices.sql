/****** Object:  StoredProcedure [dbo].[csp_ValidateCustomDocumentPsychiatricEvaluationReferralServices]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomDocumentPsychiatricEvaluationReferralServices]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ValidateCustomDocumentPsychiatricEvaluationReferralServices]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomDocumentPsychiatricEvaluationReferralServices]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create procedure [dbo].[csp_ValidateCustomDocumentPsychiatricEvaluationReferralServices]
	@DocumentVersionId int
                                  
as
Insert into #validationReturnTable (
	TableName,  
	ColumnName,  
	ErrorMessage,  
	TabOrder,  
	ValidationOrder  
)


/*
select ''CustomDocumentPsychiatricEvaluationReferrals'', ''DeletedBy'', ''Referral Service - Amount, Frequency and Staff is required.'', 7, 1
where exists (
	select *
	from dbo.CustomDocumentPsychiatricEvaluationReferrals as pr
	where pr.DocumentVersionId = @DocumentVersionId
	and ISNULL(pr.RecordDeleted, ''N'') <> ''Y''
	and ( isnull(pr.ServiceAmount,0)=0
		or isnull(pr.ServiceFrequency,0)=0
		--or isnull(pr.ServiceUnitType,0)=0 
		--or isnull(pr.ServiceRecommended,0)=0
		or isnull(pr.ReceivingStaffId,0)=0
	)
)

union
*/
select ''CustomDocumentPsychiatricEvaluationReferrals'', ''DeletedBy'', ''Referral Service - Client participation required for all services.'', 7, 2
where exists (
	select *
	from dbo.CustomDocumentPsychiatricEvaluationReferrals as pr
	where pr.DocumentVersionId = @DocumentVersionId
	and ISNULL(pr.ClientParticipatedReferral, ''N'') <> ''Y''
	and ISNULL(pr.RecordDeleted, ''N'') <> ''Y''
)


' 
END
GO
