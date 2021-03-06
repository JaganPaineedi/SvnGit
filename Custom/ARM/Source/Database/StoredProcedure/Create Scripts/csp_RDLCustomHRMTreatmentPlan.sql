/****** Object:  StoredProcedure [dbo].[csp_RDLCustomHRMTreatmentPlan]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomHRMTreatmentPlan]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomHRMTreatmentPlan]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomHRMTreatmentPlan]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_RDLCustomHRMTreatmentPlan]        
(                                        
--@DocumentId int,             
--@Version int            
@DocumentVersionId  int --Modified by Anuj Dated 03-May-2010
)                                        
As                                        
                                                
Begin                                                
/************************************************************************/                                                  
/* Stored Procedure: csp_RDLCustomHRMTreatmentPlan								*/                                         
/* Copyright: 2006 Streamline SmartCare									*/                                                  
/* Creation Date:  Dec 4 ,2007											*/                                                  
/*																		*/                                                  
/* Purpose: Gets Data for csp_RDLTreatmentPlan							*/                                                 
/* Input Parameters: DocumentID,Version									*/                                                
/* Output Parameters:													*/                                                  
/* Purpose: Use For Rdl Report											*/                                        
/* Calls:																*/                                                  
/*																		*/                                                  
/* Author: Rishu Chopra													*/                                                  
/*********************************************************************/                                         
select	d.ClientId
		,d.EffectiveDate
		,c.LastName+ '', '' + c.FirstName  as ClientName
		,s.LastName + '', '' + s.FirstName as ClinicianName
		,(select OrganizationName from SystemConfigurations ) as OrganizationName
--		,TPG.DocumentId
--		,TPG.Version
		,TPG.DocumentVersionId  --Modified by Anuj Dated 03-May-2010 
		,case when TPG.PlanOrAddendum = ''T'' then ''''
			  when TPG.PlanOrAddendum = ''A'' then ''ADDENDUM''
			  else ''''
		 end as PlanOrAddendum
		,TPG.MeetingDate
		,TPG.Participants
		,TPG.HopesAndDreams
		,TPG.PurposeOfAddendum
		,TPG.StrengthsAndPreferences
		,TPG.AreasOfNeed
		,TPG.Diagnosis
		,TPG.DeferredTreatmentIssues
		,TPG.DischargeCriteria
		,case when TPG.ClientAcceptedPlan = ''Y'' then ''Yes'' 
			  else ''No'' 
		 end as ClientAcceptedPlan
		,TPG.NotificationMessage
		,TPG.CrisisPlan
		,tpg.CrisisPlanNotNecessary
		,''Y'' as DisplayCrisisPlanNotNecessaryCheckbox
		,TPG.OtherComment
		,PeriodicReviewFrequencyNumber
		,PeriodicReviewFrequencyUnitType
		,S1.LastName + '', '' + S1.FirstName as StaffId1
		,S2.LastName + '', '' + S2.FirstName as StaffId2
		,S3.LastName + '', '' + S3.FirstName as StaffId3
		,S4.LastName + '', '' + S4.FirstName as StaffId4
		,TPG.AuthorizationSent
		,TPG.NotificationSent
		,TPG.AuthorizationRequestorComment
		,TPG.Assigned
		--av to hide Notifications in RDL
		,case when (isnull(TPG.NotificationMessage,'''') = '''' 
					and isnull(TPG.StaffId1,'''') = '''' 
					and isnull(TPG.StaffId2,'''') = '''' 
					and isnull(TPG.StaffId3,'''') = '''' 
					and isnull(TPG.StaffId4,'''') = '''') then ''N''
			  else ''Y''
		 end as DisplayNotifications
		,''Y'' as DisplayTPProcedures
		,TPG.CreatedBy
		,TPG.CreatedDate
		,TPG.ModifiedBy
		,TPG.ModifiedDate
		,TPG.RecordDeleted
		,TPG.DeletedDate
		,TPG.DeletedBy
from DocumentVersions as dv
join Documents as d on d.DocumentId = dv.DocumentId
left join TPGeneral TPG ON  TPG.DocumentVersionId = dv.DocumentVersionId and isnull(TPG.RecordDeleted,''N'')<>''Y''       --Modified by Anuj Dated 03-May-2010
left JOIN GlobalCodes as GC on (GC.GlobalCodeID = TPG.PlanDeliveryMethod)      
left JOIN staff S1 on (S1.StaffId = TPG.StaffId1)               
left JOIN staff S2 on (S2.StaffId = TPG.StaffId2)               
left JOIN staff S3 on (S3.StaffId = TPG.StaffId3)               
left JOIN staff S4 on (S4.StaffId = TPG.StaffId4)      
join Clients as c ON d.ClientId = c.ClientId and isnull(c.RecordDeleted,''N'')<>''Y''        
Left Join Staff as s On s.StaffId = d.AuthorId        
--where Documents.DocumentID = @DocumentId 
where dv.DocumentVersionId = @DocumentVersionId  --Modified by TER 9/25/2010
                      
--Checking For Errors                                        
If (@@error!=0)                                        
	Begin                                        
		RAISERROR  20006   ''csp_RDLCustomHRMTreatmentPlan : An Error Occured''                                         
		Return                                        
	End
End
' 
END
GO
