/****** Object:  StoredProcedure [dbo].[csp_RDLCustomCommercialAssessment]    Script Date: 10/15/2014 18:27:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomCommercialIndividualServiceNote]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomCommercialIndividualServiceNote] 
GO

/****** Object:  StoredProcedure [dbo].[csp_RDLCustomCommercialIndividualServiceNote]    Script Date: 10/15/2014 18:27:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[csp_RDLCustomCommercialIndividualServiceNote] (@DocumentVersionId INT)
AS
/*************************************************************************************/
/* Stored Procedure: [csp_RDLCustomCommercialIndividualServiceNote]                                 */
/* Creation Date:  Mar 6th ,2015                                                   */
/* Purpose: Gets Data from CustomDocumentCommercialIndividualServiceNote   */
/* Input Parameters: @DocumentVersionId                                              */
/* Purpose: Use For Rdl Report                                                       */
/* Author: Vamsi.N                                                                */
/*************************************************************************************/
BEGIN
	BEGIN TRY		
		DECLARE @OrganizationName VARCHAR(250)
		DECLARE @ClientName VARCHAR(100)
		DECLARE @ClinicianName VARCHAR(100)
		DECLARE @ClientID INT
		DECLARE @EffectiveDate VARCHAR(10)
		DECLARE @DOB VARCHAR(10)
		DECLARE @DocumentName  VARCHAR(100)
		DECLARE @Age varchar(10) 
		
		SELECT TOP 1 @OrganizationName = OrganizationName
		FROM SystemConfigurations
		 
		SELECT @ClientName = C.LastName + ', ' + C.FirstName
			,@ClinicianName = S.LastName + ', ' + S.FirstName + ' ' + isnull(GC.CodeName, '')
			,@ClientID = Documents.ClientID
			,@EffectiveDate = CASE 
				WHEN Documents.EffectiveDate IS NOT NULL
					THEN CONVERT(VARCHAR(10), Documents.EffectiveDate, 101)
				ELSE ''
				END
			,@DOB = CASE 
				WHEN C.DOB IS NOT NULL
					THEN CONVERT(VARCHAR(10), C.DOB, 101)
				ELSE ''
				END
			,@DocumentName = DocumentCodes.DocumentName 
		FROM Documents
		JOIN Staff S ON Documents.AuthorId = S.StaffId
		JOIN Clients C ON Documents.ClientId = C.ClientId
			AND isnull(C.RecordDeleted, 'N') <> 'Y'
		JOIN DocumentVersions dv ON dv.DocumentId = documents.DocumentId
		INNER JOIN DocumentCodes on DocumentCodes.DocumentCodeid= Documents.DocumentCodeId      
			AND ISNULL(DocumentCodes.RecordDeleted,'N')='N' 
		LEFT JOIN GlobalCodes GC ON S.Degree = GC.GlobalCodeId
		WHERE dv.DocumentVersionId = @DocumentVersionId
			AND isnull(Documents.RecordDeleted, 'N') = 'N'
			Exec csp_CalculateAge  @ClientID,@Age OUT  
	    SELECT @OrganizationName AS OrganizationName
			,@DocumentName AS DocumentName
			,@ClientName AS ClientName
			,@ClinicianName AS ClinicianName
			,@ClientID AS ClientID
			,@EffectiveDate AS EffectiveDate
			,@DOB AS DOB
			,CCISA.SituationInterventionPlan
			,CCISA.AddressProgressToGoal
			
		FROM CustomDocumentCommercialIndividualServiceNotes CCISA
				
		WHERE CCISA.DocumentVersionId = @DocumentVersionId
			AND isnull(CCISA.RecordDeleted, 'N') = 'N'

	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_RDLCustomCommercialAssessment') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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