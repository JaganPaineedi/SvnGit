/****** Object:  StoredProcedure [dbo].[csp_RDLSubReportCustomAssessmentHRMDLAScores]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportCustomAssessmentHRMDLAScores]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLSubReportCustomAssessmentHRMDLAScores]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportCustomAssessmentHRMDLAScores]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create   PROCEDURE   [dbo].[csp_RDLSubReportCustomAssessmentHRMDLAScores]
(
--@DocumentId int,             
--@Version int            
@DocumentVersionId  int --Modified by Anuj Dated 03-May-2010               
)                
AS                
          

/************************************************************************/                                                
/* Stored Procedure: [csp_RDLSubReportCustomAssessmentHRMDLAScores]		*/                                                                             
/* Copyright: 2008 Streamline SmartCare									*/                                                                                      
/* Creation Date:  July 30, 2008										*/                                                
/*																		*/                                                
/* Purpose: HRM assessment sub report for DLA scores					*/                                    
/*																		*/                                              
/* Input Parameters: DocumentID,Version									*/                                              
/* Output Parameters:													*/                                                
/* Purpose: Use For Rdl Report											*/                                      
/* Calls:																*/                                                
/* Author: Tom Remisoski												*/                                                
/************************************************************************/                  

select 
	act.HRMActivityDescription,
	act.SortOrder,
	sc.ActivityScore,
	sc.ActivityComment
from dbo.CustomHRMActivities as act
--join dbo.CustomHRMAssessmentActivityScores as sc on sc.HRMActivityId = act.HRMActivityId
join dbo.CustomDailyLivingActivityScores as sc on sc.HRMActivityId = act.HRMActivityId

--where sc.DocumentId = @DocumentId
--and sc.Version = @Version
where sc.DocumentVersionId = @DocumentVersionId  --Modified by Anuj Dated 03-May-2010     

and isnull(sc.RecordDeleted, ''N'') <> ''Y''
order by  act.SortOrder

--Checking For Errors                                                
If (@@error!=0)                                                
	Begin                                                
		RAISERROR  20006   ''[csp_RDLSubReportCustomAssessmentHRMDLAScores] : An Error Occured''                                                 
		Return                                                
	End
' 
END
GO
