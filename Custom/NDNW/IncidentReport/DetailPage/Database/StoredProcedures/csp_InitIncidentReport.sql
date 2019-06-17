/****** Object:  StoredProcedure [dbo].[csp_InitIncidentReport]    Script Date: 10/23/2014 09:59:00 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitIncidentReport]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_InitIncidentReport] ---4,550,'N'
GO

/****** Object:  StoredProcedure [dbo].[csp_InitIncidentReport]    Script Date: 10/23/2014 09:59:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_InitIncidentReport] (
	@ClientID INT
	,@StaffID INT
	,@CustomParameters XML
	)
AS
/*********************************************************************/
/* Stored Procedure: [csp_InitIncidentReport]   */
/*       Date              Author                  Purpose                   */
/*********************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @DOB DATETIME
		DECLARE @ClientName VARCHAR(max)
		DECLARE @UnitName VARCHAR(max)
		DECLARE @LatestIncidentId INT
		DECLARE @AdministratorId INT

		SET @DOB = (
				SELECT CONVERT(VARCHAR(10), C.DOB, 101)
				FROM clients C
				WHERE C.ClientId = @ClientID
				)
		SET @ClientName = (
				SELECT C.LastName + ',' + C.FirstName
				FROM clients C
				WHERE C.ClientId = @ClientID
				)
		SET @LatestIncidentId = (
				SELECT TOP 1 IncidentReportSupervisorFollowUpId
				FROM customincidentreports
				WHERE ClientId = @ClientID
				ORDER BY IncidentReportId DESC
				)
		SET @AdministratorId = (
				SELECT SupervisorFollowUpAdministrator
				FROM CustomIncidentReportSupervisorFollowUps
				WHERE IncidentReportSupervisorFollowUpId = @LatestIncidentId
				)
		--SET @UnitName = (
		--		SELECT TOP 1 U.DisplayAs
		--		FROM Units U
		--		JOIN Rooms R ON U.UnitId = R.UnitId
		--		JOIN Beds B ON R.RoomId = B.RoomId
		--		JOIN BedAvailabilityHistory BAH ON B.BedId = BAH.BedId
		--		WHERE BAH.ProgramId IN (
		--				SELECT p.ProgramId
		--				FROM Clients AS c
		--				INNER JOIN ClientPrograms AS cp ON cp.ClientId = c.ClientId
		--					AND ISNULL(cp.RecordDeleted, 'N') = 'N'
		--					AND ISNULL(c.RecordDeleted, 'N') = 'N'
		--				INNER JOIN Programs AS p ON p.ProgramId = cp.ProgramId
		--					AND ISNULL(p.RecordDeleted, 'N') = 'N'
		--				INNER JOIN StaffClients sc ON sc.StaffId = @StaffID
		--					AND sc.ClientId = c.ClientId
		--				INNER JOIN GlobalCodes AS gc ON gc.GlobalCodeId = cp.STATUS
		--					AND ISNULL(gc.RecordDeleted, 'N') = 'N'
		--					AND gc.Active = 'Y'
		--				LEFT OUTER JOIN Staff AS s ON s.StaffId = c.PrimaryClinicianId
		--				WHERE gc.CodeName = 'Enrolled'
		--					AND c.ClientId = @ClientID
		--					AND p.ResidentialProgram = 'Y'
		--				)
		--		ORDER BY U.UnitId DESC
		--		)
		
		SELECT  @UnitName = U.UnitName
		FROM ClientInPatientVisits CIV
		JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CIV.ClientInpatientVisitId
			AND ISNULL(BA.RecordDeleted, 'N') = 'N'
		LEFT JOIN Beds B ON B.BedId = BA.BedId
			AND ISNULL(B.RecordDeleted, 'N') = 'N'
		LEFT JOIN Rooms R ON R.RoomId = B.RoomId
			AND ISNULL(R.RecordDeleted, 'N') = 'N'
		LEFT JOIN Units U ON U.UnitId = R.UnitId
			AND ISNULL(U.RecordDeleted, 'N') = 'N'
		WHERE CIV.ClientId = @ClientID 		
		
		SELECT 'CustomIncidentReports' AS TableName
			,- 1 AS IncidentReportId
			,'' AS CreatedBy
			,GETDATE() AS CreatedDate
			,'' AS ModifiedBy
			,GETDATE() AS ModifiedDate
			,@ClientID AS ClientId
			,@ClientName AS Individual
			,CONVERT(VARCHAR(10), @DOB, 101) AS DOB
		FROM systemconfigurations s
		LEFT OUTER JOIN CustomIncidentReports CDS ON s.Databaseversion = - 1

		SELECT 'CustomIncidentReportGenerals' AS TableName
			,- 1 AS IncidentReportGeneralId
			,'' AS CreatedBy
			,GETDATE() AS CreatedDate
			,'' AS ModifiedBy
			,GETDATE() AS ModifiedDate
			,- 1 AS IncidentReportId
			,Cast(GETDATE() AS DATE) AS GeneralDateOfIncident
			,Cast(GETDATE() AS DATE) AS GeneralDateStaffNotified
			,@UnitName AS GeneralResidence
		FROM systemconfigurations s
		--Join Clients C on C.ClientId=@ClientID
		LEFT OUTER JOIN CustomIncidentReportGenerals CDS ON s.Databaseversion = - 1

		SELECT 'CustomIncidentReportDetails' AS TableName
			,- 1 AS IncidentReportDetailId
			,'' AS CreatedBy
			,GETDATE() AS CreatedDate
			,'' AS ModifiedBy
			,GETDATE() AS ModifiedDate
			,- 1 AS IncidentReportId
		FROM systemconfigurations s
		LEFT OUTER JOIN CustomIncidentReportDetails CDS ON s.Databaseversion = - 1

		SELECT 'CustomIncidentReportFollowUpOfIndividualStatuses' AS TableName
			,- 1 AS IncidentReportFollowUpOfIndividualStatusId
			,'' AS CreatedBy
			,GETDATE() AS CreatedDate
			,'' AS ModifiedBy
			,GETDATE() AS ModifiedDate
			,- 1 AS IncidentReportId
		FROM systemconfigurations s
		LEFT OUTER JOIN CustomIncidentReportFollowUpOfIndividualStatuses CDS ON s.Databaseversion = - 1

		SELECT 'CustomIncidentReportSupervisorFollowUps' AS TableName
			,- 1 AS IncidentReportSupervisorFollowUpId
			,'' AS CreatedBy
			,GETDATE() AS CreatedDate
			,'' AS ModifiedBy
			,GETDATE() AS ModifiedDate
			,- 1 AS IncidentReportId
		FROM systemconfigurations s
		LEFT OUTER JOIN CustomIncidentReportSupervisorFollowUps CDS ON s.Databaseversion = - 1

		SELECT 'CustomIncidentReportAdministratorReviews' AS TableName
			,- 1 AS IncidentReportAdministratorReviewId
			,'' AS CreatedBy
			,GETDATE() AS CreatedDate
			,'' AS ModifiedBy
			,GETDATE() AS ModifiedDate
			,- 1 AS IncidentReportId
			,@AdministratorId AS AdministratorReviewAdministrator 
		FROM systemconfigurations s
		LEFT OUTER JOIN CustomIncidentReportAdministratorReviews CDS ON s.Databaseversion = - 1

		SELECT 'CustomIncidentReportFallDetails' AS TableName
			,- 1 AS IncidentReportFallDetailId
			,'' AS CreatedBy
			,GETDATE() AS CreatedDate
			,'' AS ModifiedBy
			,GETDATE() AS ModifiedDate
			,- 1 AS IncidentReportId
		FROM systemconfigurations s
		LEFT OUTER JOIN CustomIncidentReportFallDetails CDS ON s.Databaseversion = - 1

		SELECT 'CustomIncidentReportFallFollowUpOfIndividualStatuses' AS TableName
			,- 1 AS IncidentReportFallFollowUpOfIndividualStatusId
			,'' AS CreatedBy
			,GETDATE() AS CreatedDate
			,'' AS ModifiedBy
			,GETDATE() AS ModifiedDate
			,- 1 AS IncidentReportId
		FROM systemconfigurations s
		LEFT OUTER JOIN CustomIncidentReportFallFollowUpOfIndividualStatuses CDS ON s.Databaseversion = - 1

		SELECT 'CustomIncidentReportFallSupervisorFollowUps' AS TableName
			,- 1 AS IncidentReportFallSupervisorFollowUpId
			,'' AS CreatedBy
			,GETDATE() AS CreatedDate
			,'' AS ModifiedBy
			,GETDATE() AS ModifiedDate
			,- 1 AS IncidentReportId
		FROM systemconfigurations s
		LEFT OUTER JOIN CustomIncidentReportFallSupervisorFollowUps CDS ON s.Databaseversion = - 1

		SELECT 'CustomIncidentReportFallAdministratorReviews' AS TableName
			,- 1 AS IncidentReportFallAdministratorReviewId
			,'' AS CreatedBy
			,GETDATE() AS CreatedDate
			,'' AS ModifiedBy
			,GETDATE() AS ModifiedDate
			,- 1 AS IncidentReportId
		FROM systemconfigurations s
		LEFT OUTER JOIN CustomIncidentReportFallAdministratorReviews CDS ON s.Databaseversion = - 1

		SELECT 'CustomIncidentReportSeizureDetails' AS TableName
			,- 1 AS IncidentReportSeizureDetailId
			,'' AS CreatedBy
			,GETDATE() AS CreatedDate
			,'' AS ModifiedBy
			,GETDATE() AS ModifiedDate
			,- 1 AS IncidentReportId
		FROM systemconfigurations s
		LEFT OUTER JOIN CustomIncidentReportSeizureDetails CDS ON s.Databaseversion = - 1

		SELECT 'CustomIncidentSeizureDetails' AS TableName
			,- 1 AS IncidentSeizureDetailId
			,'' AS CreatedBy
			,GETDATE() AS CreatedDate
			,'' AS ModifiedBy
			,GETDATE() AS ModifiedDate
			,- 1 AS IncidentReportId
		FROM systemconfigurations s
		LEFT OUTER JOIN CustomIncidentSeizureDetails CDS ON s.Databaseversion = - 1

		SELECT 'CustomIncidentReportSeizureFollowUpOfIndividualStatuses' AS TableName
			,- 1 AS IncidentReportSeizureFollowUpOfIndividualStatusId
			,'' AS CreatedBy
			,GETDATE() AS CreatedDate
			,'' AS ModifiedBy
			,GETDATE() AS ModifiedDate
			,- 1 AS IncidentReportId
		FROM systemconfigurations s
		LEFT OUTER JOIN CustomIncidentReportSeizureFollowUpOfIndividualStatuses CDS ON s.Databaseversion = - 1

		SELECT 'CustomIncidentReportSeizureSupervisorFollowUps' AS TableName
			,- 1 AS IncidentReportSeizureSupervisorFollowUpId
			,'' AS CreatedBy
			,GETDATE() AS CreatedDate
			,'' AS ModifiedBy
			,GETDATE() AS ModifiedDate
			,- 1 AS IncidentReportId
		FROM systemconfigurations s
		LEFT OUTER JOIN CustomIncidentReportSeizureSupervisorFollowUps CDS ON s.Databaseversion = - 1

		SELECT 'CustomIncidentReportSeizureAdministratorReviews' AS TableName
			,- 1 AS IncidentReportSeizureAdministratorReviewId
			,'' AS CreatedBy
			,GETDATE() AS CreatedDate
			,'' AS ModifiedBy
			,GETDATE() AS ModifiedDate
			,- 1 AS IncidentReportId
		FROM systemconfigurations s
		LEFT OUTER JOIN CustomIncidentReportSeizureAdministratorReviews CDS ON s.Databaseversion = - 1
		
			SELECT 'CustomIncidentReportManagerFollowUps' AS TableName
			,- 1 AS IncidentReportManagerFollowUpId
			,'' AS CreatedBy
			,GETDATE() AS CreatedDate
			,'' AS ModifiedBy
			,GETDATE() AS ModifiedDate
			,- 1 AS IncidentReportId
		FROM systemconfigurations s
		LEFT OUTER JOIN CustomIncidentReportManagerFollowUps CDS ON s.Databaseversion = - 1
		
			SELECT 'CustomIncidentReportSeizureManagerFollowUps' AS TableName
			,- 1 AS IncidentReportSeizureManagerFollowUpId
			,'' AS CreatedBy
			,GETDATE() AS CreatedDate
			,'' AS ModifiedBy
			,GETDATE() AS ModifiedDate
			,- 1 AS IncidentReportId
		FROM systemconfigurations s
		LEFT OUTER JOIN CustomIncidentReportSeizureManagerFollowUps CDS ON s.Databaseversion = - 1
		
			SELECT 'CustomIncidentReportFallManagerFollowUps' AS TableName
			,- 1 AS IncidentReportFallManagerFollowUpId
			,'' AS CreatedBy
			,GETDATE() AS CreatedDate
			,'' AS ModifiedBy
			,GETDATE() AS ModifiedDate
			,- 1 AS IncidentReportId
		FROM systemconfigurations s
		LEFT OUTER JOIN CustomIncidentReportFallManagerFollowUps CDS ON s.Databaseversion = - 1
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_InitLifetimeMedicalHistorySummary') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.  
				16
				,-- Severity.  
				1 -- State.  
				);
	END CATCH
END
