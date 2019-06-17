IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[ssp_PMCoveragePlanBillingCodes]')
			AND TYPE IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_PMCoveragePlanBillingCodes]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_PMCoveragePlanBillingCodes]
	/********************************************************************************                                                  
-- Stored Procedure: ssp_PMCoveragePlanBillingCodes
--
-- Copyright: Streamline Healthcate Solutions
--
-- Purpose: Query to return data for the procedure rates for the Popup(coveragePlans).
--
-- Author:  Mary Suma
-- Date:    27 Feb 2012
-- 
-- *****History****
-- Purpose: what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.  
			why:task #609, Network180 Customization
--
-- Author:  Revathi 
-- Date:    19 Oct 2015
-- 
*********************************************************************************/
	@ProcedureRateId INT
	,@CoveragePlanId INT
	,@BillingCodeTemplate CHAR(1)
AS
BEGIN
	BEGIN TRY
		--Table 5 Procedure Rate Degree Popup
		SELECT GlobalCodeId AS Degree
			,CodeName
			,PRD.RecordDeleted
			,Active
			,ProcedureRateDegreeId
			,PRD.RowIdentifier
			,PRD.CreatedBy
			,PRD.CreatedDate
			,PRD.ModifiedBy
			,PRD.ModifiedDate
			,PRD.ProcedureRateId
			,PRD.RecordDeleted
			,PRD.DeletedDate
			,PRD.DeletedBy
		FROM GlobalCodes GC
		INNER JOIN ProcedureRateDegrees PRD ON GC.GlobalCodeId = PRD.Degree
		WHERE ISNULL(GC.RecordDeleted, 'N') = 'N'
			AND Category = 'DEGREE'
			AND Active = 'Y'
			AND ISNULL(PRD.RecordDeleted, 'N') = 'N'
			AND PRD.ProcedureRateId = @ProcedureRateId

		/**********************************************************************************************          
		   Table No.:6 ProcedureRate Programs Popup :           
	**********************************************************************************************/
		SELECT prp.ProgramId
			,ProgramName
			,'0' AS StaffProgramId
			,Active
			,PRP.ModifiedDate
			,PRP.ProcedureRateProgramId
			,PRP.ProcedureRateId
			--,PRP.ProgramId
			,PRP.RowIdentifier
			,PRP.CreatedBy
			,PRP.CreatedDate
			,PRP.ModifiedBy
			--,PRP.RowIdentifier
			,PRP.DeletedBy
			,PRP.RecordDeleted
			,PRP.DeletedDate
		FROM Programs P
		INNER JOIN ProcedureRatePrograms PRP ON ISNULL(P.RecordDeleted, 'N') = 'N'
		WHERE P.ProgramID = PRP.ProgramId
			AND PRP.ProcedureRateId = @ProcedureRateId
			AND ISNULL(PRP.RecordDeleted, 'N') = 'N'

		/**********************************************************************************************          
		   Table No.:7 ProcedureRate Locations Popup :           
	  **********************************************************************************************/
		SELECT PRL.LocationId
			,L.LocationName
			,PRL.RecordDeleted
			,Active
			,PRL.ProcedureRateLocationId
			,PRL.ProcedureRateId
			,PRL.RowIdentifier
			,PRL.CreatedBy
			,PRL.CreatedDate
			,PRL.ModifiedBy
			,PRL.ModifiedDate
			,PRL.DeletedDate
			,PRL.DeletedBy
		FROM Locations L
		INNER JOIN ProcedureRateLocations PRL ON L.LocationId = PRL.LocationId
		WHERE ISNULL(L.RecordDeleted, 'N') = 'N'
			AND PRL.ProcedureRateId = @ProcedureRateId
			AND ISNULL(PRL.RecordDeleted, 'N') = 'N'

		SELECT PS.ProcedureRateStaffId
			,PS.ProcedureRateId
			,PS.StaffId
			,PS.RowIdentifier
			,PS.CreatedBy
			,PS.CreatedDate
			,PS.ModifiedBy
			,PS.ModifiedDate
			,PS.RecordDeleted
			,PS.DeletedDate
			,PS.DeletedBy
		FROM ProcedureRateStaff PS
		INNER JOIN Staff S ON S.StaffId = PS.StaffId
		WHERE ISNULL(PS.RecordDeleted, 'N') = 'N'
			AND PS.ProcedureRateId = @ProcedureRateId

		/**********************************************************************************************          
			   Table No.:9 Table Name : ProcedureRates Clients          
		**********************************************************************************************/
		IF @BillingCodeTemplate = 'S'
		BEGIN
			SELECT DISTINCT C.ClientId
				--Added by Revathi  19 Oct 2015
				,CASE 
					WHEN ISNULL(C.ClientType, 'I') = 'I'
						THEN ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, '')
					ELSE ISNULL(C.OrganizationName, '')
					END AS ClientName
			FROM Clients C
			INNER JOIN ProcedureRates PR ON PR.ClientId = C.ClientId
			WHERE ISNULL(C.RecordDeleted, 'N') = 'N'
				AND ISNULL(PR.RecordDeleted, 'N') = 'N'
				AND PR.ProcedureRateId = @ProcedureRateId
		END
		ELSE
		BEGIN
			SELECT DISTINCT C.ClientId
				--Added by Revathi  19 Oct 2015          
				,CASE 
					WHEN ISNULL(C.ClientType, 'I') = 'I'
						THEN ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, '')
					ELSE ISNULL(C.OrganizationName,'')
					END AS ClientName
			FROM Clients C
			INNER JOIN ProcedureRates PR ON PR.ClientId = C.ClientId
			WHERE ISNULL(C.RecordDeleted, 'N') = 'N'
				AND PR.StandardRAteId = @ProcedureRAteId
		END

		--Table 23 	Add Billing Code ProcedureRate Place of Service
		SELECT PRS.[ProcedureRatePlacesOfServiceId]
			,PRS.[CreatedBy]
			,PRS.[CreatedDate]
			,PRS.[ModifiedBy]
			,PRS.[ModifiedDate]
			,PRS.[RecordDeleted]
			,PRS.[DeletedDate]
			,PRS.[DeletedBy]
			,PRS.[ProcedureRateId]
			,PRS.[PlaceOfServieId]
		FROM ProcedureRatePlacesOfServices PRS
		INNER JOIN ProcedureRates PR ON PRS.ProcedureRateId = PR.ProcedureRateId
			AND ISNULL(PR.RecordDeleted, 'N') = 'N'
		WHERE ISNULL(PRS.RecordDeleted, 'N') = 'N'
			AND PRS.ProcedureRateId = @ProcedureRateId

		--Table 24 	Add Billing Code ProcedureRate ServiceAreas
		SELECT PRSA.[ProcedureRateServiceAreaId]
			,PRSA.[CreatedBy]
			,PRSA.[CreatedDate]
			,PRSA.[ModifiedBy]
			,PRSA.[ModifiedDate]
			,PRSA.[RecordDeleted]
			,PRSA.[DeletedDate]
			,PRSA.[DeletedBy]
			,PRSA.[ProcedureRateId]
			,PRSA.[ServiceAreaId]
		FROM ProcedureRateServiceAreas PRSA
		INNER JOIN ProcedureRates PR ON PR.ProcedureRateId = PRSA.ProcedureRateId
			AND ISNULL(PR.RecordDeleted, 'N') = 'N'
		WHERE ISNULL(PRSA.RecordDeleted, 'N') = 'N'
			AND PRSA.ProcedureRateId = @ProcedureRateId

		/*Select from ProcedureRateAdvancedBillingCode.*/
		SELECT PRB.ProcedureRateBillingCodeId
			,PRB.ProcedureRateId
			,PRB.FromUnit
			,PRB.ToUnit
			,PRB.BillingCode
			,PRB.Modifier1
			,PRB.Modifier2
			,PRB.Modifier3
			,PRB.Modifier4
			,PRB.RevenueCode
			,PRB.RevenueCodeDescription
			,PRB.Comment
			,PRB.CreatedBy
			,PRB.CreatedDate
			,PRB.ModifiedBy
			,PRB.ModifiedDate
			,PRB.RecordDeleted
			,PRB.DeletedDate
			,PRB.DeletedBy
			,PRB.AddModifiersFromService
			,ISNULL(PRB.BillingCode, '') + ' ' + ISNULL(PRB.Modifier1, '') + ' ' + ISNULL(PRB.Modifier2, '') AS BillingCodeModifier
		--@ProcedureCodeName AS ProcedureCodeName,  
		--@EnteredAs AS CodeName,  
		--@DisplayAs AS DisplayAs     
		FROM ProcedureRateBillingCodes PRB
		INNER JOIN ProcedureRates PR ON PRB.ProcedureRateId = PR.ProcedureRateId
		WHERE ISNULL(PRB.recordDeleted, 'N') = 'N'
			AND ISNULL(PR.recordDeleted, 'N') = 'N'
			AND PR.ProcedureRateId = @ProcedureRateId
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' 
		+ CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' 
		+ ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_PMCoveragePlanBillingCodes')
		 + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' 
		 + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' 
		 + CONVERT(VARCHAR, ERROR_STATE())

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

