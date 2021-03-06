/****** Object:  StoredProcedure [dbo].[csp_RDLCustomDischargeOld]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDischargeOld]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomDischargeOld]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDischargeOld]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE   [dbo].[csp_RDLCustomDischargeOld]         
(
@DocumentVersionId int    
)            
AS            
      
Begin      
/************************************************************************/                                            
/* Stored Procedure: [csp_RDLCustomDischarge]							*/                                   
/* Copyright: 2006 Streamline SmartCare									*/                                            
/* Creation Date:  May 11th ,2008										*/                                            
/*																		*/                                            
/* Purpose: Gets Data from CustomDischarge,SystemConfigurations,		*/
/*			Staff,Documents												*/                                           
/*																		*/                                          
/* Input Parameters: DocumentID,Version									*/                                          
/* Output Parameters:													*/                                            
/* Purpose: Use For Rdl Report											*/                                  
/* Calls:																*/                                            
/* Author: Rupali Patil													*/  
/* modifeid by avoss 9/10/2008 left join globalCodes rather than direct join, isnull for clinician name in case of no degree*/                                          
/*********************************************************************/              
SELECT	SystemConfig.OrganizationName
		,C.LastName + '', '' + C.FirstName as ClientName
		,S.LastName + '', '' + S.FirstName + '' '' + isnull(GC.CodeName,'''') as ''ClinicianName''
		,Documents.ClientID
		,Documents.EffectiveDate
		,CD.[AdmissionDate] as [AdmissionDate]
		,CD.[LastDateOfService] as [LastDateOfService]
		,CD.[PresentingProblem] as [PresentingProblem]
		,CD.[DischargeReason] as [DischargeReason]
		,CD.[DischargeDate] as [DischargeDate]
		,case when CD.[DischargeType] = ''U''
				then ''Unplanned'' 
			  when CD.[DischargeType] = ''P''
				then ''Planned''
		 end as [DischargeType]
		,CD.[ProgressSummary] as [ProgressSummary]
		,CD.[ServicesSummary] as [ServicesSummary]
		,CD.[MedicationInformation] as [MedicationInformation]
		,CD.[NaturalSupports] as [NaturalSupports]
		,CD.[ClientFeedback] as [ClientFeedback]
		,CD.[TreatmentProviders] as [TreatmentProviders]
		,CD.[DatePlanGivenToClient] as [DatePlanGivenToClient]
		,case when CD.[ClientDeclined] = ''Y''
				then ''Yes''
			  when CD.[ClientDeclined] = ''N''
				then ''No''
		 end as [ClientDeclined]
		,S1.LastName + '', '' + S1.FirstName as Staff1
		,S2.LastName + '', '' + S2.FirstName as Staff2		
		,S3.LastName + '', '' + S3.FirstName as Staff3		
		,S4.LastName + '', '' + S4.FirstName as Staff4		
		,CD.[NotificationMessage] as NotificationMessage
FROM Documents 
join documentVersions dv on dv.DocumentId = documents.DocumentId and isnull(dv.RecordDeleted,''N'')<>''Y''
join Staff S on Documents.AuthorId = S.StaffId
join Clients C on Documents.ClientId= C.ClientId and isnull(C.RecordDeleted,''N'')<>''Y''  
left join [CustomDischargesOld] as CD  ON  CD.DocumentVersionId = dv.DocumentVersionId and isnull(cd.RecordDeleted,''N'')<>''Y''             
left join GlobalCodes GC on S.Degree = GC.GlobalCodeId
left join Staff S1 on CD.[NotifyStaffId1]= S1.StaffId 
left join Staff S2 on CD.[NotifyStaffId2]= S2.StaffId 
left join Staff S3 on CD.[NotifyStaffId3]= S3.StaffId 
left join Staff S4 on CD.[NotifyStaffId4]= S4.StaffId 
Cross Join SystemConfigurations as SystemConfig  
where dv.DocumentVersionId = @DocumentVersionId  
and isnull(documents.RecordDeleted,''N'')=''N''
    
--Checking For Errors                                            
If (@@error!=0)                                            
	Begin                                            
		RAISERROR  20006   ''[csp_RDLCustomDischargeOld] : An Error Occured''                                             
		Return                                            
	End                                                     
End
' 
END
GO
