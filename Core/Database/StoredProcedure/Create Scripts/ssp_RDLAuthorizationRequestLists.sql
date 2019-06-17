/****** Object:  StoredProcedure [dbo].[csp_SubReportSafetyCrisisPlan]    Script Date: 10/15/2014 18:27:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLAuthorizationRequestLists]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLAuthorizationRequestLists]
GO

/****** Object:  StoredProcedure [dbo].[ssp_RDLAuthorizationRequestLists]    Script Date: 10/15/2014 18:27:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_RDLAuthorizationRequestLists] (@DocumentVersionId INT)
AS
/*************************************************************************************/
/* Stored Procedure: [ssp_RDLAuthorizationRequestLists]                           */
/* Creation Date:  AUG 31ST ,2015                                                    */
/* Purpose: Gets Data from CustomAuthorizationDocumentAuthorizations   */
/* Input Parameters: @DocumentVersionId                                              */
/* Purpose: Use For Rdl Report                                                       */
/* Author: Ravichandra                                                                   */
/*************************************************************************************/
BEGIN
	BEGIN TRY
	
SELECT  
CAE.AuthorizationRequestId,
CAE.SiteId,
S.siteName,
convert(varchar,CAE.StartDate,101) as  StartDate,
convert(varchar,CAE.EndDate,101) as EndDate,
B.BillingCode +' - ' +B.CodeName as BillingCode,
CAE.Active,
CAE.Appealed,
CAE.Urgent,
CAE.Modifier1,
CAE.Modifier2,
CAE.Modifier3,
CAE.Modifier4,
CAE.Units,
CAE.TotalUnits,
GC1.CodeName as Frequency,
GC.CodeName as AuthorizationStatus,
CAE.Comment
,I.InsurerName
,P.ProviderName
,CAD.Requestor 
FROM AuthorizationRequests CAE
INNER JOIN DocumentAuthorizationRequests CAD ON CAE.DocumentVersionId=CAD.DocumentVersionId
LEFT JOIN BillingCOdes B ON B.BillingCodeId=CAE.BillingCodeId AND ISNULL(b.RecordDeleted, 'N') = 'N' 
LEFT JOIN Sites S ON S.SiteId=CAE.SiteId AND ISNULL(S.RecordDeleted, 'N') = 'N' 
LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId= CAE.Status AND ISNULL(gc.RecordDeleted, 'N') = 'N'
LEFT JOIN GlobalCodes GC1 ON GC1.GlobalCodeId=CAE.Frequency AND ISNULL(GC1.RecordDeleted, 'N') = 'N'
INNER JOIN Insurers I ON I.InsurerId=CAD.InsurerId  AND ISNULL(I.RecordDeleted, 'N') = 'N'
INNER JOIN Providers P ON P.ProviderId=CAD.ProviderId  AND ISNULL(P.RecordDeleted, 'N') = 'N'  
WHERE  CAE.DocumentVersionId=@DocumentVersionId 
AND ISNULL(CAD.RecordDeleted, 'N') = 'N'
AND ISNULL(CAE.RecordDeleted, 'N') = 'N'
		   
		  
   
   END TRY  
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)  
  
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLAuthorizationRequestLists') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
  
  RAISERROR (  
    @Error  
    ,-- Message text.  
    16  
    ,-- Severity.  
    1 -- State.  
    );  
 END CATCH  
END 

