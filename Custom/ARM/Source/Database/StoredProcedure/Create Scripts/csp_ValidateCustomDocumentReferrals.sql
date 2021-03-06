/****** Object:  StoredProcedure [dbo].[csp_ValidateCustomDocumentReferrals]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomDocumentReferrals]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ValidateCustomDocumentReferrals]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomDocumentReferrals]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


CREATE procedure [dbo].[csp_ValidateCustomDocumentReferrals]
	@DocumentVersionId int
/****************************************************************/
-- PROCEDURE: [csp_ValidateCustomDocumentReferrals]
-- PURPOSE: Handles the validation for custom referral documents.
-- CALLED BY: SmartCare on post-update (signature)
-- REVISION HISTORY:
--		2011.07.19 - T. Remisoski - Created.
/****************************************************************/

as

declare @StatusNotSent int, @StatusSent int, @StatusComplete int
declare @ActionAccept int, @ActionReject int, @ActionForward int

declare @AutoApproveReferralAuthorizationCodes table (
	AuthorizationCodeId int
)

insert into @AutoApproveReferralAuthorizationCodes
        (AuthorizationCodeId)	-- from AuthorizationCodes table
values 
	(10),	--	Developmental Pediatric Consultation
	(11),	--	Integrated Primary Care
	(13),	--	Pharmacologic Management
	(14),	--	Psychiatric Evaluation
	(15)	--	Psychological Testing

-- We keep getting burned by having different code-ids between systems so we will init these each time based on category/codename
select @StatusNotSent = GlobalCodeId from GlobalCodes where Category = ''REFERRALSTATUS'' and CodeName = ''Not Sent''
select @StatusSent = GlobalCodeId from GlobalCodes where Category = ''REFERRALSTATUS'' and CodeName = ''Sent''
select @StatusComplete = GlobalCodeId from GlobalCodes where Category = ''REFERRALSTATUS'' and CodeName = ''Complete''

select @ActionAccept = GlobalCodeId from GlobalCodes where Category = ''RECEIVINGACTION'' and CodeName = ''Accept''
select @ActionReject = GlobalCodeId from GlobalCodes where Category = ''RECEIVINGACTION'' and CodeName = ''Reject''
select @ActionForward = GlobalCodeId from GlobalCodes where Category = ''RECEIVINGACTION'' and CodeName = ''Forward''

declare @CurrentStatus int, @ReceivingStaffId int, @ReceivingAction int, @ReferringStaffId int

select
	@CurrentStatus = r.ReferralStatus,
	@ReceivingStaffId = r.ReceivingStaff,
	@ReceivingAction = r.ReceivingAction,
	@ReferringStaffId = r.ReferringStaff
from CustomDocumentReferrals as r
where r.DocumentVersionId = @DocumentVersionId

-- Required when sending
if @CurrentStatus = @StatusNotSent
begin
	Insert into #validationReturnTable (
		TableName,  
		ColumnName,  
		ErrorMessage,  
		TabOrder,  
		ValidationOrder  
	)
	select ''CustomDocumentReferrals'', ''ReferringStaff'', ''Referring staff selection required'', '''', ''''
	from dbo.CustomDocumentReferrals where DocumentVersionId = @DocumentVersionId and ReferringStaff is null
	union
	select ''CustomDocumentReferrals'', ''ReceivingStaff'', ''Receiving staff selection required'', '''', ''''
	from dbo.CustomDocumentReferrals where DocumentVersionId = @DocumentVersionId and ReceivingStaff is null
	union
	select ''CustomDocumentReferrals'', ''AssessedNeedForReferral'', ''Assessed need for referral required'', '''', ''''
	from dbo.CustomDocumentReferrals where DocumentVersionId = @DocumentVersionId and LEN(ISNULL(LTRIM(RTRIM(AssessedNeedForReferral)), '''')) = 0
	union
	select ''CustomDocumentReferrals'', ''ClientParticpatedWithReferral'', ''Client particpation required'', '''', ''''
	from dbo.CustomDocumentReferrals where DocumentVersionId = @DocumentVersionId and ISNULL(ClientParticpatedWithReferral, ''N'') <> ''Y''
	
	if 0 = (select COUNT(*) from dbo.CustomDocumentReferralServices where DocumentVersionId = @DocumentVersionId and ISNULL(RecordDeleted, ''N'') <> ''Y'')
	begin
		Insert into #validationReturnTable (
			TableName,  
			ColumnName,  
			ErrorMessage,  
			TabOrder,  
			ValidationOrder  
		)
		select ''CustomDocumentReferrals'', ''DeletedBy'', ''At least one service must be selected for referral.'', '''', ''''
	end
	
	exec csp_ValidateCustomDocumentReferralServices @DocumentVersionId

			
end
else if @CurrentStatus = @StatusSent
begin
	Insert into #validationReturnTable (
		TableName,  
		ColumnName,  
		ErrorMessage,  
		TabOrder,  
		ValidationOrder  
	)
	select ''CustomDocumentReferrals'', ''ReferringStaff'', ''Referring staff selection required'', '''', ''''
	from dbo.CustomDocumentReferrals where DocumentVersionId = @DocumentVersionId and ReferringStaff is null
	union
	select ''CustomDocumentReferrals'', ''ReceivingStaff'', ''Receiving staff selection required'', '''', ''''
	from dbo.CustomDocumentReferrals where DocumentVersionId = @DocumentVersionId and ReceivingStaff is null
	union
	select ''CustomDocumentReferrals'', ''AssessedNeedForReferral'', ''Assessed need for referral required'', '''', ''''
	from dbo.CustomDocumentReferrals where DocumentVersionId = @DocumentVersionId and LEN(ISNULL(LTRIM(RTRIM(AssessedNeedForReferral)), '''')) = 0
	union
	select ''CustomDocumentReferrals'', ''ReceivingAction'', ''Receiving action must be selected'', '''', ''''
	from dbo.CustomDocumentReferrals where DocumentVersionId = @DocumentVersionId and ReceivingAction is null
	union
	select ''CustomDocumentReferrals'', ''ReceivingComment'', ''Comment required when rejecting a referral'', '''', ''''
	from dbo.CustomDocumentReferrals where DocumentVersionId = @DocumentVersionId and LEN(ISNULL(LTRIM(RTRIM(ReceivingComment)), '''')) = 0
	and ReceivingAction = @ActionReject

end



' 
END
GO
