/****** Object:  StoredProcedure [dbo].[ssp_GetDocumentationOf]    Script Date: 09/25/2017 12:58:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetDocumentationOf]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetDocumentationOf]
GO


/****** Object:  StoredProcedure [dbo].[ssp_GetDocumentationOf]    Script Date: 09/25/2017 12:58:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

           
CREATE PROCEDURE [dbo].[ssp_GetDocumentationOf]  @ClientId INT = null            
, @Type VARCHAR(10)  =null            
, @DocumentVersionId INT =null            
, @FromDate DATETIME =null            
, @ToDate DATETIME =null
AS            
-- =============================================                  
-- Author:  Gautam                  
-- Create date: Sep 15, 2017                  
-- Description: Retrieves DocumentationOf details                 
 -- =============================================                                 
/*                      
 Author   Added Date   Reason   Task                      
 Gautam   09/15/2017   Initial  MUS3 - Task#25.4 Transition of Care - CCDA Generation        
*/ 
-- =============================================                  
BEGIN            
 BEGIN TRY             
             
   DECLARE @LatestICD10DocumentVersionID INT   
                   
	   SET @LatestICD10DocumentVersionID = (              
		  SELECT TOP 1 CurrentDocumentVersionId              
		  FROM Documents a              
		  INNER JOIN DocumentCodes Dc ON Dc.DocumentCodeid = a.DocumentCodeid              
		  WHERE a.ClientId = @ClientId              
		AND a.EffectiveDate <= convert(DATETIME, convert(VARCHAR, getDate(), 101))             
		AND a.STATUS = 22              
		AND Dc.DiagnosisDocument = 'Y'              
		AND a.DocumentCodeId = 1601              
		AND isNull(a.RecordDeleted, 'N') <> 'Y'              
		AND isNull(Dc.RecordDeleted, 'N') <> 'Y'              
		ORDER BY a.EffectiveDate DESC ,a.ModifiedDate DESC              
	  )             
  
     SELECT top 1 D.ClientId               
     ,DC.ICD9Code AS ICD9Code            
     ,DC.ICD10Code  --RDL            
     ,DC.SNOMEDCODE AS SNOMED  --RDL            
     , CASE WHEN ISNULL(S.SNOMEDCTDescription,'')<> '' THEN S.SNOMEDCTDescription            
     ELSE            
     REPLACE((                
         SELECT DISTINCT ICD9Codes.ICDDescription + CHAR(13) + CHAR(10)                
         FROM dbo.DiagnosisICD10Codes ICD9Codes                
         INNER JOIN DiagnosisICD10ICD9Mapping ICD9MAP ON ICD9MAP.ICD10CodeId = ICD9Codes.ICD10CodeId                
         WHERE ICD9MAP.ICD9Code = DC.ICD9Code                
         FOR XML PATH('')                
         ), '&#x0D;', CHAR(13) + CHAR(10))   END AS [Description]--RDL               
        ,D.EffectiveDate AS EffectiveDate  --For CCDS      
        ,A.AgencyName -- For CCDS      
		,A.Address  -- For CCDS      
		,A.City   -- For CCDS     
		,A.State   -- For CCDS     
		,A.ZipCode  -- For CCDS          
		,sf.LastName  
		,sf.FirstName     
		,A.MainPhone    
      FROM Documents d   
     join documentVersions dv on  d.DocumentId= dv.DocumentId     
     JOIN dbo.DocumentDiagnosisCodes DC ON dv.DocumentVersionId= DC.DocumentVersionId    
     and DC.DiagnosisType=142 -- 142 (Primary)    
     JOIN dbo.SNOMEDCTCodes  s ON s.SNOMEDCTCode = DC.SNOMEDCODE   
     LEFT JOIN Staff sf ON sf.StaffId = d.AuthorId   
     CROSS JOIN  Agency A         
    WHERE  DC.DocumentVersionId = @LatestICD10DocumentVersionID  and ISNULL(D.RecordDeleted,'N')='N'             
                                         
              
 END TRY            
            
 BEGIN CATCH            
  DECLARE @Error VARCHAR(8000)            
            
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) +        
   '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetDocumentationOf') + '*****' +        
    CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())            
            
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


