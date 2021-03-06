/****** Object:  StoredProcedure [dbo].[ssp_GetAppealDetailInformation]    Script Date: 11/18/2011 16:25:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetAppealDetailInformation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetAppealDetailInformation]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetAppealDetailInformation]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'                              
CREATE procedure [dbo].[ssp_GetAppealDetailInformation]                            
(                                                    
@AppealId int                                           
)                                                    
As                                                    
/******************************************************************************                                                                    
**  File:                                                                     
**  Name: [ssp_GetAppealDetailInformation]                                                                    
**  Desc: This storeProcedure will return information regarding appealsDetail                                                                  
**                                                                                  
**  Parameters:                                                                    
**  Input  AppealId                                                  
                                                                      
**  Output     ----------       -----------                                                                    
**  DocumentId                                                                  
    Version                                                      
                                                                  
**  Auth:  Vikas Vyas                                                                
**  Date:  21 April 2010                                                                  
*******************************************************************************                                                                    
**  Change History                                                                    
*******************************************************************************                                                                    
**  Date:   Author:      Description:                                                                    
**  Dec 14,2010    Jitender Kumar Kamboj    Added ''AppealAuthorizations'' table                                                                      
**  June 2,2014    Smitha Sebastian         Added Case when for TotalUnitsRequested w.r.t. Core Bugs 1492                                    
**  Sep 25,2014    Prasan                   Added COALESCE statement which would consider (approved) TotalUnits  first & if that is null	
                                            then (requested) TotalUnitsRequested  is considered                                                         
 /*  21 Oct 2015	Revathi					what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.  */ 
/* 											why:task #609, Network180 Customization  */ 
/*	April 28,2016   Ajay                    Added columns into Authorization(ReviewerId,ReviewerOther,ReviewedOn,Rationale,UnitType,ChargeOrPayment,ClinicianId,UnitTypeRequested,ChargeOrPaymentRequested,ClinicianIdRequested,InterventionEndDate) why: MFS-Customization issue tracking: Task#197    */		                                                  
/*  3/17/2017       MD Hussain K			Added 5 missing columns (CoveragePlanId, ClientDisclosureId, ProviderAuthorizationDocumentId, BatchId, PaymentId) in ImageRecords table result set w.r.t Valley - Support Go Live #1127 */
*******************************************************************************/                                                      
Begin                                                    
 Begin Try         
       
 declare @ClientId int              
 select @ClientId = ClientId from Appeals where  AppealId=@AppealId and ISNULL(Appeals.RecordDeleted,''N'')<>''Y''                                                    
      
   --Appeal InforMation--                                             
   SELECT [AppealId]                                            
      ,Appeals.[ClientId]                                            
      ,[MedicaidId]                                            
      ,[ComplainantRelationToClient]                                            
      ,[ComplainantName]                                            
      ,[ComplainantAddress]                                            
      ,[DateReceived]                                            
      ,[ExpeditedAppeal]                                            
      ,[RequestReceivedInWriting]                                            
      ,[ActionBeingAppealed]                                            
      ,[ReceivedVia]                                            
      ,[AppealType]                                            
      ,[ReasonForOriginalAction]                                            
      ,[TypeOfInpatientAppeal]                                            
      ,[AppealDescription]                                            
      ,[StaffInvolved]                    
      ,[DateAcknowledgedInWriting]                                            
      ,[AdditionalInformation]                                            
      ,[ClientInformedOfStateFairHearing]                         
       ,StateFairHearingStatus                                    
      ,[ClientChoseStateFairHearing]                                            
      ,[AppealReceivedInTimePeriod]                                         
      ,[BenefitsContinuedDuringAppeal]                                            
      ,[DateResolved]                                            
      ,[DateOfResolutionNotification]                                            
      ,[Resolution]                                            
      ,[ResolutionComment]                                            
      ,[AppealStatus]                                            
      ,[StaffInvolvedInAppealDecision]                                            
      ,[StateFairHearingScheduleDate]                                                                         
      ,Appeals.[CreatedBy]                                            
      ,Appeals.[CreatedDate]                                            
      ,Appeals.[ModifiedBy]                                   
      ,Appeals.[ModifiedDate]                                            
      ,Appeals.[RecordDeleted]                                            
      ,Appeals.[DeletedDate]                                            
      ,Appeals.[DeletedBy]                                            
       ,-1 as ''OrganizationId''                                    
      ,'''' as ''OrganizationName''   
      --Added by Revathi 21 Oct 2015
      ,CASE WHEN ISNULL(Clients.ClientType,''I'')=''I'' THEN   ISNULL(Clients.LastName,'''') + '', '' + ISNULL(Clients.FirstName,'''') ELSE ISNULL(Clients.OrganizationName,'''') END as ClientName                                         
     -- ,Clients.LastName + '', '' + Clients.FirstName as ClientName                              
       , -1 as ''AcknowledgementLetterTemplateId''                                        
      , '''' as ''AcknowledgementLetterTemplateName''                                        
      , -1 as ''AppealAcknowledgementLetterId''                                         
      , -1 as ''ResolutionLetterTemplateId''                                        
      , '''' as ''ResolutionLetterTemplateName''                                        
      , -1 as ''AppealResolutionLetterId''                                         
      ,'''' as  ''AppealCreatedBy''                                          
      ,'''' as ''AppealCreatedDate''                                     
      ,'''' as ''AppealModifiedBy''                                          
      ,'''' as ''AppealModifiedDate''                                         
      ,'''' as ''ResultStatus''                                      
      --,'''' as ''AppealLetterSentOn''                                     
                                                  
  FROM [Appeals] left Join Clients                                            
  ON Appeals.ClientId=Clients.ClientId                                            
  WHERE Appeals.AppealId=@AppealId                                            
  AND ISNULL(Appeals.RecordDeleted,''N'')<>''Y''                                             
  AND ISNULL(Clients.RecordDeleted,''N'')<>''Y''                                            
   --End Appeal InforMation--                                             
                                                   
                                                    
   --AppealLetters--                                                  
   SELECT [AppealLetterId]                                            
      ,[AppealId]                                            
      ,AL.[LetterTemplateId]                                            
      ,AL.[SentOn]                                            
      ,AL.[Acknowledgement]                                            
      ,AL.[Resolution]                                            
      ,AL.[LetterText]                                            
      ,AL.[RowIdentifier]                                            
      ,AL.[CreatedBy]                                            
      ,AL.[CreatedDate]                                            
      ,AL.[ModifiedBy]                                            
      ,AL.[ModifiedDate]                                         
      ,AL.[RecordDeleted]                                                  
      ,AL.[DeletedDate]                                            
      ,AL.[DeletedBy]                   
      ,LT.[TemplateName]                                          
  FROM [AppealLetters] AL join LetterTemplates LT on AL.LetterTemplateId = LT.LetterTemplateId                                           
  where AppealId=@AppealId and ISNULL(AL.RecordDeleted,''N'')<>''Y''                                                  
   --End AppealLetters                                     
    --Messages                                    
  SELECT [MessageId]                                    
      ,[FromStaffId]                                    
      ,[FromSystemDatabaseId]                                    
      ,[FromSystemStaffId]                                    
      ,[FromSystemStaffName]              
      ,[ToStaffId]                                    
      ,[ToSystemDatabaseId]                                    
      ,[ToSystemStaffId]                                    
      ,[ToSystemStaffName]                                    
      ,[ClientId]                                    
      ,[Unread]                                    
      ,[DateReceived]                                    
      ,[Subject]                                    
      ,[Message]                                    
      ,[Priority]                                    
      ,[ReferenceSystemDatabaseId]                                    
      ,[ReferenceType]                                    
      ,[ReferenceId]                                    
      ,[Reference]                                    
      ,[ReferenceLink]                                    
      ,[DocumentId]                                    
      ,[TabId]                                    
      ,[DeletedBySender]                                    
      ,[OtherRecipients]                                    
      ,[SenderCopy]                                    
     ,[ReceiverCopy]                                    
      --,[RowIdentifier]                                    
      ,[CreatedBy]                                    
      ,[CreatedDate]                                    
      ,[ModifiedBy]                                    
      ,[ModifiedDate]                                    
      ,[RecordDeleted]                                    
   ,[DeletedDate]                                    
      ,[DeletedBy] 
                                      
  FROM [dbo].[Messages] where Reference =''Appeals'' and ReferenceId=@AppealId and SenderCopy=''Y'' and ISNULL(RecordDeleted,''N'')<>''Y''                                     
 --Messages                                    
 --END                                    
                                     
--MessageRecepients                                    
SELECT [MessageRecepientId]                                    
      ,MR.[MessageId]                                    
      ,[StaffId]                                    
      ,[SystemDatabaseId]                                    
      ,[SystemStaffId]                                    
      ,[SystemStaffName]                                    
      ,MR.[RowIdentifier]                                    
      ,MR.[CreatedBy]                                    
      ,MR.[CreatedDate]                                    
      ,MR.[ModifiedBy]                                    
      ,MR.[ModifiedDate]                                    
      ,MR.[RecordDeleted]                                    
      ,MR.[DeletedDate]                                    
      ,MR.[DeletedBy]                                    
  FROM [dbo].[MessageRecepients] MR join [Messages] MS  on MR.MessageId = MS.MessageId where MS.ReferenceId = @AppealId AND ISNULL(MR.RecordDeleted,''N'')<>''Y''                                                
                              
----ImageRecords----                              
  SELECT [ImageRecordId]                              
      ,[ScannedOrUploaded]                              
 ,[DocumentVersionId]                              
      ,[ImageServerId]                              
      ,[ClientId]                              
      ,[AssociatedId]                              
      ,[AssociatedWith]                              
      ,[RecordDescription]                              
      ,[EffectiveDate]             
      ,[NumberOfItems]                              
      ,[AssociatedWithDocumentId]                              
      ,[AppealId]                              
      ,[StaffId]                              
      ,[EventId]                              
      ,[ProviderId]                           
      ,[TaskId]                              
      ,[ScannedBy]                        
      ,[AuthorizationDocumentId]                              
      --,imgRec.[RowIdentifier]                              
      ,imgRec.[CreatedBy]                              
      ,imgRec.[CreatedDate]                              
      ,imgRec.[ModifiedBy]                              
      ,imgRec.[ModifiedDate]                              
      ,imgRec.[RecordDeleted]                              
      ,imgRec.[DeletedDate]                              
      ,imgRec.[DeletedBy]                              
      ,GlobalCodes.CodeName as AssociatedWithName
      ----Added by MD on 3/17/2017----------
	  ,imgRec.CoveragePlanId
	  ,imgRec.ClientDisclosureId
	  ,imgRec.ProviderAuthorizationDocumentId
	  ,imgRec.BatchId
	  ,imgRec.PaymentId
      --------------------------------------                              
  FROM ImageRecords imgRec                              
  inner join GlobalCodes                              
  on imgRec.AssociatedWith=GlobalCodes.GlobalCodeId                              
  where AppealId=@AppealId and AssociatedWith=5817                   
  and GlobalCodes.Active=''Y''                              
  and ISNULL(imgRec.RecordDeleted,''N'')<>''Y''                                
  and ISNULL(GlobalCodes.RecordDeleted,''N'')<>''Y''                               
                                    
                                
  --AppealAuthorizations  
  /* Regular/Internal Auths */                            
  SELECT [AppealAthorizationId]                              
      ,AA.[CreatedBy]                              
      ,AA.[CreatedDate]                              
      ,AA.[ModifiedBy]                              
      ,AA.[ModifiedDate]                              
      ,AA.[RecordDeleted]                              
      ,AA.[DeletedBy]                              
      ,AA.[DeletedDate]                              
      ,[AppealId]                              
      ,AA.[AuthorizationId]
	  ,AA.[ProviderAuthorizationId]                              
      --,AuthorizationCodes.DisplayAs + '' '' + cast(CEILING(Authorizations.TotalUnitsRequested) as varchar) + '' '' + ''Units'' + '' '' + Convert(varchar(10),Authorizations.StartDateRequested,101) + '' '' + Convert(varchar(10),Authorizations.EndDateRequested,101)
                  
--as DisplayAppealAuthorizations    
      ,''A '' + AuthorizationCodes.DisplayAs + '' '' + CAST(CEILING(COALESCE(Authorizations.TotalUnits,Authorizations.TotalUnitsRequested)) as varchar) + '' '' + ''Units'' + '' '' +                         
     
      Case when isnull(Authorizations.StartDateRequested,'''')='''' then '''' else Convert(varchar(10),isnull(Authorizations.StartDateRequested,''''),101) end + '' '' +                       
      Case when isnull(Authorizations.EndDateRequested,'''')='''' then '''' else Convert(varchar(10),isnull(Authorizations.EndDateRequested,''''),101) end as DisplayAppealAuthorizations                           
  FROM  ClientCoveragePlans                                                    
 INNER JOIN AuthorizationDocuments on AuthorizationDocuments.ClientCoveragePlanId = ClientCoveragePlans.ClientCoveragePlanId  AND  IsNull(AuthorizationDocuments.RecordDeleted,''N'')=''N'' AND  IsNull(ClientCoveragePlans.RecordDeleted,''N'')=''N''                 
  
 INNER JOIN Authorizations ON Authorizations.AuthorizationDocumentId = AuthorizationDocuments.AuthorizationDocumentId                           
 INNER JOIN AppealAuthorizations AA ON Authorizations.AuthorizationId = AA.AuthorizationId                          
 INNER JOIN Clients ON ClientCoveragePlans.ClientId = Clients.ClientId AND  IsNull(Clients.RecordDeleted,''N'')=''N''                                          
 INNER JOIN AuthorizationCodes ON Authorizations.AuthorizationCodeId = AuthorizationCodes.AuthorizationCodeId  AND  IsNull(AuthorizationCodes.RecordDeleted,''N'')=''N''                                                    
 INNER JOIN CoveragePlans ON ClientCoveragePlans.CoveragePlanId = CoveragePlans.CoveragePlanId  AND  IsNull(CoveragePlans.RecordDeleted,''N'')=''N''              
                               
  WHERE AppealId=@AppealId                          
  AND IsNull(Authorizations.RecordDeleted,''N'')=''N''                              
  AND ISNULL(AA.RecordDeleted,''N'')<>''Y''                                       
  --END                                       
  /* CM/External Auths */
  UNION
  SELECT AA.[AppealAthorizationId]
    ,AA.[CreatedBy]
    ,AA.[CreatedDate]
    ,AA.[ModifiedBy]
    ,AA.[ModifiedDate]
    ,AA.[RecordDeleted]
    ,AA.[DeletedBy]
    ,AA.[DeletedDate]
    ,AA.[AppealId]
    ,AA.[AuthorizationId]
    ,AA.[ProviderAuthorizationId]
    ,''CM '' + BC.BillingCode + '' '' + CAST(PA.TotalUnitsRequested AS VARCHAR) + '' Units '' 
        + CASE
            WHEN ISNULL(PA.StartDateRequested, '''') = ''''
                THEN ''''
            ELSE CONVERT (VARCHAR(10), PA.StartDAteRequested, 101)
        END + '' ''
        + CASE 
            WHEN ISNULL(PA.EndDateRequested, '''') = ''''
                THEN ''''
            ELSE CONVERT(VARCHAR(10), PA.EndDateRequested, 101)
        END AS DisplayAppelaAuthorizations
  FROM AppealAuthorizations AA
    INNER JOIN ProviderAuthorizations PA ON PA.ProviderAuthorizationId = AA.ProviderAuthorizationId
    LEFT JOIN BillingCodes BC ON BC.BillingCodeId = PA.BillingCodeId
  WHERE AA.AppealId = @AppealId
    AND ISNULL(AA.RecordDeleted, ''N'')<>''Y''
    AND ISNULL(PA.RecordDeleted, ''N'')<>''Y''
  
  
                 
--Authorizations                 
SELECT DISTINCT a.AuthorizationId                          
     ,a.AuthorizationDocumentId              
     ,a.[AuthorizationNumber]              
     ,a.[AuthorizationCodeId]              
     ,a.[Status]              
     ,a.[TPProcedureId]              
     ,a.[Units]              
     ,a.[Frequency]              
     ,a.[StartDate]              
     ,a.[EndDate]              
     ,a.[TotalUnits]              
     ,a.[UnitsRequested]              
     ,a.[FrequencyRequested]              
     ,a.[StartDateRequested]              
     ,a.[EndDateRequested]              
     ,a.[TotalUnitsRequested]              
     ,a.[ProviderId]              
     ,a.[SiteId]              
     ,a.[DateRequested]              
     ,a.[DateReceived]              
     ,a.[UnitsUsed]              
     ,a.[StartDateUsed]              
     ,a.[EndDateUsed]              
     ,a.[UnitsScheduled]              
     ,a.[ProviderAuthorizationId]              
     ,a.[Urgent]              
     ,a.[ReviewLevel]                                      
     --,a.[RowIdentifier]                                    
     ,a.[CreatedBy]                                    
     ,a.[CreatedDate]                                    
     ,a.[ModifiedBy]                                    
     ,a.[ModifiedDate]                                    
     ,a.[RecordDeleted]                  
     ,a.[DeletedDate]                                    
     ,a.[DeletedBy]  
     ,a.ReviewerId       --Added by Ajay on 28-April-2016 
	 ,a.ReviewerOther      
	 ,a.ReviewedOn  
	 ,a.Rationale  
	 ,a.UnitType  
	 ,a.ChargeOrPayment  
	 ,a.ClinicianId  
	 ,a.UnitTypeRequested  
	 ,a.ChargeOrPaymentRequested  
	 ,a.ClinicianIdRequested  
	 ,a.InterventionEndDate   -- Ends here              
     ,dbo.GetPreviousAuthorizationStatus(a.AuthorizationId) as PreviousStatus                                               
                                            
FROM Agency as Ag, ClientCoveragePlans                                                              
INNER JOIN AuthorizationDocuments on AuthorizationDocuments.ClientCoveragePlanId = ClientCoveragePlans.ClientCoveragePlanId  And  IsNull(AuthorizationDocuments.RecordDeleted,''N'')  =''N''And  IsNull(ClientCoveragePlans.RecordDeleted,''N'')  =''N''               
           
INNER JOIN Authorizations a ON a.AuthorizationDocumentId = AuthorizationDocuments.AuthorizationDocumentId INNER JOIN Clients ON ClientCoveragePlans.ClientId = Clients.ClientId And  IsNull(Clients.RecordDeleted,''N'')  =''N''                        
INNER JOIN AuthorizationCodes ON a.AuthorizationCodeId = AuthorizationCodes.AuthorizationCodeId  And  IsNull(AuthorizationCodes.RecordDeleted,''N'')  =''N''                                                              
INNER JOIN CoveragePlans ON ClientCoveragePlans.CoveragePlanId = CoveragePlans.CoveragePlanId  And  IsNull(CoveragePlans.RecordDeleted,''N'')  =''N''                                                              
                         
WHERE                                                               
IsNull(a.RecordDeleted,''N'')  =''N''                                                       
  and Clients.ClientId=@ClientId                                     
  and a.Status Not in(4243,6045)                                            
  and a.AuthorizationId not in (select AuthorizationId from AppealAuthorizations where IsNull(RecordDeleted,''N'')=''N'' and AppealId <> @Appealid)                                             
  --and Authorizations.EndDate > GETDATE()   commented for temp purpose               
      
--[AuthorizationHistory]              
/*SELECT [AuthorizationHistoryId]              
      ,[CreatedBy]              
      ,[CreatedDate]              
      ,[ModifiedBy]              
      ,[ModifiedDate]              
      ,[RecordDeleted]              
      ,[DeletedBy]              
      ,[DeletedDate]              
      ,[AuthorizationId]              
      ,[AuthorizationNumber]              
      ,[Status]              
      ,[Units]              
      ,[Frequency]              
      ,[StartDate]              
      ,[EndDate]              
      ,[TotalUnits]              
    ,[UnitsRequested]              
      ,[FrequencyRequested]              
      ,[StartDateRequested]              
      ,[EndDateRequested]              
      ,[TotalUnitsRequested]              
      ,[ProviderAuthorizationId]              
      ,[Urgent]              
      ,[ReviewLevel]          
      ,Case when [Status]=6045 then (select top 1 [Status] from AuthorizationHistory where AuthorizationHistoryId IN           
      (select top 2 AuthorizationHistoryId from AuthorizationHistory order by AuthorizationHistoryId desc) order by AuthorizationHistoryId asc)           
      else [Status]  End as PreviousStatus           
                    
  FROM [AuthorizationHistory]              
  WHERE AuthorizationId in(SELECT DISTINCT a.AuthorizationId FROM Agency as Ag, ClientCoveragePlans                                                              
INNER JOIN AuthorizationDocuments on AuthorizationDocuments.ClientCoveragePlanId = ClientCoveragePlans.ClientCoveragePlanId  And  IsNull(AuthorizationDocuments.RecordDeleted,''N'')  =''N''And  IsNull(ClientCoveragePlans.RecordDeleted,''N'')  =''N''               
  
    
     
         
          
           
INNER JOIN Authorizations a ON a.AuthorizationDocumentId = AuthorizationDocuments.AuthorizationDocumentId and a.Status <> 4243  and IsNull(a.RecordDeleted,''N'')=''N''                 
INNER JOIN Clients ON ClientCoveragePlans.ClientId = Clients.ClientId And Clients.ClientId=@ClientId and IsNull(Clients.RecordDeleted,''N'')  =''N''                        
INNER JOIN AuthorizationCodes ON a.AuthorizationCodeId = AuthorizationCodes.AuthorizationCodeId  And  IsNull(AuthorizationCodes.RecordDeleted,''N'')  =''N''                                                              
INNER JOIN CoveragePlans ON ClientCoveragePlans.CoveragePlanId = CoveragePlans.CoveragePlanId  And  IsNull(CoveragePlans.RecordDeleted,''N'')  =''N'')               
and IsNull(AuthorizationHistory.RecordDeleted,''N'')=''N''            
order by [AuthorizationHistoryId] desc  */            
            
            
SELECT PA.ProviderAuthorizationId
     ,PA.CreatedBy
     ,PA.CreatedDate
     ,PA.ModifiedBy
     ,PA.ModifiedDate
     ,PA.RecordDeleted
     ,PA.DeletedDate
     ,PA.DeletedBy
     ,PA.ProviderAuthorizationDocumentId
     ,PA.InsurerId
     ,PA.ClientId
     ,PA.ProviderId
     ,PA.SiteId
     ,PA.BillingCodeId
     ,PA.RequestedBillingCodeId
     ,PA.AuthorizationProviderBillingCodeId
     ,PA.Modifier1
     ,PA.Modifier2
     ,PA.Modifier3
     ,PA.Modifier4
     ,PA.AuthorizationNumber
     ,PA.Active
     ,PA.Status
     ,PA.Reason
     ,PA.StartDate
     ,PA.EndDate
     ,PA.StartDateRequested
     ,PA.EndDateRequested
     ,PA.UnitsRequested
     ,PA.FrequencyTypeRequested
     ,PA.TotalUnitsRequested
     ,PA.UnitsApproved
     ,PA.FrequencyTypeApproved
     ,PA.TotalUnitsApproved
     ,PA.UnitsUsed
     ,PA.Comment
     ,PA.DeniedDate
     ,PA.Modified
     ,PA.Urgent
     ,PA.ReviewLevel
     ,PA.BillingCodeModifierId
     ,PA.RequestedBillingCodeModifierId
     ,PA.InterventionEndDate
     ,PA.ReasonForChange
FROM ProviderAuthorizations PA
WHERE ISNULL(PA.RecordDeleted, ''N'') = ''N''
    AND PA.ClientId = @ClientId
    AND PA.Status NOT IN (2045, 2052) 
    AND PA.ProviderAuthorizationId NOT IN (SELECT ProviderAuthorizationId FROM AppealAuthorizations WHERE ISNULL(RecordDeleted, ''N'') = ''N'' and AppealId <> @AppealId)            
              
                                               
                                                     
End Try                                       
                         
  Begin Catch                                                    
  declare @Error varchar(8000)                                                                  
  set @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                   
  + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''ssp_GetAppealDetailInformation'')                                                                   
  + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                                                  
  + ''*****'' + Convert(varchar,ERROR_STATE())                                                    
                                                      
 End Catch                                                    
End ' 
END
GO
