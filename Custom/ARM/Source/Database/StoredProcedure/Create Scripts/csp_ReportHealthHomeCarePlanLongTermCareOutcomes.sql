/****** Object:  StoredProcedure [dbo].[csp_ReportHealthHomeCarePlanLongTermCareOutcomes]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportHealthHomeCarePlanLongTermCareOutcomes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportHealthHomeCarePlanLongTermCareOutcomes]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportHealthHomeCarePlanLongTermCareOutcomes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

create procedure [dbo].[csp_ReportHealthHomeCarePlanLongTermCareOutcomes]
	@DocumentVersionId int
as

select  oc.OutcomeSequence,
        oc.OutcomeDescription,
        oc.TargetDate
from dbo.CustomDocumentHealthHomeCarePlanLongTermCareOutcomes as oc
where oc.DocumentVersionId = @DocumentVersionId
and ISNULL(oc.RecordDeleted, ''N'') <> ''Y''
order by oc.OutcomeSequence


' 
END
GO
