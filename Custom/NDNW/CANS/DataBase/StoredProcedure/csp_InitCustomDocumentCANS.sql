IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'csp_InitCustomDocumentCANS')
	BEGIN
		DROP  Procedure  csp_InitCustomDocumentCANS
	END

GO
    
CREATE PROCEDURE [dbo].[csp_InitCustomDocumentCANS]    
(    
 @ClientID int,                                  
 @StaffID int,                                
 @CustomParameters xml      
)    
AS    
-- =============================================        
-- Author:  Md Hussain Khusro        
-- Create date: July 03, 2013       
-- Description: Initialize CANS Document    
-- History:    
/* Data Modifications:                                               */                        
/*                                                                   */                        
/*   Updates:                                                          */                                     
/*       Date              Author                  Purpose            */

/*********************************************************************/ 
-- =============================================     
BEGIN    
 BEGIN TRY    
  DECLARE @LatestDocumentVersionID INT    
  DECLARE @LivingArrangement VARCHAR(100)  

       
      
  SET @LatestDocumentVersionID =(SELECT TOP 1 CurrentDocumentVersionId from CustomDocumentCANSGenerals CDCG inner join Documents Doc  on                                                                                        
  CDCG.DocumentVersionId=Doc.CurrentDocumentVersionId where Doc.ClientId=@ClientID                       
  and Doc.Status=22 and  CONVERT(DATE,Doc.EffectiveDate) <= CONVERT(DATE,GETDATE())  and ISNULL(CDCG.RecordDeleted,'N')='N' and ISNULL(Doc.RecordDeleted,'N')='N'                                                           
  ORDER BY Doc.EffectiveDate DESC,Doc.ModifiedDate DESC)   
  
  SELECT 
	@LivingArrangement=dbo.csf_GetGlobalCodeNameById(LivingArrangement)
	FROM Clients 
	WHERE ClientId = @ClientID
      
SELECT top 1 Placeholder.TableName,ISNULL(CDCG.DocumentVersionId,-1) AS DocumentVersionId,    
    CDCG.[CreatedBy],      
    CDCG.[CreatedDate],    
       CDCG.[ModifiedBy],     
       CDCG.[ModifiedDate],      
       CDCG.[RecordDeleted],      
       CDCG.[DeletedDate],      
       CDCG.[DeletedBy],
       @LivingArrangement as LivingArrangement
                
  FROM (SELECT 'CustomDocumentCANSGenerals' AS TableName) AS Placeholder    
  LEFT JOIN CustomDocumentCANSGenerals CDCG ON (CDCG.DocumentVersionId=@LatestDocumentVersionID    
  AND ISNULL(CDCG.RecordDeleted,'N') <> 'Y' )    
      
  SELECT top 1 Placeholder.TableName,ISNULL(CDCYS.DocumentVersionId,-1) AS DocumentVersionId,    
    CDCYS.[CreatedBy],      
    CDCYS.[CreatedDate],    
       CDCYS.[ModifiedBy],     
       CDCYS.[ModifiedDate],      
       CDCYS.[RecordDeleted],      
       CDCYS.[DeletedDate],      
       CDCYS.[DeletedBy]           
  FROM (SELECT 'CustomDocumentCANSYouthStrengths' AS TableName) AS Placeholder    
  LEFT JOIN CustomDocumentCANSYouthStrengths CDCYS ON (CDCYS.DocumentVersionId=@LatestDocumentVersionID    
  AND ISNULL(CDCYS.RecordDeleted,'N') <> 'Y' )      
  
    SELECT top 1 Placeholder.TableName,ISNULL(CDCM.DocumentVersionId,-1) AS DocumentVersionId,    
    CDCM.[CreatedBy],      
    CDCM.[CreatedDate],    
       CDCM.[ModifiedBy],     
       CDCM.[ModifiedDate],      
       CDCM.[RecordDeleted],      
       CDCM.[DeletedDate],      
       CDCM.[DeletedBy]           
  FROM (SELECT 'CustomDocumentCANSModules' AS TableName) AS Placeholder    
  LEFT JOIN CustomDocumentCANSModules CDCM ON (CDCM.DocumentVersionId=@LatestDocumentVersionID    
  AND ISNULL(CDCM.RecordDeleted,'N') <> 'Y' )     
      
 END TRY    
 BEGIN CATCH  
  declare @Error varchar(8000)                        
  set @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                         
  + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_InitCustomDocumentCANS')                         
  + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                          
  + '*****' + Convert(varchar,ERROR_STATE())                        
  RAISERROR                         
  (                        
   @Error, -- Message text.                        
   16,  -- Severity.                        
   1  -- State.                        
  );   
END CATCH    
END    


