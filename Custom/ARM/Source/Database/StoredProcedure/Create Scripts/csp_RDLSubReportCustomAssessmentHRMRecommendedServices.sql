/****** Object:  StoredProcedure [dbo].[csp_RDLSubReportCustomAssessmentHRMRecommendedServices]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportCustomAssessmentHRMRecommendedServices]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLSubReportCustomAssessmentHRMRecommendedServices]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportCustomAssessmentHRMRecommendedServices]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[csp_RDLSubReportCustomAssessmentHRMRecommendedServices]
	--@DocumentId int,             
--@Version int            
@DocumentVersionId  int --Modified by Anuj Dated 03-May-2010
/************************************************************************/                                                
/* Stored Procedure: csp_RDLSubReportCustomAssessmentHRMRecommendedServices			*/                                                                             
/* Copyright: 2008 Streamline SmartCare									*/                                                                                      
/* Creation Date:  August 10, 2008										*/                                                
/*																		*/                                                
/* Purpose: Retrieve recommended services for a new HRMAssessment		*/
/*																		*/                                              
/* Input Parameters: DocumentID,Version									*/                                              
/* Output Parameters:													*/                                                
/* Purpose: Use For Rdl Report											*/                                      
/* Calls:																*/                                                
/* Author: Tom Remisoski												*/                                                
/************************************************************************/
as
                  
select o.ServiceChoiceLabel 
from dbo.CustomHRMAssessmentLevelOfCareOptions as a
join dbo.CustomHRMLevelOfCareOptions as o on o.HRMLevelOfCareOptionId = a.HRMLevelOfCareOptionId
--where a.Documentid = @DocumentId
--and a.Version = @Version
where a.DocumentVersionId = @DocumentVersionId  --Modified by Anuj Dated 03-May-2010
and a.OptionSelected = ''Y''
order by o.SortOrder
' 
END
GO
