/****** Object:  StoredProcedure [dbo].[ssp_GetSummaryOfCareAuthorOfDocument]     ******/
IF EXISTS (
		SELECT 1
		FROM INFORMATION_SCHEMA.ROUTINES
		WHERE SPECIFIC_SCHEMA = 'dbo'
			AND SPECIFIC_NAME = 'ssp_GetSummaryOfCareAuthorOfDocument'
		)
	DROP PROCEDURE [dbo].[ssp_GetSummaryOfCareAuthorOfDocument]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetSummaryOfCareAuthorOfDocument]     ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_GetSummaryOfCareAuthorOfDocument] @DocumentVersionId INT
AS
-- =============================================            
-- Author:  K.Soujanya            
-- Create date: August 21, 2017            
-- Description: Retrieves Author details           
/*            
 Modified Date	Author		Reason  
 12/12/2017		Ravichandra	changes done for new requirement 
							Meaningful Use Stage 3 task 68 - Summary of Care        
*/
/*23/07/2018  Ravichandra	What:  casting to a date type for EffectiveDate 
							Why : KCMHSAS - Support  #1099 Summary of Care - issues (summary for all bugs) 
*/ 
-- =============================================            
BEGIN
	BEGIN TRY
		SET NOCOUNT ON

		DECLARE @FromDate DATE
		DECLARE @ToDate DATE
		DECLARE @TransitionType CHAR(1)

		SELECT TOP 1 @FromDate = cast(FromDate AS DATE)
			,@ToDate = cast(ToDate AS DATE)
			,@TransitionType = TransitionType
		FROM TransitionOfCareDocuments
		WHERE ISNULL(RecordDeleted, 'N') = 'N'
			AND DocumentVersionId = @DocumentVersionId

		SELECT ISNULL(S.LastName, '') + ' ' + ISNULL(S.FirstName, '') AS Author
			,CONVERT(VARCHAR(10), D.EffectiveDate, 101) AS EffectiveDate
			,A.AddressDisplay
			,CASE 
				WHEN ISNULL(A.MainPhone, '') <> ''
					THEN '(' + SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(A.MainPhone, '(', ''), ')', ''), '-', ''), ' ', ''), 1, 3) + ')' + ' ' + SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(A.MainPhone, '(', ''), ')', ''), '-', ''), ' ', ''), 4, 3) + '-' + SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(A.MainPhone, '(', ''), ')', ''), '-', ''), ' ', ''), 7, 4)
				ELSE ''
				END AS MainPhone
			,A.AgencyName AS Organization
			,'SmartCare' AS SystemThatGeneratedDocument
			,A.AgencyName AS MedicalRecordsCustodian
			,CASE TOCD.ConfidentialityCode
				WHEN 'V'
					THEN 'Very Restricked'
				WHEN 'R'
					THEN 'Restricked'
				WHEN 'N'
					THEN 'Normal'
				ELSE ''
				END AS ConfidentialityCode
		FROM TransitionOfCareDocuments TOCD
		CROSS JOIN Agency A
		INNER JOIN DocumentVersions DV ON DV.DocumentVersionId = TOCD.DocumentVersionId
		INNER JOIN Documents D ON D.DocumentId = DV.DocumentId
		LEFT JOIN Staff S ON D.AuthorId = S.StaffId
			AND ISNULL(S.RecordDeleted, 'N') = 'N'
		WHERE TOCD.DocumentVersionId = @DocumentVersionId
		--23/07/2018  Ravichandra
			AND (
				CAST(D.EffectiveDate AS DATE) >= @FromDate
				AND CAST(D.EffectiveDate AS DATE) <= @ToDate
				)
			AND ISNULL(TOCD.RecordDeleted, 'N') = 'N'
			AND ISNULL(D.RecordDeleted, 'N') = 'N'
			AND ISNULL(DV.RecordDeleted, 'N') = 'N'
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetSummaryOfCareAuthorOfDocument') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                           
				16
				,-- Severity.                                                                  
				1 -- State.                                                               
				);
	END CATCH
END
