/****** Object:  StoredProcedure [dbo].[csp_CMGetDataForConcurrentReviews]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CMGetDataForConcurrentReviews]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_CMGetDataForConcurrentReviews]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CMGetDataForConcurrentReviews]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
--sp_helptext csp_CMGetDataForConcurrentReviews                                      
                                      
                                                                              
-- =============================================                                                                                
-- Author:  <Mohit Madaan>                                                                                
-- Create date: <23 March,2010>                                                                                
-- Description: <Multi tab document >                                                                                
-- =============================================                                                                                
CREATE PROCEDURE  [dbo].[csp_CMGetDataForConcurrentReviews] --71227                                                                                                      
(                                                                                                                        
  @DocumentVersionId int                                                                                                                     
)                                                                                                                        
As                                                                                                                     
BEGIN                                                                                                      
   BEGIN TRY                                                                                                          
  DECLARE @ClientID int                                
  --commented by shifali in order to use EventDateTime in Event Architecture on 1st sep,2010                    
  Declare @effectiveDate datetime                          
  Declare @eventDateTime datetime                                                  
  set @ClientID =(select ClientId from documents where CurrentDocumentVersionId= @DocumentVersionId )                     --CustomConcurrentReviews                                                                            
                                                                              
SELECT DocumentVersionId                                                              
      ,CurrentTreatingPsychiatristId                                                              
      ,CurrentTreatingPsychiatrist                                                              
      ,AdmissionDateTime                                                              
      ,AdmissionStatus                                                              
      ,NumberOfDaysInSetting                          
      ,ClinicalUpdate                                                              
      ,PreviousEvents                                                              
      ,CurrentAfterCarePlan                                                              
      ,EstimatedLengthOfStayDays                                                              
      ,PreviousAfterCarePlans                                                              
      ,DispositionComment                                                              
      ,AuthorizedContinuedHospitalization                                                              
      ,ProviderNotifiedOfAppealOptions                                                              
      ,RowIdentifier                                                              
      ,CreatedBy                                                              
      ,CreatedDate                                                              
      ,ModifiedBy                                                              
      ,ModifiedDate                                                              
      ,RecordDeleted              
      ,DeletedDate            
      ,DeletedBy ,                                                        
 AdmissionDateTime as FormatAdmissionDate,                             
  AdmissionDateTime as FormatAdmissionTime                                       
       ,(SELECT top 1 case when (select count(ClientId) from ClientRaces where ClientRaces.ClientId = @ClientID and                             
        IsNull(ClientRaces.RecordDeleted,''N'')=''N'') >1 then ''Multi-Racial'' else                                                                
        GlobalCodes.CodeName end as ''Race''                                                              
       FROM  Clients left outer join ClientRaces on Clients.ClientId=ClientRaces.ClientId and IsNull(ClientRaces.RecordDeleted,''N'')=''N''                                                                
       LEFT OUTER JOIN GlobalCodes ON ClientRaces.RaceId = GlobalCodes.GlobalCodeId Where                                                                 
       ISNULL(dbo.Clients.RecordDeleted, ''N'') = ''N'' And ISNULL(dbo.GlobalCodes.RecordDeleted, ''N'') = ''N'' And Clients.ClientId =@ClientID) As ''Race''                                                  
     , (select convert(int, DateDiff("d",dob,getdate())/365) as dob from Clients where ClientId=@ClientID) As ''Age''                                     ,  (SELECT   ( Case When Sex=''M'' then ''Male'' When Sex = ''F'' then ''Female'' End) as ''sex''               
  
     
     
        
           
           
               
                
                  
                   
                      
                        
                          
                             
                              
                                           
       FROM Clients  where  ClientId =@ClientID) AS ''Sex''                                        
  FROM CustomConcurrentReviews                                                                    
  WHERE  (ISNULL(RecordDeleted, ''N'') = ''N'') AND (DocumentVersionId = @DocumentVersionId)                                                             
                                                              
  --CustomMedications                                                             
  SELECT [MedicationId]                                                        
      ,[DocumentVersionId]                                                        
      ,[DrugId]                                                        
     ,[DrugName]                                                        
      ,[Dose]                                                        
      ,[Frequency]                                                        
      ,[Route]                                                    
      ,[OrderDate]                                                        
      ,[EndDate]                                                        
      ,[Status]                                                        
      ,[Comment]                                                     
      ,[Prescriber]                                                        
      ,[Strength]                                                        
      ,[ServiceId]                                                        
      ,[RowIdentifier]                                                        
      ,[CreatedBy]                                                        
      ,[CreatedDate]                                                 
      ,[ModifiedBy]                                                        
      ,[ModifiedDate]                                                        
      ,[RecordDeleted]                                                        
      ,[DeletedDate]                                                        
      ,[DeletedBy]              
      ,(Select Codename From GlobalCodes Where GlobalCodeId = Frequency) as FrequencyName              
      ,(Select Codename From GlobalCodes Where GlobalCodeId = [Route]) as RouteName              
      ,(Select Codename From GlobalCodes Where GlobalCodeId = [Status]) as StatusName              
  FROM CustomMedications where (ISNULL(RecordDeleted, ''N'') = ''N'') AND (DocumentVersionId = @DocumentVersionId)                                                       
                                
                                
                                
--DiagnosesIAndII                          
 SELECT     D.DocumentVersionId, D.DiagnosisId, D.Axis, D.DSMCode, D.DSMNumber, D.DiagnosisType, D.RuleOut , D.Billable, D.Severity, D.DSMVersion, D.DiagnosisOrder,                         
       D.Specifier,D.Remission,D.[Source], D.RowIdentifier, D.CreatedBy, D.CreatedDate, D.ModifiedBy, D.ModifiedDate, D.RecordDeleted, D.DeletedDate, D.DeletedBy, DSM.DSMDescription               
       , case D.RuleOut when ''Y'' then ''R/O'' else '''' end as RuleOutText                      
 FROM         DiagnosesIAndII AS D INNER JOIN                        
       DiagnosisDSMDescriptions AS DSM ON DSM.DSMCode = D.DSMCode AND DSM.DSMNumber = D.DSMNumber                        
 WHERE     (D.DocumentVersionId = @DocumentVersionId) AND (ISNULL(D.RecordDeleted, ''N'') = ''N'')                          
                          
  ---DiagnosesIII                          
 SELECT     DocumentVersionId, Specification, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedDate, DeletedBy                        
 FROM         DiagnosesIII                        
 WHERE     (DocumentVersionId = @DocumentVersionId) AND (ISNULL(RecordDeleted, ''N'') = ''N'')                         
                          
   --DiagnosesIV                          
 SELECT     DocumentVersionId, PrimarySupport, SocialEnvironment, Educational, Occupational, Housing, Economic, HealthcareServices, Legal, Other, Specification, CreatedBy,                         
       CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedDate, DeletedBy                        
 FROM         DiagnosesIV                        
 WHERE     (DocumentVersionId = @DocumentVersionId) AND (ISNULL(RecordDeleted, ''N'') = ''N'')                        
                          
   --DiagnosesV                          
 SELECT     DocumentVersionId, AxisV, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedDate, DeletedBy                        
 FROM         DiagnosesV                        
 WHERE     (DocumentVersionId = @DocumentVersionId) AND (ISNULL(RecordDeleted, ''N'') = ''N'')                         
                       
  --DiagnosesIIICodes                  
    SELECT     DIIICod.DiagnosesIIICodeId, DIIICod.DocumentVersionId,DIIICod.ICDCode,DICD.ICDDescription,DIIICod.Billable,DIIICod.CreatedBy,DIIICod.CreatedDate,DIIICod.ModifiedBy,DIIICod.ModifiedDate,DIIICod.RecordDeleted,DIIICod.DeletedDate,             
 
    DIIICod.DeletedBy                        
 FROM         DiagnosesIIICodes as DIIICod inner join DiagnosisICDCodes as DICD on DIIICod.ICDCode=DICD.ICDCode                      
 WHERE     (DIIICod.DocumentVersionId = @DocumentVersionId) AND (ISNULL(DIIICod.RecordDeleted, ''N'') = ''N'')                        
               
                            
                                                            
                             
                              
--Get EffectiveDate of document based documentversionId                               
Select @effectiveDate= EffectiveDate from Documents                              
where CurrentDocumentVersionId=@DocumentVersionId          
                    
--select @eventDateTime=EventDateTime from Events                     
--where EventId = (select EventId from Documents                    
--where CurrentDocumentVersionId=@DocumentVersionId)       
                              
--uncommented by shifali in order to use effectiveDate in Event Architecture on 28 oct,2010 after shs team feedback      
--Use the effective date to get previous events and previous after care plans                              
                 
  --commented by shifali in order to use EventDateTime in Event Architecture on 1st sep,2010                    
                                                      
  --PreviousEvents                                                              
 SELECT top 20 ''PreviousEvents'' AS TableName,      
 C.ClinicalUpdate,G.GlobalCodeId as ReviewerId,                                       
 G.CodeName as ReviewerName,                                                              
 CONVERT(nvarchar(10),D.EffectiveDate,101) as EventDateTime,                                              
 C.CreatedBy,C.CreatedDate,C.ModifiedBy,C.ModifiedDate,                                        
 C.RecordDeleted,C.DeletedBy,C.DeletedDate                                                              
 from CustomConcurrentReviews C       
 join Documents D on C.DocumentVersionId=D.CurrentDocumentVersionId                                                  
 join GlobalCodes G on G.GlobalCodeId=C.CurrentTreatingPsychiatristId      
 where (ISNULL(C.RecordDeleted, ''N'') = ''N'') and D.ClientId=@ClientID and D.EffectiveDate<@effectiveDate    
 and C.DocumentVersionId<>0                
 order by EffectiveDate       
           
                        
                 
  --commented by shifali in order to use effective datetime on 28oct,2010              
-- select top 20 ''PreviousEvents'' AS TableName,                
--C.ClinicalUpdate,                
--CurrentTreatingPsychiatristId as ReviewerId,                
--G.CodeName as ReviewerName,                
--CONVERT(nvarchar(10),E.EventDateTime,101) as EventDateTime,                
--C.CreatedBy,C.CreatedDate,C.ModifiedBy,C.ModifiedDate,                                              
--C.RecordDeleted,C.DeletedBy,C.DeletedDate                 
--from CustomConcurrentReviews C                 
--left join Documents D on D.CurrentDocumentVersionId=C.DocumentVersionId                
--left join Events E on E.EventId=D.EventId                
--left join GlobalCodes G                
--on C.CurrentTreatingPsychiatristId=G.GlobalCodeId                
--where E.EventDateTime<=@eventDateTime                
--and (ISNULL(c.RecordDeleted, ''N'') = ''N'') and E.ClientId=@ClientID                
--and C.DocumentVersionId<>@DocumentVersionId                
--order by E.EventDateTime                    
                     
                     
                                                      
--PreviousAfterCarePlans                        
--uncommented by shifali in order to use effectiveDate in Event Architecture on 28 oct,2010 after shs team feedback      
                                    
  --commented by shifali in order to use EventDateTime in Event Architecture on 1st sep,2010                                                           
 Select top 20 ''PreviousAfterCarePlan'' AS TableName,  
                                                            
 C.CurrentAfterCarePlan as AfterCarePlan                                                          
 ,CONVERT(nvarchar(10),D.EffectiveDate,101) as EventDateTime,                                              
 C.CreatedBy,C.CreatedDate,C.ModifiedBy,C.ModifiedDate,                                              
  C.RecordDeleted,C.DeletedBy,C.DeletedDate                                                       
 from CustomConcurrentReviews C join Documents D                                                           
 on C.DocumentVersionId=D.CurrentDocumentVersionId        
 where (ISNULL(c.RecordDeleted, ''N'') = ''N'') and D.ClientId=@ClientID and D.EffectiveDate<@effectiveDate      
 and C.DocumentVersionId<>@DocumentVersionId      
order by EffectiveDate                                                
        
                

--DiagnosesIANDIIMaxOrder          
   SELECT  top 1 max(DiagnosisOrder) as DiagnosesMaxOrder  ,CreatedBy,ModifiedBy,CreatedDate,ModifiedDate,            
   RecordDeleted,DeletedBy,DeletedDate from  DiagnosesIAndII             
   where DocumentVersionId=@DocumentVersionId                      
      and  IsNull(RecordDeleted,''N'')=''N'' group by CreatedBy,ModifiedBy,CreatedDate,ModifiedDate,RecordDeleted,DeletedBy,DeletedDate            
      order by DiagnosesMaxOrder desc                 
                                                                          
 END TRY                                                                         
                                                                                  
 BEGIN CATCH                                                                                                      
   DECLARE @Error varchar(8000)                                                                                             
   SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                                                        
   + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''[csp_CMGetDataForConcurrentReviews]'')                                                                                                                                         
   + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****ERROR_SEVERITY='' + Convert(varchar,ERROR_SEVERITY())                                                         
   + ''*****ERROR_STATE='' + Convert(varchar,ERROR_STATE())                                                              
   RAISERROR (@Error /* Message text*/,  16 /*Severity*/,   1/*State*/   )                                                                                                      
 END CATCH                                              
End ' 
END
GO
