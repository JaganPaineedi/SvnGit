/****** Object:  StoredProcedure [dbo].[ssp_ScWebGetTreatmentPlanInitial]    Script Date: 08/20/2015 13:04:38 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ScWebGetTreatmentPlanInitial]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ScWebGetTreatmentPlanInitial]
GO

/****** Object:  StoredProcedure [dbo].[ssp_ScWebGetTreatmentPlanInitial]    Script Date: 08/20/2015 13:04:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 CREATE PROCEDURE [dbo].[ssp_ScWebGetTreatmentPlanInitial] --220,550              
 -- Add the parameters for the stored procedure here              
 @DocumentVersionId as int,                                                                                                                           
 @StaffId as int              
 --@ClientId as int               
 AS              
BEGIN              
-- =============================================              
-- Author:  <Davinder Kumar >              
-- Create date: <26th May 2011>              
-- Description: <To get The Data for the Screen CustomTreatmentPlanInitial>              
-- =============================================              
/*********************************************************************/                                                                                  
/* Stored Procedure: [ssp_ScwebInitializeTreatmentPlanInitial]     */                                                                         
/* Creation Date:  26/May/2011               */                                                                                  
/* Purpose: To get The Data for the Screen CustomTreatmentPlanInitial*/                                                                                
/* Input Parameters: @DocumentVersionId ,@StaffID                  */                                                                                
/* Output Parameters:   Table Assoicated with the Harbor treatment Plan(6 tables)*/                                                                                  
                                                                         
/*********************************************************************/            
 -- CustomTreatmentPlan               
 -- Diagnosis/Strengths/discharge/transition criteria              
               
 --declare @DocumentId int              
 BEGIN TRY                            
declare @ClientId int   
Declare @DocumentIDDIAG as bigint                                                                                                
    Declare @VersionDIAG as bigint  
    Declare @EffectiveDate Varchar(25)  
    Declare @CurrentMentalHealthDiagnoses varchar(max)  
    Select  @ClientId=ClientId from Documents D inner join Documentversions DV on DV.DocumentID=D.DocumentID      
where DV.DocumentVersionId=@DocumentVersionId   
    SELECT  top 1  @DocumentIDDIAG = a.DocumentId,@VersionDIAG = a.CurrentDocumentVersionId,@EffectiveDate = convert(varchar, a.EffectiveDate, 103)   
FROM         Documents AS a INNER JOIN  
                      DocumentCodes AS Dc ON Dc.DocumentCodeId = a.DocumentCodeId INNER JOIN  
                      DocumentDiagnosisCodes AS DDC ON a.CurrentDocumentVersionId = DDC.DocumentVersionId                                                       
where a.ClientId = @ClientId and a.EffectiveDate <= convert(datetime, convert(varchar, getDate(),101))                                                          
and a.Status = 22 and Dc.DiagnosisDocument='Y' and isNull(a.RecordDeleted,'N')<>'Y' and isNull(Dc.RecordDeleted,'N')<>'Y'                                                                                         
order by a.EffectiveDate desc,a.ModifiedDate desc                                
   
set @CurrentMentalHealthDiagnoses ='Effective Date:'+ @EffectiveDate  
                                                        
               
 SELECT               
    DocumentVersionId              
      ,CreatedBy              
      ,CreatedDate              
      ,ModifiedBy              
      ,ModifiedDate              
      ,RecordDeleted              
      ,DeletedDate              
      ,DeletedBy              
      ,@CurrentMentalHealthDiagnoses as CurrentDiagnosis              
      ,ClientStrengths              
      ,DischargeTransitionCriteria              
      ,ClientParticipatedAndIsInAgreement              
      ,ReasonForUpdate    
      ,ClientParticpatedPreviousDocumentation    
      ,ClientDidNotParticipate    
 FROM CustomTreatmentPlans              
 WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,'N')='N'              
             
 --CustomTPNeed              
               
 --SELECT               
 --   NeedId              
 --     ,CreatedBy              
 --     ,CreatedDate              
 --     ,ModifiedBy              
 --     ,ModifiedDate              
 --     ,RecordDeleted              
 --     ,DeletedDate              
 --     ,DeletedBy              
 --     ,ClientId              
 --     ,NeedText              
 --FROM CustomTPNeeds              
 --WHERE ClientId=@ClientId AND ISNULL(RecordDeleted,'N')='N'              
            
 --CustomTPGoals           
            
 SELECT               
    TPGoalId              
      ,CreatedBy              
      ,CreatedDate              
      ,ModifiedBy              
      ,ModifiedDate              
      ,RecordDeleted              
      ,DeletedDate              
      ,DeletedBy              
      ,DocumentVersionId              
      ,CAST( GoalNumber as integer) as GoalNumber              
      ,GoalText              
      ,TargeDate              
      ,Active              
      ,ProgressTowardsGoal              
      ,DeletionNotAllowed            
 FROM CustomTPGoals              
 WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,'N')='N'              
            
---------------CustomTPNeeds              
  SELECT             
      NeedId                
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
 --CustomTPGoalNeeds              
              
 SELECT               
    CTGN.TPGoalNeeds              
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
      --,CTN.NeedText as NeedText            
 FROM CustomTPGoalNeeds CTGN               
 LEFT JOIN CustomTPGoals CTG on CTGN.TPGoalId=CTG.TPGoalId               
 LEFT JOIN CustomTPNeeds CTN on CTGN.NeedId=CTN.NeedId              
 WHERE CTG.DocumentVersionId=@DocumentVersionId AND ISNULL(CTGN.RecordDeleted,'N')='N'   AND ISNULL(CTG.RecordDeleted,'N')='N'      
      AND ISNULL(CTN.RecordDeleted,'N')='N' and CTN.ClientId=@ClientId      
            
--------------CustomTPObjectives              
               
 SELECT               
    CTO.TPObjectiveId              
      ,CTO.CreatedBy              
      ,CTO.CreatedDate              
      ,CTO.ModifiedBy              
      ,CTO.ModifiedDate              
      ,CTO.RecordDeleted              
      ,CTO.DeletedDate              
      ,CTO.DeletedBy              
      ,CTO.TPGoalId              
      ,CTO.ObjectiveNumber              
      ,CTO.ObjectiveText              
      ,CTO.TargetDate             
      ,CTO.DeletionNotAllowed            
      FROM CustomTPObjectives CTO              
      LEFT JOIN CustomTPGoals CTG on CTO.TPGoalId=CTG.TPGoalId          
      WHERE CTG.DocumentVersionId=@DocumentVersionId AND ISNULL(CTO.RecordDeleted,'N')='N'    AND ISNULL(CTG.RecordDeleted,'N')='N'               
             
--------------CustomTPServices              
                    
      SELECT               
    CTS.TPServiceId          
      ,CTS.CreatedBy              
      ,CTS.CreatedDate              
      ,CTS.ModifiedBy              
      ,CTS.ModifiedDate              
      ,CTS.RecordDeleted              
      ,CTS.DeletedDate              
      ,CTS.DeletedBy              
      ,CTS.TPGoalId              
      ,CTS.ServiceNumber              
      ,CTS.AuthorizationCodeId              
      ,CTS.Units              
      ,CTS.FrequencyType             
      ,CTS.DeletionNotAllowed             
      ,(select GC.codename from GlobalCodes GC where exists (select Unittype from AuthorizationCodes where   GC.GlobalCodeId=UnitType and AuthorizationCodeId=CTS.AuthorizationCodeId)) as  UnitType            
  FROM CustomTPServices CTS              
  LEFT JOIN CustomTPGoals CTG ON CTS.TPGoalId= CTG.TPGoalId             
  LEFT JOIN AuthorizationCodes AC ON CTS.AuthorizationCodeId=AC.AuthorizationCodeId       
  WHERE CTG.DocumentVersionId=@DocumentVersionId AND ISNULL(CTS.RecordDeleted,'N')='N'     AND ISNULL(CTG.RecordDeleted,'N')='N'       
  AND ISNULL(AC.RecordDeleted,'N')='N'   and isnull(AC.Active,'N')='Y'   
             
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
       
-----------CustomTPGlobalQuickGoals              
              
 SELECT               
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
                 
---------CustomTPQuickObjectives              
                    
      SELECT               
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
   WHERE StaffId=@StaffId AND ISNULL(RecordDeleted,'N')='N'              
              
  --CustomTPGlobalQuickTransitionPlans            
  SELECT [TPQuickId]            
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
                
           
       
END TRY            
BEGIN CATCH            
 DECLARE @Error varchar(8000)                                                           
 SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())              
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_ScWebGetTreatmentPlanInitial')                                                                                         
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                               
    + '*****' + Convert(varchar,ERROR_STATE())                                      
 RAISERROR                                                                                         
 (                                                           
   @Error, -- Message text.                                                                                        
   16, -- Severity.                                                                                        
   1 -- State.                                                                                        
  );             
END CATCH                 
END      
GO


