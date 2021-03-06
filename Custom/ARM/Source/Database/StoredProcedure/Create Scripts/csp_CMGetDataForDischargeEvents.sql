/****** Object:  StoredProcedure [dbo].[csp_CMGetDataForDischargeEvents]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CMGetDataForDischargeEvents]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_CMGetDataForDischargeEvents]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CMGetDataForDischargeEvents]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_CMGetDataForDischargeEvents]                                 
(                                  
 -- @DocumentId int,                                                                        
  @DocumentVersionId int                                   
)                                  
                                  
As                                  
                                          
Begin                                          
/*********************************************************************/                                            
/* Stored Procedure: dbo.csp_SCGetDataForDischargeEvents                */                                   
                                  
/* Copyright: 2009 Streamlin Healthcare Solutions           */                                            
                                  
/* Creation Date:  30 jan 2010                                   */                                            
/*                                                                   */                                            
/* Purpose: Gets Data for Discharge Event Multi Tab Document      */                                           
/*                                                                   */                                          
/* Input Parameters: @DocumentVersionId*/                                          
/*                                                                   */                                             
/* Output Parameters:                                */                                            
/*                                                                   */                                            
/* Return:   */                                            
/* Modified by:  Date:    Description:    
   Jitender      15 April 2010      Changed column name(PreScreenEventId) and table names(DischargeEvents,DischargeServices),                                                  
         Get ClientId,DocumentId,AdmissionDateTime,NumberOfDaysInSetting   */  
/* 19 July 2010 Damanpreet Kaur         Changed because of new data model */          
/* Called By:  Method in Documents Class Of DataService  in "Always Online Application"    */                                            
                                  
                                         
                                        
  BEGIN TRY                                
                     
                     
DECLARE @later datetime                                                                        
SELECT @later=GETDATE()  
declare @ClientId int                                
DECLARE @varDocumentIdOut int   
DECLARE @varAdmissionDateOut datetime  
DECLARE @varNumberOfDaysInSettingOut int   
  
--To get ClientId  
select @ClientId = ClientId from Documents where         
 CurrentDocumentVersionId = @DocumentVersionId and IsNull(RecordDeleted,''N'')= ''N''   
                                   
 -- To get DocumentId,AdmissionDateTime,NumberOfDaysInSetting  
 EXEC [dbo].[csp_CMGetDocumentIdAdminDate]        
  @ClientID,        
  @varDocumentIdOut OUTPUT,   
  @varAdmissionDateOut OUTPUT,  
  @varNumberOfDaysInSettingOut OUTPUT   
  
  /* CustomDischargeEvents Table*/                                   
  SELECT           
            
            
  [DocumentVersionId]             
  --[PreScreenEventId]   Column name is changed as PreScreenDocumentId    
  ,PreScreenDocumentId                              
  ,[ContactLastName]                                
  ,[ContactFirstName]            
  ,[ContactDate]                             
  ,[DischargeTo]                                
  ,[DischargeComment]                                               
  ,C.RowIdentifier                                
  ,C.CreatedBy                                
  ,C.CreatedDate                                
  ,C.ModifiedBy                                
  ,C.ModifiedDate                                
  ,C.RecordDeleted                                
  ,C.DeletedDate                       
  ,C.DeletedBy  
  ,@varAdmissionDateOut as AdmissionDate  
  ,@varNumberOfDaysInSettingOut as NumberOfDaysInSetting                               
--      ,case when Cl.Sex =''F'' then ''Female'' when Cl.Sex=''M'' then ''Male''  else '''' end                                
                                                  
--as Sex, CONVERT(varchar(10), Cl.dob,101) as DOB ,Cast(DateDIFF(yy,Cl.DOB,@later)-CASE WHEN @later>=DateAdd(yy,DateDIFF(yy,Cl.DOB,@later), Cl.DOB) THEN 0 ELSE 1 END as varchar(10)) +'' Year'' AS Age,                 
--case when (select count(ClientId) from ClientRaces where ClientRaces.ClientId = Cl.ClientId  and IsNull(ClientRaces.RecordDeleted,''N'')=''N'') >1 then ''Multi-Racial'' else                                       
--ltrim(rtrim(GC.CodeName)) end as Race          
                
  FROM CustomDischargeEvents C  --Table name is changed from DischargeEvents                           
 -- ,Clients Cl           
 -- left join ClientRaces CR on CR.Clientid = Cl.ClientId and IsNull(CR.RecordDeleted,''N'')=''N''            
 -- left join GlobalCodes GC on GC.GlobalCodeID = CR.RaceId           
 --left join Documents D  on D.ClientId = Cl.ClientId                          
     WHERE ISNull (C.RecordDeleted,''N'')=''N'' and DocumentVersionId=@DocumentVersionId                       
                         
      SELECT                    
  [ServiceId] ,                      
    [DocumentVersionId] ,                          
      [Agency]                                
      ,[AppointmentDate]                                
      ,[WalkInAvailable]                              
      ,[ClinicianName]                                
      ,[Service]                      
      ,[Comment] ,                        
            [MedicationsWillLast]                    
      ,[RowIdentifier]                                
      ,[CreatedBy]                                
      ,[CreatedDate]                                
      ,[ModifiedBy]                                
      ,[ModifiedDate]                                
      ,[RecordDeleted]                                
      ,[DeletedDate]                       
      ,[DeletedBy]                             
                                     
  FROM CustomDischargeServices    --Table name is changed from DischargeServices                      
     WHERE ISNull(RecordDeleted,''N'')=''N'' and DocumentVersionId=@DocumentVersionId                      
                          
  /* EventsMedications Table*/                                   
  SELECT                            
  [MedicationId]                         
  [DocumentVersionId] ,                          
      [DrugId]                                
      ,[DrugName]                        
      ,[Dose]                              
      ,[Frequency]                                
      ,[Route]                           
        ,[Orderdate]                        
         ,[Enddate]                        
          ,[Status]                        
          ,[DrugComment]                        
      ,[RowIdentifier]                                
      ,[CreatedBy]                                
      ,[CreatedDate]                                
      ,[ModifiedBy]                                
      ,[ModifiedDate]                                
      ,[RecordDeleted]                                
      ,[DeletedDate]                                
      ,[DeletedBy]                             
                                     
  FROM [EventMedications]                          
                                
  WHERE ISNull(RecordDeleted,''N'')=''N'' AND DocumentVersionId=@DocumentVersionId                    
                  
  DECLARE       @ProviderAuthorizationDocumentId AS INT                    
                     
 SELECT  @ProviderAuthorizationDocumentId=ProviderAuthorizationDocumentId                    
  FROM         ProviderAuthorizationDocuments                      
 WHERE     (ISNULL(RecordDeleted, ''N'') = ''N'') AND (ProviderAuthorizationDocuments.AuthorizationDocumentId = @DocumentVersionId)                                      
                                      
  /* ProviderAuthorizationDocuments Table*/                                       
  SELECT [ProviderAuthorizationDocumentId]                    
      ,ProviderAuthorizationDocumentId               
      ,[DocumentName]                    
      ,[InsurerId]                    
      ,[ClientId]                    
      ,[RequestorProgram]                    
      ,[RequestorDocumentId]                    
      ,[RequestorName]                    
      ,[RequestorId]                    
      ,[RequestDate]                    
      ,[RequestorComment]                    
      ,[ReviewerComment]                    
      ,[AuthorizationDocumentId]                    
      ,[LastReviewedBy]         
      ,[LastReviewedOn]                    
      ,[RowIdentifier]                    
      ,[CreatedBy]                    
      ,[CreatedDate]                    
      ,[ModifiedBy]                    
      ,[ModifiedDate]                    
      ,[RecordDeleted]                    
      ,[DeletedDate]                    
      ,[DeletedBy]                             
                                         
  FROM         ProviderAuthorizationDocuments                      
 WHERE      ProviderAuthorizationDocumentId = @ProviderAuthorizationDocumentId                     
                         
     /*  ProviderAuthorizations*/                         
     SELECT [ProviderAuthorizationId]                    
      ,[ProviderAuthorizationDocumentId]                    
      ,[InsurerId]                    
      ,[ClientId]                    ,[ProviderId]                    
      ,[SiteId]                    
      ,[BillingCodeId]                    
      ,[Modifier1]                    
      ,[Modifier2]                    
      ,[Modifier3]                    
      ,[Modifier4]                    
      ,[AuthorizationNumber]                    
      ,[Active]                    
      ,[Status]                    
 ,[Reason]                    
      ,[Appealed]                    
      ,[StartDate]                    
      ,[EndDate]                    
      ,[StartDateRequested]                    
      ,[EndDateRequested]                    
      ,[RequestedBillingCodeId]                    
      ,[UnitsRequested]                    
      ,[FrequencyTypeRequested]                    
      ,[TotalUnitsRequested]                    
      ,[UnitsApproved]                    
      ,[FrequencyTypeApproved]                    
      ,[TotalUnitsApproved]                    
      ,[UnitsUsed]                    
      ,[Comment]             
      --,[AuthorizationId]                    
      ,[DeniedDate]                    
      ,[Modified]                    
      ,[RowIdentifier]                    
      ,[CreatedBy]                    
      ,[CreatedDate]                    
      ,[ModifiedBy]                    
      ,[ModifiedDate]                    
      ,[RecordDeleted]                    
      ,[DeletedDate]                    
      ,[DeletedBy]                    
  FROM         ProviderAuthorizations                    
WHERE     (ISNULL(RecordDeleted, ''N'') = ''N'') AND (ProviderAuthorizationDocumentId = @ProviderAuthorizationDocumentId)                                   
                                  
          SELECT                            
    D.DocumentVersionId                            
   ,D.DiagnosisId                            
   ,D.Axis                            
   ,D.DSMCode                            
   ,D.DSMNumber                            
   ,D.DiagnosisType                            
   ,D.RuleOut                            
   ,D.Billable                            
   ,D.Severity                            
   ,D.DSMVersion                            
   ,D.DiagnosisOrder                            
   ,D.Specifier         
   ,D.RowIdentifier                            
   ,D.CreatedBy                            
   ,D.CreatedDate                            
   ,D.ModifiedBy                            
   ,D.ModifiedDate                            
   ,D.RecordDeleted                            
   ,D.DeletedDate                            
   ,D.DeletedBy                            
   ,DSM.DSMDescription                            
   FROM DiagnosesIAndII  D                            
   inner join DiagnosisDSMDescriptions DSM on  DSM.DSMCode = D.DSMCode                            
   and DSM.DSMNumber = D.DSMNumber                          
   WHERE                           
   DocumentVersionId=@DocumentVersionId   AND ISNULL(RecordDeleted,''N'')=''N''                              
                          
  ---DiagnosesIII                            
   SELECT                             
   [DocumentVersionId]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[ModifiedBy]
      ,[ModifiedDate]
      ,[RecordDeleted]
      ,[DeletedBy]
      ,[DeletedDate]
      ,[Specification]   
   FROM DiagnosesIII                            
   WHERE            
   DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,''N'')=''N''                            
                            
   --DiagnosesIV                            
   SELECT                            
   DocumentVersionId                            
   ,PrimarySupport                            
   ,SocialEnvironment                            
   ,Educational                            
   ,Occupational                            
   ,Housing                           
   ,Economic            
   ,HealthcareServices                            
   ,Legal                            
   ,Other                            
   ,Specification                            
   ,CreatedBy                            
   ,CreatedDate                            
   ,ModifiedBy                            
   ,ModifiedDate                            
   ,RecordDeleted                            
   ,DeletedDate                            
   ,DeletedBy                            
   FROM DiagnosesIV                            
   WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,''N'')=''N''                   
             --DiagnosesV                            
   SELECT                            
   DocumentVersionId                            
   ,AxisV                            
   ,CreatedBy                            
   ,CreatedDate                            
   ,ModifiedBy                            
   ,ModifiedDate                            
   ,RecordDeleted                            
   ,DeletedDate                            
   ,DeletedBy                            
   FROM DiagnosesV                            
   WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,''N'')=''N''                            
                                   
   SELECT
      [DiagnosesIIICodeId]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[ModifiedBy]
      ,[ModifiedDate]
      ,[RecordDeleted]
      ,[DeletedDate]
      ,[DeletedBy]
      ,[DocumentVersionId]
      ,[ICDCode]
      ,[Billable]                                     
   FROM DiagnosesIIICodes
   WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,''N'')=''N''        
                          
                           
  END TRY                                
                                  
  BEGIN CATCH                                                      
  DECLARE @Error varchar(8000)                
  set @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                        
  + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''[csp_CMGetDataForDischargeEvents]'')                                                                                         
  + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****ERROR_SEVERITY='' + Convert(varchar,ERROR_SEVERITY())                                                                                        
  + ''*****ERROR_STATE='' + Convert(varchar,ERROR_STATE())                                                                                        
  RAISERROR                                           
  (                                                   
  @Error, -- Message text.                                                                                         
  16, -- Severity.                                                                                         
  1 -- State.                                                                                         
  )                                                      
 END CATCH                       
End
' 
END
GO
