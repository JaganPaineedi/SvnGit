/****** Object:  StoredProcedure [dbo].[ssp_SCGetClientListSearchTemplates]    Script Date: 11/18/2011 16:25:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetClientListSearchTemplates]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetClientListSearchTemplates]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetClientListSearchTemplates]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================    
/* Author     : Shifali                                      */    
/* Create date: 20July,2011                                  */    
/* Purpose    : Get Data for Client List Search PopUp       */     
/* Input Parameters:   None   */    
/* Output Parameters:   ClientListSearchTemplates Table                     */    
/* Called By: ClientReminder.cs (function FillDocument)            */  
/* ModifiedDate		ModifiedDate		Modification*/
/* Pradeep.A		10/01/2014			Added the new fieds */
/* Pradeep.A		10/08/2014			Added new field ReminderPreference */
/* Chethan N		22 Oct 2014			Added New columns Preferrlanguage, Ethnicity */
-- =============================================    
CREATE PROCEDURE [dbo].[ssp_SCGetClientListSearchTemplates]    
   
AS    
BEGIN    
 BEGIN TRY     
    
  SELECT [ClientListSearchTemplateId]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[ModifiedBy]
      ,[ModifiedDate]
      ,[RecordDeleted]
      ,[DeletedDate]
      ,[DeletedBy]
      ,[TemplateName]
      ,[StartDate]
      ,[EndDate]
      ,[AgeFrom]
      ,[AgeTo]
      ,[Sex]
      ,[Race]
      ,[ProgramId]
      ,[ClinicianId]
      ,[SeenOrNotSeen]
      ,[SeenOrNotSeenInDays]
      ,[HospitalizedOrNotHospitalized]
      ,[HospitalizedOrNotHospitalizedInDays]
      ,[LOFCategory]
      ,[LOFMinimumValue]
      ,[LOFMaximumValue]
      ,[DiagnosisCondition1]
      ,[DiagnosisCode1]
      ,[DiagnosisCategoryCondition1]
      ,[DiagnosisCategory1]
      ,[DiagnosisCondition2]
      ,[DiagnosisCode2]
      ,[DiagnosisCategoryCondition2]
      ,[DiagnosisCategory2]
      ,[HealthDataSubTemplateId1]
      ,[HealthDataAttributeId1]
      ,[HealthDataAttributeMinimumValue1]
      ,[HealthDataAttributeMaximumValue1]
      ,[HealthDataTemplateId2]
      ,[HealthDataSubTemplateId2]
      ,[HealthDataAttributeMinimumValue2]
      ,[HealthDataAttributeMaximumValue2]
      ,[WaitingForLabResults]
      ,[MedicationCondition]
      ,[MedicationNameId]
      ,[MedicationCategoryCondition]
      ,[MedicationCategory]
      ,[PrescriberId]
      ,[AllergyCondition]
      ,[AllergenConceptId]
      ,[NoLabsForHealthDataCategoryId]
      ,[NoLabsForDays]
      ,[HealthDataAttributeId2]
      ,[HealthDataTemplateId3]
      ,[HealthDataSubTemplateId3]
      ,[HealthDataAttributeId3]
      ,[HealthDataAttributeMinimumValue3]
      ,[HealthDataAttributeMaximumValue3]
      ,[ReminderPreference]
      ,[Preferredlanguage]
      ,[Ethnicity]
  FROM [ClientListSearchTemplates] CLST    
   WHERE ISNULL(CLST.RecordDeleted, ''N'') = ''N''      
 END TRY     
     
 BEGIN CATCH    
  DECLARE @Error varchar(8000)                                                              
  SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                               
  + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''ssp_SCGetClientListSearchTemplates'')                                    
  + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                                                                
  + ''*****'' + Convert(varchar,ERROR_STATE())                                                              
                                                              
  RAISERROR                                                               
  (                                                    
    @Error, -- Message text.                                                              
    16, -- Severity.                                                              
    1 -- State.                                                              
  );      
 END CATCH    
     
END    ' 
END
GO
