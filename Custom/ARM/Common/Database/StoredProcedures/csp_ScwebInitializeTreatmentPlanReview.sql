/****** Object:  StoredProcedure [dbo].[csp_ScwebInitializeTreatmentPlanReview]    Script Date: 08/27/2015 15:00:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ScwebInitializeTreatmentPlanReview]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ScwebInitializeTreatmentPlanReview]
GO

/****** Object:  StoredProcedure [dbo].[csp_ScwebInitializeTreatmentPlanReview]    Script Date: 08/27/2015 15:00:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 CREATE procedure [dbo].[csp_ScwebInitializeTreatmentPlanReview] --3,550,N''  
 -- Add the parameters for the stored procedure here  
 @ClientID int ,  
 @StaffID int,  
 @CustomParameters xml  
 AS  
BEGIN  
/*********************************************************************/  
/* Stored Procedure: [csp_ScwebInitializeTreatmentPlanReview]     */  
/* Creation Date:  27/May/2011               */  
/* Purpose: To Initialize Tables Used in the Harbor Treatment Plan that is latest Initialized Document*/  
/* Input Parameters: @ClientID ,@StaffID,@CustomParameters                  */  
/* Output Parameters:   Table Assoicated with the Harbor treatment Plan(6 tables)*/  
/* Modified By Davinder Kumar on 15-06-2011 CustomTPNeed Table Should Be Initialized              */  
/*       Author            */  
/*       Davinder Kumar          */  
/* Updates:                                                          */  
/*  Date              Author       Purpose                                    */  
   /* 10 Nov  2011   Priyanka added three new columns(ClientDidNotParticipate,ClientDidNotParticpateComment,ClientParticpatedPreviousDocumentation)  in  [CustomTreatmentPlans] tables  
   */  
-- 2012.02.14 - T. Remisoski - Only bring forward active goals and objectives.  Do not copy client participation.  
 /*   July 21, 2012  Pralyankar   Modified for implementing the Placeholder Concept*/  
 /* April 15 2016 - Pradeep Kumar Yadav  Added Status column in Select query of table CustomTpServices because its not initializing the values for Task #513 ARM-Support   */
 /* April 25 2016 - Pradeep Kumar Yadav  Added Status column in Select query of table CustomTpobjectives because its not initializing the values for Task #516 ARM-Support   */
-- Feb 26, 2018    Vijeta        Converted ssp_ScwebInitializeTreatmentPlanReview to csp_ScwebInitializeTreatmentPlanReview for task:	A Renewed Mind - Support #814
/*********************************************************************/  
BEGIN TRY  
declare @TransitionDischargeCriteria varchar(max), @ClientStrengths varchar(max)  
declare @RegistrationDate datetime  
Declare @DocumentIDDIAG as bigint   
  Declare @VersionDIAG as bigint  
    Declare @EffectiveDate Varchar(25)  
    Declare @CurrentMentalHealthDiagnoses varchar(max)   
    DECLARE @DocumentVersionId AS int  
  
SELECT  top 1  @DocumentIDDIAG = a.DocumentId,@VersionDIAG = a.CurrentDocumentVersionId,@EffectiveDate = convert(varchar, a.EffectiveDate, 103)   
FROM         Documents AS a INNER JOIN  
                      DocumentCodes AS Dc ON Dc.DocumentCodeId = a.DocumentCodeId INNER JOIN  
                      DocumentDiagnosisCodes AS DDC ON a.CurrentDocumentVersionId = DDC.DocumentVersionId                                                       
where a.ClientId = @ClientId and a.EffectiveDate <= convert(datetime, convert(varchar, getDate(),101))                                                          
and a.Status = 22 and Dc.DiagnosisDocument='Y' and isNull(a.RecordDeleted,'N')<>'Y' and isNull(Dc.RecordDeleted,'N')<>'Y'                                                                                         
order by a.EffectiveDate desc,a.ModifiedDate desc                                
   
set @CurrentMentalHealthDiagnoses ='Effective Date:'+ @EffectiveDate  
  
select @RegistrationDate = RegistrationDate  
from dbo.ClientEpisodes as ce  
where ce.ClientId = @ClientID  
and ISNULL(ce.RecordDeleted, 'N') <> 'Y'  
and not exists (  
 select *  
 from dbo.ClientEpisodes as ce2  
 where ce2.ClientId = ce.ClientId  
 and ISNULL(ce2.RecordDeleted, 'N') <> 'Y'  
 and ce2.EpisodeNumber > ce.EpisodeNumber  
)  
  
-- get the most recent discharge/transition criteria and client strengths  
select @TransitionDischargeCriteria = tp.DischargeTransitionCriteria, @ClientStrengths = tp.ClientStrengths  
from dbo.CustomTreatmentPlans as tp  
join dbo.DocumentVersions as dv on dv.DocumentVersionId = tp.DocumentVersionId  
join dbo.Documents as d on d.DocumentId = dv.DocumentId  
where d.ClientId = @ClientID  
and d.EffectiveDate >= ISNULL(@RegistrationDate, '1/1/1900')  
and d.Status = 22  
and ISNULL(d.RecordDeleted, 'N') <> 'Y'  
and ISNULL(dv.RecordDeleted, 'N') <> 'Y'  
and ISNULL(tp.RecordDeleted, 'N') <> 'Y'  
and not exists (  
 select *  
 from dbo.CustomTreatmentPlans as tp2  
 join dbo.DocumentVersions as dv2 on dv2.DocumentVersionId = tp2.DocumentVersionId  
 join dbo.Documents as d2 on d2.DocumentId = dv2.DocumentId  
 where d2.ClientId = d.ClientId  
 and d2.Status = 22  
 and (  
  (d2.EffectiveDate > d.EffectiveDate)  
  or (  
   d2.EffectiveDate = d.EffectiveDate  
   and d2.DocumentId > d.DocumentId  
  )  
 )  
 and ISNULL(d2.RecordDeleted, 'N') <> 'Y'  
 and ISNULL(dv2.RecordDeleted, 'N') <> 'Y'  
 and ISNULL(tp2.RecordDeleted, 'N') <> 'Y'  
)  
and not exists (  
 select *  
 from dbo.DocumentVersions as dv2  
 where dv2.DocumentId = dv.DocumentId  
 and dv2.Version > dv.Version  
 and ISNULL(dv2.RecordDeleted, 'N') <> 'Y'  
)   
  
select @DocumentVersionId = dv.DocumentVersionId  
from Documents as d  
join DocumentVersions as dv on dv.DocumentVersionId = d.CurrentDocumentVersionId  
where d.ClientId = @ClientId  
and d.DocumentCodeId in (1483,1484,1485)  
and d.Status = 22  
and isnull(d.RecordDeleted, 'N') <> 'Y'  
and not exists (  
 select *  
 from Documents as d2  
 join DocumentVersions as dv2 on dv2.DocumentVersionId = d2.CurrentDocumentVersionId  
 where d2.ClientId = d.ClientId  
 and d2.DocumentCodeId in (1483,1484,1485)  
 and d2.Status = 22  
 and isnull(d2.RecordDeleted, 'N') <> 'Y'  
 and (  
   (d2.EffectiveDate > d.EffectiveDate)  
   or (d2.EffectiveDate = d.EffectiveDate  
     and d2.DocumentId > d.DocumentId)  
 )  
)   
  
if @DocumentVersionId is not null  
begin  
  
---------CustomTreatMentPlan  
  
     -- select @DocumentVersionId as documentversionid  
 SELECT Placeholder.TableName --'CustomTreatmentPlans' AS   
  ,-1 as DocumentVersionID  
  ,CTP.CreatedBy  
  ,CTP.CreatedDate  
  ,CTP.ModifiedBy  
  ,CTP.ModifiedDate  
  ,CTP.RecordDeleted  
  ,CTP.DeletedDate  
  ,CTP.DeletedBy  
  ,@CurrentMentalHealthDiagnoses AS CurrentDiagnosis  
  ,CTP.ClientStrengths  
  ,CTP.DischargeTransitionCriteria  
  ,'N' as ClientParticipatedAndIsInAgreement  
  ,'N' as ClientDidNotParticipate  
  ,cast(null as varchar(max)) as ClientDidNotParticpateComment  
  ,'N' as ClientParticpatedPreviousDocumentation  
  ,cast(null as varchar(max)) as ReasonForUpdate  
 FROM (SELECT 'CustomTreatmentPlans' AS TableName, isnull(@DocumentVersionid,-1) as DocumentVersionId) AS Placeholder  
  LEFT OUTER JOIN CustomTreatmentPlans AS CTP ON CTP.DocumentVersionId = Placeholder.DocumentVersionid  
     
  
----------CustomTPNeed  
  
  SELECT  
    'CustomTPNeeds' AS TableName  
      ,CTN.NeedId  
      ,CTN.CreatedBy  
      ,CTN.CreatedDate  
      ,CTN.ModifiedBy  
      ,CTN.ModifiedDate  
      ,CTN.RecordDeleted  
      ,CTN.DeletedDate  
      ,CTN.DeletedBy  
      ,CTN.ClientId  
      ,CTN.NeedText  
      ,(Case when (select count(1) from CustomTPGoalNeeds where NeedId =CTN.NeedId and isnull(CustomTPGoalNeeds.RecordDeleted ,'N')<>'Y')>=1 then 'Y' else 'N' end) as LinkedInDb  
      ,(Case when (select count(1) from CustomTPGoalNeeds where NeedId =CTN.NeedId and isnull(CustomTPGoalNeeds.RecordDeleted ,'N')<>'Y')>=1 then 'Y' else 'N' end) as LinkedInSession  
    FROM CustomTPNeeds CTN 
    LEFT JOIN CustomTPGoalNeeds CTGN  on CTGN.NeedId=CTN.NeedId 
    LEFT JOIN CustomTPGoals CTG on CTGN.TPGoalId=CTG.TPGoalId  
    WHERE CTN.ClientId=@ClientId 
    AND CTG.DocumentVersionId=@DocumentVersionId    
    AND ISNULL(CTG.RecordDeleted,'N')='N'
    AND ISNULL(CTN.RecordDeleted,'N')='N'               
    AND ISNULL(CTGN.RecordDeleted,'N')='N'    
  
------------ CustomTPGoals  
-- if no active goals, create an empty one  
if 0 = (  
 select count(*) FROM CustomTPGoals  
 WHERE DocumentVersionId=@DocumentVersionId  
 and isnull(Active, 'Y') = 'Y'  
 AND ISNULL(RecordDeleted,'N')='N'  
)  
begin  
  SELECT 'CustomTPGoals' AS TableName,  
             '' AS CreatedBy,  
     GETDATE() AS CreatedDate,  
     '' AS ModifiedBy,  
     GETDATE() AS ModifiedDate,  
     -1 AS 'DocumentVersionId',  
     1 as 'GoalNumber',  
     cast(cast(dateadd(year, 1, getdate()) as date) as datetime) as TargeDate,  
     'Y' as Active  
   FROM  SystemConfigurations AS s LEFT OUTER JOIN  
      CustomTPGoals ON s.DatabaseVersion = - 1  
end  
else  
begin  
  SELECT    'CustomTPGoals' AS TableName,  
      TPGoalId  
     ,CreatedBy  
     ,CreatedDate  
     ,ModifiedBy  
     ,ModifiedDate  
     ,RecordDeleted  
     ,DeletedDate  
     ,DeletedBy  
     ,DocumentVersionId  
     -- renumber goals after dropping inactive  
     ,cast(row_number() over(order by GoalNumber) as int) as GoalNumber  
     ,GoalText  
     ,DATEADD(YEAR, 1, TargeDate) as TargeDate  
     ,isnull(Active, 'Y') as Active  
     ,ProgressTowardsGoal  
     ,'Y' as  DeletionNotAllowed  
   FROM CustomTPGoals  
   WHERE DocumentVersionId=@DocumentVersionId  
   and isnull(Active, 'Y') = 'Y'  
   AND ISNULL(RecordDeleted,'N')='N'  
end  
  
 ---------CustomTPGoalNeeds  
  
  SELECT   'CustomTPGoalNeeds' AS TableName,  
      CAST(-1 as int) as TPGoalNeeds --CTGN.TPGoalNeeds  
     ,CTGN.CreatedBy  
     ,CTGN.CreatedDate  
     ,CTGN.ModifiedBy  
     ,CTGN.ModifiedDate  
     ,CTGN.RecordDeleted  
     ,CTGN.DeletedDate  
     ,CTGN.DeletedBy  
     ,CTGN.TPGoalId  
     ,CTGN.NeedId  
     ,CTGN.DateNeedAddedToPlan  
     ,CTN.NeedText as NeedText  
   FROM CustomTPGoalNeeds CTGN  
   LEFT JOIN CustomTPGoals CTG on CTGN.TPGoalId=CTG.TPGoalId  
   LEFT JOIN CustomTPNeeds CTN on CTGN.NeedId=CTN.NeedId  
   WHERE CTG.DocumentVersionId=@DocumentVersionId   
   and isnull(ctg.Active, 'Y') = 'Y'  
   AND ISNULL(CTGN.RecordDeleted,'N')='N'  
   AND ISNULL(CTG.RecordDeleted,'N')='N'  
   AND ISNULL(CTN.RecordDeleted,'N')='N'  
   AND CTN.ClientId=@ClientId  
  
  
--------------CustomTPObjectives  
  
 SELECT    'CustomTPObjectives' AS TableName,  
      CTO.TPObjectiveId  
     ,CTO.CreatedBy  
     ,CTO.CreatedDate  
     ,CTO.ModifiedBy  
     ,CTO.ModifiedDate  
     ,CTO.RecordDeleted  
     ,CTO.DeletedDate  
     ,CTO.DeletedBy  
     ,CTO.TPGoalId
     ,CTO.[Status]  
     --,CTO.ObjectiveNumber  
     ,cast(  
   cast(row_number() over(partition by ctg.GoalNumber order by ctg.GoalNumber) as decimal(10,2)) +  
   cast(cast(row_number() over(partition by ctg.GoalNumber order by ctg.GoalNumber, CTO.ObjectiveNumber) as decimal(10,2)) * 0.01 as decimal(10,2))  
  as decimal(10,2)  
   ) as ObjectiveNumber  
     ,CTO.ObjectiveText  
     ,DATEADD(YEAR, 1, CTO.TargetDate) as TargetDate  
     ,'Y' as  DeletionNotAllowed  
    FROM CustomTPObjectives CTO  
    LEFT JOIN CustomTPGoals CTG on CTO.TPGoalId=CTG.TPGoalId  
    WHERE CTG.DocumentVersionId=@DocumentVersionId  
 and isnull(ctg.Active, 'Y') = 'Y'  
    AND ISNULL(CTO.RecordDeleted,'N')='N'  
    AND ISNULL(CTG.RecordDeleted,'N')='N'  
  
--------------CustomTPServices  
  
 SELECT   'CustomTPServices' AS TableName,  
      CTS.TPServiceId  
     ,CTS.CreatedBy  
     ,CTS.CreatedDate  
     ,CTS.ModifiedBy  
     ,CTS.ModifiedDate  
     ,CTS.RecordDeleted  
     ,CTS.DeletedDate  
     ,CTS.DeletedBy  
     ,CTS.TPGoalId
     ,CTS.[Status]  
     --,CTS.ServiceNumber  
  ,cast(  
   cast(row_number() over(partition by ctg.GoalNumber order by ctg.GoalNumber) as decimal(10,2)) +  
   cast(cast(row_number() over(partition by ctg.GoalNumber order by ctg.GoalNumber, cts.ServiceNumber) as decimal(10,2)) * 0.01 as decimal(10,2))  
  as decimal(10,2)  
   ) as ServiceNumber  
     ,CTS.AuthorizationCodeId  
     ,CTS.Units  
     ,CTS.FrequencyType  
     ,'Y' as  DeletionNotAllowed  
     ,(select GC.codename from GlobalCodes GC where exists (select Unittype from AuthorizationCodes where   GC.GlobalCodeId=UnitType and AuthorizationCodeId=CTS.AuthorizationCodeId)) as  UnitType  
   FROM CustomTPServices CTS  
   LEFT JOIN CustomTPGoals CTG ON CTS.TPGoalId= CTG.TPGoalId  
   LEFT JOIN AuthorizationCodes AC ON CTS.AuthorizationCodeId=AC.AuthorizationCodeId  
   WHERE CTG.DocumentVersionId=@DocumentVersionId  
   and isnull(ctg.Active, 'Y') = 'Y'  
   AND ISNULL(CTS.RecordDeleted,'N')='N'  
   AND ISNULL(CTG.RecordDeleted,'N')='N'  
   AND ISNULL(AC.RecordDeleted,'N')='N'  
   and AC.Active='Y'  
  
        -----------CustomTPGlobalQuickObjectives  
  
  
SELECT 'CustomTPQuickObjectives' as TableName,  
 TPQuickId  
      ,CreatedBy  
      ,CreatedDate  
      ,ModifiedBy  
      ,ModifiedDate  
      ,RecordDeleted  
      ,DeletedDate  
      ,DeletedBy  
      ,StaffId  
      ,TPElementTitle  
      ,TPElementOrder  
      ,TPElementText  
    from CustomTPQuickObjectives  
    WHERE ISNULL(RecordDeleted,'N')='N' and StaffId=@StaffID  
  
  
   -----------CustomTPGlobalQuickGoals  
  
   SELECT   'CustomTPGlobalQuickGoals' AS TableName,  
   TPQuickId  
     ,CreatedBy  
     ,CreatedDate  
     ,ModifiedBy  
     ,ModifiedDate  
     ,RecordDeleted  
     ,DeletedDate  
     ,DeletedBy  
     ,TPElementTitle  
     ,TPElementOrder  
     ,TPElementText  
   FROM CustomTPGlobalQuickGoals  
   WHERE ISNULL(RecordDeleted,'N')='N'  
  
    --CustomTPGlobalQuickTransitionPlans  
  SELECT 'CustomTPGlobalQuickTransitionPlans' as TableName  
   ,[TPQuickId]  
      ,[CreatedBy]  
      ,[CreatedDate]  
      ,[ModifiedBy]  
      ,[ModifiedDate]  
      ,[RecordDeleted]  
      ,[DeletedDate]  
      ,[DeletedBy]  
      ,[TPElementTitle]  
      ,[TPElementOrder]  
      ,[TPElementText]  
  FROM CustomTPGlobalQuickTransitionPlans  
  where ISNULL(RecordDeleted,'N')='N'  
END  
ELSE  
BEGIN  
  
-------TreatmentPlan  
  
  SELECT TOP (1) Placeholder.TableName, --'CustomTreatmentPlans' AS TableName,  
    - 1 AS 'DocumentVersionId',  
     '' AS CreatedBy,  
     GETDATE() AS CreatedDate,  
     '' AS ModifiedBy,  
     GETDATE() AS ModifiedDate,  
     @CurrentMentalHealthDiagnoses AS 'CurrentDiagnosis'  
     ,@TransitionDischargeCriteria as DischargeTransitionCriteria  
     ,@ClientStrengths as ClientStrengths  
   FROM  (SELECT 'CustomTreatmentPlans' AS TableName, -1 as DocumentVersionId) AS Placeholder --SystemConfigurations AS s   
  LEFT OUTER JOIN CustomTreatmentPlans On CustomTreatmentPlans.DocumentVersionId = Placeholder.DocumentVersionid -- ON s.DatabaseVersion = - 1  
  
------------CustomTPGoals  
  
  SELECT 'CustomTPGoals' AS TableName,  
             '' AS CreatedBy,  
     GETDATE() AS CreatedDate,  
     '' AS ModifiedBy,  
     GETDATE() AS ModifiedDate,  
     -1 AS 'DocumentVersionId',  
     1 as 'GoalNumber'  
   FROM  SystemConfigurations AS s LEFT OUTER JOIN  
      CustomTPGoals ON s.DatabaseVersion = - 1  
  
  
---------------CustomTPNeeds  
   SELECT  
    'CustomTPNeeds' AS TableName  
      ,CTN.NeedId  
      ,CTN.CreatedBy  
      ,CTN.CreatedDate  
      ,CTN.ModifiedBy  
      ,CTN.ModifiedDate  
      ,CTN.RecordDeleted  
      ,CTN.DeletedDate  
      ,CTN.DeletedBy  
      ,CTN.ClientId  
      ,CTN.NeedText  
      ,(Case when (select count(1) from CustomTPGoalNeeds where NeedId =CTN.NeedId and isnull(CustomTPGoalNeeds.RecordDeleted ,'N')<>'Y')>=1 then 'Y' else 'N' end) as LinkedInDb  
      ,'N' as LinkedInSession  
     FROM CustomTPNeeds CTN   
    LEFT JOIN CustomTPGoalNeeds CTGN  on CTGN.NeedId=CTN.NeedId   
    LEFT JOIN CustomTPGoals CTG on CTGN.TPGoalId=CTG.TPGoalId    
    WHERE CTN.ClientId=@ClientId   
    AND CTG.DocumentVersionId=@DocumentVersionId      
    AND ISNULL(CTG.RecordDeleted,'N')='N'  
    AND ISNULL(CTN.RecordDeleted,'N')='N'                 
    AND ISNULL(CTGN.RecordDeleted,'N')='N'   
  
  
       --CustomTPGlobalQuickGoals  
 SELECT 'CustomTPGlobalQuickGoals' AS TableName,  
    TPQuickId  
     ,CreatedBy  
     ,CreatedDate  
     ,ModifiedBy  
     ,ModifiedDate  
     ,RecordDeleted  
     ,DeletedDate  
     ,DeletedBy  
     ,TPElementTitle  
     ,TPElementOrder  
     ,TPElementText  
  FROM CustomTPGlobalQuickGoals  
  WHERE ISNULL(RecordDeleted,'N')='N'  
  
  -- CustomTpQuickObjectives  
  SELECT 'CustomTPQuickObjectives' AS TableName,  
     TPQuickId  
      ,CreatedBy  
      ,CreatedDate  
      ,ModifiedBy  
      ,ModifiedDate  
      ,RecordDeleted  
      ,DeletedDate  
      ,DeletedBy  
      ,StaffId  
      ,TPElementTitle  
      ,TPElementOrder  
      ,TPElementText  
   FROM CustomTPQuickObjectives  
   WHERE ISNULL(RecordDeleted,'N')='N' and StaffId=@StaffID  
  
     --CustomTPGlobalQuickTransitionPlans  
  SELECT 'CustomTPGlobalQuickTransitionPlans' as TableName  
   ,[TPQuickId]  
      ,[CreatedBy]  
      ,[CreatedDate]  
      ,[ModifiedBy]  
      ,[ModifiedDate]  
      ,[RecordDeleted]  
      ,[DeletedDate]  
      ,[DeletedBy]  
      ,[TPElementTitle]  
      ,[TPElementOrder]  
      ,[TPElementText]  
  FROM CustomTPGlobalQuickTransitionPlans  
  where ISNULL(RecordDeleted,'N')='N'  
  
END  
 select 'CurrentDiagnoses' as TableName  
 ,(CAST(ROW_NUMBER() over (order by ICD10.ICDDescription) as int) * -1) as CurrentDiagnosesId  
 ,CodeName , a.ICD9Code,a.ICD10Code  
 ,case ISNULL(ICD10.DSMVCode,'') when 'Y' then 'Yes' else 'No' end as DSMVCode  
   
 ,ICD10.ICDDescription   
 ,a.CreatedBy,  
  a.CreatedDate,  
  a.ModifiedBy,  
  a.ModifiedDate,  
  a.RecordDeleted,  
  a.DeletedBy,  
  a.DeletedDate        
from DocumentDiagnosisCodes a                                
 INNER JOIN GlobalCodes b on a.DiagnosisType=b.GlobalCodeid    
 INNER JOIN DiagnosisICD10Codes ICD10 ON ICD10.ICD10CodeId = a.ICD10CodeId            
where DocumentDiagnosisCodeId in (select DocumentDiagnosisCodeId from dbo.DocumentDiagnosisCodes    
 where DocumentVersionId = @VersionDIAG and isNull(RecordDeleted,'N')<>'Y')                         
       
 and isNull(a.RecordDeleted,'N')<>'Y'  and billable ='Y' order by DiagnosisOrder  
END TRY  
BEGIN CATCH  
 DECLARE @Error varchar(8000)  
 SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())  
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_ScwebInitializeTreatmentPlanReview')  
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())  
    + '*****' + Convert(varchar,ERROR_STATE())  
 RAISERROR  
 (  
   @Error, -- Message text.  
   16, -- Severity.  
   1 -- State.  
  );  
END CATCH  
  
  
 --NEED  
  
  
  
END  
  
GO


