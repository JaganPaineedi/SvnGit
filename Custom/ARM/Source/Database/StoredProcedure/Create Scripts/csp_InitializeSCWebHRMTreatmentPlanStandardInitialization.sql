/****** Object:  StoredProcedure [dbo].[csp_InitializeSCWebHRMTreatmentPlanStandardInitialization]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitializeSCWebHRMTreatmentPlanStandardInitialization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitializeSCWebHRMTreatmentPlanStandardInitialization]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitializeSCWebHRMTreatmentPlanStandardInitialization]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'            
 CREATE PROCEDURE [dbo].[csp_InitializeSCWebHRMTreatmentPlanStandardInitialization]              
(                                                                                                                                                                          
 @ClientID int,                                                              
 @StaffID int,                                                            
 @CustomParameters xml                                                                                                                                                                          
)                                                                                                                                                                          
As                                                                                                                                                        
/*********************************************************************/                                                                                                                                                            
/* Stored Procedure: dbo.csp_InitializeHRMTreatmentPlanStandardInitialization          */                                                                                                                                                            
/* Purpose:   To Initialize from previous TreatmentPlan,Addendum,TP*/                                                                                                                                                            
/*                                                                   */                                                                                                                                                            
/* Input Parameters:   @VarClientID :-Id of the client*/                                                                                                                                                            
/*                                                                   */                                                                                                                                                            
/* Output Parameters:   None                                         */                                                                                                                                                            
/*                                                                   */                                                                                                                                                            
/* Return:  0=success, otherwise an error number                 */                                                                                                                                                            
/*                                                                   */                                                                                                                                                            
/* Called By:                  */                                                                                                                                                            
/*                                                                   */                                                                                                                                                            
/* Calls:                                                            */                                                                                                                                                            
/*                                                                   */                                             
/* Data Modifications:                             */                 
/*       */                                      
/* Updates:                             */                    
/* Date      Author      Purpose            */                                                  
/*   Sonia   Created                                                                       
/*  09/April/09 Priya Modified the table Clientneeds to CustomClientNeeds and TPNeedsClientNeeds to        CustomTPNeedsClientNeeds */                                                                                 
    04 April 2011 Modified By Rakesh Garg  (Remove Columns RowIdentifier from select statement in TPGeneral and TPNeeds table as These columns are no more in new data model)              
    8 APRIL 2011  Modified by Maninder (Added  PlanDeliveryStaff )          
/*********************************************************************/  */                                                                  
                                                                
 Declare @DocumentIDASS as bigint                                                                                                                                           
 Declare @VersionASS as bigint                                                                            
 Declare @DocumentIDDIAG as bigint                                                                                                                             
 Declare @VersionDIAG as bigint                                                                                                                          
 Declare @DischargeCriteria as varchar(max)                                                                                                         
 Declare @DocumentIDHRMASS as bigint                                                                                                               
 Declare @VersionHRMASS as bigint                                                                                                                    
 Declare @DocumentRecentPlan as bigint                                                                                                                                                                    
 Declare @VersionRecentPlan as bigint                                                                   
 Declare @DocumentRecent as bigint --Most recent plan, addendum, or periodic review                                                                
 Declare @VersionRecent as bigint                                                                
 Declare @Participants as varchar(max)                                                                                                                               
 Declare @ClientStrengths as varchar(max)                                                                       
 Declare @AreasOfNeed as varchar(max)                                                                                                          
 Declare @HopesAndDreams  as varchar(max)                                                                                           
 Declare @DeferredTreatmentIssues as varchar(max)                                                                                        
 Declare @CrisisPlan as varchar(max)                                                                                                     
 Declare @BlankPlan as char(1)                                                               
--Following option is reqd for xml operations                                              
SET ARITHABORT ON                                    
begin try                                    
                                
  set @BlankPlan=''N''                                
                                
   if @CustomParameters is not null                                 
   Begin                                
  set @BlankPlan = @CustomParameters.value(''(/Root/Parameters/@BlankPlan)[1]'', ''char(1)'' )                                 
   End                                
           
                                                                 
-- GETS THE MAXIMUM DOCUMENTID FOR A SIGNED ASSESSMENT DOCUMENT    and version according to EvvetiveDate                                                                                           
select top 1 @DocumentIDASS= a.DocumentId,  @VersionASS=a.CurrentDocumentVersionId                                                        
from Documents a                                                
where a.ClientId = @ClientID                   
and a.EffectiveDate <= convert(datetime, convert(varchar, getdate(),101))                                                                 
and a.Status = 22 and a.DocumentCodeId =101                                                                 
and isNull(a.RecordDeleted,''N'')<>''Y''                                
order by a.EffectiveDate desc,ModifiedDate desc                                                                            
                                                                
                                             
                                                                       
--GETS THE MAXIMUM DOCUMENTID FOR A SIGNED HRMASSESSMENT                                                                                          
select top 1 @DocumentIDHRMASS= a.DocumentId,  @VersionHRMASS=a.CurrentDocumentVersionId                                                                  
from Documents a                                                                 
where a.ClientId = @ClientId                                                                  
and a.EffectiveDate <= convert(datetime, convert(varchar, getdate(),101))                                                                 
and a.Status = 22 and a.DocumentCodeId in (349, 1469)                                                                 
and isNull(a.RecordDeleted,''N'')<>''Y''                                                                 
order by a.EffectiveDate desc,ModifiedDate desc                                                                                                                                            
                                        
                                                    
--Get the DesiredOutcomes from CustomHRMAssessments                                          
if(@DocumentIDHRMASS<>0)                                                                                                          
begin                                                                                       
     select @HopesAndDreams=CustomHRMAssessments.DesiredOutcomes                                                                                                          
     from CustomHRMAssessments where DocumentVersionId=@VersionHRMASS and  (RecordDeleted is null or RecordDeleted =''N'')                                                                                                                                      
  
     
     
                                                         
                                                            
end                                                                              
                                                                                                   
                                                                                                   
--find out Strengths and Preferences from recent HRMAssessment or Old AssessmenT                                                                                                        
--Case Signed Assessment exist but signed HRM Assessment does not exist                                                                                                        
if (@DocumentIDASS<>0 And isnull(@DocumentIDHRMASS,0)=0)                                                                               
Begin                   
      select @ClientStrengths=CustomAssessments.ClientStrengths                                                                    
      from CustomAssessments where DocumentVersionId= @VersionASS and  (RecordDeleted is null or RecordDeleted =''N'')                                           
end                                                                                                        
                                                                                                        
--Case Signed HRM Assessment exist but signed Assessment does not exist                                                                    
else if (@DocumentIDHRMASS<>0 And isnull(@DocumentIDASS,0)=0)                                                              
Begin                   
    select @ClientStrengths=CustomHRMAssessments.ClientStrengthsNarrative                                                                                                           
    from CustomHRMAssessments where DocumentVersionId= @VersionHRMASS and  (RecordDeleted is null or RecordDeleted =''N'')                                                                                                                                      
 
end                                                                                                        
--Case Signed Assessment is recent than HRMAssessment                                                                                                        
else if (@DocumentIDASS<>0 And @DocumentIDHRMASS<>0 And                                                                                                                                        
   ((select ModifiedDate from Documents where documentid =@DocumentIDASS                                                    
and  (RecordDeleted is null or RecordDeleted =''N''))                                                                                                     
      >                                                                                                                                                       
    (select ModifiedDate from Documents where documentid =@DocumentIDHRMASS and                                                                                                                                                               
 (RecordDeleted is null or RecordDeleted =''N'')))                                                                                                   
   )                                                                                                             
Begin                                                                                                        
 select @ClientStrengths=CustomAssessments.ClientStrengths                                                                                                          
      from CustomAssessments where DocumentVersionId= @VersionASS and  (RecordDeleted is null or RecordDeleted =''N'')                                                                                              
end                                                                                                        
--Case Signed HRMAssessment is recent than Assessment                                                                                                        
else if (@DocumentIDASS<>0 And @DocumentIDHRMASS<>0 And                                            
   ((select ModifiedDate from Documents where documentid =@DocumentIDASS                                                                                         
and  (RecordDeleted is null or RecordDeleted =''N''))                                                                                                                                    
     <                                                                                                                                             
    (select ModifiedDate from Documents where documentid =@DocumentIDHRMASS and                                                                                                                                                          
 (RecordDeleted is null or RecordDeleted =''N'')))                                                                                                                           
   )                                                                                     
Begin                                                       
select @ClientStrengths=CustomHRMAssessments.ClientStrengthsNarrative                                                                                                           
   from CustomHRMAssessments where DocumentVersionId = @VersionHRMASS and  (RecordDeleted is null or RecordDeleted =''N'')                                                                                                             
end                                                                                  
                                                  
                                                         
                                                                                                        
--Discharge Criteria                                                                                                        
Select @DischargeCriteria=(Select DischargeCriteria                                 
       from CustomHRMAssessments                                 
       Where DocumentVersionId = @VersionHRMASS                                
       and isnull(RecordDeleted, ''N'')= ''N'')                                                                   
--CrisisPlan                                                                                          
set @CrisisPlan='''';                                                       
exec csp_HRMTPCrisisPlan 1 ,@CrisisPlan output                                                                                     
                              
                                                                
--DIAGNOSIS                                                                                                                                     
--GETS THE LATEST DOCUMENTID AND VERSION FOR A SIGNED DIAGNOSIS DOCUMENT                                                                        
                                                                                                                                                
select top 1 @DocumentIDDIAG = a.DocumentId,  @VersionDIAG = a.CurrentDocumentVersionId                                                                  
from Documents a where a.ClientId = @ClientID                                                                  
and a.EffectiveDate <= convert(datetime, convert(varchar, getdate(),101))                                                                 
and a.Status = 22                                                                                                  
and a.DocumentCodeId =5                                                                 
and isNull(a.RecordDeleted,''N'')<>''Y''                                                                 
order by a.EffectiveDate desc,ModifiedDate desc                                                                                    
                                                                                                                                                                                                                           
       if @VersionDIAG<>0                                                                                                                                                                    
       begin                                                                                                                      
   select ''Specifier'' as TableName,DiagnosesIAndII.Specifier              
   from DiagnosesIAndII                                         
   where DocumentVersionId  = @VersionDIAG                                                                 
   and (RecordDeleted is null or RecordDeleted =''N'') --table6                                                                   
                             
   select ''Specifier'' as TableName,DiagnosesIII.Specification                                                                 
   from DiagnosesIII Where DocumentVersionId = @VersionDIAG                                                                 
   and (RecordDeleted is null or RecordDeleted =''N'')  --table7                                                                                                                        
                                                                                    
   select ''Specifier'' as TableName,DiagnosesIV.Specification                                                
   from DiagnosesIV where DocumentVersionId = @VersionDIAG                                                                 
   and (RecordDeleted is null or RecordDeleted =''N'') --table8                                                     
    end                                                                    
   else                                                                            
       begin                                                                                                                                                      
         Select ''Specifier'' as TableName,'''' as Specifier                                                              
         Select ''Specifier'' as TableName,''''  as Specification                                                                                                                                                    
         Select ''Specifier'' as TableName,'''' as Specification                                                                                                                      
       end                                                                                                              
                       
                                
-- Skip finding the most recent treatment plan if ''BlankForm'' is ''Y''.                                                                                  
If isnull(@BlankPlan,'''') <> ''Y''                         
Begin                                                                
 -- Fetch the Recent Signed Document for Treatment Plan HRM - 350 / Addendum -- 503                                                                                                
 select top 1 @DocumentRecentPlan= a.DocumentId,@VersionRecentPlan=a.CurrentDocumentVersionId                                                   
 from Documents a                                                                     
 where a.ClientId = @ClientID                                                               
 and a.EffectiveDate <= convert(datetime, convert(varchar, getdate(),101))                                                                 
 and a.Status = 22                                                                     
 and a.DocumentCodeId in (350,503,2)                                                                 
 and isNull(a.RecordDeleted,''N'')<>''Y''                                                              
 order by a.EffectiveDate desc,ModifiedDate desc                                                                                                 
                                                                     
 -- Fetch the most recent document (Treatment Plan, Addendum, Periodic Review)                                                                
 select top 1 @DocumentRecent= a.DocumentId,@VersionRecent=a.CurrentDocumentVersionId                                                                      
 from Documents a   
 where a.ClientId = @ClientID                                                                  
 and a.EffectiveDate <= convert(datetime, convert(varchar, getdate(),101))                                                   
 and a.Status = 22                                                                     
 and a.DocumentCodeId in (350,503,2, 352, 3)                                                                 
 and isNull(a.RecordDeleted,''N'')<>''Y''                                                                 
 order by a.EffectiveDate desc,ModifiedDate desc                                                                      
End                                                                
                            --to fetch the values of DiagnosisI-II  ref #3611                                                        
declare @Diagnosis varchar(max)                                        
set @Diagnosis=''AxisI-II''+ char(9) + ''DSM Code''  + char(9) + ''Type'' + char(9) + ''Version'' + CHAR(13)                                        
                                        
select @Diagnosis = @Diagnosis + ISNULL(cast(a.Axis AS varchar),char(9)) + char(9)+ ISNULL(cast(a.DSMCode as varchar),char(9)) + char(9)+ char(9) + ISNULL(cast(b.CodeName as varchar),char(9)) + char(9) + ISNULL(cast(a.DSMVersion as varchar),             
  
    
      
         
         
            
              
                
                  
                    
                      
                       
'' '') + char(13)--,a.DSMNumber                                         
from DiagnosesIAndII a                                 
 Join GlobalCodes b on a.DiagnosisType=b.GlobalCodeid                                            
where DiagnosisId in (select DiagnosisId from dbo.DiagnosesIAndII  where DocumentVersionId = @VersionDIAG and isNull(RecordDeleted,''N'')<>''Y'')                                                           
 and isNull(a.RecordDeleted,''N'')<>''Y''  and a.billable =''Y'' order by Axis                                                 
                                        
                                          
                                                                                                   
set @DeferredTreatmentIssues = ''''                                            
select @DeferredTreatmentIssues = @DeferredTreatmentIssues + cast(NeedName as varchar(max)) +CHAR(13) + char(10)                                        
from CustomClientNeeds                                 
inner join                                                     
ClientEpisodes                                                    
on ClientEpisodes.ClientEpisodeId=CustomClientNeeds.ClientEpisodeId                                                  
where NeedStatus=5236                                
and ClientEpisodes.ClientId=@ClientID                                  
and IsNUll(ClientEpisodes.RecordDeleted,''N'')<>''Y''                                                  
and IsNull(CustomClientNeeds.RecordDeleted,''N'')<>''Y''                                
--order by NeedName                                      
                        
                                
                                     
                                    
 --to fetch the values of AreasOfNeed  ref #3611                                           
set @AreasOfNeed= ''The clinician has recommended the following areas be addressed in the treatment plan:  '' + char(13)+char(13)                                        
select @AreasOfNeed =   coalesce(@AreasOfNeed +'','','''')+  CustomClientNeeds.NeedName                                                
 from CustomClientNeeds                                                    
inner join                                                     
ClientEpisodes                                                    
on ClientEpisodes.ClientEpisodeId=CustomClientNeeds.ClientEpisodeId
inner join Documents D ON D.InProgressDocumentVersionId = CustomClientNeeds.SourceDocumentVersionId AND Isnull(D.RecordDeleted, ''N'') <> ''Y''                                                    
where ClientEpisodes.ClientId=@ClientID                                      
and CustomClientNeeds.NeedStatus != 5237                                                   
and IsNUll(ClientEpisodes.RecordDeleted,''N'')<>''Y''                                                  
and IsNull(CustomClientNeeds.RecordDeleted,''N'')<>''Y''                                 
                                
                                                                 
if(@DocumentRecentPlan<>0)                                                                                                        
Begin                                                                  
                                                                
 -- all data returned is in variables so no [from] clause required                                                                
 select  -1 as DocumentVersionId,''T'' as PlanOrAddendum, @HopesAndDreams as HopesAndDreams, CONVERT(datetime,NULL) as MeetingDate, @DischargeCriteria as DischargeCriteria,                                                                
  @ClientStrengths  as StrengthsAndPreferences, @DeferredTreatmentIssues as DeferredTreatmentIssues,@AreasOfNeed as AreasOfNeed,@Diagnosis as Diagnosis, @CrisisPlan as CrisisPlan, '''' as CreatedBy,                                                          
  
   
  getdate() as CreatedDate, '''' as ModifiedBy, getdate() as ModifiedDate, ''TPGeneral'' as TableName                                               
                                                                
                                                                
                                                                
--Get the Needs Data corresponding to recent plan                                                                                               
 select NeedId,DocumentVersionId , NeedNumber, NeedText, NeedTextRTF, NeedCreatedDate, NeedModifiedDate, GoalText, GoalTextRTF, GoalActive, GoalNaturalSupports,                                                                 
  GoalLivingArrangement, GoalEmployment, GoalHealthSafety, GoalStrengths, GoalBarriers, GoalMonitoredStaffOther,GoalMonitoredStaffOtherCheckbox,GoalMonitoredStaff, GoalTargetDate, StageOfTreatment, SourceNeedId,                                            
  
    
                     
  CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedDate, DeletedBy, ''TPNeeds'' as TableName                           
 from TPNeeds                                                                
 where  DocumentVersionId = @VersionRecent                                                                
 and isNull(RecordDeleted,''N'')<>''Y''                                                                 
 and GoalActive=''Y''                                                                    
                                                           
--Get the TPNeedsClientNeeds Data corresponding to recent plan                                                                                                        
select                                                                             
TC.TPNeedsClientNeedId,TC.NeedId,TC.ClientNeedId,                                                    
CustomClientNeeds.NeedDescription,TC.CreatedBy,TC.CreatedDate,TC.ModifiedBy,TC.ModifiedDate,TC.RecordDeleted,TC.DeletedDate,TC.DeletedBy                                                                            
,''CustomTPNeedsClientNeeds''  as TableName                                                                 
from CustomTPNeedsClientNeeds as TC                                                                                                    
inner join CustomClientNeeds on TC.ClientNeedId=CustomClientNeeds.ClientNeedId                                                                 
    AND (ISNULL(CustomClientNeeds.RecordDeleted,''N'')<>''Y'')                                                                                                     
where NeedId in (select NeedId from TPNeeds                                                                                                             
    where DocumentVersionId = @VersionRecent                                                                
    and (RecordDeleted is null or RecordDeleted =''N'')                                                                   and GoalActive=''Y''                                                                                                             
    )                                                                                                                
and (ISNULL(TC.RecordDeleted,''N'')<>''Y'')                                                                                                     
and CustomClientNeeds.NeedStatus not in (5236,5237)                                     
                                                            
                                                                
--Get the TPObjectives Data corresponding to recent plan                                                                                                                                               
Select TPObjectives.*,''TPObjectives'' as TableName                                                                 
from TPObjectives                                               
where DocumentVersionId = @VersionRecent                                                                
and (RecordDeleted is null or RecordDeleted =''N'')                                                       
and ObjectiveStatus in(191,193)                                                                 
and NeedID In(Select NeedID from TPNeeds                                                                 
    where DocumentVersionId = @VersionRecent                               
    and (RecordDeleted is null or RecordDeleted =''N'')                                                                 
    and GoalActive=''Y''                                                  
    )                                                                                                                             
ORDER BY ObjectiveNumber                                                                  
                                                                
--Get the TPInterventionProcedures Data corresponding to recent plan                                
--Select TIP.*,''TPInterventionProcedures'' as TableName,TP.DocumentVersionId as TPProcedureSourceDocumentId                                                                                                   
Select TIP.TPInterventionProcedureId,TIP. NeedId,TIP.InterventionNumber ,TIP.InterventionText, TIP.AuthorizationCodeId, TIP.ProviderId, TIP.SiteId, TIP.StartDate, TIP.EndDate, TIP.TotalUnits, TIP.TPProcedureId,                                             
  
   
      
        
          
            
               
                
                 
                     
-- TIP.RowIdentifier, commented By Rakesh as column RowIdentifier removed                    
 TIP.CreatedBy, TIP.CreatedDate, TIP.ModifiedBy, TIP.ModifiedDate, TIP.RecordDeleted, TIP.DeletedDate, TIP.DeletedBy,''TPInterventionProcedures'' as TableName                                            
                               
from TPInterventionProcedures   TIP                                                                    
left join TPProcedures TP on  TIP.TPProcedureId=TP.TPProcedureId  and ISNULL(TP.RecordDeleted,''N'')=''N''                                                                                                            
where NeedId In(Select NeedID from TPNeeds                                                                 
    where DocumentVersionId  = @VersionRecent                                                                 
    and (RecordDeleted is null or RecordDeleted =''N'')                                       
    and GoalActive=''Y''                                                                
    )                                                                                                    
and (TIP.RecordDeleted is null or TIP.RecordDeleted =''N'')                                                                     
                                                                                   
---  TPInterventionProcedureObjectives                 
Select TIPO.*,''TPInterventionProcedureObjectives'' as TableName                                                                                              
from TPInterventionProcedureObjectives  TIPO                                                                
join TPObjectives TOJ on  TIPO.ObjectiveId=TOJ.ObjectiveId                                                                 
      and (TOJ.RecordDeleted is null or TOJ.RecordDeleted =''N'')                                                                 
    and ObjectiveStatus in(191,193)                                                        
join TPInterventionProcedures TIP on TIP.TPInterventionProcedureId=TIPO.TPInterventionProcedureId                                                                 
      and (TIP.RecordDeleted is null or TIP.RecordDeleted =''N'')                                                                 
inner join TPNeeds TN on TN.NeedId=TOJ.NeedId                                                                 
      and  TN.NeedId=TIP.NeedId                 
      and (TN.RecordDeleted is null or TN.RecordDeleted =''N'')                                                 
      and TN.DocumentVersionId= @VersionRecent                                                      
      and GoalActive=''Y''                                                                
where isnull(TIPO.RecordDeleted,''N'')<>''Y''                                                                 
                             
-- This code is added by Rakesh Garg for getting LOCID from CustomClientloc USED IN TPGeneral-Main Tab For Dropdown LOC                                
if exists (SELECT ClientLOCId from CustomClientLOCs where ClientId = @ClientID and LOCEndDate IS NULL and Isnull(RecordDeleted,''N'') = ''N'')                       
 Begin                           
 select  ClientLOCId,ClientId,CreatedBy,                      
  CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedDate, DeletedBy,                       
  LOCId, LOCStartDate, LOCEndDate, LOCBy , ''CustomClientLOCs'' as TableName,''N'' as IsInitialize                             
 from CustomClientLOCs where ClientId = @ClientID                 
 and LOCEndDate IS NULL and Isnull(RecordDeleted,''N'') = ''N''                    
 End                        
 else                          
 Begin                        
  select  -1 as ClientLOCId,@ClientID as ClientId, -1 as LOCId  , '''' as CreatedBy,                             
  getdate() as CreatedDate, '''' as ModifiedBy, getdate() as ModifiedDate, ''CustomClientLOCs'' as TableName                            
  End                        
                                                                   
                                                                
exec ssp_SCWebGetHRMTPClientNeeds @ClientID,0,''Y'',@VersionRecent                                                                                  
        
-- PlanDeliveryStaff                                               
exec csp_SCGetTreatmentPlanDeliveryStaffList         
    
-- PreviouslyRequested    
exec ssp_SCTxPlanGetPreviouslyRequestedUnits @ClientId,@VersionRecent    
                                               
end                                                                                         
else   -- In case No Signed Document exists                                                                                                     
Begin                                                          
                            
                                                                                                    
select -1 as DocumentVersionId,                                                                
 ''T'' as PlanOrAddendum,                                                                
 @HopesAndDreams as HopesAndDreams,                                                                
 CONVERT(datetime,NULL) as MeetingDate,                                                                
 @DischargeCriteria as DischargeCriteria,                 
 @ClientStrengths  as StrengthsAndPreferences,                                                                
 @DeferredTreatmentIssues as DeferredTreatmentIssues,                                  
 @AreasOfNeed as AreasOfNeed,@Diagnosis as Diagnosis,                                                              
 @CrisisPlan as CrisisPlan,                                                                                                                    
 '''' as CreatedBy,                                                                
 getdate() as CreatedDate,                                                                
 '''' as ModifiedBy,                                                                
 getdate() as ModifiedDate,                                      
 ''TPGeneral'' as TableName                                                         
                                             
                                                                
SET FMTONLY ON                                                                
                                                                
select NeedId, DocumentVersionId, NeedNumber, NeedText, NeedTextRTF, NeedCreatedDate, NeedModifiedDate, GoalText, GoalTextRTF, GoalActive, GoalNaturalSupports,                                                                 
 GoalLivingArrangement, GoalEmployment, GoalHealthSafety, GoalStrengths, GoalBarriers, GoalMonitoredStaffOther,GoalMonitoredStaffOtherCheckbox,GoalMonitoredStaff, GoalTargetDate, StageOfTreatment, SourceNeedId,                                            
  
     
                    
 CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedDate, DeletedBy,''TPNeeds'' as TableName                                                                 
from TPNeeds                                                                
                                                                
Select TPNeedsClientNeedId, NeedId, ClientNeedId, NeedDescription, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedDate, DeletedBy,                                                                
 ''CustomTPNeedsClientNeeds'' as TableName           
from CustomTPNeedsClientNeeds                                                                
                                                                
Select ObjectiveId, DocumentVersionId , NeedId, ObjectiveNumber, ObjectiveText, ObjectiveTextRTF, ObjectiveStatus, TargetDate, CreatedBy, CreatedDate,                                                                 
 ModifiedBy, ModifiedDate, RecordDeleted, DeletedDate, DeletedBy,''TPObjectives'' as TableName                        
from TPObjectives                                                                
                                                                
Select TPInterventionProcedureId, NeedId,InterventionNumber, InterventionText, AuthorizationCodeId, Units, FrequencyType, ProviderId, SiteId, StartDate, EndDate, TotalUnits, TPProcedureId,                                                                 
 -- RowIdentifier, commented By Rakesh as column RowIdentifier removed                    
 CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedDate, DeletedBy,''TPInterventionProcedures'' as TableName                                                                 
from TPInterventionProcedures                                             
                                        
                                                    
                                      
Select TPInterventionProcedureObjectiveId, TPInterventionProcedureId, ObjectiveId,                     
--RowIdentifier, commented By Rakesh as column RowIdentifier removed                    
CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted,                                            
 DeletedDate, DeletedBy,''TPInterventionProcedureObjectives'' as TableName                                                                
from TPInterventionProcedureObjectives                                                                
                                                                
Select TPProcedureId, DocumentVersionId , AuthorizationCodeId, Units, FrequencyType, ProviderId, SiteId, StartDate, EndDate, TotalUnits, AuthorizationId,                                                                 
 CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedDate, DeletedBy,''TPProcedures'' as TableName                                                                
from TPProcedures                                                                
                                           
-- This code is added by Rakesh Garg for getting LOCID from CustomClientloc USED IN TPGeneral-Main Tab For Dropdown LOC                                
                        
                                                                
SET FMTONLY OFF                             
                        
if exists (SELECT ClientLOCId from CustomClientLOCs where ClientId = @ClientID and LOCEndDate IS NULL and Isnull(RecordDeleted,''N'') = ''N'')                        
 Begin                           
 select  ClientLOCId,ClientId, CreatedBy, CreatedDate, ModifiedBy,                       
 ModifiedDate, RecordDeleted, DeletedDate, DeletedBy, LOCId, LOCStartDate, LOCEndDate, LOCBy ,                 
 ''CustomClientLOCs'' as TableName,''N'' as IsInitialize                             
 from CustomClientLOCs where ClientId = @ClientID                
 and LOCEndDate IS NULL and Isnull(RecordDeleted,''N'') = ''N''                                                                    
 End                        
 else                          
 Begin                        
  select  -1 as ClientLOCId,@ClientID as ClientId, -1 as LOCId  , '''' as CreatedBy,                             
  getdate() as CreatedDate, '''' as ModifiedBy, getdate() as ModifiedDate, ''CustomClientLOCs'' as TableName                            
  End                                                           
                                                                
exec ssp_SCWebGetHRMTPClientNeeds @ClientID,0,''Y'',-1                                                  
        
-- PlanDeliveryStaff                                   
exec csp_SCGetTreatmentPlanDeliveryStaffList    
    
-- PreviouslyRequested    
exec ssp_SCTxPlanGetPreviouslyRequestedUnits @ClientId,@VersionRecent                                         
                                                                
end                                                                
                           
RETURN(0)                                                         
                                                                
end try                                                
begin catch                                                                
                                                                
declare @emsg nvarchar(4000)                                                                
                                                                
set fmtonly off                                                                
                                                                
set @emsg = error_message()                                                    
raiserror(@emsg, 16, 1)                                                               
return 1                                                                
                                              
                                                                
end catch ' 
END
GO
