

/****** Object:  StoredProcedure [dbo].[csp_SCGetPreviousDiagnosisPsychiatricNote]    Script Date: 07/09/2015 12:07:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetPreviousDiagnosisPsychiatricNote]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetPreviousDiagnosisPsychiatricNote]
GO



/****** Object:  StoredProcedure [dbo].[csp_SCGetPreviousDiagnosisPsychiatricNote]    Script Date: 07/09/2015 12:07:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 CREATE PROCEDURE [dbo].[csp_SCGetPreviousDiagnosisPsychiatricNote] @ClientId INT    
AS    
/*********************************************************************/    
/* Stored Procedure: [csp_SCGetPreviousDiagnosisPsychiatricNote]   */    
/*       Date              Author                  Purpose                   */    
/*      11-18-2014     Vijay Yadav               To Retrieve Data           */    
/*      01-06-2015     DiagnosisICD10Codes     Included DiagnosisICD10Codes table*/   
/*      13-11-2015     Lakshmi                   To Retrieve Data      */ 
/*********************************************************************/    
BEGIN    
 BEGIN TRY    
  DECLARE @EffectiveDate VARCHAR(30);    
  DECLARE @LatestICD10DocumentVersionID INT    
  DECLARE @LatestICD9DocumentVersionID INT    
    
  SELECT TOP 1 @LatestICD10DocumentVersionID = InProgressDocumentVersionId    
   ,@EffectiveDate = CONVERT(VARCHAR(10), a.EffectiveDate, 101)    
  FROM Documents a    
  INNER JOIN DocumentCodes Dc ON Dc.DocumentCodeid = a.DocumentCodeid    
  WHERE a.ClientId = @ClientID    
   AND a.EffectiveDate <= convert(DATETIME, convert(VARCHAR, getDate(), 101))    
   AND a.STATUS = 22    
   AND Dc.DiagnosisDocument = 'Y'    
   AND isNull(a.RecordDeleted, 'N') <> 'Y'    
   AND isNull(Dc.RecordDeleted, 'N') <> 'Y'    
  ORDER BY a.EffectiveDate DESC    
   ,a.ModifiedDate DESC    
    
  --IF @LatestICD10DocumentVersionID IS NOT NULL    
  --BEGIN    
   SELECT     
     D.ICD10Code    
    ,D.ICD9Code    
    ,case when D.ICD10CodeId is null then 'Yes' else 'No' end as DSMV    
    ,ICD10.ICDDescription AS DSMDescription    
   FROM DocumentDiagnosisCodes AS D --left JOIN                  
    INNER JOIN DiagnosisICD10Codes ICD10 ON ICD10.ICD10CodeId = D.ICD10CodeId    
   WHERE (D.DocumentVersionId = @LatestICD10DocumentVersionID)    
    AND (ISNULL(D.RecordDeleted, 'N') = 'N')    
    
  --END    
 END TRY    
    
 BEGIN CATCH    
  DECLARE @Error VARCHAR(8000)    
    
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_SCGetPreviousDiagnosisPsychiatricNote') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())    
    
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


