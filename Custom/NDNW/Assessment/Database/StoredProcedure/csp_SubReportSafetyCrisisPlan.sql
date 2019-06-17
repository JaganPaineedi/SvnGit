/****** Object:  StoredProcedure [dbo].[csp_SubReportSafetyCrisisPlan]    Script Date: 10/15/2014 18:27:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SubReportSafetyCrisisPlan]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SubReportSafetyCrisisPlan]
GO

/****** Object:  StoredProcedure [dbo].[csp_SubReportSafetyCrisisPlan]    Script Date: 10/15/2014 18:27:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[csp_SubReportSafetyCrisisPlan] (@DocumentVersionId INT)
AS
/*************************************************************************************/
/* Stored Procedure: [csp_SubReportSafetyCrisisPlan]                                 */
/* Creation Date:  JAN 5TH ,2015                                                    */
/* Purpose: Gets Data from CustomDocumentSafetyCrisisPlans   */
/* Input Parameters: @DocumentVersionId                                              */
/* Purpose: Use For Rdl Report                                                       */
/* Author: Akwinass                                                                  */
/* SuryaBalan  6-April-2015 Task 955.3 Valley - Customizations- Update Safety/Crisis Plan in Assessment. Added these 
       [InitialSafetyPlan],
       [InitialCrisisPlan],
       [SafetyPlanNotReviewed]
	  ,[ReviewCrisisPlanXDays]
	  ,[NextCrisisPlanReviewDate]   */   
/*************************************************************************************/
BEGIN
	BEGIN TRY	
		DECLARE @ClientID INT	
		SELECT @ClientID = Documents.ClientID
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
				
		SELECT CDSCP.[DocumentVersionId]
		  ,CDSCP.[CreatedBy]
		  ,CDSCP.[CreatedDate]
		  ,CDSCP.[ModifiedBy]
		  ,CDSCP.[ModifiedDate]
		  ,CDSCP.[RecordDeleted]
		  ,CDSCP.[DeletedBy]
		  ,CDSCP.[DeletedDate]
		  ,ISNULL(CDSCP.[ClientHasCurrentCrisis],'') AS ClientHasCurrentCrisis
		  ,ISNULL(CDSCP.[WarningSignsCrisis],'') AS WarningSignsCrisis
		  ,ISNULL(CDSCP.[CopingStrategies],'') AS CopingStrategies
		  ,ISNULL(CDSCP.[ThreeMonths],'') AS ThreeMonths
		  ,ISNULL(CDSCP.[TwelveMonths],'') AS TwelveMonths
		  ,CASE 
				WHEN CDSCP.[DateOfCrisis] IS NOT NULL
					THEN CONVERT(VARCHAR(10), CDSCP.[DateOfCrisis], 101)
				ELSE ''
				END DateOfCrisis
		  ,(SELECT TOP 1 ISNULL(CONVERT(VARCHAR(10), DOB, 101),'') FROM clients WHERE Clientid = @ClientId) AS DOB
		  ,ISNULL(P.ProgramCode,'') AS ProgramCode
		  ,S.LastName + ', ' + S.FirstName AS StaffName
		  ,ISNULL(CDSCP.[SignificantOther],'') AS SignificantOther
		  ,ISNULL(CDSCP.[CurrentCrisisDescription],'') AS CurrentCrisisDescription
		  ,ISNULL(CDSCP.[CurrentCrisisSpecificactions],'') AS CurrentCrisisSpecificactions
		  ,@ClientID AS ClientID
		  ,ISNULL(CDSCP.[InitialSafetyPlan],'') AS InitialSafetyPlan
		  ,ISNULL(CDSCP.[InitialCrisisPlan],'') AS InitialCrisisPlan 
          ,ISNULL(CDSCP.[SafetyPlanNotReviewed],'') AS SafetyPlanNotReviewed
	      ,[ReviewCrisisPlanXDays] 
	      ,CAST(ReviewCrisisPlanXDays as varchar(5)) + ' Days' AS [ReviewCrisisPlanXDaysText] 
	        ,CASE 
				WHEN CDSCP.[NextCrisisPlanReviewDate] IS NOT NULL
					THEN CONVERT(VARCHAR(10), CDSCP.[NextCrisisPlanReviewDate], 101)
				ELSE ''
				END NextCrisisPlanReviewDate
	  FROM [CustomDocumentSafetyCrisisPlans] CDSCP	
	  left join Programs P ON CDSCP.ProgramId = P.ProgramId
	  left join Staff S ON CDSCP.StaffId = S.StaffId
		WHERE CDSCP.DocumentVersionId = @DocumentVersionId
			AND isnull(CDSCP.RecordDeleted, 'N') = 'N'

	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_SubReportSafetyCrisisPlan') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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