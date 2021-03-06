/****** Object:  StoredProcedure [dbo].[csp_RDLSubReportCustomAssessmentHRMNeeds]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportCustomAssessmentHRMNeeds]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLSubReportCustomAssessmentHRMNeeds]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportCustomAssessmentHRMNeeds]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[csp_RDLSubReportCustomAssessmentHRMNeeds]
	--@DocumentId int,             
--@Version int            
@DocumentVersionId  int --Modified by Anuj Dated 03-May-2010
/************************************************************************/                                                
/* Stored Procedure: csp_RDLSubReportCustomAssessmentHRMNeeds			*/                                                                             
/* Copyright: 2008 Streamline SmartCare									*/                                                                                      
/* Creation Date:  August 10, 2008										*/                                                
/*																		*/                                                
/* Purpose: Retrieve needs for a new HRMAssessment                      */
/*																		*/                                              
/* Input Parameters: DocumentID,Version									*/                                              
/* Output Parameters:													*/                                                
/* Purpose: Use For Rdl Report											*/                                      
/* Calls:																*/                                                
/* Author: Tom Remisoski												*/                                                
/************************************************************************/                  

as

select
	chan.NeedName,
	dbo.csf_GetGlobalCodeNameById(chan.NeedStatus) as NeedStatus,
	chan.NeedDate,
	chan.NeedDescription,
	chan.CreatedBy,
	chan.CreatedDate,
	chan.ModifiedBy,
	chan.ModifiedDate	
from CustomHRMAssessmentNeeds as chan
--where chan.Documentid = @DocumentId
--and version = @Version
where chan.DocumentVersionId = @DocumentVersionId
and isnull(recorddeleted,''N'') <> ''Y''
order by
	chan.ModifiedDate,
	chan.ModifiedBy,
	chan.CreatedDate,
	chan.CreatedBy
' 
END
GO
