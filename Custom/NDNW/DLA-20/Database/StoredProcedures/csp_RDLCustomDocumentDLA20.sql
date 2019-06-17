IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentDLA20]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_RDLCustomDocumentDLA20] 
GO

CREATE PROCEDURE [dbo].[csp_RDLCustomDocumentDLA20] @DocumentVersionId INT
AS
/*********************************************************************/
/* Stored Procedure: [csp_RDLCustomDocumentDLA20]               */
/* Creation Date:  20/Jan/2017                                    */
/* Purpose: RDL Header details */
/* Input Parameters:   @DocumentVersionId */
/* What:Moved from F&CS to NDNW; Why:New Directions - Support Go Live ,Task#286*/
/* Called By: K.Soujanya  */
/*   Updates:                                                          */
/*   Date              Author                  Purpose     */
/* *//*********************************************************************/
BEGIN TRY  
 DECLARE @clientAge VARCHAR(50)  
 DECLARE @clientid INT  
  
 SELECT @clientid = (  
   SELECT clientid  
   FROM Documents  
   WHERE InProgressDocumentVersionId = @DocumentVersionId  
   )  
  
 EXEC csp_CalculateAge @clientid  
  ,@clientAge OUT  
  
 DECLARE @AgeInt INT  
  
 IF CHARINDEX('Years', @clientAge) > 0  
 BEGIN  
  SELECT TOP 1 @AgeInt = Token  
  FROM [dbo].[SplitString](@clientAge, ' ')  
  WHERE Position = 1  
  
  SET @AgeInt = ISNULL(@AgeInt, 0)  
 END  
  
 SET @ClientAge = ISNULL(@AgeInt, 0)  
  
 SELECT DocumentCodes.DocumentName  
  ,Documents.DocumentId  
  ,(  
   SELECT OrganizationName  
   FROM SystemConfigurations  
   ) AS OrganizationName  
  ,CONVERT(VARCHAR(10), Documents.EffectiveDate, 101) AS EffectiveDate  
  ,ISNULL(Clients.LastName, '') + ', ' + ISNULL(Clients.FirstName, '') AS ClientName  
  ,Clients.ClientId  
  ,CONVERT(VARCHAR(10), Clients.DOB, 101) AS DOB  
  ,@clientAge AS ClientAge  
  ,NoDLA
 FROM Documents  
 INNER JOIN Clients ON Documents.ClientId = Clients.ClientId  
 INNER JOIN DocumentCodes ON DocumentCodes.DocumentCodeid = Documents.DocumentCodeId  
 INNER JOIN DOCUMENTVERSIONS ON DOCUMENTS.DOCUMENTID = DOCUMENTVERSIONS.DOCUMENTID  
 INNER JOIN CustomDocumentDLA20s DLL on DOCUMENTVERSIONS.DocumentVersionId=DLL.DocumentVersionId
 WHERE DocumentVersions.DocumentVersionId = @DocumentVersionID  
END TRY
BEGIN CATCH
	DECLARE @Error VARCHAR(8000)

	SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'csp_RDLCustomDocumentDLA20') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

	RAISERROR (
			@Error
			,-- Message text.                      
			16
			,-- Severity.                      
			1 -- State.                      
			);
END CATCH
GO


