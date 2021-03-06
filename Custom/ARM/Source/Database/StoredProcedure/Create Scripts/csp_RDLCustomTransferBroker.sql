/****** Object:  StoredProcedure [dbo].[csp_RDLCustomTransferBroker]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomTransferBroker]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomTransferBroker]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomTransferBroker]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create PROCEDURE   [dbo].[csp_RDLCustomTransferBroker]  
(
--@DocumentId int,             
--@Version int            
@DocumentVersionId  int --Modified by Anuj Dated 03-May-2010 
)      
AS      

Begin
/************************************************************************/                                      
/* Stored Procedure: [csp_RDLCustomTransferBroker]						*/                             
/* Copyright: 2006 Streamline SmartCare									*/                                      
/* Creation Date:  Nov 05, 2007											*/                                      
/*																		*/                                      
/* Purpose: Gets Data for TransferBroker								*/                                     
/*																		*/                                    
/* Input Parameters: DocumentID,Version									*/                                    
/* Output Parameters:													*/                                      
/* Purpose: Use For Rdl Report											*/                            
/* Calls:																*/                                      
/* Author: Vikas Vyas													*/                                      
/*********************************************************************/        

--SELECT	CTB.DocumentId
--		,CTB.Version 
SELECT	CTB.DocumentVersionId  --Modified by Anuj Dated 03-May-2010 
		,(select OrganizationName from SystemConfigurations ) as OrganizationName
		,Documents.ClientId
		,Documents.EffectiveDate
		,Clients.DOB
		,Clients.FirstName + '' '' + Clients.LastName as ClientName
		,ctb.DocumentType
		,Case when ctb.DocumentType = ''T'' then ''Transfer'' 
			  when ctb.DocumentType = ''B'' then ''Broker'' 
			  else '''' 
		 end as DocumentName
		,ctb.DateOfRequest
		,PCP.ProgramName as CurrentProgram
		,PReq.ProgramName as ProgramRequested
		,StaffReqClinicain.FirstName + '' '' + StaffReqClinicain.LastName as RequestedClinician
		,ctb.VerballyAcceptedDate
		,ctb.Rationale
		,ctb.Findings
		,ctb.NoticeDeliveredDate
		,Staff1.LastName + '', '' + Staff1.FirstName as NotifyStaff1
		,Staff2.LastName + '', '' + Staff2.FirstName as NotifyStaff2
		,Staff3.LastName + '', '' + Staff3.FirstName as NotifyStaff3
		,Staff4.LastName + '', '' + Staff4.FirstName as NotifyStaff4
		,ctb.NotificationMessage
		,ctb.NotificationSent
		,Clinician.FirstName + '' '' + Clinician.LastName + case ISNull(GC.CodeName,'''') when '''' then '''' else '', '' + ISNull(GC.CodeName,'''') end as ClinicianName
FROM CustomTransferBroker CTB 
Join DocumentVersions dv on dv.DocumentVersionId=CTB.DocumentVersionId and isnull(dv.RecordDeleted,''N'')=''N''
--INNER JOIN Documents ON  CTB.DocumentId = Documents.DocumentId and isnull(Documents.RecordDeleted,''N'')<>''Y''  
INNER JOIN Documents ON  dv.DocumentId = Documents.DocumentId and isnull(Documents.RecordDeleted,''N'')<>''Y''    --Modified by Anuj Dated 03-May-2010 
INNER JOIN Clients ON Documents.ClientId = Clients.ClientId and isnull(Clients.RecordDeleted,''N'')<>''Y''   
Left Join Programs PCP ON CTB.CurrentProgram = PCP.ProgramId   
Left Join Programs PReq ON CTB.ProgramRequested = PReq.ProgramId  
Left Join Staff StaffReqClinicain On CTB.RequestedClinician = StaffReqClinicain.StaffId  
Left Join Staff Staff1 On CTB.NotifyStaff1 = Staff1.StaffId           
Left Join Staff Staff2 On CTB.NotifyStaff2 = Staff2.StaffId           
Left Join Staff Staff3 On CTB.NotifyStaff3 = Staff3.StaffId          
Left Join Staff Staff4 On CTB.NotifyStaff4 = Staff4.StaffId  
Left Join Staff Clinician On Documents.AuthorId = Clinician.StaffId  
Left Join GlobalCodes GC On Clinician.Degree = GC.GlobalCodeId  
WHERE ISNull(CTB.RecordDeleted,''N'')<>''Y'' 
--and CTB.DocumentId = @DocumentId 
--AND CTB.Version = @Version 
and CTB.DocumentVersionId=@DocumentVersionId   --Modified by Anuj Dated 03-May-2010 


--Checking For Errors                                      
If (@@error!=0)                                      
	Begin                                      
		RAISERROR  20006   ''csp_RDLCustomTransferBroker : An Error Occured''                                       
		Return                                      
	End
End
' 
END
GO
