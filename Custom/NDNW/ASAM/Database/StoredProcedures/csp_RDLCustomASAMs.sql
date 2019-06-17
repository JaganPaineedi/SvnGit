/****** Object:  StoredProcedure [dbo].[csp_RDLCustomASAMs]    Script Date: 10/15/2014 18:27:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomASAMs]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomASAMs]
GO

/****** Object:  StoredProcedure [dbo].[csp_RDLCustomASAMs]    Script Date: 10/15/2014 18:27:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[csp_RDLCustomASAMs] (@DocumentVersionId INT)
AS
/*************************************************************************************/
/* Stored Procedure: [csp_RDLCustomASAMs]                                 */
/* Creation Date:  DEC 2ND ,2014                                                    */
/* Purpose: Gets Data from CustomDocumentASAMs   */
/* Input Parameters: @DocumentVersionId                                              */
/* Purpose: Use For Rdl Report                                                       */
/* Author: Akwinass                                                                  */
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
			
	    SELECT @OrganizationName AS OrganizationName
			,@DocumentName AS DocumentName
			,@ClientName AS ClientName
			,@ClinicianName AS ClinicianName
			,@ClientID AS ClientID
			,@EffectiveDate AS EffectiveDate
			,@DOB AS DOB
			,ISNULL(ASAM.Dimension1, '') AS Dimension1
			,ISNULL(GC1.CodeName,'') AS D1Level
			,ISNULL(GC2.CodeName,'') AS D1Risk
			,ISNULL(ASAM.D1Comments,'') AS D1Comments
			,ISNULL(ASAM.Dimension2, '') AS Dimension2
			,ISNULL(GC3.CodeName,'') AS D2Level
			,ISNULL(GC4.CodeName,'') AS D2Risk
			,ISNULL(ASAM.D2Comments,'') AS D2Comments
			,ISNULL(ASAM.Dimension3, '') AS Dimension3
			,ISNULL(GC5.CodeName,'') AS D3Level
			,ISNULL(GC6.CodeName,'') AS D3Risk
			,ISNULL(ASAM.D3Comments,'') AS D3Comments
			,ISNULL(ASAM.Dimension4, '') AS Dimension4
			,ISNULL(GC7.CodeName,'') AS D4Level
			,ISNULL(GC8.CodeName,'') AS D4Risk
			,ISNULL(ASAM.D4Comments,'') AS D4Comments
			,ISNULL(ASAM.Dimension5, '') AS Dimension5
			,ISNULL(GC9.CodeName,'') AS D5Level
			,ISNULL(GC10.CodeName,'') AS D5Risk
			,ISNULL(ASAM.D5Comments,'') AS D5Comments
			,ISNULL(ASAM.Dimension6, '') AS Dimension6
			,ISNULL(GC11.CodeName,'') AS D6Level
			,ISNULL(GC12.CodeName,'') AS D6Risk
			,ISNULL(ASAM.D6Comments,'') AS D6Comments
			,ISNULL(GC13.CodeName,'') AS IndicatedReferredLevel
			,ISNULL(GC14.CodeName,'') AS ProvidedLevel
			,ASAM.FinalDeterminationComments
			,CASE WHEN CHARINDEX('Level', ISNULL(GC1.CodeName,'')) > 0 THEN ISNULL(GC1.CodeName,'') ELSE 'Level '+ISNULL(GC1.CodeName,'') END FD1Level
			,CASE WHEN CHARINDEX('Level', ISNULL(GC3.CodeName,'')) > 0 THEN ISNULL(GC3.CodeName,'') ELSE 'Level '+ISNULL(GC3.CodeName,'') END FD2Level
			,CASE WHEN CHARINDEX('Level', ISNULL(GC5.CodeName,'')) > 0 THEN ISNULL(GC5.CodeName,'') ELSE 'Level '+ISNULL(GC5.CodeName,'') END FD3Level
			,CASE WHEN CHARINDEX('Level', ISNULL(GC7.CodeName,'')) > 0 THEN ISNULL(GC7.CodeName,'') ELSE 'Level '+ISNULL(GC7.CodeName,'') END FD4Level
			,CASE WHEN CHARINDEX('Level', ISNULL(GC9.CodeName,'')) > 0 THEN ISNULL(GC9.CodeName,'') ELSE 'Level '+ISNULL(GC9.CodeName,'') END FD5Level
			,CASE WHEN CHARINDEX('Level', ISNULL(GC11.CodeName,'')) > 0 THEN ISNULL(GC11.CodeName,'') ELSE 'Level '+ISNULL(GC11.CodeName,'') END FD6Level
			,'Risk: '+ISNULL(GC2.CodeName,'') AS FD1Risk
			,'Risk: '+ISNULL(GC4.CodeName,'') AS FD2Risk
			,'Risk: '+ISNULL(GC6.CodeName,'') AS FD3Risk
			,'Risk: '+ISNULL(GC8.CodeName,'') AS FD4Risk
			,'Risk: '+ISNULL(GC10.CodeName,'') AS FD5Risk
			,'Risk: '+ISNULL(GC12.CodeName,'') AS FD6Risk
		FROM CustomDocumentASAMs ASAM
		LEFT JOIN GlobalCodes GC1 ON ASAM.D1Level = GC1.GlobalCodeId
		LEFT JOIN GlobalCodes GC2 ON ASAM.D1Risk = GC2.GlobalCodeId		
		LEFT JOIN GlobalCodes GC3 ON ASAM.D2Level = GC3.GlobalCodeId
		LEFT JOIN GlobalCodes GC4 ON ASAM.D2Risk = GC4.GlobalCodeId		
		LEFT JOIN GlobalCodes GC5 ON ASAM.D3Level = GC5.GlobalCodeId
		LEFT JOIN GlobalCodes GC6 ON ASAM.D3Risk = GC6.GlobalCodeId		
		LEFT JOIN GlobalCodes GC7 ON ASAM.D4Level = GC7.GlobalCodeId
		LEFT JOIN GlobalCodes GC8 ON ASAM.D4Risk = GC8.GlobalCodeId		
		LEFT JOIN GlobalCodes GC9 ON ASAM.D5Level = GC9.GlobalCodeId
		LEFT JOIN GlobalCodes GC10 ON ASAM.D5Risk = GC10.GlobalCodeId		
		LEFT JOIN GlobalCodes GC11 ON ASAM.D6Level = GC11.GlobalCodeId
		LEFT JOIN GlobalCodes GC12 ON ASAM.D6Risk = GC12.GlobalCodeId		
		LEFT JOIN GlobalCodes GC13 ON ASAM.IndicatedReferredLevel = GC13.GlobalCodeId
		LEFT JOIN GlobalCodes GC14 ON ASAM.ProvidedLevel = GC14.GlobalCodeId		
		WHERE ASAM.DocumentVersionId = @DocumentVersionId
			AND isnull(ASAM.RecordDeleted, 'N') = 'N'

	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_RDLCustomASAMs') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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