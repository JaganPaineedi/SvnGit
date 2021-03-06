/****** Object:  StoredProcedure [dbo].[csp_validateCustomTransitionPlan]    Script Date: 06/19/2013 17:49:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomTransitionPlan]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateCustomTransitionPlan]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomTransitionPlan]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_validateCustomTransitionPlan]
@DocumentVersionId	Int
as

-- =============================================
-- Author:		Veena S Mani
-- Create date: 25/02/2013
-- Description:	To Validate for HealthHomeTransitionPlans Document.
-- ============================================= 

Create Table #validationReturnTable
(TableName varchar(300),
 ColumnName varchar(200),
 ErrorMessage varchar(800),
 PageIndex int
)


Insert into #validationReturnTable
(TableName,
ColumnName,
ErrorMessage
)
--This validation returns three fields
--Field1 = TableName
--Field2 = ColumnName
--Field3 = ErrorMessage

Select ''CustomDocumentHealthHomeTransitionPlans'', ''ClinicianCoordinatingDischarge'', ''Clinician Coordinating Discharge must be specified''  
	From CustomDocumentHealthHomeTransitionPlans
	 Where DocumentVersionId = @DocumentVersionId and isnull(recordDeleted,''N'')=''N'' and isnull(ClinicianCoordinatingDischarge,'''')=''''
	
Union  

Select ''CustomDocumentHealthHomeTransitionPlans'', ''TransitionFromEntityType'', ''Transition From Entity Type must be specified''  
	From CustomDocumentHealthHomeTransitionPlans
	 Where DocumentVersionId = @DocumentVersionId and isnull(recordDeleted,''N'')=''N'' and isnull(TransitionFromEntityType,'''')='''' and isnull(TransitionFromNA,''N'')<>''Y''
	
Union
Select ''CustomDocumentHealthHomeTransitionPlans'', ''TransitionFromEntityTypeComment'', ''Transition From Entity Type Comment must be specified''  
	From CustomDocumentHealthHomeTransitionPlans
	 Where DocumentVersionId = @DocumentVersionId and isnull(recordDeleted,''N'')=''N'' and isnull(TransitionFromEntityTypeComment,'''')='''' and isnull(TransitionFromNA,''N'')<>''Y''
	
Union

Select ''CustomDocumentHealthHomeTransitionPlans'', ''TransitionToEntityType'', ''Transition To Entity Type must be specified''  
	From CustomDocumentHealthHomeTransitionPlans
	 Where DocumentVersionId = @DocumentVersionId and isnull(recordDeleted,''N'')=''N'' and isnull(TransitionToEntityType,'''')='''' and isnull(TransitionToNA,''N'')<>''Y''
	
Union
Select ''CustomDocumentHealthHomeTransitionPlans'', ''TransitionToEntityTypeComment'', ''Transition To Entity Type Comment must be specified''  
	From CustomDocumentHealthHomeTransitionPlans
	 Where DocumentVersionId = @DocumentVersionId and isnull(recordDeleted,''N'')=''N'' and isnull(TransitionToEntityTypeComment,'''')='''' and isnull(TransitionToNA,''N'')<>''Y''

Union
Select ''CustomDocumentHealthHomeTransitionPlans'', ''ResidenceFollowingDischarge'', ''Either Residence immediately following discharge or N/A  must be specified''  
	From CustomDocumentHealthHomeTransitionPlans
	 Where DocumentVersionId = @DocumentVersionId and isnull(recordDeleted,''N'')=''N'' and isnull(ResidenceFollowingDischarge,'''')='''' and isnull(TransitionFromNA,''N'')<>''Y'' and isnull(ResidenceFollowingDischargeNA,''N'')<>''Y''
	
Union
Select ''CustomDocumentHealthHomeTransitionPlans'', ''ResidencePermanent'', ''LongTerm/Permanent Residence selection must be specified''
       From CustomDocumentHealthHomeTransitionPlans
       Where DocumentVersionId = @DocumentVersionId and  ResidencePermanent is null and isnull(ResidenceFollowingDischargeNA,''N'')<>''Y'' and isnull(recordDeleted,''N'')=''N'' and isnull(TransitionFromNA,''N'')<>''Y''


Union
Select ''CustomDocumentHealthHomeTransitionPlans'', ''ResidencePlanForLongTerm'', ''Plan For LongTerm/Permanent Residence must be specified''
       From CustomDocumentHealthHomeTransitionPlans
       Where DocumentVersionId = @DocumentVersionId and  ResidencePlanForLongTerm is null and ResidencePermanent =''N'' and isnull(recordDeleted,''N'')=''N''


Union
Select ''CustomDocumentHealthHomeTransitionPlans'', ''HasRerralsToAdditionalProvider'', ''At lease one referral must be specified ''
       From CustomDocumentHealthHomeTransitionPlans
       Where DocumentVersionId = @DocumentVersionId and  HasRerralsToAdditionalProvider =''Y'' and isnull(recordDeleted,''N'')=''N'' and (Select count(*) from CustomDocumentHealthHomeReferrals Where DocumentVersionId = @DocumentVersionId and isnull(recordDeleted,''N'')=''N'') < 1

Union
Select ''CustomDocumentHealthHomeTransitionPlans'', ''RequiresAuthsForAdditionalProvider'', '' At least one Prior authorization must be specified''
       From CustomDocumentHealthHomeTransitionPlans
       Where DocumentVersionId = @DocumentVersionId and  RequiresAuthsForAdditionalProvider =''Y'' and isnull(recordDeleted,''N'')=''N'' and (Select count(*) from CustomDocumentHealthHomePriorAuthorizations Where DocumentVersionId = @DocumentVersionId and isnull(recordDeleted,''N'')=''N'') < 1

Union
Select ''CustomDocumentHealthHomeTransitionPlans'', ''PreventionPlan'', ''Prevention Plan must be specified''  
	From CustomDocumentHealthHomeTransitionPlans
	 Where DocumentVersionId = @DocumentVersionId and isnull(recordDeleted,''N'')=''N'' and isnull(PreventionPlan,'''')=''''
	
Union
Select ''CustomDocumentHealthHomeTransitionPlans'', ''MedReconciliationCompletionDate'', ''Either Medication Reconciliation CompletionDate or N/A must be specified''  
	From CustomDocumentHealthHomeTransitionPlans
	 Where DocumentVersionId = @DocumentVersionId and isnull(recordDeleted,''N'')=''N'' and (isnull(MedReconciliationCompletionDate,'''')='''' and isnull(MedReconciliationCompletionNA,''N'')=''N'')

Union
Select ''CustomDocumentHealthHomeTransitionPlans'', ''ClientHasDemonstratedUnderstanding'', ''Client Has Demonstrated Understanding must be specified''
       From CustomDocumentHealthHomeTransitionPlans
       Where DocumentVersionId = @DocumentVersionId and  ClientHasDemonstratedUnderstanding is null  and isnull(recordDeleted,''N'')=''N''

Union
Select ''CustomDocumentHealthHomeTransitionPlans'', ''CoordinationOfRecordsComplete'', ''Coordination Of Records Complete must be specified''
       From CustomDocumentHealthHomeTransitionPlans
       Where DocumentVersionId = @DocumentVersionId and  CoordinationOfRecordsComplete is null  and isnull(recordDeleted,''N'')=''N''
	
	

If not exists (Select 1 from CustomDocumentHealthHomeTransitionPlans Where DocumentVersionId = @DocumentVersionId)
begin 

Insert into CustomBugTracking
(DocumentVersionId, Description, CreatedDate)
Values
(@DocumentVersionId, ''No record exists in custom table.'', GETDATE())

Insert into #validationReturnTable
(TableName,
ColumnName,
ErrorMessage
)

Select ''CustomDocumentHealthHomeTransitionPlans'', ''DeletedBy'', ''Error occurred. Please contact your system administrator. No record exists in custom table.''
Where not exists  (Select 1 from CustomDocumentHealthHomeTransitionPlans Where DocumentVersionId = @DocumentVersionId)
end
select * from #validationReturnTable
if @@error <> 0 goto error

return

error:
raiserror 50000 ''csp_validateCustomTransitionPlan failed.  Contact your system administrator.''


' 
END
GO
