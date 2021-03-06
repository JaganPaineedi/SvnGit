/****** Object:  StoredProcedure [dbo].[csp_InitializeDocumentMapToEmployments]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitializeDocumentMapToEmployments]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitializeDocumentMapToEmployments]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitializeDocumentMapToEmployments]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

 
 /*********************************************************************/                                                                            
/* Stored Procedure: [csp_InitializeDocumentMapToEmployments]    */                                                                   
/* Creation Date:  08 July /2011               */                                                                            
/* Purpose: To Initialize Tables Used in Vocational Treatment Plan of latest Signed Document */                                                                          
/* Input Parameters: @ClientID ,@StaffID,@CustomParameters                  */                                                                          
/* Output Parameters:   Table Assoicated with the Vocational Treatment Plan)*/                                                                            
/* Author:  Devi Dayal           */        
/* Modified By : Devi Dayal on 1 August 2011 Add Try Catch Block*/   
/* Modified By : Priyanka on 9 nov 2011 adde4d two new columns ClientDidNotParticipate,ClientDidNotParticpateComment */
/*Modified By  : Shifali on 16Dec 2011	Added IsInitialize field in Custom Quick objectives table (to not change row credentials at framework */       
/*Modified By  :Amit Kuamr Srivastava on 19 April 2012	#21, SmartcareWeb Phase 3 Development,Harbor Map to Employment: Pre-Loaded Lists Do Not Work in New Mode, Added a row_number() in ''CustomDocumentMapToEmploymentResponsibilities'', ''CustomDocumentMapToEmploymentMethods''  tables preivously it was giving ID with 0  */  
                                                              
/*********************************************************************/      
CREATE PROCEDURE [dbo].[csp_InitializeDocumentMapToEmployments]  
 @ClientID int ,
 @StaffID int,
 @CustomParameters xml
AS
BEGIN
BEGIN TRY
 Declare @latestDocumentVersionId int
 declare @gcProvidedBy int

 select top 1 @gcProvidedBy = GlobalCodeId from GlobalCodes where category = ''XVOCPROVIDERS'' and SortOrder = 1 and isnull(RecordDeleted, ''N'') <> ''Y'' order by GlobalCodeId

 SELECT TOP 1 @latestDocumentVersionId = DOC.CurrentDocumentVersionId
 FROM Documents DOC WHERE DOC.ClientId = @ClientID
 and DOC.EffectiveDate <= CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(),101))
 and DOC.Status = 22
 and DOC.DocumentCodeId =1488
 and ISNULL(DOC.RecordDeleted,''N'')<>''Y''
 ORDER BY DOC.EffectiveDate DESC,ModifiedDate DESC

 /*CustomDocumentMapToEmployments*/
 SELECT Placeholder.TableName,ISNULL(DV.DocumentVersionId,-1) AS DocumentVersionId,
    CDME.[CreatedBy]
      ,ISNULL(CDME.[CreatedDate],GETDATE()) AS CreatedDate
      ,CDME.[ModifiedBy]
      ,ISNULL(CDME.[ModifiedDate],GETDATE()) AS ModifiedDate
      --,ISNULL(CDME.[ModifiedDate],GETDATE()) AS ModifiedDate
      ,CDME.[RecordDeleted]
      ,CDME.[DeletedBy]
      ,CDME.[DeletedDate]
      ,CDME.[DevelopmentNotApplicable]
      ,CDME.[InitialOrReview]
      ,CDME.[JobPlacementIncluded]
      ,CDME.[JobDevelopmentIncluded]
      ,CDME.[GoalsVocationalAreas]
      ,CDME.[GoalsWage]
      ,CDME.[GoalsWorkHoursPerWeek]
      ,CDME.[GoalsShiftAvailability]
      ,CDME.[GoalsDistance]
      ,CDME.[GoalsBenefits]
      ,CDME.[GoalsAdditionalInfo]
      ,CDME.[AssistiveTechnologyNeeds]
      ,CDME.[HealthSafetyRisks]
      ,ISNULL(CDME.[FrequencyofReview], 60) as FrequencyofReview
      ,CDME.[NaturalSupports]
      ,CDME.[OtherProviderInvolvement]
      ,CDME.[ConsumerParticpatedDevelopmentPlan]
      ,CDME.[CoachingPosition]
      ,CDME.[CoachingEmploymentSite]
      ,ISNULL(CDME.[CoachingJobAccomodations],CDME.[AssistiveTechnologyNeeds]) AS CoachingJobAccomodations
      ,ISNULL(CDME.[CoachingNaturalSupports],CDME.[NaturalSupports]) AS CoachingNaturalSupports
      ,CDME.[CoachingLearningStyle]
      ,CDME.[CoachingFadingPlan]
      ,CDME.[ConsumerParticipatedCoachingPlan]
      ,CDME.[ClientDidNotParticipate]
      ,CDME.[ClientDidNotParticpateComment]
 FROM (SELECT ''CustomDocumentMapToEmployments'' AS TableName) AS Placeholder
 LEFT JOIN DocumentVersions DV ON ( DV.DocumentVersionId = @latestDocumentVersionId AND ISNULL(DV.RecordDeleted,''N'') <> ''Y'' )
 LEFT JOIN dbo.CustomDocumentMapToEmployments CDME ON ( DV.DocumentVersionId = CDME.DocumentVersionId AND ISNULL(CDME.RecordDeleted,''N'') <> ''Y'' )

--
-- Get the development responsibilities
--
if @latestDocumentVersionId is not null
begin
select
	''CustomDocumentMapToEmploymentObjectives'' as TableName
	,EmploymentObjectiveId
	,CreatedBy
	,CreatedDate
	,ModifiedBy
	,ModifiedDate
	,RecordDeleted
	,DeletedBy
	,DeletedDate
	,DocumentVersionId
	,ObjectiveType
	,ObjectiveText
	,ObjectiveTargetDate
from dbo.CustomDocumentMapToEmploymentObjectives
where DocumentVersionId = @latestDocumentVersionId
and isnull(RecordDeleted, ''N'') <> ''Y''

select
	''CustomDocumentMapToEmploymentTrainingGoals'' as TableName
	,EmploymentTrainingGoalId
	,CreatedBy
	,CreatedDate
	,ModifiedBy
	,ModifiedDate
	,RecordDeleted
	,DeletedBy
	,DeletedDate
	,DocumentVersionId
	,TrainingGoal
from dbo.CustomDocumentMapToEmploymentTrainingGoals
where DocumentVersionId = @latestDocumentVersionId
and isnull(RecordDeleted, ''N'') <> ''Y''

select
	''CustomDocumentMapToEmploymentExperiences'' as TableName
	,EmploymentExperienceId
	,CreatedBy
	,CreatedDate
	,ModifiedBy
	,ModifiedDate
	,RecordDeleted
	,DeletedBy
	,DeletedDate
	,DocumentVersionId
	,ExperienceComment
from dbo.CustomDocumentMapToEmploymentExperiences
where DocumentVersionId = @latestDocumentVersionId
and isnull(RecordDeleted, ''N'') <> ''Y''

 select
  ''CustomDocumentMapToEmploymentResponsibilities'' as TableName
  ,EmploymentResponsibilityId
  ,CreatedBy
  ,CreatedDate
  ,ModifiedBy
  ,ModifiedDate
  ,RecordDeleted
  ,DeletedBy
  ,DeletedDate
  ,DocumentVersionId
  ,ResponsibilityType
  ,ResponsibilityComment
 from CustomDocumentMapToEmploymentResponsibilities
 where DocumentVersionId = @latestDocumentVersionId
 and isnull(RecordDeleted, ''N'') <> ''Y''

 select
  ''CustomDocumentMapToEmploymentMethods'' as TableName
  ,EmploymentMethodId
  ,CreatedBy
  ,CreatedDate
  ,ModifiedBy
  ,ModifiedDate
  ,RecordDeleted
  ,DeletedBy
  ,DeletedDate
  ,DocumentVersionId
  ,MethodType
  ,MethodsTechniques
  ,ProvidedBy
 from CustomDocumentMapToEmploymentMethods
 where DocumentVersionId = @latestDocumentVersionId
 and isnull(RecordDeleted, ''N'') <> ''Y''

end
else
begin
select
  e.TableName
  ,convert(int,row_number() over(order by e.EmploymentResponsibilityId desc)) as ''EmploymentResponsibilityId''
  ,e.CreatedBy
  ,e.CreatedDate
  ,e.ModifiedBy
  ,e.ModifiedDate
  ,e.RecordDeleted
  ,e.DeletedBy
  ,e.DeletedDate
  ,e.DocumentVersionId
  ,e.ResponsibilityType
  ,e.ResponsibilityComment
from
 (select
  d.TableName
  ,d.EmploymentResponsibilityId
  ,d.CreatedBy
  ,d.CreatedDate
  ,d.ModifiedBy
  ,d.ModifiedDate
  ,d.RecordDeleted
  ,d.DeletedBy
  ,d.DeletedDate
  ,d.DocumentVersionId
  ,d.ResponsibilityType
  ,c.ResponsibilityComment
 from (
  select
   ''CustomDocumentMapToEmploymentResponsibilities'' as TableName
   ,0 as EmploymentResponsibilityId
   ,cast(null as varchar(30)) as CreatedBy
   ,cast(null as datetime) as CreatedDate
   ,cast(null as varchar(30)) as ModifiedBy
   ,cast(null as datetime) as ModifiedDate
   ,cast(null as char(1)) as RecordDeleted
   ,cast(null as varchar(30)) DeletedBy
   ,cast(null as datetime) as DeletedDate
   ,-1 as DocumentVersionId
   ,''D'' as ResponsibilityType
 ) as d
 cross join (
  select ''To maintain my jobs lead log'' as ResponsibilityComment
  union
  select ''To secure 3 references'' as ResponsibilityComment
  union
  select ''To review the help wanted section of newspaper weekly'' as ResponsibilityComment
  union
  select ''To notify my job developer of any interviews''  as ResponsibilityComment
  union
  select ''To notify my job developer of any job offers'' as ResponsibilityComment
  union
  select ''To complete 15 employer contacts per week'' as ResponsibilityComment
  union
  select ''Communicate with job developer on any concerns'' as ResponsibilityComment
  union
  select ''To keep appointments with my job developer'' as ResponsibilityComment
  union
  select ''To keep my job developer informed of my progress'' as ResponsibilityComment
  union
  select ''Once employed, to put forth good effort to maintain my new job'' as ResponsibilityComment
 ) as c
union
 select
  d.TableName
  ,d.EmploymentResponsibilityId
  ,d.CreatedBy
  ,d.CreatedDate
  ,d.ModifiedBy
  ,d.ModifiedDate
  ,d.RecordDeleted
  ,d.DeletedBy
  ,d.DeletedDate
  ,d.DocumentVersionId
  ,d.ResponsibilityType
  ,c.ResponsibilityComment
 from (
  select
   ''CustomDocumentMapToEmploymentResponsibilities'' as TableName
   ,0 as EmploymentResponsibilityId
   ,cast(null as varchar(30)) as CreatedBy
   ,cast(null as datetime) as CreatedDate
   ,cast(null as varchar(30)) as ModifiedBy
   ,cast(null as datetime) as ModifiedDate
   ,cast(null as char(1)) as RecordDeleted
   ,cast(null as varchar(30)) DeletedBy
   ,cast(null as datetime) as DeletedDate
   ,-1 as DocumentVersionId
   ,''C'' as ResponsibilityType
 ) as d
 cross join (
  select ''Learn and practice safety procedures'' as ResponsibilityComment
  union
  select ''Follow employer’s procedures for reporting any needed absences or tardiness'' as ResponsibilityComment
  union
  select ''Accept instruction from boss and co-workers'' as ResponsibilityComment
  union
  select ''Accept feedback from job coach and adjust accordingly'' as ResponsibilityComment
  union
  select ''Be on time to work and attend work regularly'' as ResponsibilityComment
  union
  select ''Communicate with job coach on any concerns'' as ResponsibilityComment
  union
  select ''As job coach fading occurs, will communicate with my employer on any concerns'' as ResponsibilityComment
 ) as c) as e

 select
  f.TableName
  ,convert(int,row_number() over(order by f.EmploymentMethodId desc)) as ''EmploymentMethodId''
  ,f.CreatedBy
  ,f.CreatedDate
  ,f.ModifiedBy
  ,f.ModifiedDate
  ,f.RecordDeleted
  ,f.DeletedBy
  ,f.DeletedDate
  ,f.DocumentVersionId
  ,f.MethodType
  ,f.MethodsTechniques
  ,f.ProvidedBy
 from
 (select
  d.TableName
  ,d.EmploymentMethodId
  ,d.CreatedBy
  ,d.CreatedDate
  ,d.ModifiedBy
  ,d.ModifiedDate
  ,d.RecordDeleted
  ,d.DeletedBy
  ,d.DeletedDate
  ,d.DocumentVersionId
  ,d.MethodType
  ,c.MethodsTechniques
  ,d.ProvidedBy
 from (
  select ''CustomDocumentMapToEmploymentMethods'' as TableName
  ,0 as EmploymentMethodId
  ,cast(null as varchar(30)) as CreatedBy
  ,cast(null as datetime) as CreatedDate
  ,cast(null as varchar(30)) as ModifiedBy
  ,cast(null as datetime) as ModifiedDate
  ,cast(null as char(1)) as RecordDeleted
  ,cast(null as varchar(30)) as DeletedBy
  ,cast(null as datetime) as DeletedDate
  ,-1 as DocumentVersionId
  ,''D'' as MethodType
  ,@gcProvidedBy as ProvidedBy
 ) as d
 cross join (
  select ''Provide follow up support for at least 90 days'' as MethodsTechniques
  union
  select ''Will support in initial orientation at worksite and understanding of benefits as new employee, reviewing new employee manuals'' as MethodsTechniques
  union
  select ''Will contact employers on my behalf, marketing my unique skills and abilities'' as MethodsTechniques
  union
  select ''Will offer support in negotiating any needed accommodations'' as MethodsTechniques
  union
  select ''Will offer support in building natural supports'' as MethodsTechniques
  union
  select ''Will assist me in developing a resume'' as MethodsTechniques
  union
  select ''Will assist me in completing mock interviews and developing professional responses to interview questions'' as MethodsTechniques
  union
  select ''Will provide instruction on job searching techniques'' as MethodsTechniques
  union
  select ''Will provide training on completing applications'' as MethodsTechniques
  union
  select ''Will provide resources for completing on-line applications'' as MethodsTechniques
  union
  select ''Will provide resources for submitting cover letters, resumes, follow up letters and thank you cards'' as MethodsTechniques
 ) as c
 union all
 select
  d.TableName
  ,d.EmploymentMethodId
  ,d.CreatedBy
  ,d.CreatedDate
  ,d.ModifiedBy
  ,d.ModifiedDate
  ,d.RecordDeleted
  ,d.DeletedBy
  ,d.DeletedDate
  ,d.DocumentVersionId
  ,d.MethodType
  ,c.MethodsTechniques
  ,d.ProvidedBy
 from (
  select ''CustomDocumentMapToEmploymentMethods'' as TableName
  ,0 as EmploymentMethodId
  ,cast(null as varchar(30)) as CreatedBy
  ,cast(null as datetime) as CreatedDate
  ,cast(null as varchar(30)) as ModifiedBy
  ,cast(null as datetime) as ModifiedDate
  ,cast(null as char(1)) as RecordDeleted
  ,cast(null as varchar(30)) as DeletedBy
  ,cast(null as datetime) as DeletedDate
  ,-1 as DocumentVersionId
  ,''C'' as MethodType
  ,cast(null as int) as ProvidedBy
 ) as d
 cross join (
  select ''Will maintain regular communication with worksite and obtain feedback from supervisor and co-workers on work performance'' as MethodsTechniques
  union
  select ''Will assist with learning rules, policies, and procedures for worksite'' as MethodsTechniques
  union
  select ''Will provide instruction to assist with learning job tasks and performing job tasks up to employer''''s expectations'' as MethodsTechniques
  union
  select ''Will break tasks into trainable steps and use systematic instruction to train on performing job tasks'' as MethodsTechniques
  union
  select ''Will assure successful transition from coaching supports to employer supports during fade'' as MethodsTechniques
 ) as c) as f
end



 /*CustomMapToEmploymentQuickObjectives*/
 SELECT ''CustomMapToEmploymentQuickObjectives'' as TableName
   ,[TPQuickId]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[ModifiedBy]
      ,[ModifiedDate]
      ,[RecordDeleted]
      ,[DeletedDate]
      ,[DeletedBy]
      ,[StaffId]
      ,[TPElementTitle]
      ,[TPElementOrder]
      ,[TPElementText]
      ,''N'' AS IsInitialize
    FROM CustomMapToEmploymentQuickObjectives CMEQO
 WHERE ISNULL(CMEQO.RecordDeleted,''N'')<>''Y'' and CMEQO.StaffId=@StaffID

END TRY
BEGIN CATCH
 DECLARE @Error varchar(8000)
 SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_InitializeDocumentMapToEmployments'')
    + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())
    + ''*****'' + Convert(varchar,ERROR_STATE())
 RAISERROR
 (
   @Error, -- Message text.
   16, -- Severity.
   1 -- State.
  );
END CATCH
END
    
' 
END
GO
