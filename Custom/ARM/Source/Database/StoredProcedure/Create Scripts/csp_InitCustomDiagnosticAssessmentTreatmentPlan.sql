/****** Object:  StoredProcedure [dbo].[csp_InitCustomDiagnosticAssessmentTreatmentPlan]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomDiagnosticAssessmentTreatmentPlan]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomDiagnosticAssessmentTreatmentPlan]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomDiagnosticAssessmentTreatmentPlan]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[csp_InitCustomDiagnosticAssessmentTreatmentPlan]    
(    
  @ClientID int,
  @StaffId int
)                                                                                                    
As                                                                                                           
  Begin                                                                                                              
 /*********************************************************************/                                                                                                                
 /* Stored Procedure: csp_InitCustomDiagnosticAssessmentTreatmentPlan               */                                                                                                       
 /*                                                                   */                                                                                                                
 /* Purpose: To Initialize */                                                                                                               
 /*                                                                   */                                                                                                              
 /* Called By:Diagnostic Assessment   */                                                                                                      
 /*                                                                   */                                                                                                                
 /* Data Modifications:                                               */                                                                                                                
 /*     */                                                            
 /*   Updates:                                                          */                                                    
 /*     Author                  Purpose                              */                                                                              
 /*     Ashwani             To Initialize Treatment Plan Data      */       
 /* 06-June-2012   Jagdeep         Commented table CustomTPQuickObjectives,CustomTPGlobalQuickTransitionPlans,CustomTPGlobalQuickGoals Now they are directly being updated into database  */      
 /*********************************************************************/                                                     
BEGIN TRY        
  -------for the initialization of Current Signed Diagonosis           
  DECLARE @VersionDIAG AS int;          
  SELECT TOP 1 @VersionDIAG = a.CurrentDocumentVersionId                                                                       
  FROM Documents a WHERE a.ClientId = @ClientID                                                                        
  and a.EffectiveDate <= CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(),101))                                                                       
  and a.Status = 22                                                                                                        
  and a.DocumentCodeId =1486                                                                      
  and ISNULL(a.RecordDeleted,''N'')<>''Y''                                                                       
  ORDER BY a.EffectiveDate DESC,ModifiedDate DESC             
  
  DECLARE @DocmentVersionId AS int;     
  DECLARE @Diagnosis VARCHAR(MAX)                                                
          
  SET @Diagnosis=''AxisI-II''+ CHAR(9) + ''DSM Code''  + CHAR(9) + ''Type'' + CHAR(9) + ''Version'' + CHAR(13)                                                
                                                
  SELECT @Diagnosis = @Diagnosis + ISNULL(CAST(a.Axis AS VARCHAR),CHAR(9)) + CHAR(9)+ ISNULL(CAST(a.DSMCode AS VARCHAR),CHAR(9)) + CHAR(9)+ CHAR(9) + ISNULL(CAST(b.CodeName AS VARCHAR),CHAR(9)) + CHAR(9) + ISNULL(CAST(a.DSMVersion AS VARCHAR),'' '') + CHAR(
  
13)--,a.DSMNumber                                                 
  FROM DiagnosesIAndII a                                   
  Join GlobalCodes b ON a.DiagnosisType=b.GlobalCodeid                                                    
  WHERE DiagnosisId in (SELECT DiagnosisId FROM dbo.DiagnosesIAndII WHERE DocumentVersionId =@VersionDIAG  and ISNULL(RecordDeleted,''N'')<>''Y'')                                                                   
  and ISNULL(a.RecordDeleted,''N'')<>''Y''  and a.billable =''Y'' ORDER BY Axis               
            
  IF(exists(SELECT        
     1        
   FROM CustomTreatmentPlans CTP,Documents D                                  
   -- before modify where C.DocumentId=D.DocumentId and D.ClientId=@ClientID                                      
   WHERE CTP.DocumentVersionId =D.CurrentDocumentVersionId AND D.DocumentCodeId=1486 AND D.ClientId=@ClientID                                      
   AND D.Status=22 AND IsNull(CTP.RecordDeleted,''N'')=''N'' AND IsNull(D.RecordDeleted,''N'')=''N''))           
                                  
BEGIN             
        
---------CustomTreatMentPlan         
        
    set @DocmentVersionId= (SELECT TOP (1) CurrentDocumentVersionId FROM Documents where ClientId=@ClientID AND Status =22 AND DocumentCodeId=1486 AND ISNULL(RecordDeleted, ''N'') = ''N'' order by ModifiedDate desc)               
       SELECT TOP (1) ''CustomTreatmentPlans'' AS TableName,         
      CTP.DocumentVersionId         
     ,CTP.CreatedBy        
     ,CTP.CreatedDate        
     ,CTP.ModifiedBy        
     ,CTP.ModifiedDate        
     ,CTP.RecordDeleted        
     ,CTP.DeletedDate        
     ,CTP.DeletedBy        
     ,@Diagnosis as  CurrentDiagnosis        
     ,CTP.ClientStrengths        
     ,CTP.DischargeTransitionCriteria        
     ,CTP.ClientParticipatedAndIsInAgreement        
     ,CTP.ReasonForUpdate  
     ,CTP.ClientDidNotParticipate
     ,CTP.ClientDidNotParticpateComment
     ,CTP.ClientParticpatedPreviousDocumentation     
   FROM  CustomTreatmentPlans AS CTP INNER JOIN        
      Documents AS D ON CTP.DocumentVersionId = D.CurrentDocumentVersionId        
   WHERE (D.ClientId = @ClientID) AND (D.Status = 22) AND (ISNULL(CTP.RecordDeleted, ''N'') = ''N'') AND (ISNULL(D.RecordDeleted, ''N'') = ''N'')        
   ORDER BY D.EffectiveDate DESC, D.ModifiedDate DESC        
         
        
  SELECT   ''CustomTPGoals'' AS TableName,        
      TPGoalId        
     ,CreatedBy        
     ,CreatedDate        
     ,ModifiedBy        
     ,ModifiedDate        
     ,RecordDeleted        
     ,DeletedDate        
     ,DeletedBy        
     ,DocumentVersionId        
     ,cast(GoalNumber as integer) as GoalNumber        
     ,GoalText        
     ,TargeDate        
     ,Active        
     ,ProgressTowardsGoal       
     ,DeletionNotAllowed       
   FROM CustomTPGoals        
   WHERE DocumentVersionId=@DocmentVersionId AND ISNULL(RecordDeleted,''N'')=''N''        
         
   ---------------CustomTPNeeds        
  SELECT          
    ''CustomTPNeeds'' AS TableName        
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
      ,(Case when (select count(1) from CustomTPGoalNeeds where NeedId =CustomTPNeeds.NeedId and isnull(CustomTPGoalNeeds.RecordDeleted ,''N'')<>''Y'')>=1 then ''Y'' else ''N'' end) as LinkedInDb        
      ,''N'' as LinkedInSession       
    FROM CustomTPNeeds          
    WHERE ClientId=@ClientId AND ISNULL(RecordDeleted,''N'')=''N''      
         
 ---------CustomTPGoalNeeds        
        
  SELECT    ''CustomTPGoalNeeds'' AS TableName,        
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
   WHERE CTG.DocumentVersionId=@DocmentVersionId AND ISNULL(CTGN.RecordDeleted,''N'')=''N''  AND ISNULL(CTG.RecordDeleted,''N'')=''N''          
   AND ISNULL(CTN.RecordDeleted,''N'')=''N''
        
        
--------------CustomTPObjectives        
        
 SELECT    ''CustomTPObjectives'' AS TableName,        
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
    WHERE CTG.DocumentVersionId=@DocmentVersionId AND ISNULL(CTO.RecordDeleted,''N'')=''N''      AND ISNULL(CTG.RecordDeleted,''N'')=''N''    
        
--------------CustomTPServices        
        
 SELECT   ''CustomTPServices'' AS TableName,        
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
   WHERE CTG.DocumentVersionId=@DocmentVersionId AND ISNULL(CTS.RecordDeleted,''N'')=''N''  AND ISNULL(CTG.RecordDeleted,''N'')=''N''  AND ISNULL(AC.RecordDeleted,''N'')=''N''         
   /*        
   --CustomTPGlobalQuickGoals        
   select ''CustomTPGlobalQuickGoals'' as TableName      
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
  FROM CustomTPGlobalQuickGoals      
   -- CustomTpQuickObjectives        
  select ''CustomTPQuickObjectives'' as TableName      
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
  FROM CustomTPQuickObjectives WHERE StaffId=@StaffID     
            
    --CustomTPGlobalQuickTransitionPlans        
   select ''CustomTPGlobalQuickTransitionPlans'' as TableName      
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
 */          
END                                  
 ELSE                                  
BEGIN          
             
-------TreatmentPlan        
                           
  SELECT TOP (1) ''CustomTreatmentPlans'' AS TableName,         
    - 1 AS ''DocumentVersionId'',        
     '''' AS CreatedBy,        
     GETDATE() AS CreatedDate,         
     '''' AS ModifiedBy,         
     GETDATE() AS ModifiedDate       
     ,@Diagnosis as  CurrentDiagnosis         
   FROM  SystemConfigurations AS s LEFT OUTER JOIN        
      CustomTreatmentPlans ON s.DatabaseVersion = - 1        
              
       
------------CustomTPGoals        
        
  SELECT  ''CustomTPGoals'' AS TableName,        
             '''' AS CreatedBy,        
     GETDATE() AS CreatedDate,         
     '''' AS ModifiedBy,         
     GETDATE() AS ModifiedDate,        
     -1 AS ''DocumentVersionId''        
     ,1 AS ''GoalNumber''
     ,CAST(CAST(DATEADD(YEAR, 1, GETDATE()) as date) as datetime) as TargeDate       
   FROM  SystemConfigurations AS s LEFT OUTER JOIN        
      CustomTPGoals ON s.DatabaseVersion = - 1        
---------------CustomTPNeeds        
  SELECT          
    ''CustomTPNeeds'' AS TableName        
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
      ,(Case when (select count(1) from CustomTPGoalNeeds where NeedId =CustomTPNeeds.NeedId and isnull(CustomTPGoalNeeds.RecordDeleted ,''N'')<>''Y'')>=1 then ''Y'' else ''N'' end) as LinkedInDb        
      ,''N'' as LinkedInSession       
    FROM CustomTPNeeds          
    WHERE ClientId=@ClientId AND ISNULL(RecordDeleted,''N'')=''N''       
  
  /*         
         --CustomTPGlobalQuickGoals        
 SELECT ''CustomTPGlobalQuickGoals'' AS TableName,        
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
  where ISNULL(CustomTPGlobalQuickGoals.RecordDeleted, ''N'') = ''N''   
          
  -- CustomTpQuickObjectives        
  SELECT ''CustomTPQuickObjectives'' AS TableName,        
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
   FROM CustomTPQuickObjectives  WHERE StaffId=@StaffID   and ISNULL(CustomTPQuickObjectives.RecordDeleted, ''N'') = ''N''     
           
     --CustomTPGlobalQuickTransitionPlans        
   select ''CustomTPGlobalQuickTransitionPlans'' as TableName      
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
  FROM CustomTPGlobalQuickTransitionPlans    WHERE  ISNULL(CustomTPGlobalQuickTransitionPlans.RecordDeleted, ''N'') = ''N''     
*/

END        
END TRY        
  BEGIN CATCH        
  DECLARE @Error varchar(8000)                                                       
  SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                     
  + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_InitCustomDiagnosticAssessmentTreatmentPlan'')                                                                                     
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
