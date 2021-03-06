/****** Object:  StoredProcedure [dbo].[csp_RDLTreatmentPlan]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLTreatmentPlan]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLTreatmentPlan]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLTreatmentPlan]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_RDLTreatmentPlan]        
(                                        
--@DocumentId int,             
--@Version int            
@DocumentVersionId  int --Modified by Anuj Dated 03-May-2010                                        
)                                        
As                                        
                                                
Begin                                                
/************************************************************************/                                                  
/* Stored Procedure: csp_RDLTreatmentPlan								*/                                         
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
select	Documents.ClientId
		,Documents.EffectiveDate
		,Clients.LastName+ '', '' + Clients.FirstName  as ClientName
		,Clinician.LastName + '', '' + Clinician.FirstName as ClinicianName
		,(select OrganizationName from SystemConfigurations ) as OrganizationName
		--,TPG.DocumentId
		--,TPG.Version
		,TPG.DocumentVersionId   --Modified by Anuj Dated 04-May-2010
		,case when TPG.PlanOrAddendum = ''T'' then ''''
			  when TPG.PlanOrAddendum = ''A'' then ''ADDENDUM''
			  else ''''
		 end as PlanOrAddendum
		,TPG.Participants
		,TPG.HopesAndDreams
		,TPG.Barriers
		,TPG.PurposeOfAddendum
		,TPG.StrengthsAndPreferences
		,TPG.AreasOfNeed
		,TPG.Diagnosis
		,TPG.AuthorizedServices
		,TPG.DeferredTreatmentIssues
		,TPG.PersonsNotPresent
		,TPG.DischargeCriteria
		,TPG.PeriodicReviewDueDate
		,Convert(varchar,GC.CodeName) as PlanDeliveryMethod
		,case when TPG.ClientAcceptedPlan = ''Y'' then ''Yes'' 
			  else ''No'' 
		 end as ClientAcceptedPlan
		,TPG.NotificationMessage
		,TPG.CrisisPlan
		,TPG.OtherComment
		,TPG.PlanDeliveredDate
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
--		,TPN.NeedText
--		,TPN.NeedCreatedDate
--		,TPN.GoalText
--		,TPN.NeedModifiedDate
--		,TPO.ObjectiveNumber
--		,TPO.ObjectiveText
--		,Convert(varchar,GC1.CodeName) as ObjectiveStatus
--		,TPO.TargetDate
--		,TPI.InterventionNumber
--		,TPI.InterventionText
from TPGeneral TPG  
join DocumentVersions dv on dv.DocumentVersionid=TPG.DocumentVersionId and isnull(dv.RecordDeleted,''N'')=''N''     
--left Join TPNeeds TPN on (TPG.Documentid=TPN.Documentid and TPG.Version=TPN.Version and ISNull(TPN.RecordDeleted,''N'')=''N'')       
--left Join TPObjectives  TPO on (TPG.Documentid=TPO.Documentid and TPG.Version=TPO.Version and ISNull(TPO.RecordDeleted,''N'')=''N'')       
--left Join TPInterventions  TPI on (TPG.Documentid=TPI.Documentid and TPG.Version=TPI.Version and ISNull(TPI.RecordDeleted,''N'')=''N'')       
left JOIN GlobalCodes as GC on (GC.GlobalCodeID = TPG.PlanDeliveryMethod)      
--left JOIN GlobalCodes GC1 on (GC1.GlobalCodeID = TPO.ObjectiveStatus)      
left JOIN staff S1 on (S1.StaffId = TPG.StaffId1)               
left JOIN staff S2 on (S2.StaffId = TPG.StaffId2)               
left JOIN staff S3 on (S3.StaffId = TPG.StaffId3)               
left JOIN staff S4 on (S4.StaffId = TPG.StaffId4)      
--INNER JOIN Documents ON  TPG.DocumentId = Documents.DocumentId and isnull(Documents.RecordDeleted,''N'')<>''Y''        
INNER JOIN Documents ON  dv.DocumentId = Documents.DocumentId and isnull(Documents.RecordDeleted,''N'')<>''Y''        --Modified by Anuj Dated 03-May-2010
INNER JOIN Clients ON Documents.ClientId = Clients.ClientId and isnull(Clients.RecordDeleted,''N'')<>''Y''        
Left Join Staff as Clinician On Documents.AuthorId = Clinician.StaffId        
--Left Join GlobalCodes as GC2 On Clinician.Degree=GC2.GlobalCodeId           
--where TPG.DocumentID = @DocumentId 
--and TPG.Version = @Version
where TPG.DocumentVersionId=@DocumentVersionId  --Modified by Anuj Dated 03-May-2010   
and ISNull(TPG.RecordDeleted,''N'') = ''N''      
--where TPG.DocumentID=492925 and TPG.Version =1 and ISNull(TPG.RecordDeleted,''N'')=''N''      
        
                      
--Checking For Errors                                        
If (@@error!=0)                                        
	Begin                                        
		RAISERROR  20006   ''csp_RDLTreatmentPlan : An Error Occured''                                         
		Return                                        
	End
End
' 
END
GO
