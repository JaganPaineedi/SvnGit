/****** Object:  StoredProcedure [dbo].[csp_RDLCustomDischargeNew]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDischargeNew]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomDischargeNew]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDischargeNew]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'  
       
CREATE PROCEDURE   [dbo].[csp_RDLCustomDischargeNew]         
(          
--@DocumentId int,                       
--@Version int                      
@DocumentVersionId  int --Modified by Anuj Dated 03-May-2010             
)                      
AS                      
                
Begin                
/************************************************************************/                                                      
/* Stored Procedure: [csp_RDLCustomDischargeNew]       */                                             
/* Copyright: 2006 Streamline SmartCare         */                                                      
/* Creation Date:  May 11th ,2008          */                                                      
/*                  */                                                      
/* Purpose: Gets Data from CustomDischarge,SystemConfigurations,  */          
/*   Staff,Documents            */                                                     
/*                  */                                                    
/* Input Parameters: DocumentID,Version         */                                                    
/* Output Parameters:             */                                                      
/* Purpose: Use For Rdl Report           */                                            
/* Calls:                */                                                      
/* Author: Rupali Patil             */            
/* modifeid by avoss 9/10/2008 left join globalCodes rather than direct join, isnull for clinician name in case of no degree*/                                                    
/*Modified by Jitender Kumar Kamboj on 30 July 2010 Added and modified columns name  And Used function csf_GetGlobalCodeNameById() to get Global Codename */        
 /* modified by priya to remove the Column name related with LOF Tab from CustomDischarge Table*/       
/*********************************************************************/                        
    
        
        
SELECT SystemConfig.OrganizationName          
   ,C.LastName + '', '' + C.FirstName as ClientName          
   ,S.LastName + '', '' + S.FirstName + '' '' + isnull(GC.CodeName,'''') as ''ClinicianName''          
   ,Documents.ClientID          
   ,Documents.EffectiveDate                                      
   ,CD.[DocumentVersionId]                                
      ,[AdmissionDate]                                    
      ,[LastDateOfService]     
   --   ,case when CD.[DischargeType] = ''U''   --Commented by Jitender         
   -- then ''Unplanned''           
   --  when CD.[DischargeType] = ''P''          
   -- then ''Planned''          
   --end as [DischargeType]                                       
      ,dbo.csf_GetGlobalCodeNameById(CD.DischargeType) as DischargeType                                 
      ,[PresentingProblem]                                    
      ,[SummaryOfServices]                                    
      ,[ProgressStrengths]                                    
      ,[ProgressNeeds]                                    
      ,[ProgressParticipants]                                    
      ,[ProgressTreatmentGoalsMet]                                    
      ,[ProgressSummary]                                    
      ,dbo.csf_GetGlobalCodeNameById(CD.DischargeReason) as DischargeReason                                   
      ,[DischargeReasonAdditionalInfo]                                    
      ,[NaturalSupports]                                    
      ,[SymptomRecurrence]                                    
      ,[OngoingTreatmentNoCurrentRisks]                                    
      ,[OngoingTreatmentNoReferral]                                    
      ,[OngoingTreatment]                                    
      ,[ClientFeedbackUnableToObtain]                                    
      ,[ClientFeedback]                                    
      ,[ClientFeedbackAdditionalInfo]                                    
      ,[MedicationsOption]                                    
      ,[MedicationsAddToNeedsList]                             
      ,[MedicationsNeedToBeModified]                                    
      ,[MedicationsList]                        
      ,[MedicationsAdditionalInfo]                                    
      --,[LOFUnableToComplete]                                    
      --,dbo.csf_GetGlobalCodeNameById(CD.LOFUnableToCompleteReason) as LOFUnableToCompleteReason                               
      --,[LOFUnableToCompleteReasonOther]                                    
      --,[LOFUnableToCompleteAdditionalInfo]     
   --   ,case when CD.[ClientDeclined] = ''Y''    --Commented by Jitender      
   -- then ''Yes''          
   --  when CD.[ClientDeclined] = ''N''          
   -- then ''No''          
   --end as [ClientDeclined]    
  --   ,S1.LastName + '', '' + S1.FirstName as Staff1          
  --,S2.LastName + '', '' + S2.FirstName as Staff2            
  --,S3.LastName + '', '' + S3.FirstName as Staff3            
  --,S4.LastName + '', '' + S4.FirstName as Staff4                                     
      ,S1.LastName + '', '' + S1.FirstName as NotifyStaff1                                    
      ,S2.LastName + '', '' + S2.FirstName as NotifyStaff2                                    
      ,S3.LastName + '', '' + S3.FirstName as NotifyStaff3                                    
      ,S4.LastName + '', '' + S4.FirstName as NotifyStaff4                                    
      ,[NotificationMessage]                          
      ,[ClientRequestOther]                           
      --,LOFType          
              
              
      FROM Documents    
join DocumentVersions  on Documents.DocumentId = DocumentVersions.DocumentId  and isnull(DocumentVersions.RecordDeleted,''N'')<>''Y''   
         
join Staff S on Documents.AuthorId = S.StaffId          
join Clients C on Documents.ClientId= C.ClientId and isnull(C.RecordDeleted,''N'')<>''Y''            
--left join [CustomDischarges] as CD  ON  CD.DocumentId = Documents.DocumentId           
left join [CustomDischarges] as CD  ON   
CD.DocumentVersionId = DocumentVersions.DocumentVersionId  and isnull(DocumentVersions.RecordDeleted,''N'')<>''Y''             
   
--CD.DocumentVersionId = Documents.CurrentDocumentVersionId   --Modified by Anuj Dated 03-May-2010             
 --and isnull(cd.RecordDeleted,''N'')<>''Y''  and CD.Version = @Version             
--and isnull(cd.RecordDeleted,''N'')<>''Y'' and CD.DocumentVersionId = @DocumentVersionId --Modified by Anuj Dated 03-May-2010                
left join GlobalCodes GC on S.Degree = GC.GlobalCodeId          
--left join Staff S1 on CD.[NotifyStaffId1]= S1.StaffId   -- Modified by Jitender on 30 July 2010        
--left join Staff S2 on CD.[NotifyStaffId2]= S2.StaffId           
--left join Staff S3 on CD.[NotifyStaffId3]= S3.StaffId           
--left join Staff S4 on CD.[NotifyStaffId4]= S4.StaffId         
        
left join Staff S1 on CD.NotifyStaff1= S1.StaffId           
left join Staff S2 on CD.NotifyStaff2= S2.StaffId           
left join Staff S3 on CD.NotifyStaff3= S3.StaffId           
left join Staff S4 on CD.NotifyStaff4= S4.StaffId         
          
Cross Join SystemConfigurations as SystemConfig            
--where Documents.DocumentId = @DocumentId            
where DocumentVersions.DocumentVersionId  = @DocumentVersionId  --Modified by Anuj Dated 03-May-2010             
and isnull(Documents.RecordDeleted,''N'')=''N''          
              
--Checking For Errors                          
If (@@error!=0)                                                      
 Begin                                                      
  RAISERROR  20006   ''[csp_RDLCustomDischarge] : An Error Occured''                                                       
  Return                                                      
 End                                                               
End                
                
                ' 
END
GO
