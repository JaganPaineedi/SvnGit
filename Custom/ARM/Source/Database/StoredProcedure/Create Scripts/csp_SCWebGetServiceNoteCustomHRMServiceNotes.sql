/****** Object:  StoredProcedure [dbo].[csp_SCWebGetServiceNoteCustomHRMServiceNotes]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCWebGetServiceNoteCustomHRMServiceNotes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCWebGetServiceNoteCustomHRMServiceNotes]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCWebGetServiceNoteCustomHRMServiceNotes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_SCWebGetServiceNoteCustomHRMServiceNotes]                 
(                    
 @DocumentVersionId  int                                                                                                                                       
)                    
As          
/******************************************************************************            
**  Name: csp_SCWebGetServiceNoteCustomHRMServiceNotes            
**  Desc: This fetches data for Service Note Custom Tables           
**            
**  This template can be customized:            
**                          
**  Return values:            
**             
**  Parameters:            
**  Input       Output            
**     ----------      -----------            
**  DocumentVersionId    Result Set containing values from Service Note Custom Tables          
**            
**  Auth: Mohit Maddan          
**  Date: 30-March-10            
*******************************************************************************            
**  Change History            
*******************************************************************************            
**  Date:    Author:      Description:  
    05 August 2010      Jitender Kumar Kamboj    commented  HRMServiceNoteId  column                              
**  --------   --------   -------------------------------------------            
          
*******************************************************************************/            
BEGIN TRY            
 SELECT   
 --[HRMServiceNoteId]  --Commented by Jitender on 05 August 2010          
      [DocumentVersionId]          
      ,[ServiceType]          
      ,[ServiceModality]          
      ,[ServiceModalityComment]          
      ,[Diagnosis]          
      ,[ChangeMoodAffect]          
      ,[ChangeMoodAffectComment]          
      ,[ChangeThoughtProcess]          
      ,[ChangeThoughtProcessComment]          
      ,[ChangeBehavior]          
      ,[ChangeBehaviorComment]          
      ,[ChangeMedicalCondition]          
      ,[ChangeMedicalConditionComment]          
      ,[ChangeSubstanceUse]          
      ,[ChangeSubstanceUseComment]          
      ,[RiskNoneReported]          
      ,[RiskSelf]          
      ,[RiskOthers]          
      ,[RiskProperty]          
      ,[RiskIdeation]          
      ,[RiskPlan]          
      ,[RiskIntent]          
      ,[RiskAttempt]          
      ,[RiskOther]          
      ,[RiskOtherComment]          
      ,[RiskResponseComment]          
      ,[MedicationConcerns]          
      ,[MedicationConcernsComment]          
      ,[ProgressTowardOutcomeComment]          
      ,[ClinicalInterventionComment]          
      ,[AxisV]     
      ,ProgressTowardOutcomeAndClinicalInterventionComment    
      ,[NotifyStaffId1]          
      ,[NotifyStaffId2]          
      ,[NotifyStaffId3]          
      ,[NotifyStaffId4]          
      ,[NotificationMessage]          
      ,[CreatedBy]          
      ,[CreatedDate]          
      ,[ModifiedBy]          
      ,[ModifiedDate]          
      ,[RecordDeleted]          
      ,[DeletedDate]          
      ,[DeletedBy]          
  FROM [CustomHRMServiceNotes]          
  WHERE ISNull(RecordDeleted,''N'')=''N'' AND DocumentVersionId=@DocumentVersionId        
           
END TRY            
          
BEGIN CATCH            
 declare @Error varchar(8000)            
 set @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())             
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_SCWebGetServiceNoteCustomHRMServiceNotes'')             
    + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())              
    + ''*****'' + Convert(varchar,ERROR_STATE())            
              
 RAISERROR             
 (            
  @Error, -- Message text.            
  16,  -- Severity.            
  1  -- State.            
 );            
            
END CATCH
' 
END
GO
