/****** Object:  StoredProcedure [dbo].[csp_ReportHealthHomeCarePlanPESNeeds]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportHealthHomeCarePlanPESNeeds]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportHealthHomeCarePlanPESNeeds]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportHealthHomeCarePlanPESNeeds]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


create procedure [dbo].[csp_ReportHealthHomeCarePlanPESNeeds]
	@DocumentVersionId int
as

select  n.PsychosocialSupportNeedSequence,
        gc.CodeName as PsychosocialSupportNeedType,
        n.PsychosocialSupportNeedPlan
from dbo.CustomDocumentHealthHomeCarePlanPESNeeds as n
LEFT join dbo.GlobalCodes as gc on gc.GlobalCodeId = n.PsychosocialSupportNeedType
where n.DocumentVersionId = @DocumentVersionId
and ISNULL(n.RecordDeleted, ''N'') <> ''Y''
order by n.PsychosocialSupportNeedSequence



' 
END
GO
