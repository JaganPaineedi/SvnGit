

/****** Object:  StoredProcedure [dbo].[csp_SCGetSubstanceUseDiagnosis]    Script Date: 07/09/2015 12:07:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetSubstanceUseDiagnosis]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetSubstanceUseDiagnosis]
GO



/****** Object:  StoredProcedure [dbo].[csp_SCGetSubstanceUseDiagnosis]    Script Date: 07/09/2015 12:07:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 CREATE PROCEDURE [dbo].[csp_SCGetSubstanceUseDiagnosis] @Subatance VARCHAR(500)    
AS    
/*********************************************************************/    
/* Stored Procedure: [csp_SCGetSubstanceUseDiagnosis] 'SUAlcohol'   */    
/*       Date              Author                  Purpose                   */    
/*      07-25-2017        Pabitra             Texas Customizations #107        */    

/*********************************************************************/    
BEGIN    
 BEGIN TRY    
  SELECT 
   ICD10.ICD10CodeId
  ,ICD10.ICD10Code
  ,ICD9Map.ICD9Code
  ,case when ICD10.DSMVCode is null then 'No' else 'Yes' end AS DSMV   
  ,ICD10.ICDDescription AS DSMDescription 
  ,R.TranslationValue1 AS ServeityID
  ,R.TranslationValue2 AS ServeityText
  FROM DiagnosisICD10Codes ICD10  INNER JOIN DiagnosisICD10ICD9Mapping ICD9Map ON ICD9Map.ICD10CodeId=ICD10.ICD10CodeId
  INNER JOIN Recodes R ON R.IntegerCodeId = ICD10.ICD10CodeId  INNER JOIN  RecodeCategories RC ON RC.RecodeCategoryId=R.RecodeCategoryId  where RC.CategoryCode='XPSYCDIGNOSISMAPPING' AND R.CharacterCodeId=@Subatance AND  ISNULL(RC.RecordDeleted, 'N') <> 'Y' and ISNULL(R.RecordDeleted, 'N') <> 'Y'     
   AND ISNULL(ICD10.RecordDeleted, 'N') <> 'Y'   
   AND ISNULL(ICD9Map.RecordDeleted, 'N') <> 'Y'    
  
 -- where ICD10.ICD10CodeId    
   --in (SELECT IntegerCodeId FROM Recodes R INNER JOIN RecodeCategories RC ON RC.RecodeCategoryId=R.RecodeCategoryId  where RC.CategoryCode='XPSYCDIGNOSISMAPPING' AND R.CharacterCodeId=@Subatance AND  ISNULL(RC.RecordDeleted, 'N') <> 'Y' and ISNULL(R.RecordDeleted, 'N') <> 'Y'  )    
   --AND ISNULL(ICD10.RecordDeleted, 'N') <> 'Y'   
   --AND ISNULL(ICD9Map.RecordDeleted, 'N') <> 'Y'    
 
 END TRY    
    
 BEGIN CATCH    
  DECLARE @Error VARCHAR(8000)    
    
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_SCGetSubstanceUseDiagnosis') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())    
    
  RAISERROR (    
    @Error    
    ,-- Message text.    
    16    
    ,-- Severity.    
    1 -- State.    
    );    
 END CATCH    
END 
GO


