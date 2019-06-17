IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLSCHL7Vocabulary]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLSCHL7Vocabulary]
GO



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


  
CREATE PROCEDURE [dbo].[ssp_RDLSCHL7Vocabulary]    
  @ConceptCode    VARCHAR(MAX)  
  ,@ConceptName    VARCHAR(MAX)  
  ,@PreferredConceptName  VARCHAR(MAX)  
  ,@PreferredAlternateCode VARCHAR(MAX)  
  ,@CodeSystemOID    VARCHAR(MAX)  
  ,@CodeSystemName   VARCHAR(MAX)  
  ,@CodeSystemCode   VARCHAR(MAX)   
  ,@CodeSystemVersion   VARCHAR(MAX)  
  ,@HL7Table0396Code   VARCHAR(MAX)  
  ,@ValueSetCode    VARCHAR(MAX)  
  ,@ValueSetVersion   VARCHAR(MAX)  
 /********************************************************************************      
-- Stored Procedure: dbo.ssp_RDLSCHL7Vocabulary        
--     
-- Copyright: Streamline Healthcate Solutions   
--      
-- Updates:                                                             
-- Date    Author   Purpose      
-- 04-Dec-2014  Revathi  What:HL7Vocabulary  
--          
*********************************************************************************/  
AS  
BEGIN  
 BEGIN TRY  
    
  SELECT ConceptCode  
  ,ConceptName  
  ,PreferredConceptName  
  ,PreferredAlternateCode  
  ,CodeSystemOID  
  ,CodeSystemName  
  ,CodeSystemCode  
  ,CodeSystemVersion  
  ,HL7Table0396Code  
  ,ValueSetCode  
  ,ValueSetVersion  
  FROM HL7Vocabulary  
   WHERE   
  (@ConceptCode IS NULL OR ConceptCode like '%'+@ConceptCode+'%' )    
  AND (@ConceptName IS NULL OR ConceptName like '%'+@ConceptName+'%' )  
  AND (@PreferredConceptName IS NULL OR PreferredConceptName like '%'+@PreferredConceptName+'%' )  
  AND (@PreferredAlternateCode IS NULL OR PreferredAlternateCode like '%'+@PreferredAlternateCode+'%' )  
  AND (@CodeSystemOID IS NULL OR CodeSystemOID like '%'+@CodeSystemOID+'%' )  
  AND (@CodeSystemName IS NULL OR CodeSystemName like '%'+@CodeSystemName+'%' )  
  AND (@CodeSystemCode IS NULL OR CodeSystemCode like '%'+@CodeSystemCode+'%' )  
  AND (@CodeSystemVersion IS NULL OR CodeSystemVersion like '%'+@CodeSystemVersion+'%' )  
  AND (@HL7Table0396Code IS NULL OR HL7Table0396Code like '%'+@HL7Table0396Code+'%' )  
  AND (@ValueSetCode IS NULL OR ValueSetCode like '%'+@ValueSetCode+'%' )  
  AND (@ValueSetVersion IS NULL OR ValueSetVersion like '%'+@ValueSetVersion+'%' )  
  AND ISNULL(RecordDeleted,'N')='N'  
    
 END TRY  
  
  BEGIN CATCH  
    DECLARE @error varchar(8000)  
  
    SET @error = CONVERT(varchar, ERROR_NUMBER()) + '*****'  
    + CONVERT(varchar(4000), ERROR_MESSAGE())  
    + '*****'  
    + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()),  
    'ssp_RDLSCHL7Vocabulary')  
    + '*****' + CONVERT(varchar, ERROR_LINE())  
    + '*****' + CONVERT(varchar, ERROR_SEVERITY())  
    + '*****' + CONVERT(varchar, ERROR_STATE())  
  
    RAISERROR (@error,-- Message text.  
    16,-- Severity.  
    1 -- State.  
    );  
  END CATCH  
END
GO


