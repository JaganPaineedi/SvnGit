/****** Object:  StoredProcedure [dbo].[csp_RDLSubReportCustomAssessmentHRMRAPScores]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportCustomAssessmentHRMRAPScores]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLSubReportCustomAssessmentHRMRAPScores]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportCustomAssessmentHRMRAPScores]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE   PROCEDURE   [dbo].[csp_RDLSubReportCustomAssessmentHRMRAPScores]        
(
--@DocumentId int,             
--@Version int            
@DocumentVersionId  int --Modified by Anuj Dated 03-May-2010
)                
AS                
          

/************************************************************************/                                                
/* Stored Procedure: [csp_RDLSubReportCustomAssessmentHRMRAPScores]		*/                                                                             
/* Copyright: 2008 Streamline SmartCare									*/                                                                                      
/* Creation Date:  July 30, 2008										*/                                                
/*																		*/                                                
/* Purpose: Gets Data from CustomAssessment,SystemConfigurations,		*/
/*			Staff,Documents,Clients,GlobalCodes,Pharmacy				*/                                               
/*																		*/                                              
/* Input Parameters: DocumentID,Version									*/                                              
/* Output Parameters:													*/                                                
/* Purpose: Use For Rdl Report											*/                                      
/* Calls:																*/                                                
/* Author: Tom Remisoski												*/                                                
/************************************************************************/                  

select 
	case rq.RAPDomain 
		when ''Community Inclusion'' then cha.RapCiDomainIntensity
		when ''Challenging Behaviors'' then cha.RapCbDomainIntensity
		when ''Current Abilities'' then cha.RapCaDomainIntensity
		when ''Health and Health Care'' then cha.RapHhcDomainIntensity
	end as DomainIntensity,
	rq.RAPDomain,
	rq.RAPQuestionNumber,
	rq.RAPQuestionText,
	rs.RAPAssessedValue,
    l.RAPLevelDescription
from dbo.CustomHRMRAPQuestions as rq
join dbo.CustomHRMAssessmentRAPScores as rs on rs.HRMRAPQuestionId = rq.HRMRAPQuestionId
--join dbo.CustomHRMAssessments as CHA on cha.DocumentId = rs.DocumentId and cha.Version = rs.Version
join dbo.CustomHRMAssessments as CHA on cha.DocumentVersionId = rs.DocumentVersionId   --Modified by Anuj Dated 03-May-2010
left Join dbo.CustomHRMRAPLevels as l on l.HRMRAPQuestionId = rs.HRMRAPQuestionId and rs.RAPAssessedValue = l.RAPLevelValue
--where rs.DocumentId = @DocumentId
--and rs.Version = @Version
where rs.DocumentVersionId=@DocumentVersionId  --Modified by Anuj Dated 03-May-2010
and isnull(rs.RecordDeleted, ''N'') <> ''Y'' 
order by 
	case rq.RAPDomain 
		when ''Community Inclusion'' then 1
		when ''Challenging Behaviors'' then 2
		when ''Current Abilities'' then 3
		when ''Health and Health Care'' then 4
	end, rq.RAPQuestionNumber

--select * from CustomHRMRAPLevels
--select * from CustomHRMAssessmentRAPScores
--Checking For Errors                                                
If (@@error!=0)                                                
	Begin                                                
		RAISERROR  20006   ''[csp_RDLSubReportCustomAssessmentHRMRAPScores] : An Error Occured''                                                 
		Return                                                
	End
' 
END
GO
