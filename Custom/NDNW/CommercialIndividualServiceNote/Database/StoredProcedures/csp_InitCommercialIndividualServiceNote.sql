 /****** Object:  StoredProcedure [dbo].[csp_SCGetCustomClientDemographics]    Script Date: 06/30/2014 18:07:32 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCommercialIndividualServiceNote]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCommercialIndividualServiceNote] 

/****** Object:  StoredProcedure [dbo].[csp_InitCommercialIndividualServiceNote]    Script Date: 06/30/2014 18:07:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO  
CREATE PROCEDURE [dbo].[csp_InitCommercialIndividualServiceNote] (  
 @ClientID INT  
 ,@StaffID INT  
 ,@CustomParameters XML  
 )  
AS  
/*********************************************************************/  
/* Stored Procedure: [csp_InitCommercialIndividualServiceNote]   */  
/*       Date              Author                  Purpose                   */  
/*       03/06/2015        Vamsi               To initialize CustomDocumentCommercialIndividualServiceNote values */  
/*********************************************************************/  
BEGIN  
 BEGIN TRY  
  DECLARE @LatestDocumentVersionID INT 

    SELECT  TOP 1 @LatestDocumentVersionID=CurrentDocumentVersionId  
    FROM CustomDocumentCommercialIndividualServiceNotes CDLS  
    INNER JOIN Documents Doc ON CDLS.DocumentVersionId = Doc.CurrentDocumentVersionId  
    WHERE Doc.ClientId = @ClientID  
     AND Doc.[Status] = 22  
     AND ISNULL(CDLS.RecordDeleted, 'N') = 'N'  
     AND ISNULL(Doc.RecordDeleted, 'N') = 'N'  
    ORDER BY Doc.EffectiveDate DESC  
     ,Doc.ModifiedDate DESC  
    
  SET @LatestDocumentVersionId = ISNULL(@LatestDocumentVersionId, - 1)  

  SELECT 'CustomDocumentCommercialIndividualServiceNotes' AS TableName  
   ,- 1 AS DocumentVersionId  
   ,'' AS CreatedBy
   ,GETDATE() AS CreatedDate
   ,'' AS ModifiedBy
   ,GETDATE() AS ModifiedDate 
   FROM systemconfigurations s  
      LEFT OUTER JOIN CustomDocumentCommercialIndividualServiceNotes  CCISN ON CCISN.DocumentVersionId = @LatestDocumentVersionID AND ISNULL(CCISN.RecordDeleted,'N') <> 'Y'  
    
     
 END TRY  
 BEGIN CATCH  
DECLARE @Error VARCHAR(8000)  
  
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_InitIndividualServiceNote') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
  
  RAISERROR (  
    @Error  
    ,-- Message text.  
    16  
    ,-- Severity.  
    1 -- State.  
    );  
   
 END CATCH  
END  
  