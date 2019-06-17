 /****** Object:  StoredProcedure [dbo].[SSP_GETPRIMARYDIAGNOSISWITHCODE]    Script Date: 06/30/2014 18:07:32 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_GETPRIMARYDIAGNOSISWITHCODE]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SSP_GETPRIMARYDIAGNOSISWITHCODE]
GO

/****** Object:  StoredProcedure [dbo].[SSP_GETPRIMARYDIAGNOSISWITHCODE]    Script Date: 06/30/2014 18:07:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 Create PROCEDURE [DBO].[SSP_GETPRIMARYDIAGNOSISWITHCODE] @CLIENTID INT  
 ,@DocumentId INT  
 ,@EffectiveDate VARCHAR(50)  
 /*********************************************************************************/  
 /* Stored Procedure: SSP_GETPRIMARYDIAGNOSISWITHCODE           */  
 /* Copyright: Streamline Healthcare Solutions          */  
 /* Creation Date:  2018-12-21              */  
 /* Purpose: Populates Progress Note Template list page         */  
 /* Author Swatika Shinde         */    
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

SELECT @temp= STUFF((SELECT ', ' + ICD10.ICD10Code
FROM DocumentDiagnosisCodes DDC
INNER JOIN DiagnosisICD10Codes ICD10 ON ICD10.ICD10CodeId = DDC.ICD10CodeId
LEFT JOIN SNOMEDCTCodes SNC ON SNC.SNOMEDCTCode = DDC.SNOMEDCODE
WHERE ISNULL(DDC.RecordDeleted, 'N') <> 'Y'
AND DDC.DocumentVersionId = @LatestICD10DocumentVersionID  	
ORDER BY DDC.DiagnosisOrder
FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '' )

  IF LEN(@temp) > 1  
   SELECT '<span style=''color:black''>' + @temp + '</span>'  
  ELSE  
   SELECT '<span style=''color:black''><b>No Diagnosis Found</b><br/>None</span>'  
 END TRY  
  
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)  
  
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'SSP_GETPRIMARYDIAGNOSISWITHCODE') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
  
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