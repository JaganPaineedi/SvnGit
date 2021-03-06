/****** Object:  StoredProcedure [dbo].[csp_RDLCustomTransfer]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomTransfer]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomTransfer]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomTransfer]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create PROCEDURE   [dbo].[csp_RDLCustomTransfer]    
--@DocumentId int,             
--@Version int            
@DocumentVersionId  int --Modified by Anuj Dated 03-May-2010      
        
AS        
  
Begin  
/*********************************************************************/                                        
/* Stored Procedure: [csp_RDLCustomTransfer]   */                               
                              
/* Copyright: 2006 Streamline SmartCare*/                                        
                              
/* Creation Date:  Jan 02 ,2008                                  */                                        
/*                                                                   */                                        
/* Purpose: Gets Data for CustomTransfers */                                       
/*                                                                   */                                      
/* Input Parameters: DocumentID,Version */                                      
/*                                                                   */                                         
/* Output Parameters:                                */                                        
/*                                                                   */                                        
/*    */                                        
/*                                                                   */                                        
/* Purpose Use For Rdl Report  */                              
/*      */                              
                              
/*                                                                   */                                        
/* Calls:                                                            */                                        
/*                                                                   */                                        
/* Author Vikas Vyas          */                                        
/*                                                                   */                                        
/*                                                             */                                        
                              
/*                                        */                                        
/*           
avoss 01.06.2010 fixed clinician name
*/                                        
/*********************************************************************/          

SELECT  SystemConfig.OrganizationName,      
       C.LastName + '', '' + C.FirstName as ClientName,         
       Documents.ClientID,      
       Documents.EffectiveDate        
      ,s.FirstName + '' '' + s.LastName + case ISNull(GC.CodeName,'''') when '''' then '''' else '', '' + ISNull(GC.CodeName,'''') end as ClinicianName    
      ,[RequestType]
      ,[ContactPerson]
      ,[ContactPhone]
      ,[CurrentResidence]
      ,[GuardianFirstName]
      ,[GuardianLastName]
      ,GC.CodeName as [GuardianRelationship]
      ,[GuardianTelephoneNumber]
      ,TProg.ProgramName as [TransferFromProgram]
      ,Prog.ProgramName as [RequestedProgram]
      ,GCServiceReq.CodeName as  [ServiceRequested]
      ,Isnull(ReqClinician.LastName,'''') + '',  '' + Isnull(ReqClinician.FirstName,'''') as  [RequestedClinician]
      ,[RationaleForRequest]
      ,GCUrgency.CodeName as [Urgency]
      ,SReqMadeBy.FirstName as [RequestMadeByFirstName]
      ,SReqMadeBy.LastName as [RequestMadeByFirstName1]
      ,[RequestDate]
      ,SReqTeamCoordinator.LastName as [RequestingTeamCoordinatorLastName]
      ,SReqTeamCoordinator.FirstName as [RequestingTeamCoordinatorFirstName]
      ,[SendRequestingCoordinator]
      ,[SentDate1]
      ,[ReceivedDate1]
      ,GCDecisionRequest.CodeName as [RequestingDecision]
      ,[SentComment]
      ,SRecTeamCoordinator.LastName as [ReceivingTeamCoordinatorLastName]
      ,SRecTeamCoordinator.FirstName as [ReceivingTeamCoordinatorFirstName]
      ,[SendReceivingCoordinator]
      ,[SentDate2]
      ,[ReceivedDate2]
      ,GCReceivedDecision.CodeName as [ReceivedDecision]
      ,[ReceivedComment]
      ,[EnrollDate]
      ,SAssignedClinician.LastName as [AssignedClinician]
      ,SAssignedAttending.LastName as [AssignedAttending]
      ,[LevelOfCareChangeNotice]
      ,[CreateAssignment]
      ,SDenialSentTo.FirstName as [DenialSentToFirstName]
      ,SDenialSentTo.LastName  as [DenialSentToLastName]
      ,[SendDocumentToDenial]
      ,[SentDate3]
      ,[ReceivedDate3]
      ,[DenialComment]
      ,[AuthorizationTeam]
      ,[ProceduresComment]

--FROM CustomTransfers CT Inner Join	Documents On CT.DocumentId=Documents.DocumentId and Isnull(Documents.RecordDeleted,''N'')<> ''Y''  
FROM CustomTransfers CT 
Join DocumentVersions dv on dv.DocumentVersionId=CT.DocumentVersionId and isnull(dv.RecordDeleted,''N'')=''N''
Join Documents On dv.DocumentId=Documents.DocumentId and Isnull(Documents.RecordDeleted,''N'')<> ''Y''    --Modified by Anuj Dated 03-May-2010    
join Staff S On Documents.AuthorId=S.StaffId  and isnull(S.RecordDeleted,''N'')<>''Y''
join Staff ReqClinician On CT.RequestedClinician=ReqClinician.StaffId
join Clients C on Documents.ClientId= C.ClientId and isnull(C.RecordDeleted,''N'')<>''Y''
Left Join Staff SAssignedClinician On CT.AssignedClinician=SAssignedClinician.StaffId
Left Join Staff SAssignedAttending On CT.AssignedAttending=SAssignedAttending.StaffId
Left Join Staff SReqTeamCoordinator On CT.RequestingTeamCoordinator=SReqTeamCoordinator.StaffId
Left Join Staff SRecTeamCoordinator On CT.ReceivingTeamCoordinator=SRecTeamCoordinator.StaffId
Left Join Staff SDenialSentTo On CT.DenialSentTo=SDenialSentTo.StaffId
Left Join Staff SReqMadeBy On CT.RequestMadeBy=SReqMadeBy.StaffId
Left Join GlobalCodes GC On CT.GuardianRelationShip=GC.GlobalCodeId 
and ISNull(GC.RecordDeleted,''N'')<>''Y''
Left Join GlobalCodes GCServiceReq On CT.ServiceRequested=GCServiceReq.GlobalCodeId 
and ISNull(GCServiceReq.RecordDeleted,''N'')<>''Y''
Left Join GlobalCodes GCUrgency On CT.Urgency=GCUrgency.GlobalCodeId
and ISNull(GCUrgency.RecordDeleted,''N'')<>''Y''
Left join GlobalCodes GCDecisionRequest on CT.RequestingDecision = GCDecisionRequest.GlobalCodeId      
and ISNull(GCDecisionRequest.RecordDeleted,''N'')<>''Y''
Left join GlobalCodes GCReceivedDecision on CT.ReceivedDecision = GCReceivedDecision.GlobalCodeId      
and ISNull(GCReceivedDecision.RecordDeleted,''N'')<>''Y''
Left Join Programs Prog on CT.RequestedProgram=Prog.ProgramId  and isnull(Prog.RecordDeleted,''N'')<>''Y''
Left Join  Programs TProg on CT.TransferFromProgram=TProg.ProgramId  and isnull(TProg.RecordDeleted,''N'')<>''Y''   
Cross Join SystemConfigurations as SystemConfig    
--Where ISNull(CT.RecordDeleted,''N'')<>''Y'' and CT.Documentid=@DocumentId and CT.Version=@Version      
Where ISNull(CT.RecordDeleted,''N'')<>''Y'' and CT.DocumentVersionId=@DocumentVersionId       --Modified by Anuj Dated 03-May-2010    
  
 --Checking For Errors                                        
  If (@@error!=0)                                        
  Begin                                        
   RAISERROR  20006   ''csp_RDLCustomTransfer : An Error Occured''                                         
   Return                                        
   End                                                 
   
  
End
' 
END
GO
