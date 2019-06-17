/****** Object:  StoredProcedure [dbo].[csp_SubReportSafetyCrisisPlan]    Script Date: 10/15/2014 18:27:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLAuthorizationRequest]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLAuthorizationRequest]
GO

/****** Object:  StoredProcedure [dbo].[ssp_RDLAuthorizationRequest]    Script Date: 10/15/2014 18:27:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_RDLAuthorizationRequest] (@DocumentVersionId INT)
AS
/*************************************************************************************/
/* Stored Procedure: [ssp_RDLAuthorizationRequest]                           */
/* Creation Date:  AUG 31ST ,2015                                                    */
/* Purpose: Gets Data from CustomAuthorizationDocumentAuthorizations   */
/* Input Parameters: @DocumentVersionId                                              */
/* Purpose: Use For Rdl Report                                                       */
/* Author: Ravichandra                                                                   */
/* Date : 18 Jan 2016    Arjun      Purpose : InProgressDocumentVersionId is changed to CurrentDocumentVersionId. Task #604.12 Network 180 Environment Issues Tracking */
/* Date : 05 Oct 2017    K.Soujanya Purpose : Added ImageRecords column to show and hide Attachments header on RDL, Ref. Partner Solutions - Enhancements Task#1 */
/*************************************************************************************/
BEGIN
	BEGIN TRY
		--DECLARE @ClientId INT	
		--SELECT @ClientId = Documents.ClientID
		--FROM Documents
		--JOIN Staff S ON Documents.AuthorId = S.StaffId
		--JOIN Clients C ON Documents.ClientId = C.ClientId
		--	AND isnull(C.RecordDeleted, 'N') <> 'Y'
		--JOIN DocumentVersions dv ON dv.DocumentId = documents.DocumentId
		--INNER JOIN DocumentCodes on DocumentCodes.DocumentCodeid= Documents.DocumentCodeId      
		--	AND ISNULL(DocumentCodes.RecordDeleted,'N')='N' 
		--LEFT JOIN GlobalCodes GC ON S.Degree = GC.GlobalCodeId
		--WHERE dv.DocumentVersionId = @DocumentVersionId
		--	AND isnull(Documents.RecordDeleted, 'N') = 'N'
			
	DECLARE @OrganizationName varchar(50)
	DECLARE @ImageRecords CHAR(1)
   SELECT @OrganizationName = OrganizationName from SystemConfigurations
   IF EXISTS (SELECT ImageRecordId FROM ImageRecords WHERE ISNULL(RecordDeleted, 'N') = 'N' 
			AND DocumentVersionId = @DocumentVersionId)
			BEGIN
			SET @ImageRecords='Y'
			END
    SELECT  
	@OrganizationName AS OrganizationName
	,D.ClientId
	,DC.DocumentName
	,I.InsurerName
	,P.ProviderName
	,CAD.Requestor 	
	,Convert(VARCHAR(10),D.EffectiveDate, 101) AS EffectiveDate 
	,C.LastName + ', ' + C.FirstName AS ClientName
	,Convert(VARCHAR(10),C.DOB, 101) AS DOB 
	,@ImageRecords AS ImageRecords
    FROM DocumentAuthorizationRequests CAD
    INNER JOIN Documents D ON D.CurrentDocumentVersionId=CAD.DocumentVersionId 
    INNER JOIN DOcumentCodes DC ON DC.DocumentCodeId=D.DocumentCodeId   AND ISNULL(DC.RecordDeleted, 'N') = 'N'   
    INNER JOIN Insurers I ON I.InsurerId=CAD.InsurerId  AND ISNULL(I.RecordDeleted, 'N') = 'N'
    INNER JOIN Providers P ON P.ProviderId=CAD.ProviderId  AND ISNULL(P.RecordDeleted, 'N') = 'N'  
    INNER Join Clients C on C.ClientId = D.ClientId    
    WHERE  CAD.DocumentVersionId=@DocumentVersionId 
		   AND ISNULL(CAD.RecordDeleted, 'N') = 'N'
		      AND ISNULL(D.RecordDeleted, 'N') = 'N'
		   
		  
   
   END TRY  
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)  
  
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLAuthorizationRequest') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
  
  RAISERROR (  
    @Error  
    ,-- Message text.  
    16  
    ,-- Severity.  
    1 -- State.  
    );  
 END CATCH  
END 

