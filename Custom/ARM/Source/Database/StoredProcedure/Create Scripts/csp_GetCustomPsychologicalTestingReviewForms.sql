/****** Object:  StoredProcedure [dbo].[csp_GetCustomPsychologicalTestingReviewForms]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetCustomPsychologicalTestingReviewForms]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_GetCustomPsychologicalTestingReviewForms]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetCustomPsychologicalTestingReviewForms]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create procedure [dbo].[csp_GetCustomPsychologicalTestingReviewForms]
	@DocumentId int
as
select
	DocumentId,
	CreatedBy,
	CreatedDate,
	ModifiedBy,
	ModifiedDate,
	RecordDeleted,
	DeletedBy,
	DeletedDate,
	ReviewedDateTime
from GetCustomPsychologicalTestingReviewForms
where dbo.ReturnDocumentId = @DocumentId
' 
END
GO
