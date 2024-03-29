
/****** Object:  StoredProcedure [dbo].[ssp_GetClientEducationResourceDetails]    Script Date: 09/03/2015 15:00:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetClientEducationResourceDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetClientEducationResourceDetails]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetClientEducationResourceDetails]    Script Date: 09/03/2015 15:00:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*********************************************************************/                                                        
/* Stored Procedure: dbo.ssp_GetClientEducationResourceDetails               */                                               
                                              
                                              
/* Creation Date:  May/06/2011                                  */                                                        
/*                                                                   */                                                        
/* Purpose:  Get All information for ClientResouceEducation based on ClientEducationResourceId      */                                                       
/*                                                                          */                                               
/* Input Parameters:   @ClientEducationResourceId   */                                                      
/*                                                                   */                                                         
/* Output Parameters:                                    */                                                        
/*                                                                   */                                                        
/* Return: 3 Data Tables if suceess otherwise raise an error  */                                                        
/*       */       
                                              
/* Author:Devi Dayal Jangra*/                      
/* Modified by : Shruthi.S
   Date        : 1/22/2014
   Purpose     : Changed Helathdatacategoryid to    HealthParameterValue.Ref :#5 Meaningful Use      
   Modified    : PPOTNURU 10/15/2014 modified table names and added 2 new tables
   Modified    : Wasif Butt May/04/2015 Adding resource comment for client education resources
   */                                            
/*********************************************************************/     
CREATE PROCEDURE [dbo].[ssp_GetClientEducationResourceDetails]    
 -- Add the parameters for the stored procedure here    
 @ClientEducationResourceId int    
AS    
BEGIN    
 -- SET NOCOUNT ON added to prevent extra result sets from    
 -- interfering with SELECT statements.    
 SET NOCOUNT ON;    
    
 BEGIN TRY    
  SELECT     
    CER.EducationResourceId,
	CER.CreatedBy,
	CER.CreatedDate,
	CER.ModifiedBy,
	CER.ModifiedDate,
	CER.RecordDeleted,
	CER.DeletedDate,
	CER.DeletedBy,
	CER.Description,
	CER.InformationType,
	CER.DocumentType,
	Cast(null as Image) as ResourcePDF,
	CER.ResourceURL,
	CER.ResourceReportId,
	CER.ParameterType,
	CER.AllMedications,
	CER.AllDiagnoses,
    Name as ReportName,
	CER.ResourceComment        
  FROM  EducationResources CER   
  LEFT JOIN Reports On Reports.ReportId = CER.ResourceReportId
  WHERE EducationResourceId=@ClientEducationResourceId    
   AND ISNULL(CER.RecordDeleted, 'N') = 'N'
    
  SELECT     
     EducationResourceMedications.* ,  
     MDMedicationNames.MedicationName   
  FROM  EducationResourceMedications     
  LEFT JOIN MDMedicationNames ON EducationResourceMedications.MedicationNameId =MDMedicationNames.MedicationNameId   
  WHERE EducationResourceId=@ClientEducationResourceId    
  AND ISNULL(EducationResourceMedications.RecordDeleted, 'N') = 'N'
      
--  SELECT EducationResourceDiagnoses.*
--	,CASE 
--		WHEN isnull(EducationResourceDiagnoses.ICDCode, '') != ''
--			THEN DiagnosisICDCodes.ICDDescription
--		ELSE DiagnosisDSMDescriptions.DSMDescription
--		END AS ICDDSMDescription
--FROM EducationResourceDiagnoses
--LEFT JOIN DiagnosisDSMDescriptions ON EducationResourceDiagnoses.DSMCode = DiagnosisDSMDescriptions.DSMCode
--	AND EducationResourceDiagnoses.DSMNumber = DiagnosisDSMDescriptions.DSMNumber
--LEFT JOIN DiagnosisICDCodes ON EducationResourceDiagnoses.ICDCode = DiagnosisICDCodes.ICDCode
--WHERE EducationResourceId = @ClientEducationResourceId
--	AND ISNULL(EducationResourceDiagnoses.RecordDeleted, 'N') = 'N'

	SELECT ERD.[EducationResourceDiagnosisId]
		  ,ERD.[CreatedBy]
		  ,ERD.[CreatedDate]
		  ,ERD.[ModifiedBy]
		  ,ERD.[ModifiedDate]
		  ,ERD.[RecordDeleted]
		  ,ERD.[DeletedDate]
		  ,ERD.[DeletedBy]
		  ,ERD.[EducationResourceId]
		  ,ERD.[DiagnosisType]
		  ,ERD.[DiagnosisCode]
		  ,ERD.[ICD9Code]
		  ,ERD.[DSMCode]
		  ,ERD.[DSMNumber]
		  ,ERD.ICD10CodeId
		  ,ERD.ICD10Code
		  ,ERD.ICDDescription
	  FROM [EducationResourceDiagnoses] ERD
	  WHERE EducationResourceId = @ClientEducationResourceId
	  AND ISNULL(ERD.RecordDeleted, 'N') = 'N'

	
SELECT 
     ERHDE.EducationResourceHealthDataElementId
	,ERHDE.EducationResourceId
	,ERHDE.CreatedBy
	,ERHDE.CreatedDate
	,ERHDE.ModifiedBy
	,ERHDE.ModifiedDate
	,ERHDE.RecordDeleted
	,ERHDE.DeletedDate
	,ERHDE.DeletedBy
	,ERHDE.HealthParameterValue
	,HDA.NAME AS HealthParameter
FROM EducationResourceHealthDataElements AS ERHDE
INNER JOIN HealthDataAttributes HDA ON HDA.HealthDataAttributeId = ERHDE.HealthParameterValue
	AND ISNULL(HDA.RecordDeleted, 'N') = 'N'
WHERE ERHDE.EducationResourceId = @ClientEducationResourceId
	AND ISNULL(ERHDE.RecordDeleted, 'N') = 'N'
 
 SELECT 
     ERO.EducationResourceOrderId
	,ERO.EducationResourceId
	,ERO.CreatedBy
	,ERO.CreatedDate
	,ERO.ModifiedBy
	,ERO.ModifiedDate
	,ERO.RecordDeleted
	,ERO.DeletedDate
	,ERO.DeletedBy
	,ERO.OrderId
	,O.OrderName
FROM EducationResourceOrders AS ERO
INNER JOIN Orders O ON O.OrderId = ERO.OrderId
	AND ISNULL(O.RecordDeleted, 'N') = 'N'
WHERE ERO.EducationResourceId = @ClientEducationResourceId
	AND ISNULL(ERO.RecordDeleted, 'N') = 'N'
	
	SELECT 
	ERHM.EducationResourceHealthMaintenanceTemplateId, 
	ERHM.CreatedBy, 
	ERHM.CreatedDate, 
	ERHM.ModifiedBy, 
	ERHM.ModifiedDate, 
	ERHM.RecordDeleted, 
	ERHM.DeletedDate, 
	ERHM.DeletedBy,
	ERHM.EducationResourceId, 
	ERHM.HealthMaintenanceTemplateId,
	HM.TemplateName
FROM EducationResourceHealthMaintenanceTemplates AS ERHM
INNER JOIN HealthMaintenanceTemplates HM ON HM.HealthMaintenanceTemplateId = ERHM.HealthMaintenanceTemplateId
	AND ISNULL(HM.RecordDeleted, 'N') = 'N'
WHERE ERHM.EducationResourceId = @ClientEducationResourceId
	AND ISNULL(ERHM.RecordDeleted, 'N') = 'N'
       
 END TRY    
 BEGIN CATCH    
 RAISERROR  20006   'ssp_GetClientEducationResourceDetails: An Error Occured'  
 END CATCH    
     
     
END    
GO


