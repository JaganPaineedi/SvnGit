/****** Object:  StoredProcedure [dbo].[csp_RDLLabResults]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLLabResults]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLLabResults]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLLabResults]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
--csp_RDLLabResults 80

create procedure [dbo].[csp_RDLLabResults]
	@DocumentVersionId int
as

select
	d.DocumentId,
	case l.LabResultsFindings when ''N'' then ''Normal'' when ''A'' then ''Abnormal'' end as LabResultsFindings,
	l.LabResultsComment,
	s.LastName + '', '' + s.FirstName as ReviewerName,
	d.EffectiveDate
from CustomScannedReviewFormLabResults as l
join dbo.Documents as d on d.DocumentId = l.DocumentId
join dbo.DocumentVersions as dv on dv.DocumentId = d.DocumentId
join dbo.Staff as s on s.StaffId = d.AuthorId
where dv.DocumentVersionId = @DocumentVersionId

' 
END
GO
