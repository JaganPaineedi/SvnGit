 
  /****** Object:  StoredProcedure [dbo].[SSP_GETPRIMARYDIAGNOSIS]    Script Date: 06/30/2014 18:07:32 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_GETPRIMARYDIAGNOSIS]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SSP_GETPRIMARYDIAGNOSIS]
GO

/****** Object:  StoredProcedure [dbo].[SSP_GETPRIMARYDIAGNOSIS]    Script Date: 06/30/2014 18:07:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 Create PROCEDURE [DBO].[SSP_GETPRIMARYDIAGNOSIS] @CLIENTID INT  
 ,@DocumentId INT  
 ,@EffectiveDate VARCHAR(50)  
 /*********************************************************************************/  
 /* Stored Procedure: SSP_GETPRIMARYDIAGNOSIS           */  
 /* Copyright: Streamline Healthcare Solutions          */  
 /* Creation Date:  2018-11-26              */  
 /* Purpose: Populates Progress Note Template list page         */  
           
 /*********************************************************************************/  
AS  
BEGIN  
 BEGIN TRY  
  DECLARE @temp VARCHAR(MAX)  
  DECLARE @tempstart VARCHAR(MAX)  
  
  
  
 DECLARE @LatestICD10DocumentVersionID INT      
     
 SET @LatestICD10DocumentVersionID = (      
   SELECT TOP 1 a.CurrentDocumentVersionId      
   FROM Documents AS a      
   INNER JOIN DocumentCodes AS Dc ON Dc.DocumentCodeId = a.DocumentCodeId      
   INNER JOIN DocumentDiagnosisCodes AS DDC ON a.CurrentDocumentVersionId = DDC.DocumentVersionId      
   WHERE a.ClientId = @CLIENTID     
    AND a.EffectiveDate <= CAST(GETDATE() AS DATE)      
    AND a.STATUS = 22      
    AND Dc.DiagnosisDocument = 'Y'      
    AND ISNULL(a.RecordDeleted, 'N') <> 'Y'      
    AND ISNULL(Dc.RecordDeleted, 'N') <> 'Y'      
   ORDER BY a.EffectiveDate DESC      
    ,a.ModifiedDate DESC      
   )    
   
   SELECT  @temp =ICDDescription
	FROM DocumentDiagnosisCodes DDC
	INNER JOIN DiagnosisICD10Codes ICD10 ON ICD10.ICD10CodeId = DDC.ICD10CodeId
	LEFT JOIN SNOMEDCTCodes SNC ON SNC.SNOMEDCTCode = DDC.SNOMEDCODE
	INNER JOIN globalcodes GC ON GC.globalcodeid =DDC.DiagnosisType
	WHERE ISNULL(DDC.RecordDeleted, 'N') <> 'Y'
	AND DDC.DocumentVersionId = @LatestICD10DocumentVersionID  	
	AND GC.ExternalCode1='PRIMARY'
	AND ISNULL(GC.RecordDeleted, 'N') <> 'Y'
	ORDER BY DDC.DiagnosisOrder 
	 
  IF LEN(@temp) > 1  
   SELECT '<span style=''color:black''>' + @temp + '</span>'  
  ELSE  
   SELECT '<span style=''color:black''><b>No Diagnosis Found</b><br/>None</span>'  
 END TRY  
  
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)  
  
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'SSP_GETPRIMARYDIAGNOSIS') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
  
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