/****** Object:  StoredProcedure [dbo].[ssp_ScwebInitializeTreatmentPlanInitial]    Script Date: 08/20/2015 13:08:15 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ScwebInitializeTreatmentPlanInitial]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ScwebInitializeTreatmentPlanInitial]
GO

/****** Object:  StoredProcedure [dbo].[ssp_ScwebInitializeTreatmentPlanInitial]    Script Date: 08/20/2015 13:08:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 CREATE PROCEDURE [dbo].[ssp_ScwebInitializeTreatmentPlanInitial] --3,550,N''  
 -- Add the parameters for the stored procedure here  
 @ClientID int ,  
 @StaffID int,  
 @CustomParameters xml  
 AS  
BEGIN  
/*********************************************************************/  
/* Stored Procedure: [ssp_ScwebInitializeTreatmentPlanInitial]       */  
/* Creation Date:  27/May/2011                                       */  
/* Purpose: To Initialize Tables Used in the Harbor Treatment Plan that is latest Signed Document*/  
/* Input Parameters: @ClientID ,@StaffID,@CustomParameters           */  
/* Output Parameters:   Table Assoicated with the Harbor treatment Plan(6 tables)*/  
/* Modified By Davinder Kumar on 15-06-2011 CustomTPNeed Table Should Be Initialized              */  
/*       Author            */  
/*       Davinder Kumar          */  
-- 2012.02.14 - T. Remisoski - Nothing except strengths and discharge criteria carried forward from any previous plan.  Set target date and active flag for goal 1.  
-- 5/6/2012   -- Maninder -- Commented statements for TPQuick  
-- July 21, 2012   Pralyankar    Modified for Placeholder Concept  
/*********************************************************************/  
BEGIN TRY  
  
 declare @TransitionDischargeCriteria varchar(max), @ClientStrengths varchar(max)  
 declare @RegistrationDate datetime  
 Declare @DocumentIDDIAG as bigint                                                                                                
    Declare @VersionDIAG as bigint  
    Declare @EffectiveDate Varchar(25)  
    Declare @CurrentMentalHealthDiagnoses varchar(max)    
      
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
)  and not exists (  
 select *  
 from dbo.DocumentVersions as dv2  
 where dv2.DocumentVersionId = dv.DocumentVersionId  
 and dv2.Version > dv.Version  
 and ISNULL(dv2.RecordDeleted, 'N') <> 'Y'  
)  
  
  -------Added on 10 June 2011 by Davinder kumar for the initialization of Current Signed Diagonosis  
 -- DECLARE @VersionDIAG AS int;  
 --  SELECT TOP 1 @VersionDIAG = a.CurrentDocumentVersionId  
 -- FROM Documents a WHERE a.ClientId = @ClientID  
 -- and a.EffectiveDate <= CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(),101))  
 -- and a.Status = 22  
 -- and a.DocumentCodeId =5  
 -- and ISNULL(a.RecordDeleted,'N')<>'Y'  
 -- ORDER BY a.EffectiveDate DESC,ModifiedDate DESC  
  
 -- DECLARE @DocmentVersionId AS int;  
 -- DECLARE @Diagnosis VARCHAR(MAX)  
  
 -- SET @Diagnosis='AxisI-II'+ CHAR(9) + 'DSM Code'  + CHAR(9) + CHAR(9) + 'Type' + CHAR(9) + 'Version' + CHAR(9) + 'Description' + CHAR(13)  
  
 -- SELECT @Diagnosis = @Diagnosis + ISNULL(CAST(a.Axis AS VARCHAR),CHAR(9)) + CHAR(9)  
 --+ ISNULL(CAST(a.DSMCode + case when a.RuleOut = 'Y' then ' (R/O)' else '' end AS VARCHAR),CHAR(9)) + CHAR(9)+ CHAR(9)   
 --+ ISNULL(CAST(b.CodeName AS VARCHAR),CHAR(9)) + CHAR(9) + ISNULL(CAST(a.DSMVersion AS VARCHAR),' ') + CHAR(9)  
 --+ ISNULL(dsc.DSMDescription, '')  
 --+ CHAR(13)  
 ----,a.DSMNumber  
 -- FROM DiagnosesIAndII a  
 -- join dbo.DiagnosisDSMDescriptions as dsc on dsc.DSMCode = a.DSMCode and dsc.DSMNumber = a.DSMNumber  
 -- Join GlobalCodes b ON a.DiagnosisType=b.GlobalCodeid  
 -- WHERE a.DocumentVersionId = @VersionDIAG  
 -- and ISNULL(a.RecordDeleted, 'N') <> 'Y'  
 -- and a.Billable = 'Y'  
 -- order by a.DiagnosisOrder  
  
-----------------------------End Added Section-------------------------------------------------------------------  
  
  
-------TreatmentPlan  
  
 SELECT TOP (1) Placeholder.TableName, -- 'CustomTreatmentPlans' AS TableName,  
  - 1 AS 'DocumentVersionId',  
  '' AS CreatedBy,  
  GETDATE() AS CreatedDate,  
  '' AS ModifiedBy,  
  GETDATE() AS ModifiedDate  
  ,@CurrentMentalHealthDiagnoses as  CurrentDiagnosis  
  ,@TransitionDischargeCriteria as DischargeTransitionCriteria  
  ,@ClientStrengths as ClientStrengths  
 FROM (SELECT 'CustomTreatmentPlans' AS TableName, -1 as DocumentVersionId) AS Placeholder --SystemConfigurations AS s   
  LEFT OUTER JOIN CustomTreatmentPlans ON CustomTreatmentPlans.DocumentVersionId = Placeholder.DocumentVersionId --s.DatabaseVersion = - 1  
  
  
------------ CustomTPGoals -------------  
  
  SELECT  'CustomTPGoals' AS TableName,  
             '' AS CreatedBy,  
     GETDATE() AS CreatedDate,  
     '' AS ModifiedBy,  
     GETDATE() AS ModifiedDate,  
     -1 AS 'DocumentVersionId'  
     ,1 AS 'GoalNumber',  
     cast(cast(dateadd(year, 1, getdate()) as date) as datetime) as TargeDate,  
     'Y' as Active  
   FROM  SystemConfigurations AS s LEFT OUTER JOIN  
      CustomTPGoals ON s.DatabaseVersion = - 1  
---------------CustomTPNeeds  
  SELECT  
    'CustomTPNeeds' AS TableName  
      ,NeedId  
      ,CreatedBy  
      ,CreatedDate  
      ,ModifiedBy  
      ,ModifiedDate  
      ,RecordDeleted  
      ,DeletedDate  
      ,DeletedBy  
      ,ClientId  
      ,NeedText  
      ,(Case when (select count(1) from CustomTPGoalNeeds where NeedId =CustomTPNeeds.NeedId and isnull(CustomTPGoalNeeds.RecordDeleted ,'N')<>'Y')>=1 then 'Y' else 'N' end) as LinkedInDb  
      ,'N' as LinkedInSession  
    FROM CustomTPNeeds  
    WHERE ClientId=@ClientId AND ISNULL(RecordDeleted,'N')='N'  
  
 --        --CustomTPGlobalQuickGoals  
 --SELECT 'CustomTPGlobalQuickGoals' AS TableName,  
 --   TPQuickId  
 --    ,CreatedBy  
 --    ,CreatedDate  
 --    ,ModifiedBy  
 --    ,ModifiedDate  
 --    ,RecordDeleted  
 --    ,DeletedDate  
 --    ,DeletedBy  
 --    ,TPElementTitle  
 --    ,TPElementOrder  
 --    ,TPElementText  
 -- FROM CustomTPGlobalQuickGoals  
  
 -- -- CustomTpQuickObjectives  
 -- SELECT 'CustomTPQuickObjectives' AS TableName,  
 --    TPQuickId  
 --     ,CreatedBy  
 --     ,CreatedDate  
 --     ,ModifiedBy  
 --     ,ModifiedDate  
 --  ,RecordDeleted  
 --     ,DeletedDate  
 --     ,DeletedBy  
 --     ,StaffId  
 --     ,TPElementTitle  
 --     ,TPElementOrder  
 --     ,TPElementText  
 --  FROM CustomTPQuickObjectives  WHERE StaffId=@StaffID  
  
 --    --CustomTPGlobalQuickTransitionPlans  
 --  select 'CustomTPGlobalQuickTransitionPlans' as TableName  
 --     ,[TPQuickId]  
 --     ,[CreatedBy]  
 --     ,[CreatedDate]  
 --     ,[ModifiedBy]  
 --     ,[ModifiedDate]  
 --     ,[RecordDeleted]  
 --     ,[DeletedDate]  
 --     ,[DeletedBy]  
 --     ,[TPElementTitle]  
 --     ,[TPElementOrder]  
 --     ,[TPElementText]  
 -- FROM CustomTPGlobalQuickTransitionPlans  
  
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
 INNER JOIN DiagnosisICD10Codes ICD10 ON ICD10.ICD10CodeId = a.Icd10codeid            
where DocumentDiagnosisCodeId in (select DocumentDiagnosisCodeId from dbo.DocumentDiagnosisCodes    
 where DocumentVersionId = @VersionDIAG and isNull(RecordDeleted,'N')<>'Y')                         
       
 and isNull(a.RecordDeleted,'N')<>'Y'  and billable ='Y' order by DiagnosisOrder  
  
  
END TRY  
BEGIN CATCH  
 DECLARE @Error varchar(8000)  
 SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())  
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_ScwebInitializeTreatmentPlanInitial')  
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


