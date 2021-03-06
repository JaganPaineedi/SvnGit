/****** Object:  StoredProcedure [dbo].[csp_AutoPopulateClientInformationOffOfHRMAssessment]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_AutoPopulateClientInformationOffOfHRMAssessment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_AutoPopulateClientInformationOffOfHRMAssessment]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_AutoPopulateClientInformationOffOfHRMAssessment]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[csp_AutoPopulateClientInformationOffOfHRMAssessment]
/*******************************************************************************      
**  Change History      
*******************************************************************************      
**  Date:  Author:    Description:      
**  --------  --------    ----------------------------------------------------      
 
*******************************************************************************/    

	@DocumentVersionId int
as


Update c
set c.LivingArrangement = a.CurrentLivingArrangement,
modifiedBy = ''AssessmentDocument'',
modifiedDate = getdate()
From Clients c
Join Documents d  with (nolock) on d.ClientId = c.ClientId 
Join CustomHRMAssessments a with (nolock) on a.DocumentVersionId = d.CurrentDocumentVersionId
Where d.CurrentDocumentVersionId = @DocumentVersionId
and a.CurrentLivingArrangement is not null
and isnull(d.RecordDeleted, ''N'') = ''N''
and isnull(a.RecordDeleted, ''N'') = ''N''
' 
END
GO
