/****** Object:  StoredProcedure [dbo].[csp_RDLSubReportCustomAssessmentHRMSupports]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportCustomAssessmentHRMSupports]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLSubReportCustomAssessmentHRMSupports]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportCustomAssessmentHRMSupports]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--select * from customhrmassessmentsupports
CREATE procedure [dbo].[csp_RDLSubReportCustomAssessmentHRMSupports]
--@DocumentId int,             
--@Version int            
@DocumentVersionId  int --Modified by Anuj Dated 03-May-2010
as


select a.SupportLabel, chas.NaturalSupportDescription
from (
	select ''P'' as NaturalSupportType, ''Proposed Supports'' as SupportLabel
	union
	select ''C'' as NaturalSupportType, ''Current Supports'' as SupportLabel
) as a
--left outer join CustomHRMAssessmentSupports as chas on chas.DocumentId = @DocumentId and chas.Version = @Version 
left outer join CustomHRMAssessmentSupports as chas on chas.DocumentVersionId = @DocumentVersionId   --Modified by Anuj Dated 03-May-2010
	and chas.NaturalSupportType = a.NaturalSupportType and isnull(chas.RecordDeleted, ''N'') <> ''Y''
order by a.SupportLabel, chas.SortOrder
' 
END
GO
