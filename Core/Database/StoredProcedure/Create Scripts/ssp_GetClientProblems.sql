 /****** Object:  StoredProcedure [dbo].[ssp_GetClientProblems]    Script Date: 10/05/2012 11:15:23 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetClientProblems]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_GetClientProblems] 
GO

--/****** Object:  StoredProcedure [dbo].[ssp_GetClientProblems]    Script Date: 10/05/2012 11:15:23 ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
--/********************************************************************************                                                  
---- Stored Procedure: ssp_GetClientProblems
----
---- Copyright: Streamline Healthcate Solutions
----
---- Purpose:   Created to get Client Problems from ClientProblmes table in ClientActionPlan Document.
----
---- Author:    Mamta Gupta
---- Date:      5-Oct-2012
----
--03 Sep  2015  vkhare			Modified for ICD10 changes
---- *****History****
--*********************************************************************************/
CREATE PROCEDURE [dbo].[ssp_GETClientProblems] @ClientId INT    
 ,@effectiveDate VARCHAR(50)    
 ,@DocumentVersionId INT    
 /*********************************************************************************/    
 /* Stored Procedure: ssp_GETClientProblems           */    
 /* Copyright: Streamline Healthcare Solutions          */    
 /* Creation Date:  2012-09-21              */    
 /* Purpose: Populates Progress Note Template list page         */    
 /* Input Parameters:@SessionId,@InstanceId,@PageNumber,@PageSize,@SortExpression,*/    
 /*      @Active,@TagTypeId ,@Others      */    
 /* Return:                      */    
 /*       */    
 /* Calls:                   */    
 /* Data Modifications:                */    
 /* Updates:                   */    
 /* Date              Author             Purpose          */    
 /* 2012-09-21   Vaibhav khare  Created          */    
 /* 2014-01-13 Chethan N  Added new column 'Terminal'-- for task#2 FQHC - Custom / Design*/    
 /* 2014-07-25 Added new logic based on  New client problem popup */      
 /* 2014-08-05 Added filter based on start date and end date  */      
 /* 2014-08-05 Adding one more   */    
 /*09-18-18 what : left join  ClientProblems and DiagnosisICD10Codes with ICD10CodeId instead of ICD10Code
            why :AHN SGL 366  Dx not populating correctly in Progress Note (SOAP) */
 /*********************************************************************************/    
AS    
BEGIN    
 BEGIN TRY    
   ;    
    
  WITH UnionResult    
  AS (    
   SELECT CPDF.ClientProblemId    
    ,CPDF.CreatedBy    
    ,CPDF.CreatedDate    
    ,CPDF.DSMCode AS DiagnosisCode    
    ,CPDF.DSMNumber    
    ,CPDF.DeletedBy    
    ,@ClientId AS ClientId    
    ,CPDF.DeletedDate    
    ,CP1.EndDate AS EndDate    
    ,CPDF.Axis    
    ,CP1.IncludeInCommonList AS IncludeInCommonList    
    ,CPDF.ModifiedBy AS ModifiedBy    
    ,CPDF.ModifiedDate AS ModifiedDate    
    ,CPDF.ProblemType AS ProblemType    
    ,CPDF.RecordDeleted    
    ,CP1.StaffId AS StaffId    
    ,CP1.StartDate AS StartDate    
    ,IsNull(DIC.ICDDescription, DC.ICDDescription) as 'Description'        
    ,CPDF.AddToNote    
    ,CPDF.NewProblem    
    ,CPDF.Discontinue AS Discontinue    
    ,CPDF.ProblemStatus AS ProblemStatus    
    ,CPDF.AdditionalWorkUp AS AdditionalWorkUp    
    ,CPDF.Terminal AS Terminal    
    ,CPDF.DocumentVersionId    
    ,CPDF.ClientProblemDiagnosisHistory    
    ,CPDF.DATE    
    ,CASE     
     WHEN CPDF.NewProblem = 'Y'    
      THEN 'checked=''checked'''    
     ELSE NULL    
     END AS 'NewProblemC'    
    ,CASE     
     WHEN CPDF.AddToNote = 'Y'    
      THEN 'checked=''checked'''    
     ELSE NULL    
     END AS 'AddToNoteC'    
    ,CASE     
     WHEN CPDF.ProblemType = '8151'    
      THEN 'checked=''checked'''    
     ELSE NULL    
     END AS 'Major'    
    ,CASE     
     WHEN CPDF.Discontinue = 'Y'    
      THEN 'checked=''checked'''    
     ELSE NULL    
     END AS 'DiscontinueC'    
    ,CASE     
     WHEN CPDF.AdditionalWorkUp = 'Y'    
      THEN 'checked=''checked'''    
     ELSE NULL    
     END AS 'AdditionalWorkUpC'    
    ,CASE     
     WHEN CPDF.Terminal = 'Y'    
      THEN 'checked=''checked'''    
     ELSE NULL    
     END AS 'TerminalC'    
    ,'N' AS IsClientProblem    
    ,CPDF.DSMCode AS DSMCode    
    ,CPDF.DiagnosisOrder    
    ,CPDF.ICD10Code    
    ,CPDF.ICD10CodeId    
    ,CPDF.SNOMEDCODE    
    ,SNC.SNOMEDCTDescription    
   FROM ClientProblemsDiagnosisHistory CPDF     
   LEFT JOIN ClientProblems CP1 ON CP1.ClientProblemId =cpdf.ClientProblemId     
   LEFT JOIN DiagnosisICD10Codes  DIC ON CPDF.ICD10CodeId = DIC.ICD10CodeId   
   LEFT JOIN DiagnosisICDCodes  DC ON DC.ICDCode = CPDF.DSMCode  
   --left JOIN GlobalCodes GC ON GC.GlobalCodeId=CPDF.ProblemType     
   LEFT JOIN SNOMEDCTCodes AS SNC ON SNC.SNOMEDCTCode = CPDF.SNOMEDCODE                   
   WHERE DocumentVersionId = @DocumentVersionId    
       
   UNION    
       
   SELECT DISTINCT CP.ClientProblemId    
    ,CP.CreatedBy    
    ,CP.CreatedDate    
    ,CP.DSMCode AS DiagnosisCode    
    ,CP.DSMNumber    
    ,CP.DeletedBy    
    ,CP.ClientId    
    ,CP.DeletedDate    
    ,CP.EndDate    
    ,CP.Axis    
    ,CP.IncludeInCommonList    
    ,CP.ModifiedBy    
    ,CP.ModifiedDate    
    ,CP.ProblemType AS ProblemType    
    ,CP.RecordDeleted    
    ,CP.StaffId    
    ,CP.StartDate    
    ,IsNull(DSM.ICDDescription, DC.ICDDescription) as 'Description'     
    ,CP.AddToNote AS AddToNote    
    ,CP.NewProblem AS NewProblem    
    ,CP.Discontinue AS Discontinue    
    ,NULL AS ProblemStatus    
    ,CP.AdditionalWorkUp    
    ,CP.Terminal    
    ,NULL AS DocumentVersionId    
    ,NULL AS ClientProblemDiagnosisHistory    
    ,NULL AS 'Date'    
    --,CASE     
    -- WHEN DATEDIFF(DAY, CP.StartDate, @effectiveDate) = 0    
    --  THEN 'checked=''checked'''    
    -- ELSE ''    
    -- END AS 'NewProblemC'    
    ,NULL AS 'NewProblemC'    
    ,NULL AS 'AddToNoteC'    
    ,CASE     
     WHEN CP.ProblemType = '8151'    
      THEN 'checked=''checked'''    
     ELSE ''    
     END AS 'Major'    
    ,CASE     
     WHEN CP.Discontinue = 'Y'    
      THEN 'checked=''checked'''    
     ELSE ''    
     END AS 'DiscontinueC'    
    ,CASE     
     WHEN CP.AdditionalWorkUp = 'Y'    
      THEN 'checked=''checked'''    
     ELSE ''    
     END AS 'AdditionalWorkUpC'    
    ,CASE     
     WHEN CP.Terminal = 'Y'    
      THEN 'checked=''checked'''    
     ELSE ''    
     END AS 'TerminalC'    
    ,'Y' AS IsClientProblem    
    ,CP.DSMCode AS 'DSMCode'    
    ,CP.DiagnosisOrder    
    ,CP.ICD10Code    
    ,CP.ICD10CodeId    
    ,CP.SNOMEDCODE    
    ,SNC.SNOMEDCTDescription       
   FROM ClientProblems CP    
   LEFT JOIN ClientProblemsDiagnosisHistory CPDH ON CP.ClientProblemId = CPDH.ClientProblemId  
   --neethu sep-18-18
   LEFT JOIN DiagnosisICD10Codes DSM ON DSM.ICD10CodeId  = CP.ICD10CodeId  
  
   LEFT JOIN DiagnosisICDCodes  DC ON DC.ICDCode = CP.DSMCode  
    
   LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = CP.ProblemType    
   LEFT JOIN SNOMEDCTCodes AS SNC ON SNC.SNOMEDCTCode = CP.SNOMEDCODE    
   WHERE ClientId = @ClientId    
    AND ISNULL(CP.RecordDeleted, 'N') = 'N'    
    AND IsNULL(CP.Discontinue, 'N') = 'N'    
   AND CAST(@effectiveDate AS DATETIME) BETWEEN ISNULL(DATEADD(DAY, - 1, CP.StartDate), DATEADD(DAY, - 1, GETDATE()))    
   AND ISNULL(DATEADD(DAY, - 1, CP.EndDate), DATEADD(DAY, 1, GETDATE()))    
    AND CP.ClientProblemId NOT IN (    
     SELECT ISNULL(CPDH1.ClientProblemId,0)    
     FROM ClientProblemsDiagnosisHistory CPDH1    
     WHERE CPDH1.DocumentVersionId = @DocumentVersionId    
     )    
   )    
  SELECT ROW_NUMBER() OVER (    
    ORDER BY CreatedBy DESC    
    ) AS id    
   ,ClientProblemId    
   ,CreatedBy    
   ,CreatedDate    
   ,DiagnosisCode AS DiagnosisCode    
   ,DSMNumber    
   ,DeletedBy    
   ,ClientId    
   ,DeletedDate    
   ,EndDate    
   ,Axis    
   ,IncludeInCommonList    
   ,ModifiedBy    
   ,ModifiedDate    
   ,ProblemType AS ProblemType    
   ,RecordDeleted    
   ,StaffId    
   ,StartDate    
   ,Description    
   ,AddToNote    
   ,NewProblem    
   ,Discontinue    
   ,ProblemStatus AS ProblemStatus    
   ,AdditionalWorkUp    
   ,Terminal    
   ,DocumentVersionId    
   ,ClientProblemDiagnosisHistory    
   ,DATE    
   ,NewProblemC    
   ,AddToNoteC    
   ,Major    
   ,DiscontinueC    
   ,AdditionalWorkUpC    
   ,TerminalC    
   ,IsClientProblem    
   ,DiagnosisCode AS 'DSMCode'    
   ,DiagnosisOrder    
   ,ICD10Code    
   ,ICD10CodeId    
   ,SNOMEDCODE    
   ,SNOMEDCTDescription    
   ,DiagnosisCode AS 'ICD9Code'    
  FROM UnionResult    
 END TRY    
    
 BEGIN CATCH    
  DECLARE @Error VARCHAR(8000)    
    
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GETClientProblemss') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())    
    
  RAISERROR (    
    @Error    
    ,-- Message text.        
    16    
    ,-- Severity.        
    1 -- State.        
    );    
 END CATCH    
END    
 --GO    
