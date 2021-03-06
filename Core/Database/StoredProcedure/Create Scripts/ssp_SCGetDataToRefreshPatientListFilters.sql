/****** Object:  StoredProcedure [dbo].[ssp_SCGetDataToRefreshPatientListFilters]    Script Date: 11/18/2011 16:25:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetDataToRefreshPatientListFilters]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetDataToRefreshPatientListFilters]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetDataToRefreshPatientListFilters]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'  CREATE procedure [dbo].[ssp_SCGetDataToRefreshPatientListFilters]   
                 
 @ClientListSearchTemplateId int                
/********************************************************************************                                                                  
-- Stored Procedure: dbo.ssp_SCGetDataToRefreshPatientListFilters                                                                    
--                                                                  
-- Copyright: Streamline Healthcate Solutions                                                                  
--                                                                  
-- Purpose: used to populate ClientListSearchTemplates Filters on Patientlist page      
--                                                                  
-- Updates:                                                                                                                         
-- Date          Author      Purpose                                                                  
-- 25 July 2010  Karan Garg  Created.    
-- 01 Oct 2014	 Pradeep.A	 Modified to have new fields.   
-- 10 Oct 2014	 Pradeep.A	 Added new Field ReminderPreference       
-- 22 Oct 2014	 Chethan N	 Added New columns Preferrlanguage, Ethnicity                                                           
*********************************************************************************/                   
                  
as                  
BEGIN                                                         
 BEGIN TRY                 
            
SELECT [ClientListSearchTemplateId]     
      ,[TemplateName]      
      ,[StartDate]      
      ,[EndDate]      
      ,ISNULL([AgeFrom],''-1'') as AgeFrom     
      ,ISNULL([AgeTo],''-1'') as AgeTo   
      ,ISNULL([Sex],''0'') as Sex      
      ,ISNULL([Race],''0'') as Race     
      ,ISNULL([ProgramId],-1) as ProgramId      
      ,ISNULL([ClinicianId] ,0) as ClinicianId      
      ,[SeenOrNotSeen]      
      ,ISNULL([SeenOrNotSeenInDays],-1) as SeenOrNotSeenInDays   
      ,[HospitalizedOrNotHospitalized]      
      ,ISNULL([HospitalizedOrNotHospitalizedInDays],-1) as HospitalizedOrNotHospitalizedInDays      
      ,ISNULL([LOFCategory],''0'') as LOFCategory      
      ,ISNULL([LOFMinimumValue],-1) as   LOFMinimumValue    
      ,ISNULL([LOFMaximumValue],-1) as  LOFMaximumValue     
      ,[DiagnosisCondition1]      
      ,ISNULL([DiagnosisCode1],'''') as DiagnosisCode1      
      ,[DiagnosisCategoryCondition1]      
      ,[DiagnosisCategory1]      
      ,[DiagnosisCondition2]      
      ,ISNULL([DiagnosisCode2],'''') as DiagnosisCode2      
      ,[DiagnosisCategoryCondition2]      
      ,[DiagnosisCategory2]      
      ,ISNULL([HealthDataSubTemplateId1],0) as HealthDataSubTemplateId1      
      ,ISNULL([HealthDataAttributeId1],0) as HealthDataAttributeId1  
      ,CONVERT(decimal(18,2),ISNULL([HealthDataAttributeMinimumValue1],-1)) as HealthDataAttributeMinimumValue1  
      ,CONVERT(decimal(18,2),ISNULL([HealthDataAttributeMaximumValue1],-1)) as HealthDataAttributeMaximumValue1      
      ,ISNULL([HealthDataTemplateId2],0) as HealthDataTemplateId2       
      ,ISNULL([HealthDataSubTemplateId2],0) as HealthDataSubTemplateId2       
      ,CONVERT(decimal(18,2),ISNULL([HealthDataAttributeMinimumValue2],-1)) as HealthDataAttributeMinimumValue2      
      ,CONVERT(decimal(18,2),ISNULL([HealthDataAttributeMaximumValue2],-1)) as HealthDataAttributeMaximumValue2      
      ,[WaitingForLabResults]      
      ,[MedicationCondition]      
      ,ISNULL(CLST.[MedicationNameId],-1) as MedicationNameId      
      ,[MedicationCategoryCondition]      
      ,[MedicationCategory]      
      ,[PrescriberId]      
      ,[AllergyCondition]      
      ,ISNULL(CLST.[AllergenConceptId],-1) as AllergenConceptId      
      ,ISNULL([NoLabsForHealthDataCategoryId],0) as NoLabsForHealthDataCategoryId      
      ,ISNULL([NoLabsForDays],-1) as NoLabsForDays      
      ,ISNULL(ICD.ICDDescription,'''') as DiagnosisDescription1    
      ,ISNULL(ICD2.ICDDescription,'''') as DiagnosisDescription2    
      ,ISNULL(MN.MedicationName,'''') as MedicationName    
      ,ISNULL(AC.ConceptDescription,'''')   as AllergenConcept  
      ,ISNULL([HealthDataAttributeId2],0) as HealthDataAttributeId2       
      ,ISNULL([HealthDataTemplateId3],0) as HealthDataTemplateId3   
      ,ISNULL([HealthDataSubTemplateId3],0) as HealthDataSubTemplateId3  
      ,ISNULL([HealthDataAttributeId3],0) as HealthDataAttributeId3    
      ,CONVERT(decimal(18,2),ISNULL([HealthDataAttributeMinimumValue3],-1)) as HealthDataAttributeMinimumValue3      
      ,CONVERT(decimal(18,2),ISNULL([HealthDataAttributeMaximumValue3],-1)) as HealthDataAttributeMaximumValue3
      ,ISNULL([ReminderPreference] ,0) as ReminderPreference
      ,ISNULL([Preferredlanguage] ,0) AS [Preferredlanguage]
      ,ISNULL([Ethnicity] ,0) AS [Ethnicity]   
   FROM ClientListSearchTemplates CLST    
   LEFT  JOIN DiagnosisICDCodes ICD ON CLST.DiagnosisCode1 = ICD.ICDCode  
   LEFT  JOIN DiagnosisICDCodes ICD2 ON CLST.DiagnosisCode2 = ICD2.ICDCode    
   LEFT  JOIN MdMedicationNames MN ON CLST.MedicationNameId = MN.MedicationNameId    
   LEFT  JOIN MDAllergenConcepts AC ON CLST.AllergenConceptId = AC.AllergenConceptId    
  WHERE ISNULL(CLST.RecordDeleted,''N'')<>''Y''       
  and ClientListSearchTemplateId = @ClientListSearchTemplateId        
        
            
 END TRY                                            
 BEGIN CATCH                                                        
 DECLARE @Error varchar(8000)                                                                          
 SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                           
 + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''ssp_SCGetDataToRefreshPatientListFilters'')                                                
 + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                                                                            
 + ''*****'' + Convert(varchar,ERROR_STATE())                                                                          
                                                                  
 RAISERROR                                                                           
 (                                                                
 @Error, -- Message text.                                                                          
 16, -- Severity.                                                                          
 1 -- State.                     
 );                                                           
 End CATCH                                                                                                                 
                                                 
End ' 
END
GO
