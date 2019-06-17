/****** Object:  StoredProcedure [dbo].[ssp_SCGetRDLCurrentDiagnosis]    ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetRDLCurrentDiagnosis]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetRDLCurrentDiagnosis]  
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetRDLCurrentDiagnosis]    ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
CREATE PROCEDURE [dbo].[ssp_SCGetRDLCurrentDiagnosis]  @DocumentVersionId INT  
AS  
/*********************************************************************/  
/* Stored Procedure:[ssp_SCGetRDLCurrentDiagnosis]                       */  
/* Creation Date:8/18/2015                                            */  
/*                                                                    */  
/* Purpose: To Retrieve client CurrentDiagnosis                       */  
/*                                                                    */  
/* Created By:Hemant Kumar                                            */  
/*                                                                    */  
/*   Updates:                                                         */  
/*       Date              Author                  Purpose            */  
/*********************************************************************/  
BEGIN  
 BEGIN TRY  
  DECLARE @EffectiveDate VARCHAR(30);  
  DECLARE @LatestICD10DocumentVersionID INT  
  DECLARE @LatestICD9DocumentVersionID INT  
  DECLARE @LatestICD9ICD10DocumentVersionID INT  
  DECLARE @DSMV CHAR(1)  
  DECLARE @ClientId INT
  DECLARE @DocumentEffectiveDate DATETIME
  

    SELECT @ClientId = ClientId,@DocumentEffectiveDate = doc.EffectiveDate
    FROM documents doc
    INNER JOIN DocumentVersions docv ON docv.DocumentId = doc.DocumentId
    WHERE DocumentVersionId = @DocumentVersionId
     AND ISNULL(docv.RecordDeleted, 'N') <> 'Y'

  
  SELECT TOP 1 @LatestICD9ICD10DocumentVersionID = a.CurrentDocumentVersionId  
   ,@EffectiveDate = CONVERT(VARCHAR(10), a.EffectiveDate, 101)  
  FROM Documents AS a  
  INNER JOIN DocumentCodes AS Dc ON Dc.DocumentCodeId = a.DocumentCodeId  
  WHERE a.ClientId = @ClientId  
   AND a.EffectiveDate <= @DocumentEffectiveDate 
   AND a.STATUS = 22  
   AND Dc.DiagnosisDocument = 'Y'  
   AND isNull(a.RecordDeleted, 'N') <> 'Y'  
   AND isNull(Dc.RecordDeleted, 'N') <> 'Y'  
  ORDER BY a.EffectiveDate DESC  
   ,a.ModifiedDate DESC  
  
  IF EXISTS (  
    SELECT 1  
    FROM DiagnosesIandII  
    WHERE DocumentVersionId = @LatestICD9ICD10DocumentVersionID  
    )  
  BEGIN  
   SET @DSMV = 'N'  
  END  
  
  IF EXISTS (  
    SELECT 1  
    FROM DocumentDiagnosisCodes  
    WHERE DocumentVersionId = @LatestICD9ICD10DocumentVersionID  
    )  
  BEGIN  
   SET @DSMV = 'Y'  
   SET @LatestICD10DocumentVersionID = @LatestICD9ICD10DocumentVersionID  
  END  
  
  IF @DSMV = 'Y'  
  BEGIN  
   SELECT D.DocumentDiagnosisCodeId  
    ,D.CreatedBy  
    ,D.CreatedDate  
    ,D.ModifiedBy  
    ,D.ModifiedDate  
    ,D.RecordDeleted  
    ,D.DeletedDate  
    ,D.DeletedBy  
    ,D.DocumentVersionId  
    ,D.ICD10CodeId  
    ,D.ICD10Code  
    ,D.ICD9Code  
    ,dbo.csf_GetGlobalCodeNameById(D.DiagnosisType) AS DiagnosisType  
    ,D.RuleOut  
    ,D.Billable  
    ,dbo.csf_GetGlobalCodeNameById(D.Severity) AS Severity  
    ,D.DiagnosisOrder  
    ,D.Specifier  
    ,D.Remission  
    ,D.[Source]  
    ,ICD10.ICDDescription 
    ,CONVERT(VARCHAR(10), @EffectiveDate, 101) AS EffectiveDate 
    ,CASE D.RuleOut  
     WHEN 'Y'  
      THEN 'R/O'  
     ELSE ''  
     END AS RuleOutText  
    ,CASE ICD10.DSMVCode  
     WHEN 'Y'  
      THEN 'Yes'  
     ELSE 'No'  
     END AS DSMVCode  
    ,dbo.csf_GetGlobalCodeNameById(D.DiagnosisType) AS 'DiagnosisTypeText'  
    ,dbo.csf_GetGlobalCodeNameById(D.Severity) AS 'SeverityText'  
   FROM DocumentDiagnosisCodes AS D  
   INNER JOIN DiagnosisICD10Codes ICD10 ON ICD10.ICD10CodeId = D.ICD10CodeId  
   WHERE (D.DocumentVersionId = @LatestICD10DocumentVersionID)  
    AND (ISNULL(D.RecordDeleted, 'N') = 'N')  
    
    
  END  
  ELSE  
  BEGIN  
   SET @LatestICD9DocumentVersionID = (  
     SELECT TOP 1 a.CurrentDocumentVersionId  
     FROM Documents AS a  
     INNER JOIN DocumentCodes AS Dc ON Dc.DocumentCodeId = a.DocumentCodeId  
     INNER JOIN DiagnosesIII AS DIII ON a.CurrentDocumentVersionId = DIII.DocumentVersionId  
     WHERE a.ClientId = @ClientID  
      AND a.EffectiveDate <= convert(DATETIME, convert(VARCHAR, getDate(), 101))  
      AND a.STATUS = 22  
      AND Dc.DiagnosisDocument = 'Y'  
      AND isNull(a.RecordDeleted, 'N') <> 'Y'  
      AND isNull(Dc.RecordDeleted, 'N') <> 'Y'  
     ORDER BY a.EffectiveDate DESC  
      ,a.ModifiedDate DESC  
     )  
  
   IF @LatestICD9DocumentVersionID IS NOT NULL  
   BEGIN  
    SELECT Placeholder.TableName  
     ,DIandII.DSMCode AS ICD9Code  
     ,DIandII.RuleOut  
     ,DIandII.CreatedBy  
     ,DIandII.CreatedDate  
     ,DIandII.ModifiedBy  
     ,DIandII.ModifiedDate  
     ,DIandII.RecordDeleted  
     ,DIandII.DeletedDate  
     ,DIandII.DeletedBy  
     ,DSM.DSMDescription as ICDDescription
     ,gc.CodeName AS 'DiagnosisTypeText'
     ,@EffectiveDate AS EffectiveDate 
    FROM (  
     SELECT 'DocumentDiagnosisCodes' AS TableName  
     ) AS Placeholder  
    LEFT JOIN DiagnosesIAndII DIandII ON (  
      DIandII.DocumentVersionId = @LatestICD9DocumentVersionID  
      AND ISNULL(DIandII.RecordDeleted, 'N') <> 'Y'  
      )  
    LEFT JOIN globalcodes gc ON DIandII.DiagnosisType = gc.globalcodeid  
    INNER JOIN DiagnosisDSMDescriptions DSM ON (  
      DSM.DSMCode = DIandII.DSMCode  
      AND DSM.DSMNumber = DIandII.DSMNumber  
      )  
   END 
    
  END  
   
 END TRY  
  
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)  
  
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetRDLCurrentDiagnosis') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR
, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
  
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


