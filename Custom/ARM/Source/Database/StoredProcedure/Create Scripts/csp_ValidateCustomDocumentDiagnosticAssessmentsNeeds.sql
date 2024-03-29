/****** Object:  StoredProcedure [dbo].[csp_ValidateCustomDocumentDiagnosticAssessmentsNeeds]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomDocumentDiagnosticAssessmentsNeeds]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ValidateCustomDocumentDiagnosticAssessmentsNeeds]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomDocumentDiagnosticAssessmentsNeeds]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create procedure [dbo].[csp_ValidateCustomDocumentDiagnosticAssessmentsNeeds]
/******************************************************************************                                      
**  File: csp_ValidateCustomDocumentDiagnosticAssessmentsNeeds                                  
**  Name: csp_ValidateCustomDocumentDiagnosticAssessmentsNeeds              
**  Desc: For Validation on Needs identified in the assessment.  Ensure they
**  are included in the initial treatment plan.
**  Return values: Resultset having validation messages                                      
**  Called by:                                       
**  Parameters:                  
**  Auth:  Jagdeep Hundal                     
**  Date:  July 29 2011                                  
*******************************************************************************                                      
**  Change History                                      
*******************************************************************************                                      
**  Date:       Author:       Description:                                      
**  --------    --------        ----------------------------------------------------                                      
** 2012.02.10	TER				Revised based on Harbor''s rules
*******************************************************************************/                                    
	@DocumentVersionId int,
	@TabOrder int = 1
as


Insert into #validationReturnTable (
	TableName,  
	ColumnName,  
	ErrorMessage,  
	TabOrder,  
	ValidationOrder  
)
select ''CustomDocumentAssessmentNeeds'', ''DeletedBy'', ''Need: "'' 
	+ SUBSTRING(cdan.NeedName, 1, 30) + case when LEN(cdan.NeedName) > 30 then ''...'' else '''' end + ''" must be addressed on the treatment plan.'', @TabOrder, 1
from dbo.CustomDocumentAssessmentNeeds as cdan
where cdan.DocumentVersionId = @DocumentVersionId
and cdan.NeedStatus = 6530 -- addressed in treatment
and ISNULL(cdan.RecordDeleted, ''N'') <> ''Y''
and not exists (
	select *
	from dbo.CustomTPGoalNeeds as tpgn
	join dbo.CustomTPGoals as tpg on tpg.TPGoalId = tpgn.TPGoalId
	join dbo.CustomTPNeeds as tpn on tpn.NeedId = tpgn.NeedId
	where tpg.DocumentVersionId = cdan.DocumentVersionId
	and SUBSTRING(tpn.NeedText, 1, 250) = cdan.NeedName
)

' 
END
GO
