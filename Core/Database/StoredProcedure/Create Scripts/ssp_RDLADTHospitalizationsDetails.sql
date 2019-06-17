IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLADTHospitalizationsDetails]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLADTHospitalizationsDetails]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_RDLADTHospitalizationsDetails]  
	(
	@ADTHospitalizationId INT
	,@MessageType INT
	)
AS
/******************************************************************************\

*******************************************************************************
**  Change History
*******************************************************************************
**  Date:			Author:			Description: 
**  --------		--------		-------------------------------------------
    28/04/2017		Ravichandra		what:get client ADT: Hospitalization  details  
									why : Task #833.1 SWMBH Support
*******************************************************************************/
BEGIN
	BEGIN TRY
	
	SELECT 
			D.ADTHospitalizationDetailId
			,D.MessageType
			,D.PatientName
			,CONVERT(varchar(10),D.DateOfBirth,101) AS DateOfBirth
			,D.PatientAddress
			,D.MaritalStatus
			,D.MRN
			,D.SSN
			,D.Gender
			,D.Race
			,D.PrimaryLanguage
			,D.PhoneNumber
			,D.InsuranceCompany
			,D.PolicyId
			,D.VisitType
			,D.Hospital
			,D.PresentingProblem
			,CONVERT(varchar(10),D.AdmissionDateTime,101) AS  AdmissionDate
			,LEFT(RIGHT(CONVERT(VARCHAR, D.AdmissionDateTime, 100), 7),5)+' '+Right(RIGHT(CONVERT(VARCHAR, D.AdmissionDateTime, 100), 7),2) AS AdmissionTime
			,CONVERT(varchar(10),D.DischargeDateTime,101) AS DischargeDate
			,LEFT(RIGHT(CONVERT(VARCHAR, D.DischargeDateTime, 100), 7),5)+' '+Right(RIGHT(CONVERT(VARCHAR, D.DischargeDateTime, 100), 7),2) AS DischargeTime
			,CONVERT(varchar(10),D.UpdateDateTime,101) AS UpdateDate 
			,LEFT(RIGHT(CONVERT(VARCHAR, D.UpdateDateTime, 100), 7),5)+' '+Right(RIGHT(CONVERT(VARCHAR, D.UpdateDateTime, 100), 7),2) AS UpdateTime
			,CONVERT(varchar(10),D.TransferDateTime,101) AS TransferDate
			,LEFT(RIGHT(CONVERT(VARCHAR, D.TransferDateTime, 100), 7),5)+' '+Right(RIGHT(CONVERT(VARCHAR, D.TransferDateTime, 100), 7),2) AS TransferTime
			,D.CurrentBed
			,D.PreviousBed
			,D.DischargeDisposition
	 FROM ADTHospitalizationDetails D 
    WHERE D.ADTHospitalizationId=@ADTHospitalizationId
		AND D.MessageType=@MessageType
    AND ISNULL(D.RecordDeleted, 'N') = 'N'
    ORDER BY D.AdmissionDateTime,D.UpdateDateTime,D.TransferDateTime,D.DischargeDateTime
			
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLADTHospitalizationsDetails') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.
				16
				,-- Severity.
				1 -- State.
				);
	END CATCH

	RETURN
END
GO

