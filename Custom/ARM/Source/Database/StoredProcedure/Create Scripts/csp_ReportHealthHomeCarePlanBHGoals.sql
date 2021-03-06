/****** Object:  StoredProcedure [dbo].[csp_ReportHealthHomeCarePlanBHGoals]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportHealthHomeCarePlanBHGoals]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportHealthHomeCarePlanBHGoals]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportHealthHomeCarePlanBHGoals]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


create procedure [dbo].[csp_ReportHealthHomeCarePlanBHGoals]
	@DocumentVersionId int
as

select  bhg.GoalNumber,
        bhg.GoalProvider,
        bhg.NeedIdentifiedDate,
        bhg.NeedDescription,
        bhg.GoalDescription,
        bhg.GoalTargetDate,
        bhg.GoalObjectives,
        bhg.GoalServices,
        bhg.SourceDocumentVersionId
from dbo.CustomDocumentHealthHomeCarePlanBHGoals as bhg
where bhg.DocumentVersionId = @DocumentVersionId
and ISNULL(bhg.RecordDeleted, ''N'') <> ''Y''
order by bhg.GoalNumber, bhg.CustomDocumentHealthHomeCarePlanBHGoalId


' 
END
GO
