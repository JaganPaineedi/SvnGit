/****** Object:  StoredProcedure [dbo].[csp_validateCustomHealthHomeDocuments]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomHealthHomeDocuments]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateCustomHealthHomeDocuments]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomHealthHomeDocuments]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_validateCustomHealthHomeDocuments]
@DocumentVersionId	Int
as

Create Table #validationReturnTable
(TableName varchar(300),
 ColumnName varchar(200),
 ErrorMessage varchar(500),
 PageIndex int
)


Insert into #validationReturnTable
(TableName,
ColumnName,
ErrorMessage,
PageIndex
)
--This validation returns three fields
--Field1 = TableName
--Field2 = ColumnName
--Field3 = ErrorMessage

Select ''CustomDocumentHealthHomeCommPlans'',''HealthHomeTeamMember1'',''Atleat one member must be selected'',1
       From CustomDocumentHealthHomeCommPlans
       Where DocumentVersionId = @DocumentVersionId and isnull(HealthHomeTeamMember1,'''')='''' and isnull(HealthHomeTeamMember2,'''')='''' and isnull(HealthHomeTeamMember3,'''')='''' and isnull(HealthHomeTeamMember4,'''')='''' and isnull(HealthHomeTeamMember5,'''')='''' and isnull(HealthHomeTeamMember6,'''')='''' and isnull(HealthHomeTeamMember7,'''')='''' and isnull(recordDeleted,''N'')=''N''
Union
Select ''CustomDocumentHealthHomeCommPlans'',''HealthHomeTeamRole1'',''Selected team member''''s role must be selected'',1
       From CustomDocumentHealthHomeCommPlans
       Where DocumentVersionId = @DocumentVersionId and  HealthHomeTeamMember1 is not null and isnull(HealthHomeTeamRole1,'''')='''' and isnull(recordDeleted,''N'')=''N''
Union
Select ''CustomDocumentHealthHomeCommPlans'',''HealthHomeTeamRole2'',''Selected team member''''s role must be selected'',1
       From CustomDocumentHealthHomeCommPlans
       Where DocumentVersionId = @DocumentVersionId and  HealthHomeTeamMember2 is not null and isnull(HealthHomeTeamRole2,'''')='''' and isnull(recordDeleted,''N'')=''N''
Union
Select ''CustomDocumentHealthHomeCommPlans'',''HealthHomeTeamRole3'',''Selected team member''''s role must be selected'',1
       From CustomDocumentHealthHomeCommPlans
       Where DocumentVersionId = @DocumentVersionId and  HealthHomeTeamMember3 is not null and isnull(HealthHomeTeamRole3,'''')='''' and isnull(recordDeleted,''N'')=''N''
Union
Select ''CustomDocumentHealthHomeCommPlans'',''HealthHomeTeamRole4'',''Selected team member''''s role must be selected'',1
       From CustomDocumentHealthHomeCommPlans
       Where DocumentVersionId = @DocumentVersionId and  HealthHomeTeamMember4 is not null and isnull(HealthHomeTeamRole4,'''')='''' and isnull(recordDeleted,''N'')=''N''
Union
Select ''CustomDocumentHealthHomeCommPlans'',''HealthHomeTeamRole5'',''Selected team member''''s role must be selected'',1
       From CustomDocumentHealthHomeCommPlans
       Where DocumentVersionId = @DocumentVersionId and  HealthHomeTeamMember5 is not null and isnull(HealthHomeTeamRole5,'''')='''' and isnull(recordDeleted,''N'')=''N''
Union
Select ''CustomDocumentHealthHomeCommPlans'',''HealthHomeTeamRole6'',''Selected team member''''s role must be selected'',1
       From CustomDocumentHealthHomeCommPlans
       Where DocumentVersionId = @DocumentVersionId and  HealthHomeTeamMember6 is not null and isnull(HealthHomeTeamRole6,'''')='''' and isnull(recordDeleted,''N'')=''N''
Union
Select ''CustomDocumentHealthHomeCommPlans'',''HealthHomeTeamRole7'',''Selected team member''''s role must be selected'',1
       From CustomDocumentHealthHomeCommPlans
       Where DocumentVersionId = @DocumentVersionId and  HealthHomeTeamMember7 is not null and isnull(HealthHomeTeamRole7,'''')='''' and isnull(recordDeleted,''N'')=''N''
Union
Select ''CustomDocumentHealthHomeCommPlans'',''MedicaidManagedCarePlan'',''Medicaid managed care plan must be selected'',1
       From CustomDocumentHealthHomeCommPlans
       Where DocumentVersionId = @DocumentVersionId and isnull(MedicaidManagedCarePlan,'''')='''' and isnull(recordDeleted,''N'')=''N''
Union
Select ''CustomDocumentHealthHomeCommPlans'',''ClientGuardianParticipatedInPlan'',''Client participstion must be selected'',1
       From CustomDocumentHealthHomeCommPlans
       Where DocumentVersionId = @DocumentVersionId and isnull(ClientGuardianParticipatedInPlan,'''')='''' and isnull(recordDeleted,''N'')=''N''

--Check to make sure record exists in custom table for @DocumentCodeId

If not exists (Select 1 from CustomDocumentHealthHomeCommPlans Where DocumentVersionId = @DocumentVersionId)
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

Select ''CustomDocumentHealthHomeCommPlans'', ''DeletedBy'', ''Error occurred. Please contact your system administrator. No record exists in custom table.''
Where not exists  (Select 1 from CustomDocumentHealthHomeCommPlans Where DocumentVersionId = @DocumentVersionId)
end
select * from #validationReturnTable
if @@error <> 0 goto error

return

error:
raiserror 50000 ''csp_validateCustomHealthHomeDocuments failed.  Contact your system administrator.''
' 
END
GO
